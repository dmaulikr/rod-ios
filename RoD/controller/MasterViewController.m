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

#import <math.h>

#import "DateTools.h"
#import "MathController.h"


@interface MasterViewController ()

@property NSMutableArray *runs;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void) viewWillAppear:(BOOL)animated {
    [self requestData];
}

- (void) onPostResource:(NewRunViewController *)sender {
    [self requestData];
}

// During startup (-viewDidLoad or in storyboard) do:


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AppData* appData = [AppData sharedManager];
        [appData deleteRun:(Run*)self.runs[indexPath.row]];
        [self.runs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"edit_run"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.currentRun = self.runs[indexPath.row];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.runs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Run" forIndexPath:indexPath];
    Run *run = self.runs[indexPath.row];
    cell.date_human_txt.text = run.datetime.timeAgoSinceNow;
 
    float totalDistance = [run.distance floatValue];
    float myKm = (int) totalDistance; //returns 5 feet
    float myMeters = fmodf(totalDistance, myKm);
    
    cell.distance_txt.text = [NSString stringWithFormat:@"%02.0f", myKm];

    if (isnan(myMeters)) {
        cell.decimal_distance_txt.text = [NSString stringWithFormat:@".%.0f", [run.distance floatValue]*10];
    } else {
        cell.decimal_distance_txt.text = [NSString stringWithFormat:@".%.0f", myMeters*10];
    }
    
    cell.pace_txt.text = [MathController stringifyAvgPaceFromDist:[run.distance floatValue]*1000 overTime:[run.duration integerValue]];
    
    float speed = [MathController speedWithDistance:[run.distance floatValue] andDuration:[run.duration floatValue]];
    NSString *badg_name = [NSString stringWithFormat:@"white_%@",[MathController speedBadge:speed]];
    cell.pace_icon.image = [UIImage imageNamed:badg_name];

    return cell;
}


#pragma mark - RESTKit

- (void)requestData {
    
    AppData *appData = [AppData sharedManager];
    [appData requestUserRuns:^{
        [self fetchRunsFromContext];
    }];

}

//OPTIMIZE: move to AppData

- (void)fetchRunsFromContext {
    
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"userId" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    User *user = [fetchedObjects firstObject];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"datetime" ascending:NO];
    
    self.runs = [NSMutableArray arrayWithArray:[[user.runs allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSort]]];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}

@end