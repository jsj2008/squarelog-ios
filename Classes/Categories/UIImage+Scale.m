#import "UIImage+Scale.h"

@implementation UIImage(Scale)

- (CGFloat) backwardsCompatibleScale
{
	CGFloat scale = 1;
	
	if ([self respondsToSelector:@selector(scale)])
		scale = self.scale;
    
    return scale;
}

@end
