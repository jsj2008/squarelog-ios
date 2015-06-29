#import "TableCellSelectedBackground.h"

@implementation TableCellSelectedBackground

@synthesize delegate;

- (id)initWithFrame:(CGRect)_frame delegate:(id)_delegate 
{
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[HEXCOLOR(0x3db5ddff) set];
	CGContextFillRect(context, rect);
	
	int pad = 0;
	int pad2 = 10;

	CGContextSaveGState(context);
	
		CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 30, HEXCOLOR(0x00325Cff).CGColor);

		CGContextMoveToPoint(context, CGRectGetMinX(rect)-pad2, CGRectGetMinY(rect)-pad2);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect)+pad2, CGRectGetMinY(rect)-pad2);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect)+pad2, CGRectGetMaxY(rect)+pad2);
		CGContextAddLineToPoint(context, CGRectGetMinX(rect)-pad2, CGRectGetMaxY(rect)+pad2);
		CGContextAddLineToPoint(context, CGRectGetMinX(rect)-pad2, CGRectGetMinY(rect)-pad2);
		CGContextClosePath(context);
	
		CGContextMoveToPoint(context, CGRectGetMinX(rect)+pad, CGRectGetMinY(rect)+pad);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-pad, CGRectGetMinY(rect)+pad);
		CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-pad, CGRectGetMaxY(rect)-pad);
		CGContextAddLineToPoint(context, CGRectGetMinX(rect)+pad, CGRectGetMaxY(rect)-pad);
		CGContextClosePath(context);
	
		CGContextSetRGBFillColor(context, 0, 0, 0, 1);
		CGContextEOFillPath(context);
			
	CGContextRestoreGState(context);
	
	[HEXCOLOR(0xcdcdcdff) setStroke];
	CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect)-.5);
	CGContextAddLineToPoint(context, rect.size.width, CGRectGetMaxY(rect)-.5);
	CGContextStrokePath(context);
	
}

- (void)willMoveToSuperview:(UIView *)newSuperview 
{
 
    if (newSuperview == nil && [self.delegate respondsToSelector:@selector(finishedBackgroundViewFadeoutAnimationWithView:)]) {
        [self.delegate finishedBackgroundViewFadeoutAnimationWithView:self];
    }
}

@end
