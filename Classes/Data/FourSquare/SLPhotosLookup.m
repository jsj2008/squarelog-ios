#import "SLPhotosLookup.h"
#import "GTMObjectSingleton.h"
#import "FSSettings.h"
#import "SLSettings.h"

@implementation SLPhotosLookup

@synthesize photos;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(SLPhotosLookup, sharedInstance)

#pragma mark -

- (void) lookupWithVenueId:(NSInteger) venueId
{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/photos.json?vid=%d",
                     SL_API_BASE_URL,
                     venueId,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:TIMEOUT_INTERVAL];
    
    [self sendRequest:theRequest];
    
}

- (void) lookupWithUserId:(NSInteger) venueId
{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/photos.json?uid=%d",
                     SL_API_BASE_URL,
                     venueId,
                     nil];
    
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
    
    self.photos = [receivedData yajl_JSON];
    
    [theConnection release]; theConnection = nil;
    [receivedData release];
	
	[UIApplication endNetworkOperation];
}

@end