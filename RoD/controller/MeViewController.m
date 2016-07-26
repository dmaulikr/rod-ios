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

    [self logout];

}

-(void) logout
{
    // Remove data from singleton (where all my app data is stored)
    AppData *appData = [AppData sharedManager];
    [appData clearAppData];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    // Reset view controller (this will quickly clear all the views)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"login_vc"];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [Flurry logAllPageViewsForTarget:navigation];
    myDelegate.window.rootViewController = navigation;

    
}


@end
