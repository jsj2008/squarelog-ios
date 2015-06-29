#import "UserHeader.h"
#import "ImageCache.h"
#import "UIView+ShadowBug.h"
#import "NSString+RenderTree.h"
#import "NSDictionary+RenderTree.h"
#import "CGHelper.h"
#import "FSUserLookup.h"
#import "ImageDownloaderOperations.h"

@implementation UserHeader

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	int headerHeight = MAX([(NSNumber*)[renderTree objectForKey:@"height"] intValue], 72);
    return CGSizeMake(320, headerHeight);
}

- (void) setInfo:(NSMutableDictionary *)i
{
    //LOG_EXPR([i retainCount]);
    
    [info release];
    info = i;
    [info retain];
	
	renderTree = [[NSMutableDictionary dictionary] retain];
    
    if (![info objectForKey:@"formatted_username"]) {
        
        [info setObject:[FSUserLookup formatUserName:[info objectForKey:@"user"]] forKey:@"formatted_username"];
    }
	
    NSString *renderString = [NSString stringWithFormat:@"\\h%@", 
                              [info objectForKey:@"formatted_username"], nil];
    
    [NSString parseRenderTree:renderTree fromString:renderString
					 forWidth:320-90
					 maxLines:2
				lineBreakMode:UILineBreakModeTailTruncation];
    
    if ([[info objectForKey:@"user"] objectForKey:@"homecity"] &&
        [[[info objectForKey:@"user"] objectForKey:@"homecity"] length] > 0) {
        
        renderString = [NSString stringWithFormat:@"\\d%@", 
                        [[info objectForKey:@"user"] objectForKey:@"homecity"],
                        nil];
        
        [NSString parseRenderTree:renderTree fromString:renderString
                         forWidth:320-90
                         maxLines:2
                    lineBreakMode:UILineBreakModeTailTruncation];
        
    }
    
    {
        
        NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *value = [formatter stringForObjectValue:[[info objectForKey:@"user"] objectForKey:@"id"]];

        renderString = [NSString stringWithFormat:@"\\d#%@", 
                        value,
                        nil];
        
        [NSString parseRenderTree:renderTree fromString:renderString
                         forWidth:320-90
                         maxLines:1
                    lineBreakMode:UILineBreakModeTailTruncation];
        
    }    
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self sizeThatFits:CGSizeZero].height);
	
    avatarImageUrl = [[info objectForKey:@"user"] objectForKey:@"photo"];
    
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
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor groupTableViewBackgroundColor] setFill];
    CGContextFillRect(context, rect);
    
    [renderTree drawAtPoint:CGPointMake(70, 10) selected:NO];
    
    {
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
    }
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
    [avatarDl removeObserver:self forKeyPath:@"image"];
    [avatarDl release]; avatarDl = nil;
    
	[avatarImage release];
	avatarImage = [i retain];
    
    [avatarAyncLoad release]; avatarAyncLoad = nil;
	[self setNeedsDisplay];
}

- (void)dealloc {
    //LOG_EXPR([info retainCount]);
    [info release];
    [super dealloc];
}

@end
