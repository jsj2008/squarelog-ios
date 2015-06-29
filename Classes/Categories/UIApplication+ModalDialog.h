#import <UIKit/UIKit.h>

@interface UIApplication (ModalDialog)
- (void)hideModalViewWithAnimation:(BOOL)animate;
- (void)showModalView:(UIView*)modalView animate:(BOOL)animate;
@end

@interface ModalDialogView : UIView {
	BOOL showBox;
}
-(void)setupView;
-(id) initWithFrame:(CGRect)frame view:(UIView*)view;
@end