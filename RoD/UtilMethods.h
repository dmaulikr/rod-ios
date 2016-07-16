//
//  UtilMethods.h
// YoVideo
//
//  Created by Nguyen Thanh Binh on 1/4/16.
//  Copyright © 2016 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLACEHOLDER_COLOR [UIColor colorWithRed:89/255.0 green:107/255.0 blue:121/255.0 alpha:1.0]
#define kWISH_LIST @"wish_list"
#define kDOWNLOAD_LIST @"download_list"
#define kLIKE_IDS @"like_ids"
#define NO_SERIES_TEXT @"No series"

@interface UtilMethods : NSObject

/**
 *  scale image xuống size bất kì
 *
 *  @param image   đối tượng UIImage
 *  @param newSize kích thước mới của ảnh
 *
 *  @return <#return value description#>
 */
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

/**
 *  tính size của text (width và height)
 *
 *  @param text    text cần tính
 *  @param font    font dùng
 *  @param maxSize size lớn nhất có thể của text
 *
 *  @return CGRect
 */
+ (CGRect)rectForText:(NSString *)text usingFont:(UIFont *)font boundedBySize:(CGSize)maxSize;

/**
 *  lấy định dạng ngắn của 1 số như: 100k, 10k, 1k
 *
 *  @param number số cần lấy định dạng ngắn
 *
 *  @return định dạng ngắn của số
 */
+ (NSString *)shortStringOfNumber:(NSInteger)number;

@end
