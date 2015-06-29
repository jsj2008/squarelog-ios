#import "RefreshTableHeaderView.h"
#import "SLTableViewController.h"

@implementation RefreshTableHeaderView

- (id)initWithFrame:(CGRect)_frame pulldownStyle:(SLPulldownStyle)_pulldownStyle
{
    if (self = [super initWithFrame:_frame]) {
        pulldownStyle = _pulldownStyle;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    float y = pulldownStyle==SLPulldownDefault?.5:44.5;
	
	[HEXCOLOR(0x999999ff) setStroke];
	CGContextMoveToPoint(context, 0, rect.size.height - y);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - y);
	CGContextStrokePath(context);	
}

- (void)dealloc {
    
    [super dealloc];
}

@end