#import "FSTipOps.h"
#import "FSSettings.h"

#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"

@implementation FSTipOps

@synthesize success;


#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSTipOps, sharedInstance)

#pragma mark -

- (void)marktodo:(NSInteger)tipId
{
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    NSString *url = [NSString stringWithFormat:@"%@/tip/marktodo?tid=%d",
                     FS_API_BASE_URL,
                     tipId,
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


- (void)markdone:(NSInteger)tipId
{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    NSString *url = [NSString stringWithFormat:@"%@/tip/markdone?tid=%d",
                     FS_API_BASE_URL,
                     tipId,
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


- (void)unmark:(NSInteger)tipId
{
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    NSString *url = [NSString stringWithFormat:@"%@/tip/unmark?tid=%d",
                     FS_API_BASE_URL,
                     tipId,
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
