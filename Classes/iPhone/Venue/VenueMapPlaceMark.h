#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface VenueMapPlaceMark : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSString *title;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSString *subtitle;
@property (nonatomic, assign) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

@end