#import <UIKit/UIKit.h>

#import "SLTableViewController.h"
#import "RefreshTableHeaderView.h"
#import "FSBaseAuth.h"
#import "CLLocation+Accuracy.h"

@interface DashboardViewController320 : SLTableViewController <UITableViewDelegate, 
                                                            UITableViewDataSource,
                                                            UIActionSheetDelegate,
															FSBaseAuthDelegate> {                                                 
    UIActionSheet *forgetPasswordActionSheet;
    UIActionSheet *createAccountActionSheet;
    UIActionSheet *logoutAccountActionSheet;
                                                                
    //NSDate *lastRefresh;
}

-(void) refreshIfDataStale;

@end
