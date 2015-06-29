#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "BadgeButton.h"
#import "Badge.h"

@implementation BadgeButton

void setCount ( id self, SEL _cmd, int c)
{
    [(Badge*) [self viewWithTag:101] removeFromSuperview];
    
    Badge *ba = [[Badge alloc] init];
    ba.tag = 101;
    ba.frame = CGRectMake(-8, -10, 30, 30);
    [self addSubview:ba];
    ba.count = [NSNumber numberWithInteger:c];
    [ba release];
}

+ (BadgeButton*) button {
    
    class_addMethod ([NSClassFromString(@"UIRoundedRectButton") class], @selector(setCount:), (IMP)setCount, "v@:i");
 
    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    Badge *ba = [[Badge alloc] init];
//    ba.tag = 101;
//    ba.frame = CGRectMake(-10, -10, 30, 30);
//    [b addSubview:ba];
//    [ba release];
    
//    [b setCount:7];
    
    return [b retain];
}

@end
