#import "ShareToggleButton.h"

@implementation ShareToggleButton

+ (UIButton*) twitter
{
    ShareToggleButton *b = [ShareToggleButton buttonWithType:UIButtonTypeCustom];
    [b setBackgroundImage:[UIImage imageNamed:@"twitter-normal.png"] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageNamed:@"twitter-highlighted.png"] forState:UIControlStateSelected];
    b->type = @"tw";
    return b;
}

+ (UIButton*) facebook
{
    ShareToggleButton *b = [ShareToggleButton buttonWithType:UIButtonTypeCustom];
    [b setBackgroundImage:[UIImage imageNamed:@"facebook-normal.png"] forState:UIControlStateNormal];
    [b setBackgroundImage:[UIImage imageNamed:@"facebook-highlighted.png"] forState:UIControlStateSelected];
    b->type = @"fb";
    return b;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([type isEqual:@"tw"]) {
        
        return CGRectContainsPoint(CGRectInset(CGRectOffset(self.bounds, 17, 0), -20, -8), point);
        
    } else {
        
        return CGRectContainsPoint(CGRectInset(CGRectOffset(self.bounds, -17, 0), -20, -8), point);
    }
}

- (void)dealloc {
    
    [super dealloc];
}


@end
