#import <QuartzCore/QuartzCore.h>

#import "DashboardViewController320.h"
#import "VenueViewController320.h"
#import "TipsViewController320.h"
#import "PlacesViewController320.h"
#import "UserViewController320.h"
#import "DashboardOverlayView320.h"
#import "ShoutViewController320.h"
#import "AppDelegate.h"

#import "LocationHelper.h"
#import "ReachabilityHelper.h"
#import "ReverseGeocode.h"
#import "FSVenuesLookup.h"
#import "FSCheckinsLookup.h"
#import "FSPostQueue.h"

#import "ViewWithDot.h"
#import "BigButton.h"

#import "DashboardTableViewCell320.h"

#import "UIDevice+Machine.h"
#import "UIView+ModalOverlay.h"
#import "UIApplication+ModalDialog.h"
#import "UIApplication+TopView.h"

#import "RegisterTableView.h"
#import "ProgressTitleView.h"

#import "FSSettings.h"
#import "FSBaseAuth.h"
#import "FSTipsLookup.h"
#import "FSVenuesLookup.h"
#import "FSCheckin.h"
#import "GNFindNearbyLookup.h"

@implementation DashboardViewController320

#pragma mark -
#pragma mark View lifecycle

- (void)configureTableView:(UITableView *)_tableView {

	if ([[UIDevice currentDevice] highQuality]) {
        _tableView.frame = CGRectMake(0, 0, 320, 480-20-44);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 74, 0);
        UIView *f = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 74)];
        _tableView.tableFooterView = f;
        [f release];
    } else {
        _tableView.frame = CGRectMake(0, 0, 320, 480-20-44-74);
    }
	
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
    
	ProgressTitleView *titleView = [[ProgressTitleView alloc] initWithFrame:CGRectMake(-16, 0, 200, 44)];
	titleView.title = @"Checkins";
    self.navigationItem.titleView = titleView;
	[titleView release];
    
    DashboardOverlayView320 *overlay = [[DashboardOverlayView320 alloc] initWithFrame:CGRectMake(0, 480-20-44-74, 320, 74)];
    [self.view addSubview:overlay];
    [overlay release];

    UIButton *button1 = [BigButton checkinButton];
    button1.frame = CGRectMake(20, 13, 140, 52);
    [button1 addTarget:self action:@selector(checkIn:) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:button1];
    
    UIButton *button3 = [BigButton tipsButton];
    button3.frame = CGRectMake(180, 13, 120, 52);
    [button3 addTarget:self action:@selector(tips:) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:button3];
    
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain
//                                                                    target:self action:@selector(logoutAccout:)];
//    self.navigationItem.leftBarButtonItem = logoutButton;
//    [logoutButton release];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [[LocationHelper sharedInstance] addObserver:self
                                  forKeyPath:@"latestLocation"
                                     options:(NSKeyValueObservingOptionNew)
                                     context:NULL];
    
    [[LocationHelper sharedInstance] addObserver:self
                                      forKeyPath:@"error"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[ReachabilityHelper sharedInstance] addObserver:self
                                      forKeyPath:@"networkStatus"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[ReverseGeocode sharedInstance] addObserver:self
                                      forKeyPath:@"locationText"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[FSCheckinsLookup sharedInstance] addObserver:self
                                      forKeyPath:@"checkins"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];

    [[FSCheckinsLookup sharedInstance] addObserver:self
                                        forKeyPath:@"recentlyPostedCheckins"
                                           options:(NSKeyValueObservingOptionNew)
                                           context:NULL];
    
    [[FSCheckinsLookup sharedInstance] addObserver:self
                                        forKeyPath:@"error"
                                           options:(NSKeyValueObservingOptionNew)
                                           context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refreshOnBecomeActive) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
    
    NSIndexPath *removedIndexPath = nil;
    if (removedIndexPath = [[FSCheckinsLookup sharedInstance] combineRecentlyPostedCheckins]){
     
        NSIndexPath* _lastIndex = [NSIndexPath indexPathForRow:lastIndex.row+1 inSection:lastIndex.section];
        
        if (_lastIndex.row < removedIndexPath.row) {
            [lastIndex release]; lastIndex = nil;
            lastIndex = _lastIndex;
        }
        
        [tableView reloadData];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self maybeShowLoginPopup];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[LocationHelper sharedInstance] removeObserver:self forKeyPath:@"latestLocation"];
    [[LocationHelper sharedInstance] removeObserver:self forKeyPath:@"error"];    
    [[ReachabilityHelper sharedInstance] removeObserver:self forKeyPath:@"networkStatus"];
    [[ReverseGeocode sharedInstance] removeObserver:self forKeyPath:@"locationText"];
    [[FSCheckinsLookup sharedInstance] removeObserver:self forKeyPath:@"checkins"];
    [[FSCheckinsLookup sharedInstance] removeObserver:self forKeyPath:@"recentlyPostedCheckins"];
    [[FSCheckinsLookup sharedInstance] removeObserver:self forKeyPath:@"error"];
    
    [[FSCheckinsLookup sharedInstance] cancel];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
}

- (void)maybeShowLoginPopup 
{
    if (![[FSSettings sharedInstance] isLoggedIn]) {
        RegisterTableView *v = [[RegisterTableView alloc] initWithFrame:CGRectNull];
        v.registerDelegate = self;
        v.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] showModalView:v animate:YES];
        [v release];
    }
}

#pragma mark -

-(void) refreshOnBecomeActive
{
    _NSLog(@"refresh times");
    
    [[FSCheckinsLookup sharedInstance] refreshCheckinTimes];
    
    [tableView reloadData];
    
    [self refreshIfDataStale];
}

-(void) refreshIfDataStale
{
    // if it's been more than 5 minutes
    if (abs([[FSCheckinsLookup sharedInstance].lastLookup timeIntervalSinceNow]) > REFRESH_EXPIRE_SECONDS
        && [[ReachabilityHelper sharedInstance] isConnected]) {
        
        [self showTableRefreshHeaderWithAnimation:YES];        
        [self reloadTableViewDataSource];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    
    if ([FSCheckinsLookup sharedInstance].checkins == nil) return nil;
    if (section == 1) {
        return @"friends in other cities";
    }  
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([FSCheckinsLookup sharedInstance].checkins == nil) return 480-20-44-70-74;
    
    if ([(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:indexPath.section] count] == 0 && indexPath.row == 0) {
        
        return 68;
    }   
    
    FSCheckin *checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return (CGFloat) MAX([checkin.height intValue]+ 14, 68);
       
//    return [DashboardTableViewCell320 calculateHeightWithWidth:320 checkinData:checkin];
}


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([FSCheckinsLookup sharedInstance].checkins == nil) return 1;
    else return [[FSCheckinsLookup sharedInstance].checkins count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([FSCheckinsLookup sharedInstance].checkins != nil) {
        int num = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:section] count]?[(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:section] count]:1;
        return num;
    }
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    
    if ([FSCheckinsLookup sharedInstance].checkins == nil) {
     
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 480-20-44-70-74)];
        [cell addSubview:v];
        [v release];
        return cell;
        
    } else if ([(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:indexPath.section] count] == 0 && indexPath.row == 0) {
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 68)];
        [cell addSubview:v];
        [v release];
        return cell;
        
    } else {
        
        DashboardTableViewCell320 *cell = (DashboardTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[DashboardTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        FSCheckin *checkin;
        if (indexPath.section == 0) {
            checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:0] objectAtIndex:indexPath.row];
        } else if (indexPath.section == 1) {
            checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:1] objectAtIndex:indexPath.row];
        }
        
        LOG_EXPR([checkin retainCount]);
        LOG_EXPR([checkin.data retainCount]);
        
        cell.checkin = checkin;
        cell.avatarImageUrl = checkin.avatarUrl;
        
        return cell;
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if ([FSCheckinsLookup sharedInstance].checkins == nil) return;
    
    FSCheckin *checkin;
    if (indexPath.section == 0 && [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:indexPath.section] count] > 0) {
        checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:0] objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1 && [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:indexPath.section] count] > 0) {
        checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:1] objectAtIndex:indexPath.row];
    } else {
        return;
    }
    
    //if (![checkin objectForKey:@"venue"] && [checkin objectForKey:@"shout"]) 
    if (checkin.checkinType == FSCheckinTypeShout)
    {
        ShoutViewController320 *detailViewController = [[ShoutViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.info = checkin.data;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
        [self saveState:indexPath];
        
        return; 
    }
    
    //if (![checkin objectForKey:@"venue"]) return;
    if (checkin.checkinType == FSCheckinTypeOffGrid) return;
    
    VenueViewController320 *detailViewController = [[VenueViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.info = checkin.data;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
    LOG_EXPR([checkin retainCount]);
    LOG_EXPR([checkin.data retainCount]);       
    
    [self saveState:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self saveState:indexPath];
    
    FSCheckin *checkin;
    if (indexPath.section == 0) {
        checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:0] objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        checkin = [(NSArray*)[[FSCheckinsLookup sharedInstance].checkins objectAtIndex:1] objectAtIndex:indexPath.row];
    }
    
    UserViewController320 *detailViewController = [[UserViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.info = checkin.data;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

//-(void)doRecentlyPostedCheckins
//{
//    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:2];
//
//    [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    
//    NSIndexPath *removedPath = [[FSCheckinsLookup sharedInstance] combineRecentlyPostedCheckins];
//
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//    if (removedPath) {
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:removedPath] withRowAnimation:UITableViewRowAnimationBottom];
//    }
//    [self.tableView endUpdates];
//
//    if ([[FSCheckinsLookup sharedInstance].checkins count] > 1) {
//
//        //[tableView reloadData];
//    }
//}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
    if ([keyPath isEqual:@"networkStatus"] 
            && [[change objectForKey:NSKeyValueChangeNewKey] intValue] != NotReachable 
            && ([FSCheckinsLookup sharedInstance].checkins == nil || abs([[FSCheckinsLookup sharedInstance].lastLookup timeIntervalSinceNow]) > REFRESH_EXPIRE_SECONDS)
            && ![[FSPostQueue sharedInstance] isActive]
            ) {
        
        [self performSelector:@selector(successfulAuthLoadTable) withObject:nil afterDelay:0];
        
    } else if ([keyPath isEqual:@"latestLocation"]) {
		
		CLLocation *location = (CLLocation*)[change objectForKey:NSKeyValueChangeNewKey];
		
		[self setAccuracy:[location accuracy]];
        
        [[FSCheckinsLookup sharedInstance] lookupWithLocation:location];
        
    } else if ([keyPath isEqual:@"locationText"]) {
        
    } else if ([keyPath isEqual:@"checkins"]) {
		
		if ([LocationHelper sharedInstance].on == FALSE) {
			[self hideTableRefreshHeader];
		}

        [FSCheckinsLookup sharedInstance].lastLookup = [[NSDate date] retain];
		
        [tableView reloadData];
        
    } else if ([keyPath isEqual:@"recentlyPostedCheckins"]) {
        
        NSIndexPath *removedPath = [[FSCheckinsLookup sharedInstance] combineRecentlyPostedCheckins];

        [tableView beginUpdates];
        if (removedPath) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:removedPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];

        if ([[FSCheckinsLookup sharedInstance].checkins count] > 1) {

            [tableView reloadData];
        }
    
    } else if ([keyPath isEqual:@"error"]) {
        
        [self hideTableRefreshHeader];
        
    }
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
#pragma mark Auth handlers
- (void) successfulAuthWithContext:(id)context {

	_NSLog(@"auth ok");

    [[[UIApplication sharedApplication] topView] hideModalOverlayWithSuccessMessage:@"authenticated" animation:YES];
    [[UIApplication sharedApplication] performSelector:@selector(hideModalViewWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.6];
    
    [self performSelector:@selector(successfulAuthLoadTable) withObject:nil afterDelay:2];
}

- (void) successfulAuthLoadTable {
    
    [self showTableRefreshHeaderWithAnimation:YES];
    [self reloadTableViewDataSource];    
}

- (void) failedAuthWithContext:(id)context error:(NSError*)error {
	
    _NSLog(@"auth fail");
	
    if (error == nil) {
        ((UILabel*)((UITextField*)[((NSDictionary*)context) objectForKey:@"usernameTextField"]).leftView).textColor = HEXCOLOR(0xff3333ff);
        ((UILabel*)((UITextField*)[((NSDictionary*)context) objectForKey:@"passwordTextField"]).leftView).textColor = HEXCOLOR(0xff3333ff);
        [[[UIApplication sharedApplication] topView] hideModalOverlayWithErrorMessage:@"bad login credentials" animation:YES];
        [context release];
        
    } else {
        
        NSString *err = [NSString stringWithFormat:@"%@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]];        
        [[[UIApplication sharedApplication] topView] hideModalOverlayWithErrorMessage:err animation:YES];
    }
}

- (void) hideModalOverlayWithErrorMessage:(NSString*)message
{
    [self performSelector:@selector(successfulAuthLoadTable) withObject:nil afterDelay:0];

}

#pragma mark -
#pragma mark Button Tap Handlers

- (void)logoutAccout:(id)sender {
    
    [[ReachabilityHelper sharedInstance] removeObserver:self forKeyPath:@"networkStatus"];
    
    logoutAccountActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];    
    [logoutAccountActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
}

- (void)checkIn:(id)sender {
    
    PlacesViewController320 *venues = [[PlacesViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownSearchBar];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:venues];
    [venues release];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [navController release];
}

- (void)tips:(id)sender {
    
    TipsViewController320 *venues = [TipsViewController320 new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:venues];
    [venues release];
    [[self navigationController] presentModalViewController:navController animated:YES];
    [navController release];
}

#pragma mark -
#pragma mark Button Event Handlers

- (void)login:(id)sender username:(NSString*)username password:(NSString*)password
{
	FSBaseAuth* auth = [[[FSBaseAuth alloc] init] autorelease];
    auth.context = sender;
	[auth authenticateWithUsername:username password:password delegate:self];
    
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"authenticating..." style:ModalOverlayStyleActivity];
}

- (void)createAccount:(id)sender {
    
    createAccountActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open link in Safari", nil];    
    [createAccountActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
}

- (void)forgetPassword:(id)sender {
    
    forgetPasswordActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open link in Safari", nil];    
    [forgetPasswordActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
}

- (void)logout
{
    [self hideTableRefreshHeader];
    [[FSCheckinsLookup sharedInstance] cancel];
    [FSCheckinsLookup sharedInstance].checkins = nil;
    [FSCheckinsLookup sharedInstance].lastLookup = nil;
    
    [FSTipsLookup sharedInstance].locationTips = nil;
    [FSTipsLookup sharedInstance].tips = nil;
    [FSTipsLookup sharedInstance].lastLookup = nil;
    
    [FSVenuesLookup sharedInstance].locationVenues = nil;
    [FSVenuesLookup sharedInstance].venues = nil;
    [FSVenuesLookup sharedInstance].lastLookup = nil;
    
    [GNFindNearbyLookup sharedInstance].places = nil;
    [GNFindNearbyLookup sharedInstance].lastLookup = nil;    
    
    [[FSPostQueue sharedInstance] stop];
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate) applicationCacheDirectoryReset];
    
    [[FSSettings sharedInstance] clearPasswordForCurrentUser];
    
    [self performSelector:@selector(maybeShowLoginPopup) withObject:nil afterDelay:.25];
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (createAccountActionSheet == actionSheet && buttonIndex == 0) {
        
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://foursquare.com/signup/"]];
        
	} else if (forgetPasswordActionSheet == actionSheet && buttonIndex == 0) {
        
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://foursquare.com/change_password"]];
        
    } else if (logoutAccountActionSheet == actionSheet) {
     
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            
            [self logout];
        }
        
        [[ReachabilityHelper sharedInstance] addObserver:self
                                              forKeyPath:@"networkStatus"
                                                 options:(NSKeyValueObservingOptionNew)
                                                 context:NULL]; 
    }
    
    [forgetPasswordActionSheet release]; forgetPasswordActionSheet = nil;
    [createAccountActionSheet release]; createAccountActionSheet = nil;
    [logoutAccountActionSheet release]; logoutAccountActionSheet = nil;
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}

@end

