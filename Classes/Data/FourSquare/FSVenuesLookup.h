#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "FSSettings.h"
#import "URLConnectionHandler.h"

typedef enum{
	PlaceTypeNearby = 0,
	PlaceTypeTrending,
    PlaceTypeFavorite
} PlaceType;

@interface FSVenuesLookup : URLConnectionHandler {
    
    NSDictionary *locationVenues;
    NSDate *locationVenuesLastLookup;
    
    NSDictionary *venues;
    NSOperationQueue *queue;
}

- (void) lookupWithLocation:(CLLocation*)location;
- (void) lookupWithLocation:(CLLocation*)location query:(NSString*)query;
+ (FSVenuesLookup*)sharedInstance;

+ (BOOL) placeTypeForGroups:(NSDictionary*)groups;
+ (NSDictionary*) parseToTableViewVenues:(NSDictionary*)rawData;

@property (nonatomic, retain) NSDictionary *venues;
@property (nonatomic, retain) NSOperationQueue *queue;

@property (nonatomic, retain) NSDictionary *locationVenues;
@property (nonatomic, retain) NSDate *locationVenuesLastLookup;

@end
