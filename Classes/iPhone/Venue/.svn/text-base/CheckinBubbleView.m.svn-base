#import "CheckinBubbleView.h"
#import "UIView+ShadowBug.h"
#import "NSString+RenderTree.h"
#import "NSDictionary+RenderTree.h"
#import "CGHelper.h"
#import "FSCheckinsLookup.h"
#import "URLLabel.h"
#import "UIView+ExploreViews.h"

static inline float radians(double degrees) { return degrees * M_PI / 180; }

@implementation CheckinBubbleView

@synthesize info, delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //self.userInteractionEnabled = YES;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	int headerHeight = [(NSNumber*)[renderTreeHeader objectForKey:@"height"] intValue];
	
	return CGSizeMake(self.bounds.size.width, headerHeight + 10 + shoutHeight + (shoutHeight?17:10));
}

- (void) setInfo:(NSMutableDictionary *) i 
{
	
	[info release];
    info = i;
    [info retain];
	
	[renderTreeHeader release]; renderTreeHeader = nil;
	renderTreeHeader = [NSMutableDictionary new];
	
    NSNumber *timeValueNumber = (NSNumber*)[info objectForKey:@"created_time_ago_val"]; // 2.45
    TimeUnitType timeUnit = [(NSNumber*)[info objectForKey:@"created_time_ago_unit"] intValue]; //"minutes"
	
    NSString *renderString;
    if (![FSCheckinsLookup isShout:info]) {
        
        if ([[info objectForKey:@"created_time_ago_string"] isEqual:@"now"]) {
        
            renderString = [NSString stringWithFormat:@"\\q%@ just checked in here", 
                            [info objectForKey:@"formatted_username"],
                            nil];
        } else {
            
            renderString = [NSString stringWithFormat:@"\\q%@ checked in here %@ %@ ago", 
                                  [info objectForKey:@"formatted_username"], 
                                  [info objectForKey:@"created_time_ago_string"],
                                  [NSDate timeUnit:timeUnit withValue:[timeValueNumber floatValue]],
                                  nil];
        }
        
    } else {
        
        if ([[info objectForKey:@"created_time_ago_string"] isEqual:@"now"]) {
            
            renderString = [NSString stringWithFormat:@"\\q%@ just shouted", 
                            [info objectForKey:@"formatted_username"], 
                            nil];            
        } else {

            renderString = [NSString stringWithFormat:@"\\q%@ shouted %@ %@ ago", 
                            [info objectForKey:@"formatted_username"], 
                            [info objectForKey:@"created_time_ago_string"],
                            [NSDate timeUnit:timeUnit withValue:[timeValueNumber floatValue]],
                            nil];
            
        }
    }
    
    if (renderString) {
    
        [NSString parseRenderTree:renderTreeHeader fromString:renderString
                         forWidth:self.bounds.size.width-20
                         maxLines:30
                    lineBreakMode:UILineBreakModeTailTruncation];
        
    }
    
    if ([self.info objectForKey:@"shout"]) {
        
        int headerHeight = [(NSNumber*)[renderTreeHeader objectForKey:@"height"] intValue];
        
        [[self viewWithTag:1000] removeFromSuperview];
        UIView *v = [[UIView alloc] initWithFrame:CGRectNull];
        v.tag = 1000;
        v.userInteractionEnabled = YES;
        [self addSubview:v];

        shoutHeight = [NSString parseUIViewTree:v 
                                     fromString:[self.info objectForKey:@"shout"]
                                      forFont:[UIFont systemFontOfSize:15]         
                                     forWidth:self.bounds.size.width-24
                                     maxLines:10
                                lineBreakMode:UILineBreakModeTailTruncation
                     parseImageViewsFromLinks:YES
                              backgroundColor:HEXCOLOR(0xF6F6F6ff)
                                     delegate:self.delegate];
        
        [self viewWithTag:1000].frame = CGRectMake(14, headerHeight+10, self.bounds.size.width-24, shoutHeight);
        
        [v release];
    }
    	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self sizeThatFits:CGSizeZero].height);
    
    //_NSLog(NSStringFromCGRect(self.frame));
    
    //[self exploreViewAtLevel:0];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[[UIColor groupTableViewBackgroundColor] setFill];
	CGContextSetPatternPhase(context, CGSizeMake(-1, 0));
	CGContextFillRect(context, CGRectInset(rect, -10, 0));
    
//    NSArray *colors = [NSArray arrayWithObjects:
//                                            HEXCOLOR(0x3B6901ff),
//                                            HEXCOLOR(0xC0F084ff),
//                                            HEXCOLOR(0xC0F084ff),
//                                            HEXCOLOR(0xE4FACAff),
//                                            HEXCOLOR(0x66666666),
//                                            HEXCOLOR(0xffffff00),
//                                            HEXCOLOR(0xffffff00),
//                                            HEXCOLOR(0x66666666),
//                                            HEXCOLOR(0xffffffff),
//                                            HEXCOLOR(0xE4FACA55),
//                                            HEXCOLOR(0x445C27FF)
//                                            nil];
    
    NSArray *colors = [NSArray arrayWithObjects:
                                           HEXCOLOR(0x8B8B8Bff),
                                           HEXCOLOR(0xF6F6F6ff),
                                           HEXCOLOR(0xF6F6F6ff),
                                           HEXCOLOR(0xffffffff),
                                           HEXCOLOR(0x66666666),
                                           HEXCOLOR(0xffffff00),
                                           HEXCOLOR(0xffffff00),
                                           HEXCOLOR(0x66666666),
                                           HEXCOLOR(0xffffffff),
                                           HEXCOLOR(0xF6F6F6ff),
                                           HEXCOLOR(0x5C5C5CFF),
                                           nil];    
	
    CGContextAddConversationBubble(context, CGRectInset(rect, 2, 4), 10, RoundRectAllCorners, colors);
	
	//write the text
	{
		[renderTreeHeader drawAtPoint:CGPointMake(14, 8) selected:NO];
	}
	
}

- (void)dealloc {
    [super dealloc];
    [info release];
	[renderTreeHeader release];
}


@end
