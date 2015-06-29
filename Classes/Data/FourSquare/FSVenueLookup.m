#import "FSVenueLookup.h"
#import "NSObject+YAJL.h"
#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"
#import "NSDateFormatter+RFC822.h"
#import "NSDate+TimeAgo.h"

@implementation FSVenueLookup

@synthesize info;

static NSDateFormatter *formatter;

+ (void) initialize {
    
    if (self == [FSVenueLookup class]) {
        
        formatter = [[NSDateFormatter dateFormatRFC882_4sq] retain];
    }
}

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSVenueLookup, sharedInstance)

#pragma mark -

// http://api.foursquare.com/v1/venues.json?geolat=40.721104&geolong=-73.948421&l=10
- (void) lookupWithVenueId:(NSInteger)venueId {
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/venue.json?vid=%d",
                     FS_API_BASE_URL,
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

    self.info = [receivedData yajl_JSON];
    
    [theConnection release]; theConnection = nil;
    [receivedData release];
	
	[UIApplication endNetworkOperation];
}


+ (BOOL) computeTipTransientValues:(NSDictionary*)checkin
{    
    BOOL changed = FALSE;
    
    NSDate *created_date = [formatter dateFromString:[checkin objectForKey:@"created"]];
    
    [checkin setObject:created_date forKey:@"created_date"];
    
    NSNumber *timeval = [NSDate timeValWithDate:created_date];
	TimeUnitType unit = [NSDate timeUnitWithDate:created_date];
    
    if ([checkin objectForKey:@"created_time_ago_val"] != timeval) {
        changed = YES;
        [checkin setObject:timeval forKey:@"created_time_ago_val"];
        [checkin setObject:[NSNumber numberWithInt:unit] forKey:@"created_time_ago_unit"];
		if (unit == kTimeUnitTypeNow) {
			[checkin setObject:@"now" forKey:@"created_time_ago_string"];
		} else {
			[checkin setObject:[NSDate timeStringWithDate:created_date showFraction:(unit==kTimeUnitTypeMinutes||unit==kTimeUnitTypeHours)] forKey:@"created_time_ago_string"];
		}
    }
    return changed;
}

@end
