#import "VenueHeader.h"
#import "CheckinBubbleView.h"
#import "FSCheckinsLookup.h"
#import "NSString+RenderTree.h"
#import "NSDictionary+RenderTree.h"
#import "UIScreen+Scale.h"
#import "UIView+ShadowBug.h"
#import "CGHelper.h"

@implementation VenueHeader

@synthesize info;

- (id) initWithFrame:(CGRect)frame 
{
    
    if (self = [super initWithFrame:frame]) {
        self.opaque = YES;
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    int headerHeight = 0;
    if (logoImageUrl) {
        headerHeight = MAX([(NSNumber*)[renderTree objectForKey:@"height"] intValue]+10, 72);
    } else {
        headerHeight = [(NSNumber*)[renderTree objectForKey:@"height"] intValue]+10;
    }
    return CGSizeMake(320, headerHeight);
}

- (void) setInfo:(NSMutableDictionary *)i
{
    
    [info release];
    info = i;
    [info retain];
    
    // render
    
    // \\n \\d%@",    
    
    [renderTree release];
    renderTree = [NSMutableDictionary new];

    NSString *renderString = [NSString stringWithFormat:@"\\h%@", 
                              [[info objectForKey:@"venue"] objectForKey:@"name"], nil];
    
    [NSString parseRenderTree:renderTree fromString:renderString
					 forWidth:320-90
					 maxLines:2
				lineBreakMode:UILineBreakModeTailTruncation];
    
    if (![info objectForKey:@"formatted_location"]) {
        
        [info setObject:[FSCheckinsLookup formatLocationWithVenue:[info objectForKey:@"venue"]] forKey:@"formatted_location"];
    }    
    
    renderString = [NSString stringWithFormat:@"\\d%@", 
                              [info objectForKey:@"formatted_location"],
                              nil];
    
    [NSString parseRenderTree:renderTree fromString:renderString
					 forWidth:320-90
					 maxLines:2
				lineBreakMode:UILineBreakModeTailTruncation];
    
    logoImageUrl = [[[info objectForKey:@"venue"] objectForKey:@"primarycategory"] objectForKey:@"iconurl"];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self sizeThatFits:CGSizeZero].height);
    
    // image
    if ([[UIScreen mainScreen] backwardsCompatibleScale] > 1) {
        logoImageUrl = [[logoImageUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_256.png"] retain];
    } else {
        logoImageUrl = [[logoImageUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_64.png"] retain];
    }
    
    if (logoImageUrl) {
        
        [logoDl removeObserver:self forKeyPath:@"image"];
        
        [logoImage release]; logoImage = nil;
        logoImage = [[[ImageCache sharedImageCache] imageForKey:logoImageUrl 
                                  imageOperationClassName:@"IdentityOperation"
                                                 asyncOperation:(NSOperation**)&logoAyncLoad 
                                                       delegate:self] retain];
        
        LOG_EXPR([self retainCount]);
        
        if (logoImage == nil && !logoAyncLoad) {
            
            [logoDl cancelDownload];
            [logoDl release];
            logoDl = [ImageDownloader new];
            [logoDl startDownloadUrl:logoImageUrl imageOperationClassName:@"IdentityOperation"];
        }
        
        [logoDl addObserver:self
				 forKeyPath:@"image"
					options:(NSKeyValueObservingOptionNew)
					context:logoImageUrl];
    }
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor groupTableViewBackgroundColor] setFill];
    CGContextFillRect(context, rect);
    
    if (logoImageUrl) {
        [renderTree drawAtPoint:CGPointMake(70, 10) selected:NO];
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, HEXCOLOR(0x00000066).CGColor);
        
        CGContextTranslateCTM(context, 0, 52);
        CGContextScaleCTM(context, 1.0, -1.0);        

        if (logoImage) {
            
            CGContextDrawImage(context, CGRectMake(10, -10, 52, 52), logoImage.CGImage);
            
        } else {
            
            CGContextAddRoundRect(context, CGRectMake(10, -10, 52, 52), 8, RoundRectAllCorners);        
            [HEXCOLOR(0xE1E1E0ff) setFill];
            CGContextFillPath(context);
        }
        
        CGContextRestoreGState(context);
        
    } else {
        [renderTree drawAtPoint:CGPointMake(10, 10) selected:NO];
    }
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context 
{
    
    if (object == logoDl && [keyPath isEqual:@"image"] && [logoImageUrl isEqual:(NSString*)context] ) {
        
        logoImage = [(UIImage*) [change objectForKey:NSKeyValueChangeNewKey] retain];
        
        [self setNeedsDisplay]; 
    }
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [logoAyncLoad release]; logoAyncLoad = nil;
    
	[logoImage release];
	logoImage = [i retain];
	[self setNeedsDisplay];
    
    //LOG_EXPR([self retainCount]);
}

- (void) dealloc 
{
    [renderTree release]; renderTree = nil;
    [logoDl removeObserver:self forKeyPath:@"image"];
    
    [info release];

    //[logoImageUrl release]; logoImageUrl = nil;
    [logoImage release]; logoImage = nil;
    [logoDl release]; logoDl = nil;
    [logoAyncLoad release]; logoAyncLoad = nil;
    
    [super dealloc];
}
@end