#import "FSUserLookup.h"
#import "NSObject+YAJL.h"
#import "GTMObjectSingleton.h"
#import "UIApplication+Network.h"
#import "AppDelegate.h"

#define USER_CACHE_TIMEOUT -60*60*24*3

@implementation FSUserLookup

@synthesize info;

@dynamic authenticatedUser;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSUserLookup, sharedInstance)

#pragma mark -

// http://api.foursquare.com/v1/venues.json?geolat=40.721104&geolong=-73.948421&l=10
- (void) lookupWithUserId:(NSInteger)userId 
{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/user.json?uid=%d&badges=1&mayor=1",
                     FS_API_BASE_URL,
                     userId,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:5.0];
    
    [self sendRequest:theRequest];
}

- (void) lookupAuthenticatedUser 
{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    [self cancel];
    
    NSString *url = [NSString stringWithFormat:@"%@/user.json",
                     FS_API_BASE_URL,
                     nil];
    
    _NSLog(url);
    
    // Create the request.
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:5.0];
    
    [self sendRequest:theRequest];
}

- (void) handleError:(NSError*)_error
{
    [super handleError:_error];
    [self performSelector:@selector(setError:) withObject:_error];
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

- (void) setAuthenticatedUser:(NSDictionary *) authUser
{
    [authUser setObject:[NSDate date] forKey:@"datecreated"];
    NSString *dir = [((AppDelegate*)[UIApplication sharedApplication].delegate) applicationCacheDirectory];
    [NSKeyedArchiver archiveRootObject:authUser toFile:[dir stringByAppendingPathComponent:@"authenticatedUser.plist"]];
}

- (NSDictionary*) authenticatedUser
{
    return [self authenticatedUser:YES];
}

- (NSDictionary*) authenticatedUser:(BOOL)expire 
{
    NSString *dir = [((AppDelegate*)[UIApplication sharedApplication].delegate) applicationCacheDirectory];
    NSDictionary* authUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[dir stringByAppendingPathComponent:@"authenticatedUser.plist"]];
    
    if (expire && [((NSDate*)[authUser valueForKey:@"datecreated"]) compare:[NSDate dateWithTimeIntervalSinceNow:USER_CACHE_TIMEOUT]] == NSOrderedAscending) return nil;
    else return (NSDictionary*) authUser;
}

+ (NSString*) formatUserName:(NSDictionary*) user
{
	NSString *lastName = [user objectForKey:@"lastname"];
	
	if (lastName == nil) lastName = @"";
	else lastName = [NSString stringWithFormat:@" %@.", [((NSString*)[user objectForKey:@"lastname"]) substringWithRange:NSMakeRange(0,1)]];

	return [NSString stringWithFormat:@"%@%@", [user objectForKey:@"firstname"], lastName];
}

@end
