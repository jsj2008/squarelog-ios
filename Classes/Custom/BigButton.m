#import <QuartzCore/QuartzCore.h>

#import "BigButton.h"
#import "UIDevice+Machine.h"

#import "Badge.h"

@implementation BigButton

@synthesize highlightColor, normalColor;

+ (BigButton*) checkinButton {
    
    BigButton *button;
    
    if (button = [BigButton buttonWithType:UIButtonTypeCustom]) {
        
        button.opaque = YES;
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        button.titleLabel.shadowColor = [UIColor blackColor];
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10.0f;
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        button.layer.borderWidth = 4.0f;
		
		button.normalColor = [UIColor colorWithRed:134/255.0f green:169/255.0f blue:27/255.0f alpha:1.0f];//[UIColor colorWithRed:164/255.0f green:199/255.0f blue:57/255.0f alpha:1.0f];
		button.highlightColor = [UIColor colorWithRed:114/255.0f green:149/255.0f blue:17/255.0f alpha:1.0f];
		
        button.layer.backgroundColor = button.normalColor.CGColor;
        
//        if ([[UIDevice currentDevice] highQuality]) {
//            
//            CAKeyframeAnimation *colorAnim = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
//            colorAnim.values = [NSArray arrayWithObjects:
//                                (id)[UIColor colorWithRed:134/255.0f green:169/255.0f blue:27/255.0f alpha:1.0f].CGColor,
//                                (id)[UIColor colorWithRed:108/255.0f green:138/255.0f blue:2/255.0f alpha:1.0f].CGColor,
//                                (id)[UIColor colorWithRed:134/255.0f green:169/255.0f blue:27/255.0f alpha:1.0f].CGColor,
//                                nil];
//            colorAnim.repeatCount = 1000;
//            colorAnim.duration = 3;
//            [button.layer addAnimation:colorAnim forKey:@"selectionAnimation"];
//        }
        
        [button setTitle:@"Places" forState:UIControlStateNormal];
    }
    
    return button;
}

+ (BigButton*) tipsButton {
    
    BigButton *button;
    
    if (button = [BigButton buttonWithType:UIButtonTypeCustom]) {
		
//		Badge *ba = [[Badge alloc] init];
//		ba.tag = 101;
//		ba.frame = CGRectMake(-10, -10, 30, 30);
//		[button addSubview:ba];
//		[ba release];
//		
//		[button setCount:3];
        
        button.opaque = YES;
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        button.titleLabel.shadowColor = [UIColor blackColor];
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 10.0f;
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        button.layer.borderWidth = 4.0f;
		
		button.normalColor = [UIColor colorWithRed:0.298f green:0.558f blue:0.723f alpha:1.0f];
        button.highlightColor = [UIColor colorWithRed:0.108f green:0.358f blue:0.523f alpha:1.0f];
		
        button.layer.backgroundColor = button.normalColor.CGColor;
        
        [button setTitle:@"Tips" forState:UIControlStateNormal];
    }
                
    return button;
}

- (void) setCount:(NSInteger) c
{
    Badge *l = (Badge*) [self viewWithTag:101];
    l.count = [NSNumber numberWithInteger:c];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	self.layer.backgroundColor = self.highlightColor.CGColor;
	
	[self setNeedsDisplay];
	
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	self.layer.backgroundColor = self.highlightColor.CGColor;

	[self setNeedsDisplay];
	
	[super cancelTrackingWithEvent:event];
}

//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//	BOOL cont = [super continueTrackingWithTouch:touch withEvent:event];
//	
//	if (!cont) {
//	
//		self.layer.backgroundColor = self.normalColor.CGColor;
//		
//		[self setNeedsDisplay];
//	}
//	
//	return cont;
//}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	self.layer.backgroundColor = self.normalColor.CGColor;
	
	[self setNeedsDisplay];
	
	[super endTrackingWithTouch:touch withEvent:event];
}

- (void)dealloc
{
	[super dealloc];
}

- (void)update
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    [[UIColor colorWithCGColor:self.layer.backgroundColor] setFill];
    CGContextFillRect(context, rect);
    
    size_t num_locations_1 = 2;
    CGFloat locations_1[2] = { 0.0, 1.0 };
    CGFloat colors_1[8] = {255/255.0, 255/255.0, 255/255.0, 0.4, 200/255.0, 200/255.0, 200/255.0, .2 }; // Start/End colors
    
    CGGradientRef gradient_1 = CGGradientCreateWithColorComponents(colorspace, colors_1, locations_1, num_locations_1);
    CGContextDrawLinearGradient(context, gradient_1, rect.origin, CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)/2), 0);
    
    CGGradientRelease(gradient_1);
    
    CGContextSetBlendMode (context, kCGBlendModeHue);

    size_t num_locations_2 = 2;
    CGFloat locations_2[2] = { 0.0, 1.0 };
    CGFloat colors_2[8] = {200/255.0, 200/255.0, 200/255.0, 0.0, 255/255.0, 255/255.0, 255/255.0, .3 }; // Start/End colors
    
    CGGradientRef gradient_2 = CGGradientCreateWithColorComponents(colorspace, colors_2, locations_2, num_locations_2);
    CGContextDrawLinearGradient(context, gradient_2, CGPointMake(rect.origin.x, CGRectGetMaxY(rect)/2), CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)), 0);
    
    CGGradientRelease(gradient_2);
    
    CGColorSpaceRelease(colorspace);
}

@end
