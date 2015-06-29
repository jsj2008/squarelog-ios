#import "FSTipsLookup.h"
#import "NSObject+YAJL.h"
#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"

#import "TipTableViewCell320.h"

@implementation FSTipsLookup

@synthesize locationTips, locationTipsLastLookup, tips, queue;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSTipsLookup, sharedInstance)

#pragma mark -

// http://api.foursquare.com/v1/tips.json?geolat=40.721104&geolong=-73.948421&l=10
- (void) lookupWithLocation:(CLLocation*) location {
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/tips.json?geolat=%f&geolong=%f",
                     FS_API_BASE_URL,
                     location.coordinate.latitude,
                     location.coordinate.longitude,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:TIMEOUT_INTERVAL];
    self.queue = [NSOperationQueue new];
    [self.queue setMaxConcurrentOperationCount:1];
    
    [self sendRequest:theRequest];
}

- (void) lookupWithUserId:(NSInteger)userId {
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/tips.json?uid=%d",
                     FS_API_BASE_URL,
                     userId,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:TIMEOUT_INTERVAL];
    self.queue = [NSOperationQueue new];
    [self.queue setMaxConcurrentOperationCount:1];
    
    [self sendRequest:theRequest];
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    SEL sel = @selector(parseData:);
    NSMethodSignature *sig = [self methodSignatureForSelector:sel];
    
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:sel];
    [invo setArgument:&receivedData atIndex:2];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithInvocation:invo];
    [queue addOperation:operation];
    [operation release];
    
    [theConnection release]; theConnection = nil;
	
	[UIApplication endNetworkOperation];
    
}

- (void)didFinishParsing:(NSDictionary *)data
{
    [self performSelectorOnMainThread:@selector(setTips:) withObject:data waitUntilDone:NO];
    self.queue = nil;
}

- (void)parseData:(NSMutableData*)_receivedData
{
    NSDictionary *rawData = [_receivedData yajl_JSON]; [_receivedData release];
    NSDictionary *venueInfo = [FSTipsLookup parseToTableViewVenues:rawData];
    
	[self didFinishParsing:venueInfo];
}

- (void) handleError:(NSError*)_error
{
    [super handleError:_error];
    [self performSelector:@selector(setError:) withObject:_error];
}

#pragma mark -

+ (NSDictionary*) parseToTableViewVenues:(NSDictionary*)rawData 
{
    
    for (NSDictionary* group in [rawData objectForKey:@"groups"]) {
        
        for (NSMutableDictionary* tip in [group objectForKey:@"tips"]) {
            
            [tip setObject:[NSNumber numberWithInt:[TipTableViewCell320 createRenderTreeWithWidth:320 tipData:tip]] forKey:@"height"];
            
        }
    }
    
    return rawData;
}

@end
