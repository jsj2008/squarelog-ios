#import "SlidingLabel.h"

#define VIEWTAG_1 1001
#define VIEWTAG_2 1002

@implementation SlidingLabel

@synthesize text, font, textColor, shadowColor, shadowOffset, backgroundColor, textAlignment;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectOffset(self.bounds, 0, -self.bounds.size.height)];
        l1.tag = VIEWTAG_1;
        l1.opaque = YES;
        [self addSubview:l1];
        [l1 release];
        
        UILabel *l2 = [[UILabel alloc] initWithFrame:self.bounds];
        l2.tag = VIEWTAG_2;
        l2.opaque = YES;
        [self addSubview:l2];
        [l2 release];
        
        nextActiveTag = VIEWTAG_1;
        currentActiveTag = VIEWTAG_2;
        
        self.clipsToBounds = YES;
        
        inAnim = NO;
        
    }
    return self;
}

- (void) setBackgroundColor:(UIColor *) c 
{ 
    super.backgroundColor = c;
    UILabel *l1 = (UILabel*)[self viewWithTag:VIEWTAG_1];
    l1.backgroundColor = c;
    UILabel *l2 = (UILabel*)[self viewWithTag:VIEWTAG_2];
    l2.backgroundColor = c;
}

- (void) setTextAlignment:(UITextAlignment) a
{
    UILabel *l1 = (UILabel*)[self viewWithTag:VIEWTAG_1];
    l1.textAlignment = a;
    UILabel *l2 = (UILabel*)[self viewWithTag:VIEWTAG_2];
    l2.textAlignment = a;
}

- (void) setShadowOffset:(CGSize) s
{
    UILabel *l1 = (UILabel*)[self viewWithTag:VIEWTAG_1];
    l1.shadowOffset = s;
    UILabel *l2 = (UILabel*)[self viewWithTag:VIEWTAG_2];
    l2.shadowOffset = s;
}

- (void) setTextColor:(UIColor *) c
{
    UILabel *l1 = (UILabel*)[self viewWithTag:VIEWTAG_1];
    l1.textColor = c;
    UILabel *l2 = (UILabel*)[self viewWithTag:VIEWTAG_2];
    l2.textColor = c;
}

- (void) setShadowColor:(UIColor *) c
{
    UILabel *l1 = (UILabel*)[self viewWithTag:VIEWTAG_1];
    l1.shadowColor = c;
    UILabel *l2 = (UILabel*)[self viewWithTag:VIEWTAG_2];
    l2.shadowColor = c;
}

- (void) setFont:(UIFont*) f
{
    UILabel *l1 = (UILabel*)[self viewWithTag:VIEWTAG_1];
    l1.font = f;
    UILabel *l2 = (UILabel*)[self viewWithTag:VIEWTAG_2];
    l2.font = f;
}

- (void) setText:(NSString *) y 
{
    
    UILabel *nextActiveView = (UILabel*)[self viewWithTag:nextActiveTag];
    
    if (inAnim) {
        nextActiveView.text = y;
        return;
    }
    
    inAnim = YES;
    
    UILabel *currentActiveView = (UILabel*)[self viewWithTag:currentActiveTag];
    
    if ([currentActiveView.text isEqual:y]) return;
    
    //_NSLog(@"%@, %@ currentActiveTag=%d", y, currentActiveView.text, currentActiveTag);    
    
    nextActiveView.text = y;
    nextActiveView.frame = CGRectOffset(self.bounds, 0, -self.bounds.size.height);
    nextActiveView.alpha = 0;
    
    [UIView beginAnimations:@"slide" context:NULL];
    [UIView setAnimationDuration:.300];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    nextActiveView.alpha = 1;
    nextActiveView.frame = self.bounds;
    currentActiveView.frame = CGRectOffset(self.bounds, 0, self.bounds.size.height);
    currentActiveView.alpha = 0;
    
    [UIView commitAnimations];
    
    //[self exploreViewAtLevel:0];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    int ttag = nextActiveTag; 
    nextActiveTag = currentActiveTag;
    currentActiveTag = ttag;
    
    _NSLog(@"animationDidStop currentActiveTag=%d", currentActiveTag);
    
    inAnim = NO;
}

- (void)dealloc {
    [super dealloc];
}

@end
