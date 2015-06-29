#import "SingleTipView.h"
#import "NSDictionary+RenderTree.h"
#import "NSString+RenderTree.h"

@implementation SingleTipView

@synthesize tipData, delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //self.userInteractionEnabled = YES;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	//int headerHeight = [(NSNumber*)[renderTree objectForKey:@"height"] intValue];
	
	return CGSizeMake(self.bounds.size.width, tipHeight+1);
}

- (void) setTipData:(NSMutableDictionary *)i
{
    [tipData release];
    tipData = i;
    [tipData retain];
	
    int height = 0;
    [renderTree release];
    renderTree = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@"items"];
    [renderTree retain];
    
    if ([tipData objectForKey:@"text"]) {
        
        //renderTreeShout = [[NSMutableDictionary dictionary] retain];
        
        int headerHeight = 0; //[(NSNumber*)[renderTree objectForKey:@"height"] intValue];
        
        [[self viewWithTag:1000] removeFromSuperview];
        UIView *v = [[UIView alloc] initWithFrame:CGRectNull];
        v.tag = 1000;
        v.userInteractionEnabled = YES;
        [self addSubview:v];
        
        tipHeight = [NSString parseUIViewTree:v 
                                     fromString:[tipData objectForKey:@"text"]
                                        forFont:[UIFont systemFontOfSize:15]         
                                       forWidth:self.bounds.size.width-24
                                       maxLines:10
                                  lineBreakMode:UILineBreakModeTailTruncation
                       parseImageViewsFromLinks:YES
                                backgroundColor:[UIColor whiteColor]
                                       delegate:delegate];
        
        [self viewWithTag:1000].frame = CGRectMake(14, headerHeight, self.bounds.size.width, tipHeight);//CGRectMake(14, headerHeight, self.bounds.size.width, tipHeight);
        
        [v release];
    }    
    
    //height += 4;
    
    [renderTree setObject:[NSNumber numberWithInt:height] forKey:@"height"];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self sizeThatFits:CGSizeZero].height);
}

- (void) drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
	CGContextFillRect(context, rect);
    
    [renderTree drawAtPoint:CGPointMake(0, 0) selected:NO];
}


- (void)dealloc {
    [tipData release];
    [renderTree release];
    [super dealloc];
}

@end
