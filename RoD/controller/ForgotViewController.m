//
//  ForgotViewController.m
//  YoVideo
//
//  Created by Huyns89 on 3/3/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import "ForgotViewController.h"
#import "AFNetworking.h"

@interface ForgotViewController () <UITextFieldDelegate>

- (IBAction)btnBack_Click:(id)sender;
@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    btn_reset.layer.masksToBounds = YES;
    btn_reset.layer.cornerRadius = 25;
    btn_reset.layer.rasterizationScale = [UIScreen mainScreen].scale;
    btn_reset.layer.shouldRasterize = YES;
    btn_reset.clipsToBounds = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:nil
                                                  forBarMetrics:UIBarMetricsDefault];   
    
    tf_email.leftViewNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_about_us"]];
    tf_email.leftViewHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_about_us_p"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onReset:(id)sender {
    if (tf_email.text.length <= 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"Email empty warning", nil));
        return;
    }
    [tf_email resignFirstResponder];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    NSURL *baseURL = [NSURL URLWithString:ENDPOINT_URL];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tf_email.text, @"user[email]",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/api/v1/password" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            // Action bellow

                                                                                            [SVProgressHUD dismiss];
                                                                                            ALERT_WITH_TITLE(@"", NSLocalizedString(@"Please follow the instructions in your email", nil));
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            ALERT_WITH_TITLE(@"", NSLocalizedString(@"Email not found", nil));
                                                                                            
                                                                                        }];
    
    [operation start];
    [operation waitUntilFinished];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnBack_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
