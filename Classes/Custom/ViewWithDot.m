#import "ViewWithDot.h"

@implementation ViewWithDot

@synthesize spinner;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        spinner = NO;
    }
    return self;
}

- (void)setSpinner:(BOOL)_spinner {
    
    spinner = _spinner;
    
    if (spinner) {
        UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        v.tag = 1000;
        [v startAnimating];
        v.center = self.center;
        [self addSubview:v];
        [v release];
    } else {
        [[self viewWithTag:1000] removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
	CGContextFillRect(context, rect);
    
    if (spinner) return;
    
    [[UIColor lightGrayColor] setFill];
    CGContextFillEllipseInRect(context, CGRectMake((rect.size.width-6)/2, (rect.size.height-6)/2, 6, 6));
}

- (void)dealloc {
    [super dealloc];
}


@end
