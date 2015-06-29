#import <UIKit/UIKit.h>

@interface CheckInShareButtonsCell : UITableViewCell {

    id delegate;
    BOOL spinner;
}

- (void) showTwitterButton:(BOOL)show;
- (void) showFacebookButton:(BOOL)show;

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) UIButton *facebookButton;
@property (nonatomic, readonly) UIButton *twitterButton;

@property BOOL spinner;

@end
