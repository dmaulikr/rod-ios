//
//  ForgotViewController.h
//  YoVideo
//
//  Created by Huyns89 on 3/3/15.
//  Copyright (c) 2015 Huyns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaddingTextField.h"

@interface ForgotViewController : BaseViewController
{
    __weak IBOutlet PaddingTextField *tf_email;
    __weak IBOutlet UIButton *btn_reset;
    
}
- (IBAction)onReset:(id)sender;
@end
