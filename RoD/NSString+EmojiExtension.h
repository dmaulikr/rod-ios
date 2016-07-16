//
//  NSString+EmojiExtension.h
//  YoVideo
//
//  Created by HuyNS on 5/29/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EmojiExtension)
- (NSString*)removeEmoji ;
-(NSString *) removeSpecialCharacters;
-(BOOL) isValidEmailString;
-(BOOL) conTainSpecialCharaters;
-(BOOL) containEmojiCharaters;
-(BOOL) isValidUserNameString;
@end
