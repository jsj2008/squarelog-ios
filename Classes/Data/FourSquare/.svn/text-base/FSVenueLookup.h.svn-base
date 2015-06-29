#import <Foundation/Foundation.h>
#import "FSSettings.h"

#import "URLConnectionHandler.h"

@interface FSVenueLookup : URLConnectionHandler {
    
    NSDictionary *info;
}

- (void) lookupWithVenueId:(NSInteger) venueId;
+ (FSVenueLookup*)sharedInstance;
+ (BOOL) computeTipTransientValues:(NSDictionary*)checkin;

@property (nonatomic, retain) NSDictionary *info;

@end
