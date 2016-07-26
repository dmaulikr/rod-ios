//
//  AppDelegate.m
//  RoD
//
//  Created by Pedro Anisio Silva on 27/06/16.
//  Copyright © 2016 RoD. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

// Use a class extension to expose access to MagicalRecord's private setter methods
@interface NSManagedObjectContext ()
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;
@end

@implementation AppDelegate

@synthesize managedObjectContext;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Flurry startSession:@"DBZ2TQV3FXB8MMSXNPWX"];
    
    [MagicalRecord enableShorthandMethods];
    
    AppData *appData = [AppData sharedManager];
    
    // Initialize RestKit
    NSURL *baseURL = [NSURL URLWithString:ENDPOINT_URL];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    // Initialize managed object model from bundle
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;

    // Complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"RoD.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"RKSeedDatabase" ofType:@"sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    // Start mapping definition
    
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"User" inManagedObjectStore:managedObjectStore];
    userMapping.identificationAttributes = @[ @"userId" ];
    
    [userMapping
     addAttributeMappingsFromDictionary:
     @{
       @"email"         : @"email",
       @"status"        : @"status",
       @"name"          : @"name",
       @"id"            : @"userId"
       }
     ];
    
    RKEntityMapping *runMapping = [RKEntityMapping mappingForEntityForName:@"Run" inManagedObjectStore:managedObjectStore];
    runMapping.identificationAttributes = @[ @"runId" ];
    [runMapping
     addAttributeMappingsFromDictionary:
        @{
            @"distance" : @"distance",
            @"duration" : @"duration",
            @"pace"     : @"pace",
            @"speed"    : @"speed",
            @"datetime" : @"datetime",
            @"id"       : @"runId",
            @"user_id"  : @"userId"
        }
        ];

    [userMapping addPropertyMapping:
     [RKRelationshipMapping relationshipMappingFromKeyPath:@"runs"
                                                 toKeyPath:@"runs"
                                               withMapping:runMapping]
     ];
    
    
    RKResponseDescriptor *userResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/v1/users/:id"
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [objectManager addResponseDescriptor:userResponseDescriptor];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
 
    //authenticatedUser: check from NSUserDefaults User credential if its present then set your navigation flow accordingly
    if (![appData authenticatedUser])
    {
        [self showLoginScreen];
    }
    
    return YES;
}

-(void) showLoginScreen {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = (LoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"login_vc"];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [Flurry logAllPageViewsForTarget:navigation];
    self.window.rootViewController = navigation;
}

// Shared context

- (NSManagedObjectContext *)managedObjectContext
{
    return [NSManagedObjectContext MR_defaultContext];
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}


@end
