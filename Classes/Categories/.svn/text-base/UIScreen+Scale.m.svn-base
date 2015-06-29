#import "UIScreen+Scale.h"

@implementation UIScreen(Scale)

- (CGFloat) backwardsCompatibleScale
{
	CGFloat scale = 1;
	
	if ([self respondsToSelector:@selector(scale)])
		scale = self.scale;
    
    return scale;
}

@end
