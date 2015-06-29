#import "UIApplication+TopView.h"
#import "UIView+ExploreViews.h"

@implementation UIApplication (TopView)

- (UIView *)topViewWithTag:(int)tag
{
	NSArray *windows = [self windows];
	for (UIWindow *window in [windows reverseObjectEnumerator]) {
        
        UIView *v = [window viewWithTag:tag];
        if (v) return v;
	}
	
	return nil;
}

- (UIView *)topViewBelowKeyboard 
{
    for (UIView *v in [[self windows] reverseObjectEnumerator]) {
        if ([v class] == [UIWindow class]) return v;
    }
    
    return [[self windows] lastObject];
}

- (UIView *)topView
{
	return [[self windows] lastObject];
}

@end