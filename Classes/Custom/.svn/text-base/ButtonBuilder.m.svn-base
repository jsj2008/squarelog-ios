#import "ButtonBuilder.h"

@implementation ButtonBuilder

+ (UIButton*) button1 {
    
    UIImage *button1NormalImage = [[UIImage imageNamed:@"button1-normal.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9];
    UIImage *button1HighlightedImage = [[UIImage imageNamed:@"button1-highlighted.png"] stretchableImageWithLeftCapWidth:9 topCapHeight:9];
 
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.reversesTitleShadowWhenHighlighted = YES;
    [b setBackgroundImage:button1NormalImage forState:UIControlStateNormal];
    [b setBackgroundImage:button1HighlightedImage forState:UIControlStateHighlighted];
    b.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    b.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [b setTitleColor:HEXCOLOR(0x4F585EFF) forState:UIControlStateNormal];
    [b setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    b.opaque = YES;
    
    return b;
}

@end
