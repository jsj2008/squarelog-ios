#import "GTMObjectSingleton.h"

#import "ReachabilityHelper.h"

@implementation ReachabilityHelper

@synthesize networkStatus;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(ReachabilityHelper, sharedInstance)

#pragma mark -

- (id) init {
 
    if (self = [super init]) {
        
        // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
        // method "reachabilityChanged" will be called. 
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(reachabilityChanged:) 
                                                     name:kReachabilityChangedNotification 
                                                   object:nil];        
 
        hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
        [hostReach startNotifier];
    }
    
    return self;
}

- (NetworkStatus) lookupReachability
{
    return [hostReach currentReachabilityStatus];
    
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    if ([curReach connectionRequired]) {

        self.networkStatus = NotReachable;
        
    } else {

        self.networkStatus = [curReach currentReachabilityStatus];
    }
    
    LOG_EXPR(self.networkStatus);
}

- (BOOL) isConnected
{
    if (networkStatus != NotReachable) {
        return TRUE;
    } else {
        self.networkStatus = [hostReach currentReachabilityStatus];
        return networkStatus != NotReachable && ![hostReach connectionRequired];
    }
}

- (void) dealloc
{
    [hostReach stopNotifier];
    [super dealloc];
}

@end
