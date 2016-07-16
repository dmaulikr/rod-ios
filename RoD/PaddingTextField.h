//
//  PaddingTextField.h
//  Kuilima
//
//  Created by Huyns89 on 2/26/14.
//  Copyright (c) 2014 Hoanglm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaddingTextField : UITextField

@property (strong, nonatomic) UIView * leftViewNormal;
@property (strong, nonatomic) UIView * leftViewHighlight;
@property (strong, nonatomic) UIView * rightViewNormal;
@property (strong, nonatomic) UIView * rightViewHighlight;

@end
