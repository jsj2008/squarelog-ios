#import "SLTableViewController.h"
#import "UIDevice+Machine.h"
#import "RefreshTableLocationSearchView.h"
#import "RefreshProgressView.h"

#import "SearchBar.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

@implementation SLTableViewController

- (id)initWithStyle:(UITableViewStyle)style pulldownStyle:(SLPulldownStyle)_pulldownStyle
{
    if (self = [super initWithStyle:style]) {
        pulldownStyle = _pulldownStyle;
    }
    return self;
}
                
- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        pulldownStyle = SLPulldownDefault;
    }
    return self;
}

- (id) init 
{
    if (self = [self initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownSearchBar]) {
        pulldownStyle = SLPulldownDefault;
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void) loadView 
{
	tableView = [[UITableView alloc] initWithFrame:CGRectNull];
    tableView.delegate = self;
    tableView.dataSource = self;
    
	[self configureTableView:tableView];
    
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    mainView.opaque = YES;
    [mainView addSubview:tableView];
	self.view = mainView;
    [mainView release];
    
    if (pulldownStyle != SLPulldownNone) {
    
        [self addPullToRefreshHeader];
    }
}

// default implementation
- (void)configureTableView:(UITableView *)_tableView {
	
    _tableView.frame = CGRectMake(0, 0, 320, 480-20-44);
	_tableView.rowHeight = 54;
}

- (void) addPullToRefreshHeader
{
        
    refreshHeaderView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, tableView.bounds.size.width, tableView.bounds.size.height)
                                                        pulldownStyle:pulldownStyle];
    refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    [tableView addSubview:refreshHeaderView];
    [refreshHeaderView release];
    
//    progressView = [[RefreshProgressView alloc] initWithFrame:CGRectNull];
//    [refreshHeaderView addSubview:progressView];
//    [progressView release];
    
    pinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
    pinView.hidden = YES;
    [refreshHeaderView addSubview:pinView];
    [pinView release];
    
    if (pulldownStyle == SLPulldownSearchBar) {
        
        //progressView.frame = CGRectMake((refreshHeaderView.frame.size.width-100)/2.0, refreshHeaderView.frame.size.height - 44 - 24, 100, 10);
    
        searchBar = [[SearchBar alloc] initWithFrame:CGRectMake(0, refreshHeaderView.frame.size.height-44, 320, 44)];
        
        [refreshHeaderView addSubview:searchBar];
        [searchBar release];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((refreshHeaderView.frame.size.width-186)/2 + 4, refreshHeaderView.frame.size.height - 88.0f, 186, 20.0f)];
        
        locationView = [[RefreshTableLocationSearchView alloc] initWithFrame:CGRectMake(16.0f, refreshHeaderView.frame.size.height - (53.0f+44.0f), 55.0f, 55.0f)];
        pinView.frame = CGRectNull;//CGRectMake(10.0f, refreshHeaderView.frame.size.height - (100.0f+44.0f), 16.0f, 36.0f);
        
        topInset = 70 + 44;
        
        tableView.contentInset = UIEdgeInsetsMake(44, 0.0f, 0.0f, 0.0f);
        tableView.contentOffset = CGPointMake(0, -44);

    } else {
        
        //progressView.frame = CGRectMake((refreshHeaderView.frame.size.width-100)/2.0, refreshHeaderView.frame.size.height - 24, 100, 10);
        locationView = [[RefreshTableLocationSearchView alloc] initWithFrame:CGRectMake(16.0f, refreshHeaderView.frame.size.height - 53.0f, 55.0f, 55.0f)];
        pinView.frame = CGRectNull;
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((refreshHeaderView.frame.size.width-186)/2 + 4, refreshHeaderView.frame.size.height - 44.0, 186, 20.0f)];        
        
        topInset = 70;
    }
    
    [refreshHeaderView addSubview:locationView];
    [locationView release];
    
    statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    statusLabel.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    statusLabel.opaque = YES;
    statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    statusLabel.textColor = TEXT_COLOR;
    statusLabel.shadowColor = [UIColor whiteColor];//[UIColor colorWithWhite:1.f alpha:1.0f];
    statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    statusLabel.textAlignment = UITextAlignmentCenter;
    pulldownState = RefreshTablePullRefreshNormal;
    [refreshHeaderView addSubview:statusLabel];
    [statusLabel release];
    
}

#pragma mark -
#pragma mark Pulldown Header

- (void)setPulldownState:(RefreshTablePullRefreshState)aState{
    
    [locationView setPulldownState:aState];
	
	switch (aState) {
		case RefreshTablePullRefreshPulling:
			
			statusLabel.text = @"Release to refresh...";
			
			break;
			
		case RefreshTablePullRefreshNormal:
			
			statusLabel.text = @"Pull down to refresh...";
            
            if (pulldownStyle == SLPulldownSearchBar) {
                pinView.frame = CGRectMake(36.0f, refreshHeaderView.frame.size.height - (100.0f+44.0f), 16.0f, 36.0f);
            } else {
                pinView.frame = CGRectMake(36.0f, refreshHeaderView.frame.size.height - 100.0f, 16.0f, 36.0f);
            }
            pinView.hidden = YES;
			
			break;
            
		case RefreshTablePullRefreshLocated:
        case RefreshTablePullRefreshLoading:
            
			statusLabel.text = @"Locating...";
            
            pinView.hidden = NO;
            
            [UIView beginAnimations:@"pindrop" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:.20];
            
            if (pulldownStyle == SLPulldownSearchBar) {
                pinView.frame = CGRectMake(36.0f, refreshHeaderView.frame.size.height - (60.0f+44.0f), 16.0f, 36.0f);
            } else {   
                pinView.frame = CGRectMake(36.0f, refreshHeaderView.frame.size.height - 60.0f, 16.0f, 36.0f);
            }
            
            [UIView commitAnimations];
            
            break;
            
		default:
			break;
	}
	
	pulldownState = aState;
}


- (void)setAccuracy:(SLLocationAccuracy)accuracy 
{	
//	CALayer *layer = locationView.spinView.layer;
//	[UIView beginAnimations:@"accuracy" context:locationView.spinView];
//	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDuration:.25];
//	layer.opacity = 1.0;
//	layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
//	[UIView commitAnimations];
    
    statusLabel.text = @"Updating...";
}

#pragma mark -
#pragma mark ScrollView

//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView 
//{
//    //_NSLog(NSStringFromUIEdgeInsets(scrollView.contentInset));
//    
//    if ( == RefreshTablePullRefreshLoading) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.2];
//        tableView.contentInset = UIEdgeInsetsMake(70.0f, 0.0f, 0.0f, 0.0f);
//        [UIView commitAnimations];
//    } else {
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//    
//    //_NSLog(NSStringFromUIEdgeInsets(scrollView.contentInset));
//}

- (void) unhighlightCells
{
    for (UITableViewCell *cell in [tableView visibleCells]) {
        cell.selected = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self performSelector:@selector(unhighlightCells) withObject:nil afterDelay:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{	
	
    if (pulldownStyle == SLPulldownNone) return;
    
	if (scrollView.isDragging) {
        
        for (UITableViewCell *cell in [tableView visibleCells]) {
            cell.selected = NO;
        }
        
		if (pulldownState == RefreshTablePullRefreshPulling 
            && scrollView.contentOffset.y > -1*(topInset+10) 
            && scrollView.contentOffset.y < 0.0f 
            && !_reloading) {
            
			[self setPulldownState:RefreshTablePullRefreshNormal];
            
		} else if (pulldownState == RefreshTablePullRefreshNormal 
                   && scrollView.contentOffset.y < -1*(topInset+10) 
                   && !_reloading) {
            
			[self setPulldownState:RefreshTablePullRefreshPulling];
            
//		} else if (pulldownState == RefreshTablePullRefreshLoading
//                   && scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -1*(topInset)) {
//            
//            scrollView.delegate = nil;
//            scrollView.contentInset = UIEdgeInsetsMake(fabs(scrollView.contentOffset.y), 0.0f, 0.0f, 0.0f);
//            scrollView.delegate = self;
        }
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    for (UITableViewCell *cell in [tableView visibleCells]) {
        cell.selected = NO;
    }    
    
    if (pulldownStyle == SLPulldownNone) return;    
	
	if (scrollView.contentOffset.y <= -1*(topInset+10)
        && !_reloading) {
        
        _reloading = YES;
        
        [self reloadTableViewDataSource];
        [self setPulldownState:RefreshTablePullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
	}
}

#pragma mark -

- (void)hideTableRefreshHeader 
{
	
    if (pulldownStyle == SLPulldownNone) return;
    
	_reloading = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
    
    if (pulldownStyle == SLPulldownSearchBar) {
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    } else {
        tableView.contentInset = UIEdgeInsetsZero;
    }
    
	[UIView commitAnimations];
	
	[self setPulldownState:RefreshTablePullRefreshNormal];
	
	[tableView flashScrollIndicators];
    
    _NSLog(@"hideTableRefreshHeader");
}

- (void)showTableRefreshHeader
{
    [self showTableRefreshHeaderWithAnimation:NO];
}

- (void)showTableRefreshHeaderWithAnimation:(BOOL)animation 
{
    if (pulldownStyle == SLPulldownNone) return;
    
    [self setPulldownState:RefreshTablePullRefreshLoading];
    
    LOG_EXPR(tableView);
    
    if (animation) {        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
    }
    
    tableView.contentOffset = CGPointMake(0, -1*topInset);
    tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, 0.0f, 0.0f);
    
    if (animation) {
        [UIView commitAnimations];
    }
    
    LOG_EXPR(tableView);
}

- (void) reloadTableViewDataSource 
{
	NSAssert(false, @"not implemented");
}

#pragma mark -
#pragma mark Table Selection State

- (void) loadState 
{
	
	if (lastIndex != nil) {
		
		[tableView selectRowAtIndexPath:lastIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
		[tableView deselectRowAtIndexPath:lastIndex animated:YES];
	}
	
	lastIndex = nil;	
}

- (void) saveState:(NSIndexPath *)indexPath 
{
	
    [lastIndex release]; lastIndex = nil;
	lastIndex = [indexPath retain];
}

- (void) viewWillAppear:(BOOL)animated 
{
    [self loadState];
    [super viewWillAppear:animated];
}

- (void)dealloc {
    
    //[refreshHeaderView release];
	//[searchBar release];
    //[statusLabel release];
    //[locationView release];
    //[pinView release];
    [tableView release];
    
    [lastIndex release];
    
    [super dealloc];
}

@end

