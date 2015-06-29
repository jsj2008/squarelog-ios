#import "UIView+ModalOverlay.h"
#import "UIFontAdditions.h"

#import "CGHelper.h"

#define ZOOM_ANIMATION_TIME 0.30f
#define ZOOM_ANIMATION_OVERLAY_DURATION 1.5f
#define ZOOM_ANIMATION_SUCCESS_OVERLAY_DURATION 1.5f

@implementation UIView (ModalOverlay)

- (BOOL)isShowingModalOverlay
{
    return [self viewWithTag:MODALOVERLAY_VIEW_ID] != nil;
}

- (void)hideModalOverlayWithErrorMessage:(NSString*)message animation:(BOOL)animate 
{
    
    ModalOverlayView *v = (ModalOverlayView*)[self viewWithTag:MODALOVERLAY_VIEW_ID];
    v.message = message;
    v.iconStyle = ModalOverlayIconStyleError;
    
    [self performSelector:@selector(hideModalOverlay) withObject:nil afterDelay:ZOOM_ANIMATION_SUCCESS_OVERLAY_DURATION];
}

- (void)hideModalOverlayWithSuccessMessage:(NSString*)message animation:(BOOL)animate 
{
    
    ModalOverlayView *v = (ModalOverlayView*)[self viewWithTag:MODALOVERLAY_VIEW_ID];
    v.message = message;
    v.iconStyle = ModalOverlayIconStyleSuccess;
    
    [self performSelector:@selector(hideModalOverlay) withObject:nil afterDelay:ZOOM_ANIMATION_SUCCESS_OVERLAY_DURATION];
}

- (void)hideModalOverlayWithAnimation:(BOOL)animate 
{
    
    ModalOverlayView *v = (ModalOverlayView*)[self viewWithTag:MODALOVERLAY_VIEW_ID];
    [v hideWithAnimation:animate];
}

- (void)hideModalOverlay 
{
    [self hideModalOverlayWithAnimation:YES];
}

- (void)showModalOverlayWithMessage:(NSString*)message 
                              style:(ModalOverlayStyle)style
{
    if ([self isShowingModalOverlay]) return;
    
    CGRect r = CGRectInset(CGRectOffset([UIScreen mainScreen].bounds, 0, 10), -25, -25);
    CGRect r2 = CGRectInset(r, r.size.width * -.25, r.size.height * -.25);

	ModalOverlayView *v = [[ModalOverlayView alloc] initWithMessage:message style:style];
    v.tag = MODALOVERLAY_VIEW_ID;
    v.alpha = 0;
    v.frame = r2;

    [self addSubview:v];
    
    [UIView beginAnimations:@"modal-overlay" context:NULL];
	[UIView setAnimationDuration:ZOOM_ANIMATION_TIME];
    
    v.frame = r;
    v.alpha = 1;
    
	[UIView commitAnimations];
    
    [v release];
    
    if (style == ModalOverlayStyleError || style == ModalOverlayStyleSuccess) {
        [self performSelector:@selector(hideModalOverlay) withObject:nil afterDelay:ZOOM_ANIMATION_OVERLAY_DURATION];
    }
}

@end

@implementation ModalOverlayView

@synthesize message, iconStyle;

-(id) initWithMessage:(NSString*)newMessage style:(ModalOverlayStyle)_style {
    
    if (self = [super init]) {

		style = _style;
		
        self.opaque = NO;
        		
		a = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[self addSubview:a];
        [a release];
        
        if (style == ModalOverlayStyleActivity) {
            iconStyle = ModalOverlayIconStyleActivity;
            self.userInteractionEnabled = YES;
            [a startAnimating];
        } else if (style == ModalOverlayStyleError) {
            iconStyle = ModalOverlayIconStyleError;
            self.userInteractionEnabled = NO;
        } else {
            iconStyle = ModalOverlayIconStyleSuccess;
            self.userInteractionEnabled = NO;
        }
		
		messageFont = [UIFont boldSystemFontOfSize:14];
        message = newMessage;
		[message retain];
    }
    
    return self;
}

- (void)setIconStyle:(ModalOverlayIconStyle) i
{
    iconStyle = i;
    if (iconStyle != ModalOverlayStyleActivity) {
        a.hidden = YES;
    } else {
        a.hidden = NO;
    }
    
    [self setNeedsDisplay];
    
}
- (void)hide 
{
    [self hideWithAnimation:YES];
}

- (void)hideWithAnimation:(BOOL)animate {
    
    if (animate) {
        
        [UIView beginAnimations:@"modal-overlay" context:NULL];
        [UIView setAnimationDuration:.250];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        
        self.frame = CGRectInset(self.frame, 25, 25);
        self.alpha = 0;
        
        [UIView commitAnimations];
        
    } else {
        
        [self removeFromSuperview];
    }
}

- (void) setMessage:(NSString *) m
{
    [message release]; message = m; [message retain];
    [self layoutSubviews];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    [self removeFromSuperview];
}

- (void) setFrame:(CGRect) rect
{	
	[super setFrame:rect];
	[self layoutSubviews];
}

- (void) layoutSubviews {
	
	// highlight rect
	lightRect = CGRectOffset(CGRectInset(self.frame, 80, 170), 30, 10);
	
	CGSize iconSize = CGSizeMake(37, 37);
	if (a != nil) {
		iconSize = a.frame.size;
	}
    
	// center the text and graphic
    CGSize messageSize = [message sizeWithFont:messageFont constrainedToSize:CGSizeMake(lightRect.size.width-30, [messageFont ttLineHeight] * 3) lineBreakMode:UILineBreakModeTailTruncation];
	
	CGFloat iconY = (self.frame.size.height - (iconSize.width + 10 + messageSize.height)) / 2.0;
	
    a.frame = CGRectMake((self.frame.size.width - iconSize.width)/2.0, iconY, iconSize.width, iconSize.height);
	
	CGFloat textY = a.frame.origin.y + iconSize.width + 10;
	
	textRect = CGRectMake((self.frame.size.width - messageSize.width)/2.0, textY, messageSize.width, messageSize.height);
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	if (style == ModalOverlayStyleActivity) {
		
		NSMutableArray *colors;
		UIColor *color;
		CGFloat locations[2];
		CGGradientRef gradient;
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

		CGAffineTransform transform;

		colors = [NSMutableArray arrayWithCapacity:2];
		color = HEXCOLOR(0x33333333);
		[colors addObject:(id)[color CGColor]];
		locations[0] = 0.0f;
		color = HEXCOLOR(0x33333300);
		[colors addObject:(id)[color CGColor]];
		locations[1] = 1.0f;
		gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);

		CGContextSaveGState(context);
		CGContextEOClip(context);
		transform = CGAffineTransformMakeTranslation(CGRectGetMidX(rect), CGRectGetMidY(rect));
		transform = CGAffineTransformScale(transform, 0.5f * rect.size.width, 0.5f * rect.size.height);
		CGContextConcatCTM(context, transform);
		CGContextDrawRadialGradient(context, gradient, CGPointZero, 1.0f, CGPointMake(0.0f, 0.0f), 0.0f, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
		CGContextRestoreGState(context);
		
	} 
    
    [HEXCOLOR(0x00000099) set];
    [HEXCOLOR(0x00000099) setStroke];

	CGContextAddRoundRect(context, lightRect, 8, RoundRectAllCorners);
    CGContextSetLineWidth(context, 0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [HEXCOLOR(0xffffffff) set];
	
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, HEXCOLOR(0x000000ff).CGColor);
    
    [message drawInRect:textRect withFont:messageFont];                               
	
	if (iconStyle == ModalOverlayIconStyleError) {
		
		[HEXCOLOR(0xffffffff) setStroke];
		
		CGContextSetLineWidth(context, 4);
		CGContextSetLineCap(context, kCGLineCapRound);		
		
		CGContextMoveToPoint(context, CGRectGetMinX(a.frame), CGRectGetMinY(a.frame));
		CGContextAddLineToPoint(context, CGRectGetMaxX(a.frame), CGRectGetMaxY(a.frame));
		
		CGContextMoveToPoint(context, CGRectGetMinX(a.frame), CGRectGetMaxY(a.frame));
		CGContextAddLineToPoint(context, CGRectGetMaxX(a.frame), CGRectGetMinY(a.frame));
		CGContextStrokePath(context);
        
	} else if (iconStyle == ModalOverlayIconStyleSuccess) {
        
		[HEXCOLOR(0xffffffff) setStroke];
		
		CGContextSetLineWidth(context, 4);
		CGContextSetLineCap(context, kCGLineCapRound);		
		
		CGContextMoveToPoint(context, CGRectGetMinX(a.frame), a.frame.origin.y+a.frame.size.height/2.0f);
        CGContextAddLineToPoint(context, a.frame.origin.x + a.frame.size.width/2.0f, CGRectGetMaxY(a.frame));
        CGContextAddLineToPoint(context, CGRectGetMaxX(a.frame), CGRectGetMinY(a.frame));
		CGContextStrokePath(context);        
    }
	
	CGContextRestoreGState(context);
}

- (void) dealloc 
{
	[super dealloc];
//	[message release];
//	[messageFont release];
}

@end