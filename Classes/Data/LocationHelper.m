#import "GTMObjectSingleton.h"

#import "LocationHelper.h"
#import "CLLocation+Accuracy.h"

#import "UIApplication+TopView.h"
#import "UIView+ModalOverlay.h"

@implementation LocationHelper

@synthesize latestLocation, on, error;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(LocationHelper, sharedInstance)

#pragma mark -
#pragma mark class instance methods

- (void)lookup {
    
	if (locationManager == nil) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = kCLDistanceFilterNone;
	} else {
        [self stopLocating:nil];
    }
    
    [latestLocation release]; latestLocation = nil;
    
    [locationManager startUpdatingLocation];
	on = TRUE;
}
	 
- (void)stopLocating:(NSTimer*)theTimer {
 
	[locationManager stopUpdatingLocation];
	on = FALSE;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    BOOL setEndTimer = self.latestLocation == nil;
    
    self.latestLocation = newLocation;
	if ([self.latestLocation accuracy] == SLLocationAccuracyHigh) {
        
		[self stopLocating:nil];
        
	} else if (setEndTimer) {
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stopLocating:) userInfo:nil repeats:NO];
		[timer fire];
    }
    
    _NSLog([newLocation description]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)_error
{
    on = FALSE;
    self.error = _error;
    
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"Enable location in Settings / General / Location Services" style:ModalOverlayStyleError]; 
    
    _NSLog(@"failed location");
}

- (void) dealloc {
    [locationManager release];
    [super dealloc];
}

@end
