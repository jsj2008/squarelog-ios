#import "URLConnectionHandler.h"
#import "UIApplication+Network.h"
#import "UIView+ModalOverlay.h"
#import "NSMutableURLRequest+BasicAuth.h"
#import "UIApplication+TopView.h"
#import "FSSettings.h"

@implementation URLConnectionHandler

@synthesize error, lastLookup;

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	if ([((NSHTTPURLResponse*)response) statusCode] >= 400) {
		[theConnection cancel]; [theConnection release]; theConnection = nil;
        
        NSError *e = [NSError errorWithDomain:[NSHTTPURLResponse localizedStringForStatusCode:[((NSHTTPURLResponse*)response) statusCode]] code:[((NSHTTPURLResponse*)response) statusCode] userInfo:nil];
        [self handleError:e];
        
        [UIApplication endNetworkOperation];
        
	} //else if ([((NSHTTPURLResponse*)response) statusCode] == 200) {
//        
//        contentTotalSize = [[[response allHeaderFields] objectForKey:@"Content-Length"] intValue];
//        contentDownloadedSize = 0;
//    }
    
    self.lastLookup = [NSDate date];
	
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    contentDownloadedSize += [data length];
    
//    if (contentTotalSize != 0) {
//        self.progress = (float)contentDownloadedSize / contentTotalSize;
//    }
    
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)_error
{
    //self.progress = -1;
    
    [theConnection release]; theConnection = nil;
    [receivedData release];
	
    [self handleError:_error];
    
	[UIApplication endNetworkOperation];
}

- (void)sendRequest:(NSMutableURLRequest*)theRequest 
{
    
    [theRequest basicAuthUsername:[FSSettings sharedInstance].username password:[FSSettings sharedInstance].password];
    //[theRequest addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //automatic
    
    [theConnection cancel];
    [theConnection release];
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [[NSMutableData data] retain];
		[UIApplication startNetworkOperation];
    } else {
        // Inform the user that the connection failed.
    }
    
    contentTotalSize = -1;
}

- (BOOL) inProgress
{
    return theConnection != nil;
}

- (void) cancel
{
    if (theConnection) [UIApplication endNetworkOperation];
    [theConnection cancel]; [theConnection release]; theConnection = nil;
}

- (void) handleError:(NSError*)_error
{
    [theConnection release]; theConnection = nil;
    
    NSString *errStr = nil;
    
    if ([_error userInfo] != nil) {
        
        errStr = [NSString stringWithFormat:@"%@ %@", [_error localizedDescription], [[_error userInfo] objectForKey:NSErrorFailingURLStringKey]];
        
    } else {
        
        errStr = [_error localizedDescription];
    }
    
    // inform the user
    _NSLog(@"Connection failed! URLConnectionHandler Error: %@ %@",
           [_error localizedDescription],
           [[_error userInfo] objectForKey:NSErrorFailingURLStringKey]);    
        
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:errStr style:ModalOverlayStyleError];        
}

@end
