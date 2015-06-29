#import <Foundation/Foundation.h>

#define MODALOVERLAY_VIEW_ID 102102

typedef enum {
	ModalOverlayStyleActivity,
    ModalOverlayStyleSuccess,
	ModalOverlayStyleError
} ModalOverlayStyle;

typedef enum {
	ModalOverlayIconStyleActivity,
	ModalOverlayIconStyleError,
    ModalOverlayIconStyleSuccess
} ModalOverlayIconStyle;

@interface UIView (ModalOverlay) 
- (void)showModalOverlayWithMessage:(NSString*)message style:(ModalOverlayStyle) style;
- (void)hideModalOverlayWithAnimation:(BOOL)animate;
- (void)hideModalOverlayWithErrorMessage:(NSString*)message animation:(BOOL)animate;
- (void)hideModalOverlayWithSuccessMessage:(NSString*)message animation:(BOOL)animate;
- (BOOL)isShowingModalOverlay;
@end

@interface ModalOverlayView : UIView {	
    NSString *message;
	UIFont *messageFont;
    UIActivityIndicatorView *a;
    CGRect lightRect;
    CGRect textRect;
	ModalOverlayStyle style;
    ModalOverlayIconStyle iconStyle;
}

-(id) initWithMessage:(NSString*)message style:(ModalOverlayStyle) style;
- (void)hide;
- (void)hideWithAnimation:(BOOL)animate;

@property (nonatomic, retain) NSString* message;
@property ModalOverlayIconStyle iconStyle;

@end