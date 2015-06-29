#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define ManagedObjectContext() [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    NSPersistentStore *persistentStore_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)applicationCacheDirectoryReset;
- (NSString *)applicationCacheDirectory;
- (NSString *)applicationImageCacheDirectory;
- (NSString *)applicationUploadTempDirectory;

@end

