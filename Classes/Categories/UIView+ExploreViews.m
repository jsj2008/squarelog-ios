#import "UIView+ExploreViews.h"

void doLog(int level, id formatstring,...)
{
    int i;
    for (i = 0; i < level; i++) printf("    ");
    
    va_list arglist;
    if (formatstring)
    {
        va_start(arglist, formatstring);
        id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
    }
}

@implementation UIView (ExploreViews)

- (void)exploreViewAtLevel:(int)level;
{
    doLog(level, @"%@ %d", [[self class] description], self.tag);
    doLog(level, @"%@", NSStringFromCGRect([self frame]));
    doLog(level, @" opaque=%d", self.opaque);
    for (UIView *subview in [self subviews])
        [subview exploreViewAtLevel:(level + 1)];
}

@end