#import "BottomRounderTableView.h"

#import "CGHelper.h"

@implementation BottomRounderTableView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] set];
    CGContextFillRect(context, rect);
    
    [HEXCOLOR(0xffffffff) set];
    
	CGContextAddRoundRect(context, rect, 2, RoundRectBottomCorners);
    CGContextSetLineWidth(context, 0);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)dealloc {
    [super dealloc];
}


@end
