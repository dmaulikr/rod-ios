//
//  StatsControllerViewController.h
//  RoD
//
//  Created by Pedro Anisio Silva on 24/07/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsControllerViewController : UIViewController

@property (strong, nonatomic) NSArray *statsArray;
@property int statsPosition;

@property (weak, nonatomic) IBOutlet UILabel *weekGoal;
@property (weak, nonatomic) IBOutlet UILabel *weekGoalPercentage;
@property (weak, nonatomic) IBOutlet UILabel *weekPace;
@property (weak, nonatomic) IBOutlet UILabel *weekRunCount;
@property (weak, nonatomic) IBOutlet UILabel *weekDistance;
@property (weak, nonatomic) IBOutlet UILabel *weekNumber;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *goalProgress;

-(void) buildView;

@end
