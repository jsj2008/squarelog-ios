#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityHelper : NSObject {

    Reachability* hostReach;
    NetworkStatus netStatus;
}

+ (ReachabilityHelper*) sharedInstance;

- (NetworkStatus) lookupReachability;
- (BOOL) isConnected;

@property NetworkStatus networkStatus;

@end
