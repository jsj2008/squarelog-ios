#import "SearchBar.h"

//@implementation UISearchBarBackground : NSObject { } @end

@implementation SearchBar

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		for (UIView *v in [self subviews]) {
			if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) [v removeFromSuperview];
		}
	}
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat colors[8] = {HEXCHANNEL(0xEA), HEXCHANNEL(0xEC), HEXCHANNEL(0xEE), HEXCHANNEL(0xFF), 
						 HEXCHANNEL(0xBE), HEXCHANNEL(0xC5), HEXCHANNEL(0xD1), HEXCHANNEL(0xFF)}; // Start/End colors

	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, num_locations);
	CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMinX(rect), 0), CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)), 0);
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);

	[HEXCOLOR(0xeeeeeeff) setStroke];
	CGContextMoveToPoint(context, 0, .5);
	CGContextAddLineToPoint(context, rect.size.width, .5);
	CGContextStrokePath(context);

	[HEXCOLOR(0x999999ff) setStroke];
	CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.5);
	CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}

@end
