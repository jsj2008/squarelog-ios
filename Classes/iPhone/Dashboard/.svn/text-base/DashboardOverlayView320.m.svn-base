#import "DashboardOverlayView320.h"

#import "UIDevice+Machine.h"

@implementation DashboardOverlayView320

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        
         if ([[UIDevice currentDevice] highQuality]) {
        
            self.opaque = NO;
             
        } else {
            
            self.opaque = YES;
            self.backgroundColor = [UIColor whiteColor];
            
        }
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    [HEXCOLOR(0x111111ff) setStroke];
    CGContextMoveToPoint(context, 0, .5);
    CGContextAddLineToPoint(context, rect.size.width, 0.5);
    CGContextStrokePath(context);
    
    [HEXCOLOR(0xaaaaaaff) setStroke];
    CGContextMoveToPoint(context, 0, 1.5);
    CGContextAddLineToPoint(context, rect.size.width, 1.5);
    CGContextStrokePath(context);
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat colors[8] = {HEXCHANNEL(0x99), HEXCHANNEL(0x99), HEXCHANNEL(0x99), HEXCHANNEL(0xFF), 
                         HEXCHANNEL(0x33), HEXCHANNEL(0x33), HEXCHANNEL(0x33), HEXCHANNEL(0xEE)}; // Start/End colors
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, num_locations);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x, 2), CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)/2+2), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    [HEXCOLOR(0x111111ee) setFill];
	CGContextFillRect(context, CGRectMake(rect.origin.x, CGRectGetMaxY(rect)/2+2, rect.size.width, CGRectGetMaxY(rect)/2-2));
}

- (void)dealloc {
    [super dealloc];
}

@end
