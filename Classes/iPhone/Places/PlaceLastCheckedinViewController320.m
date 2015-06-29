#import "PlaceLastCheckedinViewController320.h"
#import "FSHistoryLookup.h"
#import "PlaceTableViewCell320.h"
#import "VenueViewController320.h"
#import "DashboardTableViewCell320.h"
#import "FSUserLookup.h"
#import "DashboardTableViewCell320.h"
#import "ViewWithDot.h"
#import "ShoutViewController320.h"
#import "ReachabilityHelper.h"
#import "UIView+ModalOverlay.h"
#import "UIApplication+TopView.h"

@implementation PlaceLastCheckedinViewController320

- (void)loadView {
	
	[super loadView];
	
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
}

- (void)configureTableView:(UITableView *)_tableView {
	
    _tableView.frame = CGRectMake(0, 0, 320, 480-20-44);
	//_tableView.rowHeight = 54;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"My Checkins";
}

//- (void)viewDidAppear:(BOOL)animated 
//{
//    [super viewDidAppear:animated];
//}

- (void)viewWillAppear:(BOOL)animated 
{
    
    [[FSHistoryLookup sharedInstance] addObserver:self
                                      forKeyPath:@"checkins"
                                         options:NSKeyValueObservingOptionNew
                                         context:NULL];
                                                  
    [[FSHistoryLookup sharedInstance] addObserver:self
                                     forKeyPath:@"error"
                                        options:NSKeyValueObservingOptionNew
                                                 context:NULL];                                                  
    
    [[FSUserLookup sharedInstance] addObserver:self
                                    forKeyPath:@"info"
                                       options:NSKeyValueObservingOptionNew
                                       context:NULL];
    
    [[FSUserLookup sharedInstance] addObserver:self
                                    forKeyPath:@"error"
                                       options:NSKeyValueObservingOptionNew
                                       context:NULL];  
    
    authenticatedUser = [FSUserLookup sharedInstance].authenticatedUser;
	
    if (authenticatedUser == nil) {
        
        [[FSUserLookup sharedInstance] lookupAuthenticatedUser];
        [self showTableRefreshHeader];
        [self setAccuracy:SLLocationAccuracyHigh];
        
    } else if ([FSHistoryLookup sharedInstance].checkins == nil) {
        
        avatarUrl = [authenticatedUser valueForKeyPath:@"user.photo"];
        [avatarUrl retain];
        
        [self showTableRefreshHeader];
        [self setAccuracy:SLLocationAccuracyHigh];
        [[FSHistoryLookup sharedInstance] lookup];
    }
                                                 
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[FSHistoryLookup sharedInstance] removeObserver:self forKeyPath:@"error"];
    [[FSHistoryLookup sharedInstance] removeObserver:self forKeyPath:@"checkins"];
    [[FSUserLookup sharedInstance] removeObserver:self forKeyPath:@"info"];
    [[FSUserLookup sharedInstance] removeObserver:self forKeyPath:@"error"];
    
    [[FSUserLookup sharedInstance] cancel];
    [[FSHistoryLookup sharedInstance] cancel];
    
    if (lastIndex == nil) [FSHistoryLookup sharedInstance].checkins = nil;
	
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark RefreshTableHeader

- (void)reloadTableViewDataSource {
	
    if (![[ReachabilityHelper sharedInstance] isConnected]) {
        
        [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"No Network Available" style:ModalOverlayStyleError];
        [self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
        
        [[ReachabilityHelper sharedInstance] lookupReachability];
        
    } else {
        
        [[FSHistoryLookup sharedInstance] lookup];
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    if ([FSHistoryLookup sharedInstance].checkins == nil) {
        return 1;
    } else {
        return 1;
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    
	if ([FSHistoryLookup sharedInstance].checkins == nil) {
        return 1;
    } else {
        return [(NSArray*)[[FSHistoryLookup sharedInstance].checkins objectAtIndex:0] count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    
	if ([FSHistoryLookup sharedInstance].checkins == nil) {
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 480-20-44-70)];
        [cell addSubview:v];
        [v release];
        return cell;
        
    } else {
        
        DashboardTableViewCell320 *cell = (DashboardTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[DashboardTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        FSCheckin *checkin = [(NSArray*)[[FSHistoryLookup sharedInstance].checkins objectAtIndex:0] objectAtIndex:indexPath.row];
            
        cell.checkin = checkin;
        cell.avatarImageUrl = avatarUrl;
        
        if (checkin.checkinType == FSCheckinTypeShout) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }        
        
        return cell;
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([FSHistoryLookup sharedInstance].checkins == nil) {
        
        return 480-20-44-70;
        
    } else {
    
        FSCheckin *checkin = [(NSArray*)[[FSHistoryLookup sharedInstance].checkins objectAtIndex:0] objectAtIndex:indexPath.row];
        return (CGFloat) MAX([checkin.height intValue]+ 14, 68);
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    FSCheckin *checkin = [(NSArray*)[[FSHistoryLookup sharedInstance].checkins objectAtIndex:0] objectAtIndex:indexPath.row];
    
    if (checkin.checkinType == FSCheckinTypeShout) return;
    
    [self saveState:indexPath];
    
//	CheckInViewController320 *detailViewController = [[CheckInViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
//  NSDictionary *venue = [checkin.data objectForKey:@"venue"];
//	detailViewController.info = [NSMutableDictionary dictionaryWithObject:venue forKey:@"venue"];
//	[self.navigationController pushViewController:detailViewController animated:YES];
//	[detailViewController release];
    
//    if (checkin.checkinType == FSCheckinTypeShout)
//    {
//        
//        ShoutViewController320 *detailViewController = [[ShoutViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
//        detailViewController.info = checkin.data;
//        [self.navigationController pushViewController:detailViewController animated:YES];
//        [detailViewController release];
//        
//        [self saveState:indexPath];
//        
//        return; 
//    }
    
    VenueViewController320 *detailViewController = [[VenueViewController320 alloc] initWithStyle:UITableViewStyleGrouped venueStyle:VenueViewControllerStyleAddPhotos];
    detailViewController.info = checkin.data;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{

    if ([keyPath isEqual:@"checkins"]) {
        
        [self hideTableRefreshHeader];
        [tableView reloadData];
        
    } else if ([keyPath isEqual:@"info"]) {
        
        [authenticatedUser release];
        authenticatedUser = (NSDictionary*)[change objectForKey:NSKeyValueChangeNewKey];
        [authenticatedUser retain];
        
        [FSUserLookup sharedInstance].authenticatedUser = authenticatedUser;
        
        avatarUrl = [authenticatedUser valueForKeyPath:@"user.photo"];
        
        [[FSHistoryLookup sharedInstance] lookup];
        
    } else if ([keyPath isEqual:@"error"]) {
    
        [self hideTableRefreshHeader];
    }
}

- (void)dealloc {
    //[authenticatedUser release];
    [avatarUrl release];
    [super dealloc];
}

@end
