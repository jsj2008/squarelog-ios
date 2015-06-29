#import "GTMObjectSingleton.h"
#import "DashboardTableViewCell320.h"

#import "FSCheckinsLookup.h"
#import "NSObject+YAJL.h"
#import "UIApplication+Network.h"
#import "NSDateFormatter+RFC822.h"

#import "FSUserLookup.h"
#import "FSCheckin.h"

#import "AppDelegate.h"

#define CHECKIN_CACHE_TIMEOUT 60*60*24*4

@implementation FSCheckinsLookup

@synthesize checkins, queue, recentlyPostedCheckins;

static NSDateFormatter *formatter;

+ (void) initialize {
    
    if (self == [FSCheckinsLookup class]) {
        
        formatter = [[NSDateFormatter dateFormatRFC882_4sq] retain];
    }
}

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSCheckinsLookup, sharedInstance)

#pragma mark -

// http://api.foursquare.com/v1/venues.json?geolat=40.721104&geolong=-73.948421&l=10
- (void) lookupWithLocation:(CLLocation*) location {
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/checkins.json?geolat=%f&geolong=%f&l=50",
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
    
	[UIApplication endNetworkOperation];
}

- (void)parseData:(NSMutableData*)_receivedData
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *rawDictionary = [_receivedData yajl_JSON]; [_receivedData release];
    NSMutableArray *sectionCheckins = nil;
    
    if ([rawDictionary objectForKey:@"error"]) {
        
        NSError *err = [NSError errorWithDomain:[rawDictionary objectForKey:@"error"] code:0 userInfo:nil];
        
        if (![queue isSuspended]) {
            [self parseErrorOccurred:err];
        }
        
    } else {
        
        _NSLog(@"started");
        
        sectionCheckins = [FSCheckinsLookup parseToTableViewCheckinSections:rawDictionary];
        
        _NSLog(@"ended started");
        
        if (![queue isSuspended]) {
            [self didFinishParsing:sectionCheckins];
        }
    }
    
    [pool release];
    
}

- (void) handleError:(NSError*)_error
{
    [super handleError:_error];
    [self performSelector:@selector(setError:) withObject:_error];
}

#pragma mark -
#pragma mark ParseOperation

- (void)didFinishParsing:(NSArray *)sectionCheckins
{
    [self performSelectorOnMainThread:@selector(setCheckins:) withObject:sectionCheckins waitUntilDone:NO];
    self.queue = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurred:(NSError *)_error
{
    [self performSelectorOnMainThread:@selector(setError:) withObject:_error waitUntilDone:NO];
    self.queue = nil;
}

- (void) addPostedCheckin:(FSCheckin*)checkin
{
    NSMutableArray *sc = [NSMutableArray arrayWithArray:self.recentlyPostedCheckins];
    [sc insertObject:checkin atIndex:0]; 
    self.recentlyPostedCheckins = sc;
    
    [checkin release];
}

// return the old index of previous entry
- (NSIndexPath*) combineRecentlyPostedCheckins
{
    
    NSDictionary *user = [[FSUserLookup sharedInstance] authenticatedUser:NO];
    if (!user) return nil;

    if (!recentlyPostedCheckins || [recentlyPostedCheckins count] == 0) return nil;
    
    FSCheckin *fsCheckin = [recentlyPostedCheckins lastObject];
        
    [fsCheckin.data setObject:[user objectForKey:@"user"] forKey:@"user"];
    [fsCheckin.data setObject:fsCheckin.date forKey:@"created_date"];
            
    [FSCheckinsLookup computeTransientValues:fsCheckin.data];
    [FSCheckinsLookup cleanServerValues:fsCheckin.data];
    
    [fsCheckin.data setObject:[NSNumber numberWithInt:[DashboardTableViewCell320 createRenderTreeWithWidth:320 checkinData:fsCheckin.data]] forKey:@"height"];
    
    fsCheckin.renderTree = [[fsCheckin.data objectForKey:@"render_tree"] objectForKey:@"items"];
    fsCheckin.avatarUrl = [[fsCheckin.data objectForKey:@"user"] objectForKey:@"photo"];
    fsCheckin.height = [fsCheckin.data objectForKey:@"height"];    
    
    fsCheckin.userId = [[fsCheckin.data objectForKey:@"user"] objectForKey:@"id"];
    
    NSIndexPath *pathRemoved = nil;
    
    for (int i = 0; i < [[checkins objectAtIndex:0] count]; i++) {
        if ([((FSCheckin*)[[checkins objectAtIndex:0] objectAtIndex:i]).userId isEqual:fsCheckin.userId]) {
            pathRemoved = [NSIndexPath indexPathForRow:i inSection:0];
            [((NSMutableArray*)[checkins objectAtIndex:0]) removeObjectAtIndex:i];
        }
    }
    
    for (int i = 0; i < [[checkins objectAtIndex:1] count]; i++) {
        if ([((FSCheckin*)[[checkins objectAtIndex:1] objectAtIndex:i]).userId isEqual:fsCheckin.userId]) {
            pathRemoved = [NSIndexPath indexPathForRow:i inSection:1];
            [((NSMutableArray*)[checkins objectAtIndex:1]) removeObjectAtIndex:i];            
        }
    }
    
    [[checkins objectAtIndex:0] insertObject:fsCheckin atIndex:0];
    
    [recentlyPostedCheckins release];
    recentlyPostedCheckins = nil;
    
    return pathRemoved;
}

-(void) refreshCheckinTimes
{
    
    for (NSArray* section in self.checkins) {
        
        for (FSCheckin* checkin in section) {
            
            if (![FSCheckinsLookup computeTransientValues:checkin.data]) continue;
            
            [checkin.data setObject:[NSNumber numberWithInt:[DashboardTableViewCell320 createRenderTreeWithWidth:320 checkinData:checkin.data]] forKey:@"height"];
            
            checkin.date = [checkin.data objectForKey:@"created"];
            checkin.renderTree = [[checkin.data objectForKey:@"render_tree"] objectForKey:@"items"];
            checkin.height = [checkin.data objectForKey:@"height"];
            
        }
    }
}

#pragma mark -

- (void) saveCheckins
{
    NSString *path = [[((AppDelegate*)[UIApplication sharedApplication].delegate) applicationCacheDirectory] 
                                    stringByAppendingPathComponent:@"checkins.plist"];
    
    NSDictionary* properties = [[NSFileManager defaultManager]
                                attributesOfItemAtPath:path
                                error:nil];
    
    if ([[FSCheckinsLookup sharedInstance].lastLookup isEqualToDate:[properties fileModificationDate]]) return;
    
    [NSKeyedArchiver archiveRootObject:self.checkins toFile:path];
}

- (void) loadCheckins
{
    NSString *path = [[((AppDelegate*)[UIApplication sharedApplication].delegate) applicationCacheDirectory] 
                                    stringByAppendingPathComponent:@"checkins.plist"];
    
    NSDictionary* properties = [[NSFileManager defaultManager]
                                attributesOfItemAtPath:path
                                error:nil];
    
    self.lastLookup = [properties fileModificationDate];
    
    LOG_EXPR(self.lastLookup);
   
    if (!properties || abs([self.lastLookup timeIntervalSinceNow]) > CHECKIN_CACHE_TIMEOUT) {
        return;
    } else { 
        self.checkins = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
}

#pragma mark -

+ (NSMutableArray*) parseToTableViewCheckinSections:(NSDictionary*)checkinsFromServer 
{
    return [FSCheckinsLookup parseToTableViewCheckinSections:checkinsFromServer distanceSections:YES];
}

+ (void) cleanServerValues:(NSMutableDictionary*)checkin
{

    [checkin setObject:[checkin objectForKey:@"user"]?[FSUserLookup formatUserName:[checkin objectForKey:@"user"]]:@"You" forKey:@"formatted_username"];
    
    NSString *venue = [[checkin objectForKey:@"venue"] objectForKey:@"name"];
    
    NSString *venue_fmt;
    if (venue == nil) {
        venue = @"[off the grid]";
        venue_fmt = @"\\r";
        [checkin setObject:[NSNumber numberWithBool:TRUE] forKey:@"off_grid"];
        
    } else {
        [checkin setObject:[NSNumber numberWithBool:FALSE] forKey:@"off_grid"];
        venue_fmt = @"\\b";
    }
    
    if ([FSCheckinsLookup isShout:checkin]) {
        
        [checkin setObject:[NSString stringWithFormat:@"\\b%@ \\rshouted...", 
                           [checkin objectForKey:@"formatted_username"]]
                   forKey:@"rndr_formatted_title"];
    } else {
        
        [checkin setObject:venue forKey:@"formatted_venue"];
        [checkin setObject:[NSString stringWithFormat:@"%@\\b%@ \\r@ %@%@", 
                           ([(NSNumber*)[checkin objectForKey:@"ismayor"] boolValue]?@"\\m":@""), 
                           [checkin objectForKey:@"formatted_username"], 
                           venue_fmt,
                           venue] forKey:@"rndr_formatted_title"];
        
    }
    
    if (((NSNumber*)[checkin objectForKey:@"distance"]).intValue > 80000) {
        [checkin setObject:[FSCheckinsLookup formatCityWithVenue:[checkin objectForKey:@"venue"]] forKey:@"formatted_location"];
    } else {
        [checkin setObject:[FSCheckinsLookup formatLocationWithVenue:[checkin objectForKey:@"venue"]] forKey:@"formatted_location"];
    }    
}

+ (NSMutableArray*) parseToTableViewCheckinSections:(NSDictionary*)checkinsFromServer distanceSections:(BOOL)distanceSections
{
    
    NSMutableArray *checkinSections = [NSMutableArray arrayWithCapacity:2];
    
    NSArray *checkins = [checkinsFromServer objectForKey:@"checkins"];
    
    NSMutableArray *farCheckins = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *closeCheckins = [NSMutableArray arrayWithCapacity:100];
    
    for (NSDictionary* checkin in checkins) {
        
        [FSCheckinsLookup computeTransientValues:checkin];
        [FSCheckinsLookup cleanServerValues:checkin];
        
        [checkin setObject:[NSNumber numberWithInt:[DashboardTableViewCell320 createRenderTreeWithWidth:320 checkinData:checkin]] forKey:@"height"];
            
        FSCheckin *fsCheckin = [FSCheckin new];
        fsCheckin.date = [checkin objectForKey:@"created"];
        fsCheckin.renderTree = [[checkin objectForKey:@"render_tree"] objectForKey:@"items"];
        fsCheckin.avatarUrl = [[checkin objectForKey:@"user"] objectForKey:@"photo"];
        fsCheckin.height = [checkin objectForKey:@"height"];
        fsCheckin.userId = [[checkin objectForKey:@"user"] objectForKey:@"id"];
        fsCheckin.data = checkin;
        
        if ([FSCheckinsLookup isShout:checkin])  {
            fsCheckin.checkinType = FSCheckinTypeShout;
        } else if ([checkin objectForKey:@"venue"] && [[[checkin objectForKey:@"venue"] objectForKey:@"name"] length] > 0) {
            fsCheckin.checkinType = FSCheckinTypeCheckin;
        } else {
            fsCheckin.checkinType = FSCheckinTypeOffGrid;
        }
                    
        if (distanceSections && ((NSNumber*)[checkin objectForKey:@"distance"]).intValue > 80000) {
            [farCheckins addObject:fsCheckin]; 
        } else {
            [closeCheckins addObject:fsCheckin];
        }
        
        [fsCheckin release];
    }
    
    [checkinSections addObject:closeCheckins];
    [checkinSections addObject:farCheckins];
    
//    [closeCheckins release];
//    [farCheckins release];
    
    return checkinSections;
}

+ (BOOL) isShout:(NSDictionary*)checkin
{
    return [checkin objectForKey:@"display"] && [[checkin objectForKey:@"display"] rangeOfString:@"shouted"].location != NSNotFound
    || ([checkin objectForKey:@"venue"] && [[[checkin objectForKey:@"venue"] objectForKey:@"name"] length] == 0);
}

+ (NSString*) formatCityWithVenue:(NSDictionary*)venue 
{
    if (![[venue objectForKey:@"city"] isEqual:@""] && [venue objectForKey:@"city"] != nil && ![[venue objectForKey:@"state"] isEqual:@""] && [venue objectForKey:@"state"] != nil) {
        return [NSString stringWithFormat:@"%@, %@", [venue objectForKey:@"city"], [venue objectForKey:@"state"]];
    } else if ([venue objectForKey:@"city"] != nil) {
        return [venue objectForKey:@"city"];
    } else {
        return @"";
	}
}

+ (NSString*) formatLocationWithVenue:(NSDictionary*)venue 
{    
    if (venue == nil) {
        return @"";
    } else if ([venue objectForKey:@"crossstreet"] != nil) {
        return [NSString stringWithFormat:@"%@ (%@)", [venue objectForKey:@"address"], [venue objectForKey:@"crossstreet"]];
    } else {
        return [venue objectForKey:@"address"]?[venue objectForKey:@"address"]:@"";
    }
}

+ (BOOL) computeTransientValues:(NSDictionary*)checkin
{    
    BOOL changed = FALSE;
    
    NSDate *created_date = nil;
    
    if ([checkin objectForKey:@"created"]) {
    
        NSDate *created_date = [formatter dateFromString:[checkin objectForKey:@"created"]];
        [checkin setObject:created_date forKey:@"created_date"];
    }
    
    if (![checkin objectForKey:@"created_date"]) return FALSE;
    
    created_date = [checkin objectForKey:@"created_date"];
    
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
