//
//  Run+CoreDataProperties.h
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run.h"

NS_ASSUME_NONNULL_BEGIN

@interface Run (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *pace;
@property (nullable, nonatomic, retain) NSDate *datetime;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *speed;
@property (nullable, nonatomic, retain) NSNumber *runId;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSManagedObject *user;

@end

NS_ASSUME_NONNULL_END
