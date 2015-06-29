#import "FSHistoryLookup.h"
#import "NSObject+YAJL.h"
#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"
#import "FSHistoryLookup.h"
#import "PlaceTableViewCell320.h"
#import "FSCheckinsLookup.h"

@implementation FSHistoryLookup

@synthesize checkins, queue;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSHistoryLookup, sharedInstance)

#pragma mark -

// http://api.foursquare.com/v1/venues.json?geolat=40.721104&geolong=-73.948421&l=10
- (void) lookup {
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/history.json", 
                     FS_API_BASE_URL,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
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

- (void)didFinishParsing:(NSArray *)sectionCheckins
{
    if (![queue isSuspended]) {
         [self performSelectorOnMainThread:@selector(setCheckins:) withObject:sectionCheckins waitUntilDone:NO];
    }
    self.queue = nil;
}

- (void)parseErrorOccurred:(NSError *)_error
{
    [self performSelectorOnMainThread:@selector(setError:) withObject:_error waitUntilDone:NO];
    self.queue = nil;
}

- (void)parseData:(NSMutableData*)_receivedData
{
    NSDictionary *rawData = [_receivedData yajl_JSON]; [_receivedData release];
    NSArray *history = [FSHistoryLookup parseToTableViewVenues:rawData];
    
	[self didFinishParsing:history];
}

- (void) handleError:(NSError*)_error
{
    [super handleError:_error];
    [self performSelector:@selector(setError:) withObject:_error];
}

#pragma mark -

+ (NSArray*) parseToTableViewVenues:(NSDictionary*)rawData 
{

    NSArray *history = [FSCheckinsLookup parseToTableViewCheckinSections:rawData distanceSections:NO];
    return history;
}

@end
