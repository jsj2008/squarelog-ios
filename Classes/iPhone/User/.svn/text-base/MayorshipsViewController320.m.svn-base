#import "MayorshipsViewController320.h"

#import "PlaceTableViewCell320.h"
#import "VenueViewController320.h"

#import "ViewWithDot.h"

@implementation MayorshipsViewController320

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

- (void) loadView {
	[super loadView];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Mayorships";
    
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    h.backgroundColor = HEXCOLOR(0xcdcdcdff);
    tableView.tableHeaderView = h;
    [h release];
    
    tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);    
    
    UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    tableView.tableFooterView = v;
    [v release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self.info objectForKey:@"user"] objectForKey:@"mayor"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    PlaceTableViewCell320 *cell = (PlaceTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PlaceTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.venueInfo = [(NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"mayor"] objectAtIndex:indexPath.row];
    cell.logoImageUrl = [(NSDictionary*)[cell.venueInfo objectForKey:@"primarycategory"] objectForKey:@"iconurl"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *venue = [(NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"mayor"] objectAtIndex:indexPath.row];
    return [PlaceTableViewCell320 calculateHeightWithWidth:320 venueData:venue];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self saveState:indexPath];
    
	NSDictionary *venue = [(NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"mayor"] objectAtIndex:indexPath.row];
    NSDictionary *checkin = [NSMutableDictionary dictionary];
    [checkin setObject:venue forKey:@"venue"];
    
    VenueViewController320 *detailViewController = [[VenueViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.info = checkin;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
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
    [info release];
    [super dealloc];
}


@end

