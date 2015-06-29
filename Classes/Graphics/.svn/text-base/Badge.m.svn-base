#import "Badge.h"
#import "UIView+ShadowBug.h"

#ifndef M_PI 
#define M_PI 3.1415926535897932385 
#endif

static inline float radians(double degrees) { return degrees * M_PI / 180; }

@implementation Badge

@synthesize count;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setOpaque:NO];
        self.userInteractionEnabled = NO;
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectNull];
        l.tag = 100;
        l.hidden = YES;
        l.textColor = [UIColor whiteColor];
        l.font = [UIFont boldSystemFontOfSize:16];
        l.backgroundColor = [UIColor clearColor];
        l.opaque = NO;
        [self addSubview:l];
		[l release];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setOpaque:NO];
	}
	return self;
}

- (void) setCount:(NSNumber *) c
{
    [count release];
    count = c; 
	[count retain];
    
    UILabel *l = (UILabel*) [self viewWithTag:100];
    
    if ([count intValue] > 0) {
        
        l.text = [count stringValue];
        CGSize s = [l.text sizeWithFont:l.font];
        l.frame = CGRectMake(0, 0, s.width, s.height);
        l.hidden = NO;
		
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, MAX(s.width+16,24), self.bounds.size.height);
        self.hidden = NO;
		
		l.center = CGPointMake((int)CGRectGetMaxX(self.bounds)/2,(int)(CGRectGetMaxY(self.bounds)-6)/2);
        
    } else {
        
        self.hidden = YES;
    }
}

//http://en.wikipedia.org/wiki/File:Degree-Radian_Conversion.svg

- (void)drawRect:(CGRect)rect
{
	
	CGPoint shadowOffset = CGPointMake(0, 4);
	NSInteger shadowSize = 4;
	NSInteger radius = 10;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// red fill and shadow
	{
	
		CGContextSaveGState(context);
		CGContextSetShadowWithColor(context, CGSizeMake(0, 3*[UIView shadowVerticalMultiplier]), 3, HEXCOLOR(0x111111dd).CGColor);
		
		CGContextAddArc(context, radius+(int)(shadowOffset.x/2)+(int)(shadowSize/2), radius+(int)(shadowSize/2), radius, radians(270), radians(90), true);
		CGContextAddArc(context, self.bounds.size.width-(radius+(int)(shadowOffset.x/2)+(int)(shadowSize/2)), radius+(int)(shadowSize/2), radius, radians(90), radians(270), true);

		[[UIColor colorWithRed:0.801f green:0.0f blue:0.009f alpha:1.0f] setFill];
		CGContextFillPath(context);		
		CGContextRestoreGState(context);
		
	}
	
	// glare
	{
		
		CGContextSaveGState(context);

		CGContextAddArc(context, radius+(int)(shadowOffset.x/2)+(int)(shadowSize/2), radius+(int)(shadowSize/2), radius, radians(200), radians(270), false);
		CGContextAddArc(context, self.bounds.size.width-(radius+(int)(shadowOffset.x/2)+(int)(shadowSize/2)), radius+(int)(shadowSize/2), radius, radians(270), radians(340), false);
		
		CGContextAddCurveToPoint (
									   context,
									   self.bounds.size.width-((int)(shadowOffset.x/2)+(int)(shadowSize/2)),
									   radius+(int)(shadowSize/2)+2,
									   (int)(shadowOffset.x/2)+(int)(shadowSize/2),
									   radius+(int)(shadowSize/2)+2,
									   (shadowOffset.x/2)+3,
									   radius-2
									   );
		CGContextEOClip(context);
		
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		
		CGFloat locations[2];
		NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
		UIColor *color = [UIColor colorWithRed:1.0f green:0.647f blue:0.636f alpha:1.0f];
		[colors addObject:(id)[color CGColor]];
		locations[0] = 0.0f;
		color = [UIColor colorWithRed:0.787f green:0.037f blue:0.082f alpha:1.0f];
		[colors addObject:(id)[color CGColor]];
		locations[1] = 1.0f;
		CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
		
		CGContextDrawLinearGradient(context, gradient, 
									CGPointMake(CGRectGetMaxX(self.bounds), 
												(shadowOffset.x/2)+2), 
									CGPointMake(CGRectGetMaxX(self.bounds), 
												(shadowOffset.x/2+radius+3)), 
									0); //(kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation)
		
		CGGradientRelease(gradient);
		CGColorSpaceRelease(space);
		
		CGContextRestoreGState(context);
	}

	// white border 
	{
	
		CGContextSetLineWidth(context, 2);
		CGContextSetLineCap(context, kCGLineCapSquare);
		[[UIColor whiteColor] setStroke];
		
		CGContextAddArc(context, self.bounds.size.width-(radius+(int)(shadowOffset.x/2)+(int)(shadowSize/2)), radius+(int)(shadowSize/2), radius, radians(90), radians(270), true);
		CGContextAddArc(context, radius+(int)(shadowOffset.x/2)+(int)(shadowSize/2), radius+(int)(shadowSize/2), radius, radians(270), radians(90), true);
		CGContextAddLineToPoint(context, self.bounds.size.width-(radius+(int)(shadowSize/2)), (shadowSize/2)+2*radius);
		
		CGContextStrokePath(context);
	}
}

@end
