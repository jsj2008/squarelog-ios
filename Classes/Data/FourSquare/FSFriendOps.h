#import <Foundation/Foundation.h>

#import "URLConnectionHandler.h"

@interface FSFriendOps : URLConnectionHandler {

    BOOL success;
}

- (void)approveFriend:(NSInteger) userId;
- (void)denyFriend:(NSInteger) userId;
- (void)sendFriend:(NSInteger) userId;

+ (FSFriendOps*)sharedInstance;

@property BOOL success;

@end
