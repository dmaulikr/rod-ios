//
//  User+CoreDataProperties.m
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

@dynamic name;
@dynamic email;
@dynamic status;
@dynamic auth_token;
@dynamic userId;
@dynamic runs;

@end
