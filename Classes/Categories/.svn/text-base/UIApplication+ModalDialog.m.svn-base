#import "UIApplication+ModalDialog.h"
#import "UIApplication+TopView.h"
#import "CGHelper.h"

#define ZOOM_ANIMATION_TIME .40

@implementation UIApplication (LoginDialog)

- (void)hideModalViewWithAnimation:(BOOL)animate {
    
    UIView *v = [[UIApplication sharedApplication] topViewWithTag:103];
    
    [[v viewWithTag:1000] removeFromSuperview];
    
    if (animate) {
        
        [UIView beginAnimations:@"modal-view-3" context:NULL];
        [UIView setAnimationDuration:.250];
        [UIView setAnimationDelegate:v];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        
        v.frame = CGRectInset(v.frame, 25, 25);
        v.alpha = 0;
        
        [UIView commitAnimations];
        
    } else {
        
        [v removeFromSuperview];
    }
}

- (void) showModalView:(UIView*)modalView animate:(BOOL)animate {
	
    modalView.tag = 1000;
    
	CGRect r = CGRectInset(CGRectOffset([UIScreen mainScreen].bounds, 0, 10), -10, 0);
	CGRect r2 = CGRectInset(r, r.size.width*.40, r.size.height*.40);
	
	ModalDialogView *v = [[ModalDialogView alloc] initWithFrame:r2 view:modalView];
    v.tag = 103;
    [[[UIApplication sharedApplication] topViewBelowKeyboard] addSubview:v];
    
    //[[[UIApplication sharedApplication] topViewBelowKeyboard] exploreViewAtLevel:0];
	
	[UIView beginAnimations:@"modal-view-1" context:v];
	[UIView setAnimationDuration:ZOOM_ANIMATION_TIME];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationZoomDidStop:finished:context:)];
	v.frame = r;
	[UIView commitAnimations];
	
	[v release];
}

#pragma mark Animations

- (void)animationZoomDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
	UIView *v = (UIView*)context;
	[UIView beginAnimations:@"modal-view-2" context:v];
	[UIView setAnimationDuration:.25];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationBounceDidStop:finished:context:)];
	v.frame = CGRectInset(v.frame, 10, 10);	
	[UIView commitAnimations];
}

- (void)animationBounceDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
	ModalDialogView *v = (ModalDialogView*)context;
	[v setupView];
}

@end


@implementation ModalDialogView

- (id) initWithFrame:(CGRect)frame view:(UIView*)view 
{

	if (self = [super initWithFrame:frame]) {
		self.opaque = NO;
		view.hidden = YES;
		view.tag = 1000;
		showBox = YES;
		[self addSubview:view];
	}
	
	return self;
}

-(void)setupView 
{
	UIView *v = [self viewWithTag:1000];
	v.hidden = NO;
	v.frame = CGRectInset(self.bounds, 20, 20);
    v.opaque = YES;
    v.backgroundColor = [UIColor whiteColor];
//	showBox = NO;
//	[self setNeedsDisplay];
}	

- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
//    [[UIColor redColor] set];
//    CGContextFillRect(context, rect);
	
	[HEXCOLOR(0x888888cc) set];
    [HEXCOLOR(0x888888cc) setStroke];
	
	CGContextAddRoundRect(context, CGRectInset(rect, 10,10), 8, RoundRectAllCorners);
    CGContextSetLineWidth(context, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
	
	if (showBox) {
		[HEXCOLOR(0xffffffff) set];
		[HEXCOLOR(0x88888877) setStroke];
		CGContextAddRoundRect(context, CGRectInset(rect, 20, 20), 4, RoundRectAllCorners);
		CGContextSetLineWidth(context, 0);
		CGContextDrawPath(context, kCGPathFillStroke);
	}
}

@end