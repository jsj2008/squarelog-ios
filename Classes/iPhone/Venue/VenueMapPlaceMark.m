#import "VenueMapPlaceMark.h"

@implementation VenueMapPlaceMark

@synthesize coordinate, subtitle, title;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate = c;
	return self;
}

@end