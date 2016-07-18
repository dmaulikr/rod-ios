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
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;



@end

@implementation NewRunViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    self.runDateAndTime = [NSDate date];
    _btnDateTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnDuration.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnDistance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    //initialize arrays
    hoursArray = [[NSMutableArray alloc] init];
    minutesArray = [[NSMutableArray alloc] init];
    secondsArray = [[NSMutableArray alloc] init];
    
    secondLabel = @[@"sec"];
    minuteLabel = @[@"min"];
    hourLabel = @[@"hour"];
    
    _btnSave.layer.masksToBounds = YES;
    _btnSave.layer.cornerRadius = 25;
    _btnSave.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _btnSave.layer.shouldRasterize = YES;
    _btnSave.clipsToBounds = YES;
    
    NSString *strVal = [[NSString alloc] init];
    
    for(int i=0; i<61; i++)
    {
        strVal = [NSString stringWithFormat:@"%d", i];
        
        //NSLog(@"strVal: %@", strVal);
        
        //Create array with 0-24 hours
        if (i < 24)
        {
            [hoursArray addObject:strVal];
        }
        
        //create arrays with 0-60 secs/mins
        [minutesArray addObject:strVal];
        [secondsArray addObject:strVal];
    }
    
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
    
    if ([self.runDistance floatValue] == 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"You should set run distance before save", nil));
        return;
    }
    if ([self.runDuration intValue] == 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"You should set run duration before save", nil));
        return;
    }
    
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
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:requestPathResponseReady keyPath:@"" statusCodes:statusCodes];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping objectClass:[Run class] rootKeyPath:@"" method:RKRequestMethodAny];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
    
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:appDelegate.managedObjectContext];
    
    newRun.distance = self.runDistance;
    newRun.duration = self.runDuration;
    newRun.datetime = self.runDateAndTime;
    newRun.user = [User MR_findFirstByAttribute:@"userId"
                                      withValue:userId];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    // POST to create
    [[RKObjectManager sharedManager] postObject:newRun path:requestPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [SVProgressHUD dismiss];
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];


    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];

}

-(void) setLabel:(NSString*)label toUIButton:(UIButton*)button {
    
    [button setTitle:label forState:UIControlStateNormal];
    
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

- (void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy' 'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:date];

}
- (IBAction)durationPicker:(UIButton *)sender {
    NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Color"
                                            rows:colors
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@, Index: %@, value: %@",
                                                 picker, selectedIndex, selectedValue);
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

-(NSDate*) dateFromNSString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MM-yyyy' 'HH:mm:ssZ"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    NSLog(@"Todays date is %@",dateFromString);
    return  dateFromString;
}


- (IBAction)selectADuration:(id)sender {
    
    NSNumber *hour = @0;
    NSNumber *yass2 = @0;
    NSNumber *minute = @0;
    NSNumber *yass4 = @0;
    NSNumber *second = @0;
    NSNumber *yass6 = @0;
    
    if ([self.runDuration intValue] > 0) {
        second = [NSNumber numberWithInt:[self.runDuration intValue] % 60];
        minute = [NSNumber numberWithInt:([self.runDuration intValue] / 60) % 60];
        hour = [NSNumber numberWithInt:[self.runDuration intValue] / 3600];
    }
    
    NSArray *initialSelections = @[hour, yass2, minute, yass4, second, yass6];
    
    [ActionSheetCustomPicker showPickerWithTitle:@"Select HH:MM:SS" delegate:self showCancelButton:NO origin:sender
                               initialSelections:initialSelections];
    
}

- (IBAction)selectADistance:(id)sender {
    [ActionSheetDistancePicker showPickerWithTitle:@"Select Distance" bigUnitString:@"." bigUnitMax:99 selectedBigUnit:[self.distanceKmPart integerValue]smallUnitString:@"km" smallUnitMax:99 selectedSmallUnit:[self.distanceMeterPart integerValue] target:self action:@selector(measurementWasSelectedWithBigUnit:smallUnit:element:) origin:sender];
}

- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element {
    self.distanceKmPart = bigUnit;
    self.distanceMeterPart = smallUnit;
    self.runDistance = [NSNumber numberWithFloat:[bigUnit floatValue]+[smallUnit floatValue]/100];
    [self setLabel:[NSString stringWithFormat:@"%2.2f km", [self.runDistance floatValue]] toUIButton:self.btnDistance];
}




- (IBAction)selectADate:(id)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.runDateAndTime
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSCalendarUnitDay amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];

}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.runDateAndTime = selectedDate;
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    [self setLabel:[dateFormatter stringFromDate:self.runDateAndTime] toUIButton:self.btnDateTime];

}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    int hoursInt = [self.selectedHour intValue];
    int minsInt = [self.selectedMinute intValue];
    int secsInt = [self.selectedSecond intValue];
    
    int interval = secsInt + (minsInt*60) + (hoursInt*3600);
    
    if (interval > 0) {
        self.runDuration = [NSNumber numberWithInt:interval];
        [self setLabel:[self timeFormatted:interval] toUIButton:self.btnDuration];
    }
    
    NSLog(@"hours: %d ... mins: %d .... sec: %d .... interval: %d", hoursInt, minsInt, secsInt, interval);
    
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [hoursArray count];
        case 1: return [hourLabel count];
        case 2: return [minutesArray count];
        case 3: return [minuteLabel count];
        case 4: return [secondsArray count];
        case 5: return [secondLabel count];
        default:break;
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return 40.0f;
        case 1: return 70.0f;
        case 2: return 40.0f;
        case 3: return 70.0f;
        case 4: return 40.0f;
        case 5: return 70.0f;
        default:break;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: return hoursArray[(NSUInteger) row];
        case 1: return hourLabel[0];
        case 2: return minutesArray[(NSUInteger) row];
        case 3: return minuteLabel[0];
        case 4: return secondsArray[(NSUInteger) row];
        case 5: return secondLabel[0];
        default:break;
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %li selected in component %li", (long)row, (long)component);
    switch (component) {
        case 0:
            self.selectedHour = hoursArray[(NSUInteger) row];
            return;
        case 2:
            self.selectedMinute = minutesArray[(NSUInteger) row];
            return;
        case 4:
            self.selectedSecond = secondsArray[(NSUInteger) row];
            return;
        default:break;
    }
}
@end
