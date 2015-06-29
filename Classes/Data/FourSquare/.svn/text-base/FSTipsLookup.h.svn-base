#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FSSettings.h"
#import "URLConnectionHandler.h"

@interface FSTipsLookup : URLConnectionHandler {
    
	NSDictionary *tips;
    NSDictionary *locationTips;
    NSDate *locationTipsLastLookup;
    
	NSOperationQueue *queue;
    
    NSDictionary *locationBasedTips;
}

- (void) lookupWithLocation:(CLLocation*) location;
- (void) lookupWithUserId:(NSInteger)userId;

+ (FSTipsLookup*)sharedInstance;

+ (NSDictionary*) parseToTableViewVenues:(NSDictionary*)rawData;

@property (nonatomic, retain) NSDictionary *tips;
@property (nonatomic, retain) NSDictionary *locationTips;
@property (nonatomic, retain) NSDate *locationTipsLastLookup;
@property (nonatomic, retain) NSOperationQueue *queue;

@end