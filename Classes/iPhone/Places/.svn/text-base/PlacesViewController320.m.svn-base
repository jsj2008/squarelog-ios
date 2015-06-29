#import "PlacesViewController320.h"
#import "CheckInViewController320.h"
#import "PlaceTableViewCell320.h"

#import "UIApplication+TopView.h"

#import "LocationHelper.h"
#import "ReachabilityHelper.h"
#import "ReverseGeocode.h"
#import "FSVenuesLookup.h"

#import "BottomRounderTableView.h"
#import "SearchBar.h"

#import "VenueViewController320.h"
#import "PlaceButtonTableViewCell320.h"
#import "PlaceLastCheckedinViewController320.h"

#import "ViewWithDot.h"

#import "UIView+ModalOverlay.h"

@implementation PlacesViewController320

@synthesize venues, searchVenues;

#pragma mark -
#pragma mark View lifecycle

- (void) loadView {
	
	[super loadView];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;    
    
    UIView *overlay = [[BottomRounderTableView alloc] initWithFrame:CGRectMake(0, 480-20-44-26-2, 320, 2)];
    overlay.opaque = YES;
    [self.view addSubview:overlay];
    [overlay release];
    
    UIView *bottomMargin = [[UIView alloc] initWithFrame:CGRectMake(0, 480-20-44-26, 320, 26)];
    bottomMargin.backgroundColor = [UIColor blackColor];
    bottomMargin.opaque = YES;
	
//	locationText = [[UILabel alloc] initWithFrame:bottomMargin.bounds];//CGRectInset(CGRectOffset(bottomMargin.bounds, 10, 0), 5, 0)];
//	locationText.backgroundColor = [UIColor blackColor];
//	locationText.opaque = YES;
//	locationText.textColor = HEXCOLOR(0xddddddff);
//	locationText.textAlignment = UITextAlignmentCenter;
//	locationText.font = [UIFont boldSystemFontOfSize:12];
    
    locationText = [[SlidingLabel alloc] initWithFrame:bottomMargin.bounds];
	locationText.backgroundColor = [UIColor blackColor];
	locationText.opaque = YES;
	locationText.textColor = HEXCOLOR(0xddddddff);
	locationText.textAlignment = UITextAlignmentCenter;
	locationText.font = [UIFont boldSystemFontOfSize:12];
    
//    [locationText performSelector:@selector(setText:) withObject:@"dfsdfsdfs" afterDelay:1];
//    [locationText performSelector:@selector(setText:) withObject:@"dfsdfsdfs" afterDelay:1.1];
//    [locationText performSelector:@selector(setText:) withObject:@"dfsdfsdfs" afterDelay:1.11];
//    [locationText performSelector:@selector(setText:) withObject:@"dfsdfsdfs" afterDelay:1.12];
    
	[bottomMargin addSubview:locationText];
	
    [self.view addSubview:bottomMargin];
    [bottomMargin release];
    
    searchBar.delegate = self;
    
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Places";
    searchBar.placeholder = @"Search Places";

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    [cancelButton release];
}

- (void)configureTableView:(UITableView *)_tableView {
	
    _tableView.frame = CGRectMake(0, 0, 320, 480-20-44-26);
	_tableView.rowHeight = 54;
//    UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    _tableView.tableFooterView = v;
//    [v release];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[ReachabilityHelper sharedInstance] addObserver:self
                                          forKeyPath:@"networkStatus"
                                             options:(NSKeyValueObservingOptionNew)
                                             context:NULL];    
    
    [[LocationHelper sharedInstance] addObserver:self
                                      forKeyPath:@"latestLocation"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[LocationHelper sharedInstance] addObserver:self
                                      forKeyPath:@"error"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[ReverseGeocode sharedInstance] addObserver:self
                                      forKeyPath:@"locationText"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[FSVenuesLookup sharedInstance] addObserver:self
                                      forKeyPath:@"venues"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[FSVenuesLookup sharedInstance] addObserver:self
                                      forKeyPath:@"searchVenues"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[FSVenuesLookup sharedInstance] addObserver:self
                                      forKeyPath:@"error"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];        
    
    if ([FSVenuesLookup sharedInstance].locationVenues != nil 
        && abs([[FSVenuesLookup sharedInstance].locationVenuesLastLookup timeIntervalSinceNow]) <= REFRESH_EXPIRE_SECONDS) {
        
        if ([ReverseGeocode sharedInstance].locationText != nil) {
            locationText.text = [ReverseGeocode sharedInstance].locationText;
        }
        
        self.venues = [FSVenuesLookup sharedInstance].locationVenues;
        [tableView reloadData];
    }
    
    if (venues == nil) {
        [self showTableRefreshHeader];
        [self reloadTableViewDataSource];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[ReachabilityHelper sharedInstance] removeObserver:self forKeyPath:@"networkStatus"];    
    [[LocationHelper sharedInstance] removeObserver:self forKeyPath:@"latestLocation"];
    [[LocationHelper sharedInstance] removeObserver:self forKeyPath:@"error"];
    [[ReverseGeocode sharedInstance] removeObserver:self forKeyPath:@"locationText"];
    [[FSVenuesLookup sharedInstance] removeObserver:self forKeyPath:@"venues"];
    [[FSVenuesLookup sharedInstance] removeObserver:self forKeyPath:@"searchVenues"];
    [[FSVenuesLookup sharedInstance] removeObserver:self forKeyPath:@"error"];
    
    [[FSVenuesLookup sharedInstance] cancel];
	
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark RefreshTableHeader

- (void)reloadTableViewDataSource {
	
    if (![[ReachabilityHelper sharedInstance] isConnected]) {
        
        if ([LocationHelper sharedInstance].latestLocation != nil) {
            
            [LocationHelper sharedInstance].latestLocation = [LocationHelper sharedInstance].latestLocation;
            
        } else {
        
            [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"No Network Available" style:ModalOverlayStyleError];
            [self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
            
            [[ReachabilityHelper sharedInstance] lookupReachability];
            
        }
        
    } else {
        
        [[LocationHelper sharedInstance] lookup];
    }    
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    
    if (searchController.searchResultsTableView == _tableView) {
        
        if (self.searchVenues == nil) {
            return 1;
        } else {
            return 1;//[[self.searchVenues objectForKey:@"groups"] count];
        }
        
    } else {
        
        if (self.venues == nil) {
            return 2;
        } else {
            return [[self.venues objectForKey:@"groups"] count]+1;
        }
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    
    if (searchController.searchResultsTableView == _tableView) {
        
        if (self.searchVenues == nil) {
            return 1;
        } else {
            return [[(NSDictionary*)[(NSArray*)[self.searchVenues objectForKey:@"groups"] 
                                     objectAtIndex:0] objectForKey:@"venues"] count];
        } 
        
    } else {
        
        if (section == 0) {
            return 1;
        } else if (self.venues == nil) {
            return 1;
        } else {
            return [[(NSDictionary*)[(NSArray*)[self.venues objectForKey:@"groups"] 
                                     objectAtIndex:section-1] objectForKey:@"venues"] count];
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"CellButton";
    static NSString *CellIdentifier2 = @"Cell";
    static NSString *CellIdentifier3 = @"CellDot";
    
    if (searchController.searchResultsTableView == _tableView) {
        
        if (self.searchVenues == nil) {
            
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            searchViewDotSpinner = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            [cell addSubview:searchViewDotSpinner];
            [searchViewDotSpinner release];
            return cell;
            
        } else {
        
            PlaceTableViewCell320 *cell = (PlaceTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[[PlaceTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
            }
            
            cell.venueInfo = [[(NSDictionary*)[(NSArray*)[self.searchVenues objectForKey:@"groups"] objectAtIndex:indexPath.section] objectForKey:@"venues"] objectAtIndex:indexPath.row];
            cell.logoImageUrl = [(NSDictionary*)[cell.venueInfo objectForKey:@"primarycategory"] objectForKey:@"iconurl"];
            
            return cell;
            
        }
        
    } else {
        
        if (indexPath.section == 0) {
            PlaceButtonTableViewCell320 *cell = [[[PlaceButtonTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            cell.delegate = self;
            return cell;
        }
        
        if (self.venues == nil) {
            
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 222)];
            [cell addSubview:v];
            [v release];
            return cell;
            
        } else {
        
            NSDictionary *venue = [[(NSDictionary*)[(NSArray*)[self.venues objectForKey:@"groups"] objectAtIndex:indexPath.section-1] objectForKey:@"venues"] objectAtIndex:indexPath.row];
                
            PlaceTableViewCell320 *cell = (PlaceTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[[PlaceTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
            }
            
            cell.venueInfo = venue;
            cell.logoImageUrl = [(NSDictionary*)[cell.venueInfo objectForKey:@"primarycategory"] objectForKey:@"iconurl"];
            
            cell.placeType = [FSVenuesLookup placeTypeForGroups:(NSDictionary*)[(NSArray*)[self.venues objectForKey:@"groups"] 
                                                                                 objectAtIndex:indexPath.section-1]];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (searchController.searchResultsTableView == _tableView) {
        
        if (self.searchVenues == nil) {
            
            return 480-44-20;
            
        } else {
        
            NSDictionary *venue = [[(NSDictionary*)[(NSArray*)[self.searchVenues objectForKey:@"groups"] objectAtIndex:indexPath.section] objectForKey:@"venues"] objectAtIndex:indexPath.row];
            return [PlaceTableViewCell320 calculateHeightWithWidth:320 venueData:venue];
        }
        
    } else {
        
        if (indexPath.section == 0) {
            return 44+10;
        }
        
        if (self.venues == nil) {
            
            return 222;
            
        } else {
        
        NSDictionary *venue = [[(NSDictionary*)[(NSArray*)[self.venues objectForKey:@"groups"] objectAtIndex:indexPath.section-1] objectForKey:@"venues"] objectAtIndex:indexPath.row];        
        return [PlaceTableViewCell320 calculateHeightWithWidth:320 venueData:venue];
        }
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    [self saveState:indexPath];
    
    if (searchController.searchResultsTableView == _tableView) {
        
        if (self.searchVenues == nil) {
            return;
        }
        
        NSDictionary *venue = [[(NSDictionary*)[(NSArray*)[self.searchVenues objectForKey:@"groups"] objectAtIndex:indexPath.section] objectForKey:@"venues"] objectAtIndex:indexPath.row];
        NSDictionary *checkin = [NSMutableDictionary dictionary];
        [checkin setObject:venue forKey:@"venue"];
        
        VenueViewController320 *detailViewController = [[VenueViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.info = checkin;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
        
    } else {
        
        if (self.venues == nil) {
            return;
        }
        
        if (indexPath.section == 0) return;
        
        NSDictionary *venue = [[(NSDictionary*)[(NSArray*)[self.venues objectForKey:@"groups"] objectAtIndex:indexPath.section-1] objectForKey:@"venues"] objectAtIndex:indexPath.row];
        NSDictionary *checkin = [NSMutableDictionary dictionary];
        [checkin setObject:venue forKey:@"venue"];
        
        VenueViewController320 *detailViewController = [[VenueViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.info = checkin;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    }
}

#pragma mark -
#pragma mark Handlers

- (void)cancel:(id)sender {
    
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (void)addShoutTapped: (id)sender
{
    _NSLog(@"shout");
    
    CheckInViewController320 *detailViewController = [[CheckInViewController320 alloc] initWithStyle:UITableViewStyleGrouped checkinStyle:PostStyleShout];
    //detailViewController.info = self.info;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

- (void) lastCheckinsTapped: (id)sender
{
    _NSLog(@"photo");
    
    PlaceLastCheckedinViewController320 *detailViewController = [[PlaceLastCheckedinViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
    //detailViewController.info = self.info;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];    
}

#pragma mark -
#pragma mark SearchController delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchVenues = nil;
    return NO;
}

#pragma mark -
#pragma mark SearchBar delegate

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [_searchBar resignFirstResponder];
    [[FSVenuesLookup sharedInstance] lookupWithLocation:[LocationHelper sharedInstance].latestLocation query:searchBar.text];
    searchViewDotSpinner.spinner = YES;
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqual:@"latestLocation"]) {
        
        _NSLog(@"%@", [change description]);
        
        [[ReverseGeocode sharedInstance] lookupWithLocation:(CLLocation*)[change objectForKey:NSKeyValueChangeNewKey]];
        [[FSVenuesLookup sharedInstance] lookupWithLocation:(CLLocation*)[change objectForKey:NSKeyValueChangeNewKey]];
        
    } else if ([keyPath isEqual:@"locationText"]) {
        
        _NSLog(@"%@", [change description]);
		
        if ([[change objectForKey:NSKeyValueChangeNewKey] class] != [NSNull class]) {
            locationText.text = [NSString stringWithFormat:@"Near: %@", (NSString*)[change objectForKey:NSKeyValueChangeNewKey]];
        } else {
            locationText.text = nil;
        }
        
    } else if ([keyPath isEqual:@"venues"] && searchController.active ) {
        
        searchViewDotSpinner = nil;
        
        self.searchVenues = (NSDictionary*)[change objectForKey:NSKeyValueChangeNewKey];
        [searchController.searchResultsTableView reloadData];
        
    } else if ([keyPath isEqual:@"venues"]) {        
        
        if ([LocationHelper sharedInstance].on == FALSE) {
			[self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
		}
        
        self.venues = (NSDictionary*)[change objectForKey:NSKeyValueChangeNewKey];
        [FSVenuesLookup sharedInstance].locationVenues = self.venues;
        [FSVenuesLookup sharedInstance].locationVenuesLastLookup = [FSVenuesLookup sharedInstance].lastLookup;
        [tableView reloadData];
        
    } else if ([keyPath isEqual:@"error"]) {
        
        [self hideTableRefreshHeader];
        
        searchViewDotSpinner.spinner = NO;
    }
}

- (void) dealloc
{
    [searchController release];
    [venues release];
    [searchVenues release];
    [super dealloc];
}

@end