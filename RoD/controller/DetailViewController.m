//
//  DetailViewController.m
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import "DetailViewController.h"


@interface DetailViewController ()
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void) setupview {
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
    [_btnSave setShowsTouchWhenHighlighted:YES];
    
    
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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    _runDateAndTime = self.currentRun.datetime;
    _runDistance = self.currentRun.distance;
    _runDuration = self.currentRun.duration;
    
    [self setLabel:[dateFormatter stringFromDate:self.runDateAndTime] toUIButton:self.btnDateTime];
    [self setLabel:[NSString stringWithFormat:@"%2.2f km", [self.runDistance floatValue]] toUIButton:self.btnDistance];
    [self setLabel:[self timeFormatted:[_runDuration intValue]] toUIButton:self.btnDuration];
    
    
    [self setupview];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSString *) randomFileName:(int)len withExtension: (NSString*)extension {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return [NSString stringWithFormat:@"%@.%@",randomString,extension];
}


- (IBAction)doPostRun:(id)sender {
    
    if ([self.runDistance floatValue] == 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"You should set run distance before save", nil));
        return;
    }
    if ([self.runDuration intValue] == 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"You should set run duration before save", nil));
        return;
    }
    
    AppData *appData = [AppData sharedManager];
    [appData updateRun:_currentRun withBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void) setLabel:(NSString*)label toUIButton:(UIButton*)button {
    
    [button setTitle:label forState:UIControlStateNormal];
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
    
    float totalDistance = [_runDistance floatValue];
    float myKm = (int) totalDistance; //returns 5 feet
    float myMeters = totalDistance-myKm;
    myMeters = myMeters*100;
    
    if (_distanceKmPart == nil) {
        _distanceKmPart = [NSNumber numberWithInt:totalDistance];
    }

    if (_distanceMeterPart == nil) {
        _distanceMeterPart = [NSNumber numberWithInt:myMeters];
    }

    [ActionSheetDistancePicker showPickerWithTitle:@"Select Distance" bigUnitString:@"." bigUnitMax:99 selectedBigUnit:[self.distanceKmPart integerValue]smallUnitString:@"km" smallUnitMax:99 selectedSmallUnit:[self.distanceMeterPart integerValue] target:self action:@selector(measurementWasSelectedWithBigUnit:smallUnit:element:) origin:sender];
}

- (void)measurementWasSelectedWithBigUnit:(NSNumber *)bigUnit smallUnit:(NSNumber *)smallUnit element:(id)element {
    
    self.distanceKmPart = bigUnit;
    self.distanceMeterPart = smallUnit;
    self.runDistance = [NSNumber numberWithFloat:[bigUnit floatValue]+[smallUnit floatValue]/100];
    _currentRun.distance = _runDistance;
    [self setLabel:[NSString stringWithFormat:@"%2.2f km", [self.runDistance floatValue]] toUIButton:self.btnDistance];
}


- (IBAction)selectADate:(id)sender {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    if (_runDateAndTime == nil) {
        
        _runDateAndTime = [NSDate date];
    }
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime
                                                         selectedDate:self.runDateAndTime
                                                               target:self
                                                               action:@selector(dateWasSelected:element:)
                                                               origin:sender];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSCalendarUnitDay amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.runDateAndTime = selectedDate;
     _currentRun.datetime = _runDateAndTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
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
        _currentRun.duration = _runDuration;
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
- (IBAction)cameraTap:(id)sender {
    
    //Show action sheet for selecting photo source
    UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                 initWithTitle:@"Please select photo"
                                 delegate:self
                                 cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"choose from library", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self launchImagePickerViewController];
        
    }
    
    if (buttonIndex == 2) {
        
    }
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(PHAsset *)asset {
    
    NSLog(@"selecionou");
}


-(void) launchImagePickerViewController {
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new]; imagePickerController.delegate = self;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    PHImageRequestOptions* requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // this one is key
    requestOptions.synchronous = true;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[assets count]];
    
    // assets contains PHAsset objects.
    __block UIImage *ima;
    
    for (PHAsset *asset in assets) {
        // Do something with the asset
        
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            ima = image;
                            
                            [images addObject:ima];
                        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:[images objectAtIndex:0]];
    cropViewController.delegate = self;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    // 'image' is the newly cropped version of the original image
    
    UIImage *small = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:image.imageOrientation];
    self.runImage.contentMode = UIViewContentModeScaleAspectFit;
    self.runImage.clipsToBounds = YES;
    self.runImage.image =  small;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
