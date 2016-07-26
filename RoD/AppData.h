//
//  AppData.h
//  RoD
//
//  Created by Pedro Anisio Silva on 26/07/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <foundation/Foundation.h>
#import "Run.h"
#import "User.h"

@interface AppData : NSObject {
    NSString *someProperty;
    NSString *userEmail;
    NSString *userToken;
    NSString *userId;
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) NSString *userToken;
@property (nonatomic, retain) NSString *userId;

+ (id)sharedManager;
- (BOOL) authenticatedUser;
- (void) clearAppData;
- (void) deleteRun:(Run *)run;
- (void) requestUserRuns:(void (^)(void))callbackBlock;
- (void) saveUserSession:(NSDictionary *)json;
- (void) createRun:(Run *)run withImage:(UIImage*)image withBlock:(void (^)(void))callbackBlock;
- (void) updateRun:(Run *)run withBlock:(void (^)(void))callbackBlock;
- (Run *) createTemporaryRunWithDistance:(NSNumber*)distance duration:(NSNumber*)duration dateAndTime:(NSDate*)date andImage:(UIImage*)image;
- (User *) getMeUser;



@end
