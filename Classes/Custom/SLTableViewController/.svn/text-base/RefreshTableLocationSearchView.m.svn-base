#import "RefreshTableLocationSearchView.h"
#import <QuartzCore/QuartzCore.h>
#import "CGHelper.h"

@implementation RefreshTableLocationSearchView

@synthesize spinView;

#pragma mark Setup and teardown

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        self.opaque = NO;
        
        spinView = [[RefreshTableLocationSearchSpinView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:spinView];
        
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -70;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 65.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        self.layer.transform = rotationAndPerspectiveTransform;   
        
    }
    return self;
}

- (void)setPulldownState:(RefreshTablePullRefreshState)aState{
	
    [spinView setPulldownState:aState];
}

- (void)dealloc {
    [spinView release];
	[super dealloc];
}

@end


@implementation RefreshTableLocationSearchSpinView

@synthesize color;
@synthesize showArrows;

#pragma mark Setup and teardown

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.color = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        self.opaque = NO;
        self.showArrows = NO;

    }
    return self;
}

- (void)setPulldownState:(RefreshTablePullRefreshState)aState{
	
	switch (aState) {
		case RefreshTablePullRefreshPulling:
			
            self.showArrows = YES;
            [self.layer removeAnimationForKey:@"transform"];
            
			break;
		case RefreshTablePullRefreshNormal:
			
            self.showArrows = NO;
			[self.layer removeAnimationForKey:@"transform"];
			
			break;
		case RefreshTablePullRefreshLoading:
            
            self.showArrows = YES;
            {
            
                CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
                rotation.repeatCount = 10000; // "1000 full-circle repetitions ought to be enough for anybody."
                rotation.values = [NSArray arrayWithObjects:
                                   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)],
                                   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f)],
                                   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2.0, 0.0f, 0.0f, 1.0f)],
                                   nil];
                rotation.duration = 1.5; // duration to animate a full revolution of 2*Pi radians.
                [self.layer addAnimation:rotation forKey:@"transform"];
                
            }
			
			break;
		default:
			break;
	}
}

#pragma mark Drawing

- (void)drawRect:(CGRect)r
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.color setStroke];
    [self.color set];
    
	CGContextSetLineWidth(context, 2);
	CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextStrokeEllipseInRect(context, CGRectInset(r, 3, 3));
    
    if (self.showArrows) {
        
//        int padding = 6;
//        int squareSize = r.size.width/6;
//
//        CGContextFillRect(context, CGRectMake(padding, (r.size.height-(squareSize))/2, squareSize, squareSize));
//        CGContextFillRect(context, CGRectMake((r.size.width-(squareSize))/2, padding, squareSize, squareSize));
//        CGContextFillRect(context, CGRectMake(r.size.width-6-(squareSize), (r.size.height-(squareSize))/2, squareSize, squareSize));
//        CGContextFillRect(context, CGRectMake((r.size.width-(squareSize))/2, r.size.height - padding - (r.size.width/6), squareSize, squareSize));

        int padding = 2;
        int squareSize = 14;
        
        CGContextAddRoundRect(context, CGRectMake(self.center.x - squareSize - padding, self.center.y - squareSize - padding, squareSize, squareSize), 4, RoundRectAllCorners);
        CGContextAddRoundRect(context, CGRectMake(self.center.x + padding, self.center.y - squareSize - padding, squareSize, squareSize), 4, RoundRectAllCorners);
        CGContextAddRoundRect(context, CGRectMake(self.center.x + padding, self.center.y + padding, squareSize, squareSize), 4, RoundRectAllCorners);
        CGContextAddRoundRect(context, CGRectMake(self.center.x - squareSize - padding, self.center.y + padding, squareSize, squareSize), 4, RoundRectAllCorners);
        
        CGContextSetLineWidth(context, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

#pragma mark Accessors and properties

- (void)setColor:(UIColor *)newColor
{
	if (newColor && newColor != color) {
		[color release];
		color = [newColor retain];
		
		[self setNeedsDisplay];
	}
}

- (void)setShowArrows:(BOOL)flag
{
	if (flag != showArrows) {
		showArrows = flag;
		[self setNeedsDisplay];
	}
}

- (void)dealloc
{
	self.color = nil;
	[super dealloc];
}

@end
