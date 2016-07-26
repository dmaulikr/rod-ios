//
//  AppData.m
//  RoD
//
//  Created by Pedro Anisio Silva on 26/07/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"

@implementation AppData

@synthesize someProperty;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static AppData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
    }
    return self;
}

- (void) saveUserSession:(NSDictionary *)json {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[json objectForKey:@"email"] forKey:@"user_email"];
    [defaults setObject:[json objectForKey:@"auth_token"] forKey:@"user_token"];
    [defaults setObject:[json objectForKey:@"user_id"] forKey:@"user_id"];
    [defaults synchronize];
    
    [self loadUserSession];
}

- (void) loadUserSession {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _userToken  = [defaults objectForKey:@"user_token"];
    _userEmail  = [defaults objectForKey:@"user_email"];
    _userId     = [defaults objectForKey:@"user_id"];
}

-(BOOL) authenticatedUser {
    // Get the stored data before the view loads
    [self loadUserSession];
    
    if ([_userEmail length] > 3 && [_userToken length] > 3) {
        return TRUE;
        
    } else {
        return FALSE;
    }
}

-(void) clearAppData {
    // Cancel any network operations and clear the cache
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // Cancel any object mapping in the response mapping queue
    [[RKObjectRequestOperation responseMappingQueue] cancelAllOperations];
    
    // Reset persistent stores
    [[RKManagedObjectStore defaultStore] resetPersistentStores:nil];
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"user_email"];
    [defaults removeObjectForKey:@"user_token"];
    [defaults removeObjectForKey:@"user_id"];
    [defaults synchronize];
}

- (void) deleteRun:(Run*) run {
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/runs/%@?user_email=%@&user_token=%@", run.runId, _userEmail, _userToken];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] deleteObject:run
                                             path:requestPath
                                       parameters:nil
                                          success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                    [SVProgressHUD dismiss];
                                                    }
                                          failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                                                    [SVProgressHUD dismiss];
                                              ALERT_WITH_TITLE(@"", NSLocalizedString(@"Error while deleting run", nil));
                                              RKLogError(@"Delete failed with error: %@", error);
                                          }];
}


- (void) requestUserRuns:(void (^)(void))callbackBlock {
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/users/%@?user_email=%@&user_token=%@", _userId, _userEmail, _userToken];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:requestPath
                                           parameters:nil
                                              success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [SVProgressHUD dismiss];
                                                  callbackBlock();
                                              }
                                              failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                                                  [SVProgressHUD dismiss];
                                                  ALERT_WITH_TITLE(@"", NSLocalizedString(@"Error while loading runs", nil));
                                                  RKLogError(@"Load failed with error: %@", error);
                                              }];
}

- (void) createRun:(Run *)run withImage:(UIImage*)image withBlock:(void (^)(void))callbackBlock {
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/users/%@/runs?user_email=%@&user_token=%@", _userId, _userEmail, _userToken];
    NSString *requestPathResponseReady = [NSString stringWithFormat:@"/api/v1/users/%@/runs", _userId, _userEmail, _userToken];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    // Log all HTTP traffic with request and response bodies
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    // Log debugging info about Core Data
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelDebug);
    
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping
     addAttributeMappingsFromDictionary:
     @{
       @"email"         : @"email",
       @"status"        : @"status",
       @"name"          : @"name",
       @"id"            : @"userId"
       }
     ];
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Run class]];
    [responseMapping
     addAttributeMappingsFromDictionary:
     @{
       @"distance" : @"distance",
       @"duration" : @"duration",
       @"pace"     : @"pace",
       @"speed"    : @"speed",
       @"datetime" : @"datetime",
       @"id"       : @"runId"
       }
     ];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping
     addAttributeMappingsFromDictionary:
     @{
       @"distance" : @"distance",
       @"duration" : @"duration",
       @"datetime" : @"datetime",
       @"userId"  :  @"user_id"
       }
     ];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:responseMapping
                                                method:RKRequestMethodAny
                                                pathPattern:requestPathResponseReady
                                                keyPath:@""
                                                statusCodes:statusCodes];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
                                              requestDescriptorWithMapping:requestMapping
                                              objectClass:[Run class]
                                              rootKeyPath:@""
                                              method:RKRequestMethodAny];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
        
    NSMutableURLRequest *request = [[RKObjectManager sharedManager]
                                    multipartFormRequestWithObject:run
                                    method:RKRequestMethodPOST
                                    path:requestPath
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        NSData *imgData = UIImagePNGRepresentation(image);
                                        NSLog(@"Size of ori Image(bytes):%lu",(unsigned long)[imgData length]);
                                        
                                        float compressionQuality = 1;
                                        
                                        while ((unsigned long)[imgData length] > kImageUploadSize) {
                                            
                                            imgData = UIImageJPEGRepresentation(image,compressionQuality);
                                            compressionQuality = compressionQuality-0.1;
                                            NSLog(@"Size of sma Image(bytes):%lu",(unsigned long)[imgData length]);
                                        }
                                        
                                        [formData appendPartWithFileData:imgData
                                                                    name:@"rod_images_attributes[0][image]"
                                                                fileName:[UtilMethods randomFileName:32 withExtension:@"jpg"]
                                                                mimeType:@"image/jpg"];}];
    
    
    RKManagedObjectRequestOperation *operation = [[RKObjectManager sharedManager]
                                                  managedObjectRequestOperationWithRequest:request
                                                  managedObjectContext:[[[RKObjectManager sharedManager]managedObjectStore]mainQueueManagedObjectContext]
                                                  success:
                                                  ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      [SVProgressHUD dismiss];
                                                      callbackBlock();}
                                                  failure:
                                                  ^(RKObjectRequestOperation *operation, NSError *error) {
                                                      [SVProgressHUD dismiss];}];
    
    operation.targetObject = run;
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation]; // NOTE: Must be enqueued rather than started
        
}

- (Run *) createTemporaryRunWithDistance:(NSNumber*)distance duration:(NSNumber*)duration dateAndTime:(NSDate*)date andImage:(UIImage*)image {
    
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:[[[RKObjectManager sharedManager]managedObjectStore]mainQueueManagedObjectContext]];
    
    newRun.distance = distance;
    newRun.duration = duration;
    newRun.datetime = date;
    newRun.user = [self getMeUser];
    return newRun;
}

- (void) updateRun:(Run *)run withBlock:(void (^)(void))callbackBlock {
    NSString *requestPath = [NSString stringWithFormat:@"/api/v1/runs/%i?user_email=%@&user_token=%@", [run.runId intValue], _userEmail, _userToken];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];
    [requestMapping
     addAttributeMappingsFromDictionary:
     @{
       @"distance" : @"distance",
       @"duration" : @"duration",
       @"datetime" : @"datetime",
       @"runId"    : @"id"
       }
     ];
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[Run class]];
    [responseMapping
     addAttributeMappingsFromDictionary:
     @{
       @"distance" : @"distance",
       @"duration" : @"duration",
       @"pace"     : @"pace",
       @"speed"    : @"speed",
       @"datetime" : @"datetime",
       @"id"       : @"runId"
       }
     ];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor
                                                responseDescriptorWithMapping:responseMapping
                                                method:RKRequestMethodAny
                                                pathPattern:@"/api/v1/runs/:id"
                                                keyPath:@""
                                                statusCodes:statusCodes];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor
                                              requestDescriptorWithMapping:requestMapping
                                              objectClass:[Run class]
                                              rootKeyPath:@""
                                              method:RKRequestMethodAny];
    
    [[RKObjectManager sharedManager] addRequestDescriptor:requestDescriptor];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
    
    
    [[RKObjectManager sharedManager] putObject:run
                                          path:requestPath
                                    parameters:nil
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           [SVProgressHUD dismiss];
                                           callbackBlock();}
                                       failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                                           [SVProgressHUD dismiss];}];
}

-(User*) getMeUser {
    return [User MR_findFirstByAttribute:@"userId" withValue:_userId];
}

@end
