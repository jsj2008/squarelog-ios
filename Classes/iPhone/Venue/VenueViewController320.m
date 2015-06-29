#import "VenueViewController320.h"
#import "NSDictionary+RenderTree.h"
#import "NSString+RenderTree.h"
#import "UIView+ShadowBug.h"
#import "FSVenueLookup.h"
#import "CheckinTableViewCell.h"
#import "BadgeButton.h"

#import "VenueMapViewController320.h"
#import "CheckInViewController320.h"
#import "UserViewController320.h"

#import "VenueHeader.h"

#import "Tips2ViewController320.h"
#import "PhotosViewController320.h"

#import "UserTableViewCell.h"
#import "FSUserLookup.h"

#import "URLLabel.h"
#import "URLImageView.h"

#import "WebViewController.h"
#import "SLSettings.h"
#import "SLPhotosLookup.h"

#import "ViewItem.h"

@implementation VenueViewController320

@synthesize info, venueInfo;

- (id) initWithStyle:(UITableViewStyle)_tableStyle 
          venueStyle:(VenueViewControllerStyle)_controllerStyle 
{

    if (self = [super initWithStyle:_tableStyle]) {
        
        controllerStyle = _controllerStyle;
    }
    
    return self;
}

- (id) initWithStyle:(UITableViewStyle)_tableStyle
{
    if (self = [super initWithStyle:_tableStyle]) {
        
        controllerStyle = VenueViewControllerStyleNormal;
    }
    
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    VenueHeader *venue = [[VenueHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    venue.info = (NSMutableDictionary*)self.info;
    self.tableView.tableHeaderView = venue;
    [venue release];
    
    LOG_EXPR([venue retainCount]);
    
    tableSections = [NSMutableArray new];
    tableSectionHeaders = [NSMutableArray new];
    
    tipsButtonBadgeCount = -1;
    photosButtonBadgeCount = -1;
    
    [self loadTableSections];
}

- (void) loadTableSections
{
    
    [tableSections removeAllObjects];
    [tableSectionHeaders removeAllObjects];
	
	if ([self.info objectForKey:@"user"])
	{
		// section 2
		NSMutableArray *section0 = [[NSMutableArray array] retain];
		CheckinTableViewCell *cell = [[CheckinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
		cell.info = (NSMutableDictionary*)self.info;
		[section0 addObject:cell];
		[cell release]; cell = nil;
		[tableSections addObject:section0];
		[tableSectionHeaders addObject:@""];
		[section0 release];
	}
 
    // section 1
    NSMutableArray *section1 = [[NSMutableArray array] retain];
    
    if (controllerStyle == VenueViewControllerStyleNormal) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Check in";
        cell.textLabel.textColor = HEXCOLOR(0x3A4D85ff);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [section1 addObject:cell];
        [cell release]; cell = nil;
        [tableSections addObject:section1];
        [tableSectionHeaders addObject:@""];
        
    } else if (controllerStyle == VenueViewControllerStyleAddPhotos) {
    
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIView *bg = [[UIView alloc] initWithFrame:CGRectNull];
        bg.backgroundColor = [UIColor clearColor];
        cell.backgroundView = bg;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [bg release];
        
        checkinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        checkinButton.frame = CGRectMake(10, 0, 145, 44);
        [checkinButton setTitle:@"Check in again" forState:UIControlStateNormal];
        [checkinButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
        [checkinButton addTarget:self action:@selector(checkinButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:checkinButton];
        
        addPhotosButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addPhotosButton.frame = CGRectMake(165, 0, 145, 44);
        [addPhotosButton setTitle:@"Add photos" forState:UIControlStateNormal];
        [addPhotosButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
        [addPhotosButton addTarget:self action:@selector(addPhotosButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addPhotosButton];
        
        [section1 addObject:cell];
        [cell release]; cell = nil;
        [tableSections addObject:section1];
        [tableSectionHeaders addObject:@""];
    }
    
    [section1 release];
    
    //section 2
    
    NSMutableArray *section2 = [[NSMutableArray array] retain];
    
    //cell 1
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectNull];
    bg.backgroundColor = [UIColor clearColor];
    cell.backgroundView = bg;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [bg release];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 0, 93, 44);
    [button setTitle:@"Map" forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
	[button addTarget:self action:@selector(mapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    tipsButton = [BadgeButton button];
    tipsButton.frame = CGRectMake(113, 0, 93, 44);
    [tipsButton setTitle:@"Tips" forState:UIControlStateNormal];
    [tipsButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
	[tipsButton addTarget:self action:@selector(tipsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (tipsButtonBadgeCount > 0) [tipsButton setCount:tipsButtonBadgeCount];
    [cell addSubview:tipsButton];
    
    photosButton = [BadgeButton button];
    photosButton.frame = CGRectMake(217, 0, 93, 44);
    [photosButton setTitle:@"Photos" forState:UIControlStateNormal];
    [photosButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
	[photosButton addTarget:self action:@selector(photosButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (photosButtonBadgeCount > 0) [tipsButton setCount:tipsButtonBadgeCount];
    [cell addSubview:photosButton];
    
    [section2 addObject:cell];
    [cell release]; cell = nil;
    [tableSections addObject:section2];
    [tableSectionHeaders addObject:@""];
    [section2 release];

    //section 3
    
    if ([self.info objectForKey:@"checkins"] == nil) {
        
        NSMutableArray *section3 = [[NSMutableArray array] retain];
        
        //cell 1
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = CGPointMake(320/2, 44/2);
        [activityView startAnimating];
        [cell addSubview:activityView];
        [activityView release]; activityView = nil;
        
        [section3 addObject:cell];
        [cell release]; cell = nil;
        [tableSections addObject:section3];
        [tableSectionHeaders addObject:@"who is here"];
        [section3 release]; 
    }    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[[info objectForKey:@"venue"] objectForKey:@"primarycategory"] objectForKey:@"nodename"];   
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated {
    
    [[FSVenueLookup sharedInstance] addObserver:self
                                      forKeyPath:@"info"
                                         options:NSKeyValueObservingOptionNew
                                         context:NULL];

    [[SLPhotosLookup sharedInstance] addObserver:self
                                     forKeyPath:@"photos"
                                        options:NSKeyValueObservingOptionNew
                                        context:NULL];
    
    NSInteger venueId = [[((NSDictionary*)[info objectForKey:@"venue"]) objectForKey:@"id"] intValue];    
    
    if ([FSVenueLookup sharedInstance].info == nil) {
        [[FSVenueLookup sharedInstance] lookupWithVenueId:venueId];
    }
    
    if (photosButtonBadgeCount == -1) {
        [[SLPhotosLookup sharedInstance] lookupWithVenueId:venueId];
    }
    
    viewPushed = NO;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
	@try { // for dismissing 2 uicontrollers when posting
		[[FSVenueLookup sharedInstance] removeObserver:self forKeyPath:@"info"];
        [[SLPhotosLookup sharedInstance] removeObserver:self forKeyPath:@"photos"];
	} @catch (NSException *exception) { }
    
    [[FSVenueLookup sharedInstance] cancel];
    [[SLPhotosLookup sharedInstance] cancel];
    
    if (!viewPushed) {
        [FSVenueLookup sharedInstance].info = nil;
    }
}

#pragma mark -
#pragma mark Button Events

- (void) checkinButtonTapped:(id) event 
{
    CheckInViewController320 *detailViewController = [[CheckInViewController320 alloc] 
                                                      initWithStyle:UITableViewStyleGrouped
                                                      checkinStyle:PostStyleCheckin];
    detailViewController.info = (NSMutableDictionary*)self.info;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.parentNavigationController = self.navigationController;
    [self.navigationController presentModalViewController:navController animated:YES];
    [detailViewController release];
    [navController release];
    
    viewPushed = YES;
}

- (void) addPhotosButtonTapped:(id) event
{
    
    CheckInViewController320 *detailViewController = [[CheckInViewController320 alloc] 
                                                      initWithStyle:UITableViewStyleGrouped
                                                      checkinStyle:PostStyleCheckinAddPhotos];
    detailViewController.info = (NSMutableDictionary*)self.info;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.parentNavigationController = self.navigationController;
    [self.navigationController presentModalViewController:navController animated:YES];
    [detailViewController release];
    [navController release];
    
    viewPushed = YES;
}
                                                 
- (void) mapButtonTapped:(id) event 
{
	VenueMapViewController320 *vc = [[VenueMapViewController320 alloc] init];
	vc.info = self.info;
	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
    
    viewPushed = YES;
}

- (void) tipsButtonTapped:(id) event 
{

    Tips2ViewController320 *tip = [[Tips2ViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
    tip.venueId = [[((NSDictionary*)[info objectForKey:@"venue"]) objectForKey:@"id"] integerValue];
    
    if (self.venueInfo == nil) {
        tip.venueInfo = (NSMutableDictionary*)self.info;
    } else {
            tip.venueInfo = (NSMutableDictionary*)self.venueInfo;
    }
    [self.navigationController pushViewController:tip animated:YES];
    [tip release];
    
    viewPushed = YES;
}

- (void) photosButtonTapped:(id) event 
{
	
//    PhotosViewController320 *mayor = [[PhotosViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
//    mayor.info = self.info;
//    [self.navigationController pushViewController:mayor animated:YES];
//    [mayor release];
    
    if ([[[SLPhotosLookup sharedInstance].photos objectForKey:@"photos"] count] == 0) return;
    
    WebViewController *wvc = [[WebViewController alloc] init];
    wvc.url = [NSString stringWithFormat:@"%@venue/%@?utm_source=app&utm_medium=iphone&utm_campaign=venue", SL_WEBSITE_BASE_URL, [[self.info objectForKey:@"venue"] objectForKey:@"id"]];
    [self.navigationController pushViewController:wvc animated:YES];
    [wvc release];
    
    viewPushed = YES;
}

#pragma mark -
#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	if ([self.info objectForKey:@"user"] && indexPath.section == 0) {
		
		return [(UIView*)[[tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] sizeThatFits:CGSizeZero].height;
		
	} else {
	
		return 44;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![[tableSectionHeaders objectAtIndex:section] isEqual:@""]) {
        return [tableSectionHeaders objectAtIndex:section];
    }
                
    return nil;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [tableSections count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == [tableSections count] - 1 && [[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"]) {
    
        return [(NSArray*)[[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"] count];
        
    } else {
        return [(NSArray*)[tableSections objectAtIndex:section] count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *userTableCells = @"user";
    
    if (indexPath.section == [tableSections count] - 1 && [[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"]) {
        
        UserTableViewCell *cell = (UserTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:userTableCells];
        if (cell == nil) {
            cell = [[[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userTableCells] autorelease];
        }        
        
        cell.textLabel.text = [FSUserLookup formatUserName:[[(NSArray*)[[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"] objectAtIndex:indexPath.row] objectForKey:@"user"]];
        cell.avatarImageUrl = [[[(NSArray*)[[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"] objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"photo"];
        return cell;        
        
    } else if (indexPath.section == [tableSections count] - 1 && self.venueInfo) {
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkin"] autorelease];
        cell.textLabel.text = @"no one found";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;        
        
    } else {
        
        return (UITableViewCell*)[(NSArray*)[tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

	if ([self.info objectForKey:@"user"] && indexPath.section == 2 || indexPath.section == 1 ||
        (![self.info objectForKey:@"user"] && indexPath.section == 0))
	{
        CheckInViewController320 *detailViewController = [[CheckInViewController320 alloc] 
                                                          initWithStyle:UITableViewStyleGrouped
                                                          checkinStyle:PostStyleCheckin];
        detailViewController.info = (NSMutableDictionary*)self.info;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        detailViewController.parentNavigationController = self.navigationController;
        [self.navigationController presentModalViewController:navController animated:YES];
        [detailViewController release];
        [navController release];
        
	} else if (indexPath.section == [tableSections count] - 1 && [[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"]) {
        
        UserViewController320 *detailViewController = [[UserViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.info = [NSMutableDictionary dictionaryWithObject:[[(NSArray*)[[self.venueInfo objectForKey:@"venue"] objectForKey:@"checkins"] objectAtIndex:indexPath.row] objectForKey:@"user"] forKey:@"user"];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	if ([self.info objectForKey:@"user"] && indexPath.section == 1 || indexPath.section == 0) {
		UserViewController320 *detailViewController = [[UserViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
		detailViewController.info = (NSMutableDictionary*)self.info;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
        
        viewPushed = YES;
	}	
}

#pragma mark -

- (void)didReceiveMemoryWarning {
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
		
    if ([keyPath isEqual:@"info"]) {
        
        self.venueInfo = [FSVenueLookup sharedInstance].info;
		
        tipsButtonBadgeCount = [[[self.venueInfo objectForKey:@"venue"] objectForKey:@"tips"] count];
        [tipsButton setCount:tipsButtonBadgeCount];
        
        [self.tableView reloadData];
        
    } else if ([keyPath isEqual:@"photos"]) {
        
        photosButtonBadgeCount = [[[SLPhotosLookup sharedInstance].photos objectForKey:@"photos"] count];
        [photosButton setCount:photosButtonBadgeCount];
    }
}

#pragma mark -
#pragma mark BubbleView Delegate

-(void)viewItemTapped:(id)sender
{
    viewPushed = [ViewItem handleTap:sender controller:self];
}

- (void)dealloc {

    [tableSections release];
    [tableSectionHeaders release];

    [photosButton release];
    [tipsButton release];
    
    [venueInfo release];
    [info release];
    
    [super dealloc];
    
    LOG_EXPR([info retainCount]);
}

@end
  