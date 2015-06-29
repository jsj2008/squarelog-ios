#import "CLLocation+Accuracy.h"

@implementation CLLocation (Accuracy)

- (SLLocationAccuracy) accuracy
{
	if (self.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters || self.verticalAccuracy <= kCLLocationAccuracyNearestTenMeters) {
		return SLLocationAccuracyHigh;
	}
	else if (self.horizontalAccuracy <= kCLLocationAccuracyHundredMeters || self.verticalAccuracy <= kCLLocationAccuracyHundredMeters) {
		return SLLocationAccuracyMedium;
	}
	
	return SLLocationAccuracyLow;
}

@end
