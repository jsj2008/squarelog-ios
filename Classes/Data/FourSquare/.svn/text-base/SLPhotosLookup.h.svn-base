#import <Foundation/Foundation.h>

#import "URLConnectionHandler.h"

@interface SLPhotosLookup : URLConnectionHandler {
    
    NSMutableDictionary *photos;
}

- (void) lookupWithUserId:(NSInteger)userId;
- (void) lookupWithVenueId:(NSInteger)venueId;
+ (SLPhotosLookup*)sharedInstance;

@property (nonatomic, retain) NSMutableDictionary *photos;

@end