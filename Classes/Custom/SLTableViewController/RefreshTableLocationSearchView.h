#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SLTableViewController.h"

@class RefreshTableLocationSearchSpinView;

@interface RefreshTableLocationSearchView : UIView {
    CALayer *transformed;
    RefreshTableLocationSearchSpinView *spinView;
}

- (void)setPulldownState:(RefreshTablePullRefreshState)aState;

@property (nonatomic, assign) RefreshTableLocationSearchSpinView *spinView;

@end

@interface RefreshTablePinView : UIView {

}

@end

@interface RefreshTableLocationSearchSpinView : UIView {
    UIColor *color;
    BOOL showArrows;
}

- (void)setPulldownState:(RefreshTablePullRefreshState)aState;

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) BOOL showArrows;

@end