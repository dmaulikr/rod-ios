//
//  LoginViewController.h
//  RoD
//
//  Created by Pedro Anisio Silva on 28/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PaddingTextField.h"

@interface LoginViewController : UIViewController {

    __weak IBOutlet PaddingTextField *txtEmail;
    __weak IBOutlet PaddingTextField *txtPassword;
}



@end
