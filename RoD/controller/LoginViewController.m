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
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *msgAlert;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtPassword.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self myLogin];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tryLogin:(id)sender {
    self.msgAlert.text = @"apertou o botao";
    [self myLogin];
}

-(void) myLogoff{
    
    // Cancel any network operations and clear the cache
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // Cancel any object mapping in the response mapping queue
    [[RKObjectRequestOperation responseMappingQueue] cancelAllOperations];
    
    // Reset persistent stores
    [[RKManagedObjectStore defaultStore] resetPersistentStores:nil];
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"user_email"];
    [defaults removeObjectForKey:@"user_token"];
    [defaults removeObjectForKey:@"user_id"];
    
    [defaults synchronize];

}

-(void) myLogin {
    
//    NSURL *baseURL = [NSURL URLWithString:@"http://localhost:3000/api/v1/"];
    NSURL *baseURL = [NSURL URLWithString:@"http://app.runordie.run/api/v1/"];

    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.txtEmail.text, @"email",
                            self.txtPassword.text, @"password",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"sessions" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            // Store the data
                                                                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                                                            
                                                                                            [defaults setObject:self.txtEmail.text forKey:@"user_email"];
                                                                                            [defaults setObject:[JSON objectForKey:@"auth_token"] forKey:@"user_token"];
                                                                                            [defaults setObject:[JSON objectForKey:@"user_id"] forKey:@"user_id"];
                                                                                            
                                                                                            [defaults synchronize];
                                                                                            [self pushAuthUserView];
                                                                                                                                                                                        
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                                            NSLog(@"Failure");
                                                                                        }];
    
    [operation start];
    [operation waitUntilFinished];
    

    
}

- (void) pushAuthUserView {
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    myDelegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Master"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
