#import <Foundation/Foundation.h>

#import "URLConnectionHandler.h"

@interface FSFriendLookup : URLConnectionHandler {
    
    NSMutableDictionary *info;
}

- (void) lookupWithUserId:(NSInteger) userId;
+ (FSFriendLookup*)sharedInstance;

@property (nonatomic, retain) NSMutableDictionary *info;

@end
