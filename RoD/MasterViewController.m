//
//  MasterViewController.m
//  Articles
//
//  Created by Marcin on 02.02.2015.
//  Copyright (c) 2015 Marcin. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

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
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Run *run = self.runs[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ Km", [run.distance stringValue]];
    
    cell.detailTextLabel.text = run.datetime.timeAgoSinceNow;
    return cell;
}


#pragma mark - RESTKit

- (void)requestData {
//  Production
    NSString *requestPath = @"/api/v1/users/6?user_email=pedroanisio@gmail.com&user_token=2SyHaQrDMBj9EhZNKnNq";
    
// Development
//    NSString *requestPath = @"/api/v1/users/7?user_email=runordieadm@gmail.com&user_token=-Ee48k2xe532wEJ3Uh4V";
    
    
    [[RKObjectManager sharedManager]
     getObjectsAtPath:requestPath
     parameters:nil
     success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
         //runs have been saved in core data by now
         [self fetchRunsFromContext];
     }
     failure: ^(RKObjectRequestOperation *operation, NSError *error) {
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