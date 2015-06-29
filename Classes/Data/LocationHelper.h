#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHelper : NSObject <CLLocationManagerDelegate> {

    CLLocation *latestLocation;
	CLLocationManager *locationManager;
    BOOL on;
    NSError *error;
}

- (void)lookup;
+ (LocationHelper*)sharedInstance;

- (void)stopLocating:(NSTimer*)theTimer;

@property (nonatomic, retain) CLLocation *latestLocation;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, retain) NSError *error;

@end