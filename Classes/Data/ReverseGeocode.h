#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ReverseGeocode : NSObject <MKReverseGeocoderDelegate> {

    NSString *locationText;
    MKReverseGeocoder *reverseGeocoder;
}

+ (ReverseGeocode*)sharedInstance;
- (void) lookupWithLocation:(CLLocation*) coordinates;

@property (nonatomic, retain) NSString *locationText;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

@end
