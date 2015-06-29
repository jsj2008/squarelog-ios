#import <Foundation/Foundation.h>
#import "FSSettings.h"
#import "URLConnectionHandler.h"

@interface FSUserLookup : URLConnectionHandler {
    
    NSDictionary *info;
}

- (void) lookupAuthenticatedUser;
- (void) lookupWithUserId:(NSInteger) userId;

- (NSDictionary*) authenticatedUser:(BOOL)expire;

+ (FSUserLookup*)sharedInstance;
+ (NSString*) formatUserName:(NSDictionary*)user;

@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) NSDictionary *authenticatedUser;

@end