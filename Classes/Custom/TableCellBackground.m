#import "TableCellBackground.h"

@implementation TableCellBackground

- (void)drawRect:(CGRect)r 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    [HEXCOLOR(0xffffffff) setStroke];
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, 0, .5);
    CGContextAddLineToPoint(context, r.size.width, .5);
    CGContextStrokePath(context);
    
    [HEXCOLOR(0xcdcdcdff) setStroke];
    CGContextMoveToPoint(context, 0, CGRectGetMaxY(r)-.5);
    CGContextAddLineToPoint(context, r.size.width, CGRectGetMaxY(r)-.5);
    CGContextStrokePath(context);
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat colors[8] = {HEXCHANNEL(0xfe), HEXCHANNEL(0xfe), HEXCHANNEL(0xfe), HEXCHANNEL(0xFF), 
        HEXCHANNEL(0xf6), HEXCHANNEL(0xf6), HEXCHANNEL(0xf6), HEXCHANNEL(0xFF)};
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, num_locations);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMinX(r), 1), CGPointMake(CGRectGetMinX(r), CGRectGetMaxY(r)-1), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
}

- (void)dealloc {
    [super dealloc];
}


@end
