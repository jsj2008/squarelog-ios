#import "FSBaseAuth.h"
#import "FSSettings.h"
#import "UIApplication+Network.h"
#import "NSObjectAdditions.h"
#import "GTMObjectSingleton.h"
#import "NSObject+YAJL.h"
#import "AppDelegate.h"
#import "URLConnectionHandler.h"

@implementation FSBaseAuth

@synthesize context;

//#pragma mark -
//#pragma mark Singleton definition
//
//GTMOBJECT_SINGLETON_BOILERPLATE(FSBaseAuth, sharedInstance)

#pragma mark -

- (void) authenticateWithUsername:(NSString*)_username 
                         password:(NSString*)_password 
                         delegate:(id<FSBaseAuthDelegate>)_delegate 
{
	
	username = [_username retain];
	password = [_password retain];
	delegate = _delegate;
	
	NSString *url = [NSString stringWithFormat:@"%@/user.json",
                     FS_API_BASE_URL,
                     nil];
    
    _NSLog(url);
	
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:TIMEOUT_INTERVAL];
    
    [theRequest basicAuthUsername:_username password:_password];

    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [[NSMutableData data] retain];
        [UIApplication startNetworkOperation];
    } else {
        // Inform the user that the connection failed.
    }
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *rawDictionary = [receivedData yajl_JSON]; [receivedData release];

    if ([rawDictionary objectForKey:@"error"]) {
        NSError *err = [NSError errorWithDomain:[rawDictionary objectForKey:@"error"] code:0 userInfo:nil];
        [delegate performSelector:@selector(failedAuthWithContext:error:) withObject:self.context withObject:err];
    }
    
    [UIApplication endNetworkOperation];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
	
	_NSLog(@"resp: %d", [httpResp statusCode]);
	if ([httpResp statusCode] == 200) {
	
		[[FSSettings sharedInstance] setPassword:password forUsername:username];
		[delegate performSelector:@selector(successfulAuthWithContext:) withObject:self.context];
		
	} else {
        
		[delegate performSelector:@selector(failedAuthWithContext:error:) withObject:self.context withObject:nil];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection cancel]; [connection release]; connection = nil;
    
    // inform the user
    _NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	[delegate performSelector:@selector(failedAuthWithContext:error:) withObject:self.context withObject:error];
	
	[UIApplication endNetworkOperation];
}

- (void)dealloc {
    
    [username release];
    [password release];
    
    [super dealloc];
}

@end
