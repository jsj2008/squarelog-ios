#import "FSVenuesLookup.h"
#import "NSObject+YAJL.h"
#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"
#import "PlaceTableViewCell320.h"

@implementation FSVenuesLookup

@synthesize locationVenues, locationVenuesLastLookup, venues, queue;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSVenuesLookup, sharedInstance)

#pragma mark -

// http://api.foursquare.com/v1/venues.json?geolat=40.721104&geolong=-73.948421&l=10
- (void) lookupWithLocation:(CLLocation*) location {
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/venues.json?geolat=%f&geolong=%f&l=50",
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

- (void) lookupWithLocation:(CLLocation*) location query:(NSString*)query{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/venues.json?geolat=%f&geolong=%f&l=50&q=%@",
                     FS_API_BASE_URL,
                     location.coordinate.latitude,
                     location.coordinate.longitude,
                     [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
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

- (void) handleError:(NSError*)_error
{
    [super handleError:_error];
    [self performSelector:@selector(setError:) withObject:_error];
}

- (void)didFinishParsing:(NSDictionary *)sectionCheckins
{
    [self performSelectorOnMainThread:@selector(setVenues:) withObject:sectionCheckins waitUntilDone:NO];
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
    NSDictionary *venueInfo = [FSVenuesLookup parseToTableViewVenues:rawData];
    
	[self didFinishParsing:venueInfo];
}

#pragma mark -

+ (NSDictionary*) parseToTableViewVenues:(NSDictionary*)rawData 
{
    
    for (NSDictionary* group in [rawData objectForKey:@"groups"]) {
        
        for (NSMutableDictionary* venue in [group objectForKey:@"venues"]) {
        
            [venue setObject:[NSNumber numberWithInt:[PlaceTableViewCell320 createRenderTreeWithWidth:320 venueData:venue]] forKey:@"height"];        
        }
    }
    
    return rawData;
}

+ (BOOL) placeTypeForGroups:(NSDictionary*)groups 
{

    if ([(NSString*)[groups objectForKey:@"type"] isEqual:@"My Favorites"]) {
        return PlaceTypeFavorite;
    } else if ([(NSString*)[groups objectForKey:@"type"] isEqual:@"Trending Now"]) {
        return PlaceTypeTrending;
    } else {
        return PlaceTypeNearby;
    }
}

@end
