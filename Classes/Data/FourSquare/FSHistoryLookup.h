#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FSSettings.h"
#import "URLConnectionHandler.h"

@interface FSHistoryLookup : URLConnectionHandler {
    
    NSArray *checkins;
	NSOperationQueue *queue;	
}

- (void) lookup;
+ (FSHistoryLookup*)sharedInstance;

+ (NSArray*) parseToTableViewVenues:(NSDictionary*)rawData;

@property (nonatomic, retain) NSArray *checkins;
@property (nonatomic, retain) NSOperationQueue *queue;

@end