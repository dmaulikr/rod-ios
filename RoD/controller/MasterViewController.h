//
//  MasterViewController.h
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRunViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NewRunViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;


@end
