//
//  NewRunViewController.h
//  RoD
//
//  Created by Pedro Anisio Silva on 29/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSDate+TCUtils.h"
#import "ActionSheetPicker.h"

@class NewRunViewController;
@protocol NewRunViewControllerDelegate <NSObject>   //define delegate protocol
- (void) onPostResource: (NewRunViewController *) sender;  //define delegate method to be implemented within another class
- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element;

@end //end protocol

@interface NewRunViewController : UIViewController <ActionSheetCustomPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource > {
    NSMutableArray *secondsArray;
    NSMutableArray *minutesArray;
    NSMutableArray *hoursArray;
    NSArray *secondLabel;
    NSArray *minuteLabel;
    NSArray *hourLabel;
}
@property (strong, nonatomic) AbstractActionSheetPicker *actionSheetPicker;
@property (weak, nonatomic) IBOutlet UIImageView *runImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) NSDate *runDateAndTime;
@property (strong, nonatomic) NSNumber *runDistance;
@property (strong, nonatomic) NSNumber *distanceKmPart;
@property (strong, nonatomic) NSNumber *distanceMeterPart;
@property (strong, nonatomic) NSNumber *runDuration;
@property (nonatomic, strong) NSNumber *selectedSecond;
@property (nonatomic, strong) NSNumber *selectedMinute;
@property (nonatomic, strong) NSNumber *selectedHour;
@property (nonatomic, strong) NSString *secondLabel;
@property (nonatomic, strong) NSString *minuteLabel;
@property (nonatomic, strong) NSString *hourLabel;



@end
