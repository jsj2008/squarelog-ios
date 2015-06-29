#import "URLLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation URLLabel

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.textColor = HEXCOLOR(0x0000CDff);
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.backgroundColor = [UIColor grayColor];
    self.layer.cornerRadius = 4;
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.backgroundColor = [UIColor clearColor];
    [self.delegate performSelector:@selector(viewItemTapped:) withObject:self];
    self.layer.cornerRadius = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    self.font = [UIFont boldSystemFontOfSize:self.font.pointSize];
    [self.textColor setStroke];
    CGContextSetLineWidth(ctx, 2.0f);
    
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - .5);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - .5);
    
    CGContextStrokePath(ctx);
    
    [super drawRect:rect];  
}

- (void)dealloc {
    [super dealloc];
}


@end
