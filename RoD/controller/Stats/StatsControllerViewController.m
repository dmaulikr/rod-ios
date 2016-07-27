//
//  StatsControllerViewController.m
//  RoD
//
//  Created by Pedro Anisio Silva on 24/07/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import "StatsControllerViewController.h"

@interface StatsControllerViewController ()

@end

@implementation StatsControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadStats];
    [self buildView];
    _chartView.delegate = self;

    _statsPosition = 0;
    
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forwardStatus:(id)sender {
    _statsPosition = _statsPosition-1;
    [self buildView];
//    [self loadChart];
}
- (IBAction)backwardStatus:(id)sender {
    _statsPosition = _statsPosition+1;
    [self buildView];
//    [self loadChart];
}

#pragma mark - RESTKit

- (void) loadChart {
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"chartjs" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSString *jsInject = [NSString stringWithFormat:@"var week = %i; var temp = %@",[_currentStats.number intValue],_jsonResponse];
    
    _chartView.opaque = NO;
    _chartView.backgroundColor = [UIColor clearColor];

    [_chartView loadHTMLString:htmlString baseURL:nil];
    [_chartView stringByEvaluatingJavaScriptFromString:jsInject];

}


- (void) buildView {
    NSLog(@"stats ->[%lu]",[_statsArray count]);
    if ([_statsArray count]>0) {
        _currentStats = [_statsArray objectAtIndex:_statsPosition];
        _weekDistance.text = [NSString stringWithFormat:@"%02.1f",[_currentStats.total_kms floatValue]];
        _weekGoal.text = [NSString stringWithFormat:@"%02i",[_currentStats.goal intValue]];
        _weekPace.text = [NSString stringWithFormat:@"%@",_currentStats.pace];
        _weekRunCount.text = [NSString stringWithFormat:@"%i",[_currentStats.run_count intValue]];
        _weekNumber.text = [NSString stringWithFormat:@"week %i",[_currentStats.number intValue]];
        [_goalProgress setValue:([_currentStats.total_kms floatValue]/[_currentStats.goal intValue])*100 animateWithDuration:1];
    }
    
    if ([_statsArray count] <= 1) {
        _forwardButton.enabled = FALSE;
        _backwardButton.enabled = FALSE;
    } else {
        _forwardButton.enabled = TRUE;
        _backwardButton.enabled = TRUE;
    }
    
    if (_statsPosition == 0) {
        _forwardButton.enabled = FALSE;
    }
    if (_statsPosition == [_statsArray count]-1) {
        _backwardButton.enabled = FALSE;
    }
}


- (void)loadStats
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [defaults objectForKey:@"user_token"];
    NSString *userEmail = [defaults objectForKey:@"user_email"];
    NSString *userId    = [defaults objectForKey:@"user_id"];
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/users/%@?user_email=%@&user_token=%@", userId, userEmail, userToken];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping addAttributeMappingsFromArray:@[@"number",@"goal",@"pace",@"run_count",@"total_kms"]];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:statsMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/v1/users/:id"
                                                keyPath:@"stats"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    // Initialize RestKit
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ENDPOINT_URL,requestPath]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        _statsArray = [NSArray arrayWithArray:mappingResult.array];

        [self buildView];
 
        _jsonResponse = operation.HTTPRequestOperation.responseString ;
        
        [self loadChart];
        


    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}


@end
