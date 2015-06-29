#import "FSFriendLookup.h"
#import "GTMObjectSingleton.h"
#import "FSSettings.h"
#import "NSMutableURLRequest+BasicAuth.h"
#import "UIApplication+Network.h"

@implementation FSFriendLookup

@synthesize info;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSFriendLookup, sharedInstance)

#pragma mark -

- (void) lookupWithUserId:(NSInteger) userId
{
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/friends.json?uid=%d", FS_API_BASE_URL, userId, nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:TIMEOUT_INTERVAL];
    
    [self sendRequest:theRequest];
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    self.info = [receivedData yajl_JSON];
    
    [theConnection release]; theConnection = nil;
    [receivedData release];
	
	[UIApplication endNetworkOperation];
}

@end
