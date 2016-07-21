//
//  LoginViewController.m
//  RoD
//
//  Created by Pedro Anisio Silva on 28/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>



@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSignin;

@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _btnSignin.layer.masksToBounds = YES;
    _btnSignin.layer.cornerRadius = 25;
    _btnSignin.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _btnSignin.layer.shouldRasterize = YES;
    _btnSignin.clipsToBounds = YES;
    
    txtEmail.leftViewNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_about_us"]];
    txtEmail.leftViewHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_about_us_p"]];
    
    txtPassword.leftViewNormal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_lock"]];
    txtPassword.leftViewHighlight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_lock_p"]];
    
    UIButton * btnShowPass1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btnShowPass1 setImage:[UIImage imageNamed:@"ic_view_n"] forState:UIControlStateNormal];
    [btnShowPass1 addTarget:self action:@selector(btnShowPass_Click:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btnShowPass2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btnShowPass2 setImage:[UIImage imageNamed:@"ic_view_p"] forState:UIControlStateNormal];
    [btnShowPass2 addTarget:self action:@selector(btnShowPass_Click:) forControlEvents:UIControlEventTouchUpInside];
    txtPassword.rightViewNormal = btnShowPass1;
    txtPassword.rightViewHighlight = btnShowPass2;
    
    txtPassword.delegate = self;
    // Do any additional setup after loading the view.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLogin:(id)sender {
    
    NSString *userName = txtEmail.text;
    NSString *pass = txtPassword.text;
    
    if (userName.length <= 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"User name empty warning", nil));
        return;
    }
    if (pass.length <= 0) {
        ALERT_WITH_TITLE(@"", NSLocalizedString(@"Password empty warning", nil));
        return;
    }
    if ([userName conTainSpecialCharaters] || [pass conTainSpecialCharaters]) {
        ALERT_WITH_TITLE(@"",kMessageContainSpecialCharacters);
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];

    
    NSURL *baseURL = [NSURL URLWithString:ENDPOINT_URL];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            txtEmail.text, @"email",
                            txtPassword.text, @"password",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/api/v1/sessions" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            // Store the data
                                                                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                                            
                                                                                            [defaults setObject:txtEmail.text forKey:@"user_email"];
                                                                                            [defaults setObject:[JSON objectForKey:@"auth_token"] forKey:@"user_token"];
                                                                                            [defaults setObject:[JSON objectForKey:@"user_id"] forKey:@"user_id"];
                                                                                            
                                                                                            [defaults synchronize];
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self pushAuthUserView];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                                            NSLog(@"Failure");
                                                                                            [SVProgressHUD dismiss];
                                                                                            ALERT_WITH_TITLE(@"", NSLocalizedString(@"Wrong password or Invalid user", nil));

                                                                                        }];
    
    [operation start];
    [operation waitUntilFinished];
    

}


- (void) pushAuthUserView {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    myDelegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TabBar"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - util methods
- (void)btnShowPass_Click:(UIButton *)sender {
    txtPassword.secureTextEntry = !txtPassword.secureTextEntry;
}

@end
