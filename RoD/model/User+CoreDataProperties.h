//
//  User+CoreDataProperties.h
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *auth_token;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSSet<Run *> *runs;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRunsObject:(Run *)value;
- (void)removeRunsObject:(Run *)value;
- (void)addRuns:(NSSet<Run *> *)values;
- (void)removeRuns:(NSSet<Run *> *)values;

@end

NS_ASSUME_NONNULL_END
