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

    _statsPosition = 0;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RESTKit


- (void) buildView {
    NSLog(@"stats ->[%lu]",[_statsArray count]);
    if ([_statsArray count]>0) {
        Stats *currentStats = [_statsArray objectAtIndex:_statsPosition];
        _weekDistance.text = [NSString stringWithFormat:@"%02.1f",[currentStats.total_kms floatValue]];
        _weekGoal.text = [NSString stringWithFormat:@"%02i",[currentStats.goal intValue]];
        _weekPace.text = [NSString stringWithFormat:@"%@",currentStats.pace];
        _weekRunCount.text = [NSString stringWithFormat:@"%i",[currentStats.run_count intValue]];

        
    } else {
        
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


    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}


@end
