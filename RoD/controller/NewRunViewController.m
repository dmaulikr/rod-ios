//
//  NewRunViewController.m
//  RoD
//
//  Created by Pedro Anisio Silva on 29/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import "NewRunViewController.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import "Run.h"
#import "User.h"
#import <MagicalRecord/MagicalRecord.h>

@interface NewRunViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtDateTIme;

@end

@implementation NewRunViewController
@synthesize delegate; //synthesise  MyClassDelegate delegate


- (void)viewDidLoad {
    self.txtDateTIme.delegate = self;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doPostRun:(id)sender {
    
    // Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Log debugging info about Core Data
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userToken = [defaults objectForKey:@"user_token"];
    NSString *userEmail = [defaults objectForKey:@"user_email"];
    NSString *userId    = [defaults objectForKey:@"user_id"];
    
    
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/users/%@/runs?user_email=%@&user_token=%@", userId, userEmail, userToken];
    NSString *requestPathResponseReady = [NSString stringWithFormat:@"/api/v1/users/%@/runs", userId, userEmail, userToken];

    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping
     addAttributeMappingsFromDictionary:
     @{
       @"email"         : @"email",
       @"status"        : @"status",
       @"name"          : @"name",
       @"id"            : @"userId"
       }
     ];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Run class]];
    [responseMapping
     addAttributeMappingsFromDictionary:
     @{
       @"distance" : @"distance",
       @"duration" : @"duration",
       @"pace"     : @"pace",
       @"speed"    : @"speed",
       @"datetime" : @"datetime",
       @"id"       : @"runId"
       }
     ];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping
     addAttributeMappingsFromDictionary:
     @{
       @"distance" : @"distance",
       @"duration" : @"duration",
       @"datetime" : @"datetime",
       @"userId"  :  @"user_id"
       }
     ];
    
//    [responseMapping addPropertyMapping:
//     [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
//                                                 toKeyPath:@"user"
//                                               withMapping:userMapping]
//     ];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:requestPathResponseReady keyPath:@"" statusCodes:statusCodes];
//    
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Run class] rootKeyPath:@"" method:RKRequestMethodAny];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
    
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:appDelegate.managedObjectContext];
    
    newRun.distance = [NSNumber numberWithInt:99];
    newRun.duration = [NSNumber numberWithInt:60*60];
    newRun.datetime = [NSDate date];
    newRun.user = [User MR_findFirstByAttribute:@"userId"
                                      withValue:userId];
    
    // POST to create
    [[RKObjectManager sharedManager] postObject:newRun path:requestPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self didPost];
    } failure:nil];

    
//    // PATCH to update
//    article.body = @"New Body";
//    [manager patchObject:newRun path:@"/articles/1234" parameters:nil success:nil failure:nil];
//    
//    // DELETE to destroy
//    [manager deleteObject:article path:@"/articles/1234" parameters:nil success:nil failure:nil];
}


- (void) didPost {
    [self.delegate onPostResource:nil]; //this will call the method implemented in your other class
}

- (void)changeDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    self.txtDateTIme.text = [NSString stringWithFormat:@"%@",sender.date];

}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)aTextField{
    
    [aTextField resignFirstResponder];
    if ([self.view viewWithTag:9]) {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)] ;
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}



@end
