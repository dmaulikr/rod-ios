//
//  NewRunViewController.h
//  RoD
//
//  Created by Pedro Anisio Silva on 29/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class NewRunViewController;
@protocol NewRunViewControllerDelegate <NSObject>   //define delegate protocol
- (void) onPostResource: (NewRunViewController *) sender;  //define delegate method to be implemented within another class
@end //end protocol

@interface NewRunViewController : UIViewController
@property (nonatomic, weak) IBOutlet id <NewRunViewControllerDelegate> delegate; //define MyClassDelegate as delegate


@end
