#import "VenueMapViewController320.h"
#import "VenueMapPlaceMark.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AppDelegate.h"

@implementation VenueMapViewController320

@synthesize info;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
	
	[super loadView];
	
	float geolong = [((NSNumber*)[[info objectForKey:@"venue"] objectForKey:@"geolong"]) floatValue];
	float geolat = [((NSNumber*)[[info objectForKey:@"venue"] objectForKey:@"geolat"]) floatValue];
    
    CLLocationCoordinate2D cords;
    cords.latitude = geolat;
    cords.longitude = geolong;    
	
	MKCoordinateRegion region = MKCoordinateRegionMake(cords, MKCoordinateSpanMake(.05, .05));

	MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
	mapView.delegate = self;
	[mapView setRegion:region animated:YES];
    
	VenueMapPlaceMark *placemark = [[VenueMapPlaceMark alloc] initWithCoordinate:cords];
    placemark.title = [[info objectForKey:@"venue"] objectForKey:@"title"];
	[mapView addAnnotation:placemark];    
    [placemark release];
	
	self.view = mapView;
	[mapView release];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Map";
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *test = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"vendor"];
    test.animatesDrop = YES;
    [test setPinColor:MKPinAnnotationColorPurple];
	return test;
}

- (void)actionButtonTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open in Maps", @"Copy Link", nil ];
    
    [actionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];    
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        
	} else if (actionSheet.firstOtherButtonIndex == buttonIndex) {
        
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@,%@",
                         [[info objectForKey:@"venue"] objectForKey:@"geolat"],
                         [[info objectForKey:@"venue"] objectForKey:@"geolong"]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    } else if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
        
        NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%@,%@",
                         [[info objectForKey:@"venue"] objectForKey:@"geolat"],
                         [[info objectForKey:@"venue"] objectForKey:@"geolong"]];        
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:
                              url, @"public.utf8-plain-text", [NSURL URLWithString:url],
                              (NSString *)kUTTypeURL,
                              nil];
        pasteboard.items = [NSArray arrayWithObject:item];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	
    [super dealloc];
    [info release];
}


@end

