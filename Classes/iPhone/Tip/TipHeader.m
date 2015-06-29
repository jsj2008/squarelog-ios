#import "TipHeader.h"
#import "ImageDownloaderOperations.h"
#import "NSString+RenderTree.h"
#import "NSDictionary+RenderTree.h"
#import "UIView+ShadowBug.h"
#import "CGHelper.h"
#import "FSUserLookup.h"

@implementation TipHeader

@synthesize tipData;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor groupTableViewBackgroundColor] setFill];
    CGContextFillRect(context, rect);
    
    [renderTree drawAtPoint:CGPointMake(70, 10) selected:NO];
    
    if (avatarImage) {
        
        CGContextDrawImage(context, CGRectMake(10, 10, [AvatarOperation sizeToFit].width, [AvatarOperation sizeToFit].height), avatarImage.CGImage);
        
    } else {
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, HEXCOLOR(0x00000066).CGColor);
        CGContextAddRoundRect(context, CGRectMake(11, 11, [AvatarOperation imageSize].width, [AvatarOperation imageSize].height), 4, RoundRectAllCorners);        
        [HEXCOLOR(0xE1E1E0ff) setFill];
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }    
	
//	CGContextSaveGState(context);
//	CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 10, HEXCOLOR(0x000000cc).CGColor);
//	
//		CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
//		CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect)-10);
//		
//		CGContextAddLineToPoint(context, CGRectGetMinX(rect)+27, CGRectGetMaxY(rect)-10);
//		CGContextAddLineToPoint(context, CGRectGetMinX(rect)+37, CGRectGetMaxY(rect)-20);
//		CGContextAddLineToPoint(context, CGRectGetMinX(rect)+47, CGRectGetMaxY(rect)-10);
//		
//		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect)-10);
//		CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
//		
//		[[UIColor groupTableViewBackgroundColor] setFill];
//		CGContextFillPath(context);
//	
//	CGContextRestoreGState(context);
	
}

- (CGSize) sizeThatFits:(CGSize)size
{
	int headerHeight = MAX([(NSNumber*)[renderTree objectForKey:@"height"] intValue], 72);
	return CGSizeMake(320, headerHeight);
}

- (void)setTipData:(NSMutableDictionary *) data 
{
	[tipData release]; tipData = data; [tipData retain];
	
	renderTree = [[NSMutableDictionary dictionary] retain];
	
    NSString *renderString = [NSString stringWithFormat:@"\\j@ \\h%@ \\jvia \\h%@", 
                              [[data objectForKey:@"venue"] objectForKey:@"name"],
                              [FSUserLookup formatUserName:[tipData objectForKey:@"user"]], nil];
    
    [NSString parseRenderTree:renderTree fromString:renderString
					 forWidth:320-90
					 maxLines:4
				lineBreakMode:UILineBreakModeTailTruncation];
	
    avatarImageUrl = [[tipData objectForKey:@"user"] objectForKey:@"photo"];
    
    if (avatarImageUrl) {
        
        [avatarDl removeObserver:self forKeyPath:@"image"];
        
        [avatarImage release]; avatarImage = nil;
        avatarImage = [[[ImageCache sharedImageCache] imageForKey:avatarImageUrl
                                          imageOperationClassName:@"AvatarOperation"
												   asyncOperation:(NSOperation**)&avatarAyncLoad 
														 delegate:self] retain];
        
        if (avatarImage == nil && !avatarAyncLoad) {
            
            [avatarDl cancelDownload];
            [avatarDl release];
            avatarDl = [ImageDownloader new];
            [avatarDl startDownloadUrl:avatarImageUrl imageOperationClassName:@"AvatarOperation"];
        }
        
        [avatarDl addObserver:self
				   forKeyPath:@"image"
					  options:(NSKeyValueObservingOptionNew)
					  context:avatarImageUrl];
    }
	
	CGSize venueSize = [self sizeThatFits:CGSizeZero];
	self.frame = CGRectMake(0, 0, self.frame.size.width, venueSize.height);
	
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context 
{
    
    if (object == avatarDl && [keyPath isEqual:@"image"] && [avatarImageUrl isEqual:(NSString*)context] ) {
        
        avatarImage = [(UIImage*) [change objectForKey:NSKeyValueChangeNewKey] retain];
        [self setNeedsDisplay]; 
    }
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [avatarAyncLoad release]; avatarAyncLoad = nil;
    
	[avatarImage release];
	avatarImage = [i retain];
	[self setNeedsDisplay];
}

- (void)dealloc {
    [tipData release];
    [super dealloc];
}


@end
