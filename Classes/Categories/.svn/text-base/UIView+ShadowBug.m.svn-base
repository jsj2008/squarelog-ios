#import "UIView+ShadowBug.h"

//http://stackoverflow.com/questions/2997501/cgcontextsetshadow-shadow-direction-reversed-between-ios-3-0-and-4-0

@implementation UIView (shadowBug)

+ (NSInteger) shadowVerticalMultiplier
{
    static NSInteger shadowVerticalMultiplier = 0;
    if (0 == shadowVerticalMultiplier) {
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        shadowVerticalMultiplier = (systemVersion < 3.2f) ? -1 : 1;
    }
    
    return shadowVerticalMultiplier;
}

@end
