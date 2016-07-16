//
//  NSString+EmojiExtension.m
//  YoVideo
//
//  Created by HuyNS on 5/29/14.
//  Copyright (c) 2014 Huyns. All rights reserved.
//

#import "NSString+EmojiExtension.h"

@implementation NSString (EmojiExtension)
- (NSString*)removeEmoji {
    __block NSMutableString* temp = [NSMutableString string];
    
    [self enumerateSubstringsInRange: NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         const unichar hs = [substring characterAtIndex: 0];
         
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             const unichar ls = [substring characterAtIndex: 1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             
             [temp appendString: (0x1d000 <= uc && uc <= 0x1f77f)? @"": substring]; // U+1D000-1F77F
             
             // non surrogate
         } else {
             [temp appendString: (0x2100 <= hs && hs <= 0x26ff)? @"": substring]; // U+2100-26FF
         }
     }];
    
    return temp;
}
-(NSString *) removeSpecialCharacters
{
//    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.'\":;,?/.-=!$%&()+|\\ "] invertedSet];
    NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:kSpecialCharacters];
    NSString *resultString = [[self componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    return resultString;
}
-(BOOL) conTainSpecialCharaters
{
    NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:kSpecialCharacters];
    if ([self rangeOfCharacterFromSet:notAllowedChars].location != NSNotFound) {
        return YES;
    }
    return NO;
}
-(BOOL) containEmojiCharaters
{
    NSInteger length = self.length;
    NSString *newString = [self removeEmoji];
    if (length > newString.length) {
        return YES;
    }
    return NO;
}
-(BOOL) isValidEmailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject: self];
}
-(BOOL) isValidUserNameString
{
    NSString *userRegex = @"^[a-zA-Z0-9_-]+$";
    NSPredicate *UserTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userRegex];
    
    return [UserTest evaluateWithObject: self];
}
@end
