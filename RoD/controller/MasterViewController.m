//
//  MasterViewController.m
//  Articles
//
//  Created by Marcin on 02.02.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NewRunViewController.h"
#import "RunTableViewCell.h"

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <math.h>

#import "Run.h"
#import "User.h"

#import "DateTools.h"


@interface MasterViewController ()

@property NSArray *runs;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

- (void) onPostResource:(NewRunViewController *)sender {
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Run *run = self.runs[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:run];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if ([[segue identifier] isEqualToString:@"addRun"]) {
        NewRunViewController *controller = (NewRunViewController *)[segue destinationViewController];
        controller.delegate = self;
        
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Number of rows: %lu", (unsigned long)[self.runs count]);
    return [self.runs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Run" forIndexPath:indexPath];
    Run *run = self.runs[indexPath.row];
    cell.date_human_txt.text = run.datetime.timeAgoSinceNow;
    //cell.pace_txt.text = run.pace;
 
    float totalDistance = [run.distance floatValue];
    float myKm = (int) totalDistance; //returns 5 feet
    float myMeters = fmodf(totalDistance, myKm);
    
    cell.distance_txt.text = [NSString stringWithFormat:@"%02.0f", myKm];

    if (isnan(myMeters)) {
        cell.decimal_distance_txt.text = [NSString stringWithFormat:@",%.0f", [run.distance floatValue]*10];
    } else {
        cell.decimal_distance_txt.text = [NSString stringWithFormat:@",%.0f", myMeters*10];
    }

    return cell;
}


#pragma mark - RESTKit

- (void)requestData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userToken = [defaults objectForKey:@"user_token"];
    NSString *userEmail = [defaults objectForKey:@"user_email"];
    NSString *userId    = [defaults objectForKey:@"user_id"];

    
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/users/%@?user_email=%@&user_token=%@", userId, userEmail, userToken];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         //runs have been saved in core data by now
         [self fetchRunsFromContext];
         [SVProgressHUD dismiss];

     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];

         ALERT_WITH_TITLE(@"", NSLocalizedString(@"Error while loading runs", nil));

         RKLogError(@"Load failed with error: %@", error);
     }
     ];
}

- (void)fetchRunsFromContext {
    
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"userId" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    User *user = [fetchedObjects firstObject];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:NO];
    self.runs = [[user.runs allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSort]];

    [self.tableView reloadData];
    
}

@end