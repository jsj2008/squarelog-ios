#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "GTMObjectSingleton.h"
#import "URLConnectionHandler.h"

#import "GNSettings.h"

@interface GNFindNearbyLookup : URLConnectionHandler {

    NSOperationQueue *queue;
	NSMutableDictionary *places;
}

+ (GNFindNearbyLookup*)sharedInstance;
+ (NSDictionary*) parseToTableViewVenues:(NSDictionary*)rawData;

- (void) lookupWithLocation:(CLLocation*) location;

@property (nonatomic, retain) NSMutableDictionary *places;
@property (nonatomic, retain) NSOperationQueue *queue;

@end
