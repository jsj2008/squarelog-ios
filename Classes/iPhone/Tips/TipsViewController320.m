#import "TipsViewController320.h"

#import "LocationHelper.h"
#import "ReverseGeocode.h"
#import "FSTipsLookup.h"
#import "FSCheckinsLookup.h"
#import "GNFindNearbyLookup.h"

#import "ReachabilityHelper.h"

#import "BottomRounderTableView.h"
#import "TipTableViewCell320.h"

#import "TipViewController320.h"
#import "ReachabilityHelper.h"
#import "UIView+ModalOverlay.h"
#import "UIApplication+TopView.h"

#import "ViewWithDot.h"
#import "WebViewController.h"

#import "WikipediaTableViewCell320.h"

#define WIKIPEDIA_CONTROL_INDEX 0
#define TIPS_CONTROL_INDEX 1
#define TODOS_CONTROL_INDEX 2

@implementation TipsViewController320

@synthesize tips, wikiPlaces;

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
    
    locationText = [[SlidingLabel alloc] initWithFrame:bottomMargin.bounds];
	locationText.backgroundColor = [UIColor blackColor];
	locationText.opaque = YES;
	locationText.textColor = HEXCOLOR(0xddddddff);
	locationText.textAlignment = UITextAlignmentCenter;
	locationText.font = [UIFont boldSystemFontOfSize:12];
    
	[bottomMargin addSubview:locationText];
	
    [self.view addSubview:bottomMargin];
    [bottomMargin release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	pickerSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Wikipedia", @"Nearby Tips", @"My To Dos", nil]];
	pickerSegmentedControl.selectedSegmentIndex = TIPS_CONTROL_INDEX;
	pickerSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[pickerSegmentedControl addTarget:self
                               action:@selector(segmentControlAction:)
                     forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = pickerSegmentedControl;
	
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];

}

- (void)configureTableView:(UITableView *)_tableView {
	
    _tableView.frame = CGRectMake(0, 0, 320, 480-20-44-26);
	_tableView.rowHeight = 54;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
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
    
    [[FSTipsLookup sharedInstance] addObserver:self
                                   forKeyPath:@"tips"
                                      options:(NSKeyValueObservingOptionNew)
                                      context:NULL];
    
    [[FSTipsLookup sharedInstance] addObserver:self
                                    forKeyPath:@"error"
                                       options:(NSKeyValueObservingOptionNew)
                                       context:NULL];
    
    [[GNFindNearbyLookup sharedInstance] addObserver:self
                                    forKeyPath:@"places"
                                       options:(NSKeyValueObservingOptionNew)
                                       context:NULL];
    
    [[GNFindNearbyLookup sharedInstance] addObserver:self
                                    forKeyPath:@"error"
                                       options:(NSKeyValueObservingOptionNew)
                                       context:NULL];    
    
    [self reloadTips];
    
    [super viewWillAppear:animated];
}

- (void) reloadTips
{
    if ([FSTipsLookup sharedInstance].locationTips != nil 
        && abs([[FSTipsLookup sharedInstance].locationTipsLastLookup timeIntervalSinceNow]) <= REFRESH_EXPIRE_SECONDS) {
        
        if ([ReverseGeocode sharedInstance].locationText != nil) {
            locationText.text = [ReverseGeocode sharedInstance].locationText;
        }
        
        self.tips = [FSTipsLookup sharedInstance].locationTips;
        [tableView reloadData];
    }
    
    if (tips == nil) {
        [self showTableRefreshHeader]; // always show at start
        [self reloadTableViewDataSource];
    }
}

- (void) reloadWikipedia
{
    if ([GNFindNearbyLookup sharedInstance].places != nil 
        && abs([[GNFindNearbyLookup sharedInstance].lastLookup timeIntervalSinceNow]) <= REFRESH_EXPIRE_SECONDS) {
        
        if ([ReverseGeocode sharedInstance].locationText != nil) {
            locationText.text = [ReverseGeocode sharedInstance].locationText;
        }
        
        self.wikiPlaces = [GNFindNearbyLookup sharedInstance].places;
        [tableView reloadData];
    }
    
    if (wikiPlaces == nil) {
        [self showTableRefreshHeaderWithAnimation:YES]; // always show at start
        [self reloadTableViewDataSource];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[LocationHelper sharedInstance] removeObserver:self forKeyPath:@"latestLocation"];
    [[LocationHelper sharedInstance] removeObserver:self forKeyPath:@"error"];
    [[ReverseGeocode sharedInstance] removeObserver:self forKeyPath:@"locationText"];
    [[FSTipsLookup sharedInstance] removeObserver:self forKeyPath:@"tips"];
    [[FSTipsLookup sharedInstance] removeObserver:self forKeyPath:@"error"];
    
    [[GNFindNearbyLookup sharedInstance] removeObserver:self forKeyPath:@"places"];
    [[GNFindNearbyLookup sharedInstance] removeObserver:self forKeyPath:@"error"];    
    
    [[GNFindNearbyLookup sharedInstance] cancel];
    [[FSTipsLookup sharedInstance] cancel];
    
	[super viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    [self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX && wikiPlaces == nil ||
        pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX && tips == nil ||
        pickerSegmentedControl.selectedSegmentIndex == TODOS_CONTROL_INDEX && tips == nil) {
        return 1;
    } else {
        
        //wikipedia
        if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX) {
            
            int count = [(NSArray*)[wikiPlaces objectForKey:@"geonames"] count];
            
            if (count > 0) {
                return count;
            } else {
                return 1;
            }
            
        } else {
                    
            if ([[tips objectForKey:@"groups"] count] <= pickerSegmentedControl.selectedSegmentIndex-1) {
                    
                return 1;
                
            } else {
                
                return [[(NSDictionary*)[(NSArray*)[tips objectForKey:@"groups"] 
                                         objectAtIndex:pickerSegmentedControl.selectedSegmentIndex-1] objectForKey:@"tips"] count];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX && wikiPlaces == nil ||
        pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX && tips == nil ||
        pickerSegmentedControl.selectedSegmentIndex == TODOS_CONTROL_INDEX && tips == nil) {
        
        return 320;
        
    } else {
         
        //wikipedia
        if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX) {
            
            if ([[wikiPlaces objectForKey:@"geonames"] count] == 0) {
                
                return 320;
                
            } else {
                
                NSDictionary *data = [(NSArray*)[wikiPlaces objectForKey:@"geonames"] objectAtIndex:indexPath.row];
                return [WikipediaTableViewCell320 calculateHeightWithWidth:320 wikiData:data];
            }
            
        } else {
    
            if ([[tips objectForKey:@"groups"] count] <= pickerSegmentedControl.selectedSegmentIndex-1) {
                
                return 320;
                
            } else {
                
                NSDictionary *tip = [[(NSDictionary*)[(NSArray*)[tips objectForKey:@"groups"] objectAtIndex:pickerSegmentedControl.selectedSegmentIndex-1] objectForKey:@"tips"] objectAtIndex:indexPath.row];
                return [TipTableViewCell320 calculateHeightWithWidth:320 tipData:tip];
            }
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"CellButton1";
    static NSString *CellIdentifier2 = @"CellButton2";
    static NSString *CellIdentifier3 = @"CellButton3";
    
    if (pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX && tips == nil 
        || pickerSegmentedControl.selectedSegmentIndex == TODOS_CONTROL_INDEX && tips == nil
        || pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX && wikiPlaces == nil) {
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [cell addSubview:v];
        [v release];
        return cell;
        
    } else {
        
        if (pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX && 
            [[tips objectForKey:@"groups"] count] < 2) {
            
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
            [cell addSubview:v];
            [v release];
            return cell;
            
        } else if (pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX || 
                   pickerSegmentedControl.selectedSegmentIndex == TODOS_CONTROL_INDEX) {
    
            TipTableViewCell320 *cell = (TipTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            if (cell == nil) {
                cell = [[[TipTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            }
            
            cell.tipData = [[(NSDictionary*)[(NSArray*)[tips objectForKey:@"groups"] objectAtIndex:pickerSegmentedControl.selectedSegmentIndex-1] objectForKey:@"tips"] objectAtIndex:indexPath.row];
            
            return cell;
            
        } else { // (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX) {
            
            WikipediaTableViewCell320 *cell = (WikipediaTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
            if (cell == nil) {
                cell = [[[WikipediaTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3] autorelease];
            }
            
            cell.data = [(NSArray*)[wikiPlaces objectForKey:@"geonames"] objectAtIndex:indexPath.row];
            
            return cell;
        }
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self saveState:indexPath];
    
    if (pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX || 
        pickerSegmentedControl.selectedSegmentIndex == TODOS_CONTROL_INDEX) {
    
        TipViewController320 *detailViewController = [[TipViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.tipData = [[(NSDictionary*)[(NSArray*)[tips objectForKey:@"groups"] objectAtIndex:pickerSegmentedControl.selectedSegmentIndex-1] objectForKey:@"tips"] objectAtIndex:indexPath.row];
        detailViewController.venueData = [[(NSDictionary*)[(NSArray*)[tips objectForKey:@"groups"] objectAtIndex:pickerSegmentedControl.selectedSegmentIndex-1] objectForKey:@"tips"] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
    } else if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX) {
        
        NSDictionary *data = [(NSArray*)[wikiPlaces objectForKey:@"geonames"] objectAtIndex:indexPath.row];
        
        WebViewController *wvc = [[WebViewController alloc] init];
        wvc.url = [NSString stringWithFormat:@"http://%@", [data objectForKey:@"wikipediaUrl"]];
        
        float geolong = [((NSNumber*)[data objectForKey:@"lng"]) floatValue];
        float geolat = [((NSNumber*)[data objectForKey:@"lat"]) floatValue];
        
        CLLocationCoordinate2D cords;
        cords.latitude = geolat;
        cords.longitude = geolong;    
        
        wvc.location = cords;
        
        [self.navigationController pushViewController:wvc animated:YES];
        [wvc release];
        
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Handlers

- (void)cancel:(id)sender
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (void)segmentControlAction:(id)sender 
{
    
    [[GNFindNearbyLookup sharedInstance] cancel];
    [[FSTipsLookup sharedInstance] cancel];
    
    if (pickerSegmentedControl.selectedSegmentIndex == TIPS_CONTROL_INDEX ||
        pickerSegmentedControl.selectedSegmentIndex == TODOS_CONTROL_INDEX) {
        
        [self hideTableRefreshHeader];
        [self reloadTips];
        
    } else if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX) {
     
        [self hideTableRefreshHeader];
        [self reloadWikipedia];
    }
	
	_NSLog(@"segmentControlAction");
	[tableView reloadData];
    
    [tableView scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
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
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"latestLocation"]) {
        
        _NSLog(@"%@", [change description]);
        [[ReverseGeocode sharedInstance] lookupWithLocation:(CLLocation*)[change objectForKey:NSKeyValueChangeNewKey]];        
        
        if (pickerSegmentedControl.selectedSegmentIndex == WIKIPEDIA_CONTROL_INDEX) {

            [[GNFindNearbyLookup sharedInstance] lookupWithLocation:(CLLocation*)[change objectForKey:NSKeyValueChangeNewKey]];
            
        } else {
            
            [[FSTipsLookup sharedInstance] lookupWithLocation:(CLLocation*)[change objectForKey:NSKeyValueChangeNewKey]];
        }
        
    } else if ([keyPath isEqual:@"locationText"]) {
		
        if ([[change objectForKey:NSKeyValueChangeNewKey] class] != [NSNull class]) {
            locationText.text = [NSString stringWithFormat:@"Near: %@", (NSString*)[change objectForKey:NSKeyValueChangeNewKey]];
        } else {
            locationText.text = nil;
        }
        
    } else if ([keyPath isEqual:@"tips"]) {
        
        if ([LocationHelper sharedInstance].on == FALSE) {
			[self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
		}
        
        id obj = [change objectForKey:NSKeyValueChangeNewKey];
        if ([obj class] == [NSNull class]) return;        
        
        self.tips = (NSDictionary*)obj;        
        [FSTipsLookup sharedInstance].locationTips = self.tips;
        [FSTipsLookup sharedInstance].locationTipsLastLookup = [FSTipsLookup sharedInstance].lastLookup;
        [tableView reloadData];
        
    } else if ([keyPath isEqual:@"places"]) {
        
        if ([LocationHelper sharedInstance].on == FALSE) {
			[self performSelector:@selector(hideTableRefreshHeader) withObject:nil afterDelay:0];
		}
        
        id obj = [change objectForKey:NSKeyValueChangeNewKey];
        if ([obj class] == [NSNull class]) return;
        
        self.wikiPlaces = (NSDictionary*)obj;        
        [tableView reloadData];        
        
    } else if ([keyPath isEqual:@"error"]) {
        
        [self hideTableRefreshHeader];
    }
}

- (void)dealloc {
    [tips release];
    [wikiPlaces release];
	[pickerSegmentedControl release];
    [super dealloc];
}

@end
