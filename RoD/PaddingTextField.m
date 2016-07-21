//
//  PaddingTextField.m
//  Kuilima
//
//  Created by Huyns89 on 2/26/14.
//  Copyright (c) 2014 Hoanglm. All rights reserved.
//

#import "PaddingTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface PaddingTextField ()
{
    CALayer * _underlineLayer, * _highlightUnderlineLayer;
}
@end

@implementation PaddingTextField

@synthesize leftViewNormal = _leftViewNormal;
@synthesize rightViewNormal = _rightViewNormal;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//    return CGRectInset( bounds , 15 , 0 );
//}
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    return CGRectInset( bounds , 15 , 0 );
//}


- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    
    self.rightViewMode = UITextFieldViewModeAlways;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    [self addTarget:self action:@selector(textField_TouchUp:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(textField_TouchDown:) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)textField_TouchDown:(UITextField *)txt {
    
    self.leftView = _leftViewHighlight;
    self.rightView = _rightViewHighlight;
    
    self.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];

    _underlineLayer.backgroundColor = [UIColor colorWithRed:0.294 green:0.059 blue:0.682 alpha:1.00].CGColor;
    
}

- (void)textField_TouchUp:(UITextField *)txt {
    
    self.leftView = _leftViewNormal;
    self.rightView = _rightViewNormal;
    
    self.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.00];
    _underlineLayer.backgroundColor = [UIColor whiteColor].CGColor;
}

- (void)setLeftViewNormal:(UIView *)leftViewNormal {
    _leftViewNormal = leftViewNormal;
    self.leftView = _leftViewNormal;
}

- (void)setRightViewNormal:(UIView *)rightViewNormal {
    _rightViewNormal = rightViewNormal;
    self.rightView = _rightViewNormal;
}

- (CALayer *)layerForTextField {
    CALayer * layer = [CALayer layer];
    CGRect frame = self.bounds;
    layer.frame = CGRectMake(0, frame.size.height-1, 600, 1.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    //    layer.backgroundColor = [UIColor grayColor].CGColor;
    return layer;
}

- (CALayer *)highlightLayerForTextField {
    CALayer * layer = [CALayer layer];
    CGRect frame = self.bounds;
    layer.frame = CGRectMake(0, frame.size.height-1, 600, 1.0f);
    layer.backgroundColor = [UIColor colorWithRed:0.294 green:0.059 blue:0.682 alpha:1.00].CGColor;
    //    layer.backgroundColor = [UIColor grayColor].CGColor;
    return layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_underlineLayer) {
        _underlineLayer = [self layerForTextField];
        [self.layer addSublayer:_underlineLayer];
        self.layer.masksToBounds = YES;
    }
    
//    _highlightUnderlineLayer = [self highlightLayerForTextField];
}

@end
