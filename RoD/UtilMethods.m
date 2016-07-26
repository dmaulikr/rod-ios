//
//  UtilMethods.m
//  YoVideo
//
//  Created by Nguyen Thanh Binh on 1/4/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import "UtilMethods.h"

@implementation UtilMethods

+(NSString *) randomFileName:(int)len withExtension: (NSString*)extension {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return [NSString stringWithFormat:@"%@.%@",randomString,extension];
}

@end
