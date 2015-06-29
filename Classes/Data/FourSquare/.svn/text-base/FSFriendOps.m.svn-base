#import "FSFriendOps.h"
#import "FSSettings.h"

#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"

@implementation FSFriendOps

@synthesize success;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSFriendOps, sharedInstance)

#pragma mark -

- (void)approveFriend:(NSInteger) userId
{
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    NSString *url = [NSString stringWithFormat:@"%@/friend/approve.json?uid=%d",
                     FS_API_BASE_URL,
                     userId,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:TIMEOUT_INTERVAL];
    
    //Set the request method to post
    [theRequest setHTTPMethod:@"POST"];	 
    
    [self sendRequest:theRequest];
}

- (void)denyFriend:(NSInteger) userId
{
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    NSString *url = [NSString stringWithFormat:@"%@/friend/deny.json?uid=%d",
                     FS_API_BASE_URL,
                     userId,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:TIMEOUT_INTERVAL];
    
    //Set the request method to post
    [theRequest setHTTPMethod:@"POST"];	 
    
    [self sendRequest:theRequest];   
}

- (void)sendFriend:(NSInteger) userId
{
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    NSString *url = [NSString stringWithFormat:@"%@/friend/sendrequest.json?uid=%d",
                     FS_API_BASE_URL,
                     userId,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:TIMEOUT_INTERVAL];
    
    //Set the request method to post
    [theRequest setHTTPMethod:@"POST"];	 
    
    [self sendRequest:theRequest];   
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication endNetworkOperation];
    self.success = TRUE;
}

- (void)handleError:(NSError *)_error
{
    //[super handleError:_error];
    
    [theConnection release]; theConnection = nil;
    
    self.success = FALSE;
    self.error = _error;
}

@end
