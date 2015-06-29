#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CLLocation+Accuracy.h"
#import "RefreshTableHeaderView.h"
#import "RefreshProgressView.h"

typedef enum {
    SLPulldownDefault,
    SLPulldownSearchBar,
    SLPulldownNone
} SLPulldownStyle;

typedef enum{
    RefreshTablePullRefreshPulling,
    RefreshTablePullRefreshNormal,
    RefreshTablePullRefreshLocated,
    RefreshTablePullRefreshLoading,
} RefreshTablePullRefreshState;

@class RefreshTableLocationSearchView;

@interface SLTableViewController : UITableViewController {
	UITableView *tableView;
    NSIndexPath *lastIndex;
    
	BOOL _reloading;
    UIView *refreshHeaderView;
    SLPulldownStyle pulldownStyle;
    
    RefreshTablePullRefreshState pulldownState;
    
	UISearchDisplayController *searchController;	
	UISearchBar *searchBar;
    
    UILabel *statusLabel;

    RefreshTableLocationSearchView *locationView;
    UIImageView *pinView;
    RefreshProgressView *progressView;
    
    CGFloat topInset;
}

- (id)initWithStyle:(UITableViewStyle)style pulldownStyle:(SLPulldownStyle)_pulldownStyle;
- (id)initWithStyle:(UITableViewStyle)style;

- (void)reloadTableViewDataSource;

- (void)hideTableRefreshHeader;
- (void)showTableRefreshHeader;
- (void)showTableRefreshHeaderWithAnimation:(BOOL)animation;

- (void) addPullToRefreshHeader;

- (void) setAccuracy:(SLLocationAccuracy)accuracy;

- (void) loadState;
- (void) saveState:(NSIndexPath *)indexPath;

- (void) configureTableView:(UITableView*)_tableView;

@end
