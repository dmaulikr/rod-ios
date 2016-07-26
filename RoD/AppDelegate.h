//
//  AppDelegate.h
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext; // or strong if you ARC instead of retain

+ (AppDelegate *)sharedAppDelegate;

@end



