#import "Tips2ViewController320.h"
#import "TipTableViewCell320.h"
#import "TipViewController320.h"
#import "CheckInViewController320.h"
#import "FSTipsLookup.h"
#import "FSVenueLookup.h"
#import "ViewWithDot.h"

@implementation Tips2ViewController320

@synthesize venueInfo, tipInfo, userInfo, venueId;

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


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  
    
    NSMutableArray *tips;
    
    if (self.venueInfo) {
        
        tips = [[self.venueInfo objectForKey:@"venue"] objectForKey:@"tips"];
        
    } else {
        
        tips = self.tipInfo;
    }
    
    if (venueInfo != nil) {
        self.title = [NSString stringWithFormat:@"%@ (%d)", [[venueInfo objectForKey:@"venue"] objectForKey:@"name"], [tips count]];
    }
    
    if (userInfo == nil) {

        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTip:)];
        self.navigationItem.rightBarButtonItem = item;
        [item release];
        
    } else {
        
        self.title = [NSString stringWithFormat:@"%@'s Tips (%d)", [userInfo objectForKey:@"firstname"], [tips count]];
    }
    
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    h.backgroundColor = HEXCOLOR(0xcdcdcdff);
    tableView.tableHeaderView = h;
    [h release];
    
    tableView.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    
    UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    tableView.tableFooterView = v;
    [v release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (venueInfo == nil && tipInfo == nil) {
    
        [[FSVenueLookup sharedInstance] addObserver:self
                                         forKeyPath:@"info"
                                            options:NSKeyValueObservingOptionNew
                                            context:NULL];
        
        [[FSVenueLookup sharedInstance] lookupWithVenueId:venueId];    
    }
}

- (void)viewWillDisappear:(BOOL)animated {

	@try {
		[[FSVenueLookup sharedInstance] removeObserver:self forKeyPath:@"info"];
	} @catch (NSException *exception) { }
    
    [[FSVenueLookup sharedInstance] cancel];
    
	[super viewWillDisappear:animated];    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return self.tipInfo?[self.tipInfo count]:0;
    
    if (self.venueInfo) {
        
        return [[[venueInfo objectForKey:@"venue"] objectForKey:@"tips"] count];
        
    } else {
        
        return [self.tipInfo count];
        
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"CellButton";
    
    TipTableViewCell320 *cell = (TipTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[[TipTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
    }
    
    if (self.venueInfo) {
        
        cell.tipData = (NSDictionary*)[[[self.venueInfo objectForKey:@"venue"] objectForKey:@"tips"] objectAtIndex:indexPath.row];
        
    } else {
        
        cell.tipData = (NSDictionary*)[self.tipInfo objectAtIndex:indexPath.row];
    }
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *tip;
    
    if (self.venueInfo) {
        
        tip = [[[self.venueInfo objectForKey:@"venue"] objectForKey:@"tips"] objectAtIndex:indexPath.row];
        
    } else {
        
        tip = [self.tipInfo objectAtIndex:indexPath.row];
    }
    
    return [TipTableViewCell320 calculateHeightWithWidth:320 tipData:tip];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self saveState:indexPath];
    
    TipViewController320 *detailViewController = [[TipViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
    
    if (self.venueInfo) {
        
        detailViewController.tipData = [[[self.venueInfo objectForKey:@"venue"] objectForKey:@"tips"] objectAtIndex:indexPath.row];
        detailViewController.venueData = venueInfo;
        
    } else {
        
        NSMutableDictionary *m = [NSMutableDictionary dictionaryWithDictionary:[self.tipInfo objectAtIndex:indexPath.row]];
        [m setObject:userInfo forKey:@"user"];
        detailViewController.tipData = m;
        
        detailViewController.venueData = detailViewController.tipData;
    }
    
    LOG_EXPR(venueInfo);
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark -
#pragma mark Handlers

- (void)addTip:(id)sender
{
    CheckInViewController320 *detailViewController = [[CheckInViewController320 alloc] initWithStyle:UITableViewStyleGrouped checkinStyle:PostStyleTip];
    detailViewController.info = venueInfo;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.parentNavigationController = self.navigationController;
    [self.navigationController presentModalViewController:navController animated:YES];
    [detailViewController release];
    [navController release];
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqual:@"info"]) {
        
        self.venueInfo = (NSMutableDictionary*)[FSVenueLookup sharedInstance].info;
        self.tipInfo = [[self.venueInfo objectForKey:@"venue"] objectForKey:@"tips"];
        
        self.title = [NSString stringWithFormat:@"%@", [[venueInfo objectForKey:@"venue"] objectForKey:@"name"]];
        
        [tableView reloadData];
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
    [venueInfo release];
    [super dealloc];
}


@end

