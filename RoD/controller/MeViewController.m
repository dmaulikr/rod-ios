//
//  MeViewController.m
//  RoD
//
//  Created by Pedro Anisio Silva on 16/07/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSignout;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _btnSignout.layer.masksToBounds = YES;
    _btnSignout.layer.cornerRadius = 25;
    _btnSignout.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _btnSignout.layer.shouldRasterize = YES;
    _btnSignout.clipsToBounds = YES;
    [_btnSignout setShowsTouchWhenHighlighted:YES];
}
- (IBAction)onLogoff:(id)sender {
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
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login_vc"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
//    myDelegate.window.rootViewController = navigation;
    
    [(UINavigationController*)myDelegate.window.rootViewController pushViewController:rootController animated:YES];

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

@end
