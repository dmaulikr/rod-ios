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
    // Do any additional setup after loading the view.
//    tf_email.layer.cornerRadius = 2;
//    tf_email.layer.borderColor = [[UIColor colorFromHexString:@"#ccccce"] CGColor];
//    tf_email.layer.borderWidth = 1;
//    tf_email.layer.masksToBounds = YES;
    [self.view setBackgroundColor:[UIColor blackColor]];
    [tf_email setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}]];
    
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
    
//    httpClient = [[AFCustomClient alloc] initWithBaseURL:[NSURL URLWithString:base_url]];
    
    tf_email.leftViewNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_email"]];
    tf_email.leftViewHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_email_p"]];
    [tf_email setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName : PLACEHOLDER_COLOR, NSFontAttributeName : [UIFont systemFontOfSize:17]}]];
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
    
    NSURL *baseURL = [NSURL URLWithString:@"http://localhost:3000/api/v1/"];
    //NSURL *baseURL = [NSURL URLWithString:@"http://app.runordie.run/api/v1/"];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tf_email.text, @"user[email]",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"password" parameters:params];
    
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
