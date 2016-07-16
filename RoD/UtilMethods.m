//
//  UtilMethods.m
//  YoVideo
//
//  Created by Nguyen Thanh Binh on 1/4/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "UtilMethods.h"

@implementation UtilMethods

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (CGRect)rectForText:(NSString *)text usingFont:(UIFont *)font boundedBySize:(CGSize)maxSize
{
    if (!text || text.length == 0) {
        text = @"Updating...";
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:@{ NSFontAttributeName:font}];
    
    return [attrString boundingRectWithSize:maxSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}

+ (NSString *)shortStringOfNumber:(NSInteger)number {
    NSString * shortNumber;
    if (number >= 1000000) {
        shortNumber = [NSString stringWithFormat:@"%zdm", number / 1000000];
    }
    else if (number > 1000) {
        shortNumber = [NSString stringWithFormat:@"%zdk", number / 1000];
    }
    else {
        shortNumber = [NSString stringWithFormat:@"%zd", number];
    }
    return shortNumber;
}

@end
