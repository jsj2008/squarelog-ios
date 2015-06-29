#import "RefreshProgressView.h"

#import "FSCheckinsLookup.h"
#import "FSTipsLookup.h"
#import "FSVenuesLookup.h"
#import "FSHistoryLookup.h"

#import "CGHelper.h"

@implementation RefreshProgressView

@synthesize progress;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        [[FSCheckinsLookup sharedInstance] addObserver:self
                                       forKeyPath:@"progress"
                                          options:(NSKeyValueObservingOptionNew)
                                          context:NULL];
        
        [[FSTipsLookup sharedInstance] addObserver:self
                                            forKeyPath:@"progress"
                                               options:(NSKeyValueObservingOptionNew)
                                               context:NULL];
        
        [[FSVenuesLookup sharedInstance] addObserver:self
                                            forKeyPath:@"progress"
                                               options:(NSKeyValueObservingOptionNew)
                                               context:NULL];        
        
        [[FSHistoryLookup sharedInstance] addObserver:self
                                          forKeyPath:@"progress"
                                             options:(NSKeyValueObservingOptionNew)
                                             context:NULL];
        
        progress = 0;
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *c = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    [c set];
    [c setFill];
    
    CGContextFillRect(context, rect);
    
    [[UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0] set]; 
    
    CGContextAddRoundRect(context, CGRectOffset(CGRectInset(rect, 1, 1), 0.5, 0.5), 4, RoundRectAllCorners);
    
	CGContextSetLineWidth(context, 1);
	CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextStrokePath(context);
    
    CGContextAddRoundRect(context, CGRectOffset(CGRectInset(rect, 1, 1), 0.5, 0.5), 4, RoundRectAllCorners);
    
    CGContextClip(context);
    
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width*progress, rect.size.height));
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqual:@"progress"]) {
        
        progress = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        if (progress == -1) {
            self.hidden = YES;
        }
        else {
            self.hidden = NO;
            [self setNeedsDisplay];
        }
    }
}

- (void)dealloc {
    
	[[FSCheckinsLookup sharedInstance] removeObserver:self forKeyPath:@"progress"];
    [[FSTipsLookup sharedInstance] removeObserver:self forKeyPath:@"progress"];
    [[FSVenuesLookup sharedInstance] removeObserver:self forKeyPath:@"progress"];
    [[FSHistoryLookup sharedInstance] removeObserver:self forKeyPath:@"progress"];
    
    [super dealloc];
}

@end
