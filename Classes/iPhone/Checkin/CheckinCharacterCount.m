#import "CheckinCharacterCount.h"
#import "CGHelper.h"
#import "UIView+ShadowBug.h"

@implementation CheckinCharacterCount

static UIColor *okColor;
static UIColor *okTextColor;
static UIColor *okTextShadowColor;

static UIColor *lowColor;
static UIColor *lowTextColor;
static UIColor *lowTextShadowColor;

static UIColor *doneColor;

static UIFont *font;

@synthesize number;

+ (void) initialize {
    
    if (self == [CheckinCharacterCount class]) {
        okColor = [HEXCOLOR(0xefefefff) retain];
        okTextColor = [[UIColor blackColor] retain];
        okTextShadowColor = [[UIColor whiteColor] retain];
        
        doneColor = [HEXCOLOR(0xFAC6BBff) retain];
        
        lowColor = [HEXCOLOR(0xFCECDEff) retain];
        lowTextColor = [[UIColor blackColor] retain];
        lowTextShadowColor = [[UIColor whiteColor] retain];
        
        font = [UIFont boldSystemFontOfSize:12];
    }
}

- (id) initWithFrame:(CGRect)frame 
{
    
    if (self == [super initWithFrame:frame]) {
        numStr = nil;
    }
    
    return self;
}

- (void) setNumber:(int) num 
{
    number = num;
    [numStr release];
    numStr = [[NSString stringWithFormat:@"%d", number] retain];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    UIColor *textColor;
    UIColor *shadowColor;
    UIColor *backgroundColor;
    
    if (number < 10) {
        
        textColor = lowTextColor;
        shadowColor = lowTextShadowColor;
        
        if (number == 0) {
            backgroundColor = doneColor;
        } else {
            backgroundColor = lowColor;
        }
        
    } else {
        
        textColor = okTextColor;
        shadowColor = okTextShadowColor;
        backgroundColor = okColor;
    }
    
    [backgroundColor set];
    
    CGContextAddRoundRect(context, rect, 4, RoundRectAllCorners);
    CGContextFillPath(context);
    
    CGContextSaveGState(context);	
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 1, shadowColor.CGColor);
    
    CGSize s = [numStr sizeWithFont:font];
    [textColor set];
    
    [numStr drawAtPoint:CGPointMake((rect.size.width-s.width)/2.0, (rect.size.height-s.height)/2.0) withFont:font];
    
    CGContextRestoreGState(context);	
}


- (void)dealloc {
    [super dealloc];
}


@end
