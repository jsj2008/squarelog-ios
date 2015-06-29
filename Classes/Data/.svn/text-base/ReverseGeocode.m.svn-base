#import "ReverseGeocode.h"
#import "NSObject+YAJL.h"

#import "GTMObjectSingleton.h"

@implementation ReverseGeocode

@synthesize locationText, reverseGeocoder;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(ReverseGeocode, sharedInstance)

#pragma mark -

- (void) lookupWithLocation:(CLLocation*) location {
    
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate] autorelease];
    self.reverseGeocoder.delegate = self;
    [self.reverseGeocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    _NSLog(@"MKReverseGeocoder has failed. %@", [error localizedDescription]);
    self.locationText = nil;
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    
    NSString *thoroughfarePart = @"";

    if (placemark.subThoroughfare && placemark.thoroughfare) 
        thoroughfarePart = [NSString stringWithFormat:@"%@ %@, ", placemark.subThoroughfare, placemark.thoroughfare];
    else if (placemark.subThoroughfare)
        thoroughfarePart = [NSString stringWithFormat:@"%@, ", placemark.subThoroughfare];
    else if (placemark.thoroughfare)
        thoroughfarePart = [NSString stringWithFormat:@"%@, ", placemark.thoroughfare];
    
    self.locationText = [NSString stringWithFormat:@"%@%@, %@", thoroughfarePart, placemark.locality, placemark.administrativeArea, nil];
    //[geocoder release];
}

- (void)dealloc
{
    [super dealloc];
}

@end