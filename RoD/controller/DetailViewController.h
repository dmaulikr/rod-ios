//
//  DetailViewController.h
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSDate+TCUtils.h"
#import "ActionSheetPicker.h"
#import "TOCropViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <QBImagePickerController/QBImagePickerController.h>

@interface DetailViewController : UIViewController <ActionSheetCustomPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,TOCropViewControllerDelegate > {
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
@property (strong, nonatomic) Run *currentRun;
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

