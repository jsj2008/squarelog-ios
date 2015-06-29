#import "WikipediaTableViewCell320.h"
#import "NSDictionary+RenderTree.h"
#import "NSString+RenderTree.h"
#import "RenderTreeTextItem.h"
#import "CGHelper.h"
#import "TableCellSelectedBackground.h"

#import "UIImage+Resize.h"
#import "UIScreen+Scale.h"
#import "UIView+ShadowBug.h"

@implementation WikipediaTableViewCell320

@synthesize data;

static UIFont *summaryFont;
static UIColor *shadowColor;

+ (void) initialize {
    
    if (self == [WikipediaTableViewCell320 class]) {
        
        shadowColor = [HEXCOLOR(0x00000066) retain];
        summaryFont = [UIFont systemFontOfSize:14];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.selectedBackgroundView = [[TableCellSelectedBackground alloc] initWithFrame:CGRectNull delegate:self];
		paddingPixel = 0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    _selected = selected;
    
    if (selected) {
        
        backgroundColor = [UIColor clearColor];
        
    } else if (!selected && animated) {
        
        backgroundColor = [UIColor clearColor];
        
        [self setNeedsDisplay];
        
    } else if (!selected && !animated) {
        
        backgroundColor = [UIColor whiteColor];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)setAvatarImageUrl:(NSString *)s
{
    
	[avatarImageUrl release];
	avatarImageUrl = [s copy];
    
    [avatarDl removeObserver:self forKeyPath:@"image"];
    
    [avatarDl cancelDownload];
    [avatarDl release]; avatarDl = nil;
    
	[avatarAyncLoad cancel]; [avatarAyncLoad release]; avatarAyncLoad = nil;
    
    [avatarImage release]; avatarImage = nil;
    
    if (avatarImageUrl != nil) {
        
        avatarImage = [[[ImageCache sharedImageCache] imageForKey:avatarImageUrl
                                          imageOperationClassName:@"WikipediaThumbOperation"
                                                   asyncOperation:(NSOperation**)&avatarAyncLoad 
                                                         delegate:self] retain];
		
		if (avatarImage == nil && !avatarAyncLoad) {		
            
            [avatarDl cancelDownload];
            [avatarDl release];
            avatarDl = [ImageDownloader new];
            [avatarDl startDownloadUrl:avatarImageUrl imageOperationClassName:@"WikipediaThumbOperation"];
        }
        
        [avatarDl addObserver:self
                   forKeyPath:@"image"
                      options:(NSKeyValueObservingOptionNew)
                      context:avatarImageUrl];
    }
    
	[self setNeedsDisplay]; 
    
}

#pragma mark -

- (void)drawContentView:(CGRect)r {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [backgroundColor set];
	CGContextFillRect(context, r);
	
	if (backgroundColor == whiteColor) {
		
		[HEXCOLOR(0xffffffff) setStroke];
		CGContextSetLineWidth(context, 1);
		CGContextMoveToPoint(context, 0, .5);
		CGContextAddLineToPoint(context, r.size.width, .5);
		CGContextStrokePath(context);
		
		[HEXCOLOR(0xcdcdcdff) setStroke];
		CGContextMoveToPoint(context, 0, CGRectGetMaxY(r)-.5);
		CGContextAddLineToPoint(context, r.size.width, CGRectGetMaxY(r)-.5);
		CGContextStrokePath(context);
		
	} else {
        
		[backgroundColor set];
		CGContextFillRect(context, r);
		
		[HEXCOLOR(0xcdcdcdff) setStroke];
		CGContextMoveToPoint(context, 0, CGRectGetMaxY(r)-.5);
		CGContextAddLineToPoint(context, r.size.width, CGRectGetMaxY(r)-.5);
		CGContextStrokePath(context);
	}
    
    [((NSDictionary*)[data objectForKey:@"render_tree"]) drawAtPoint:CGPointMake(66, 5) selected:_selected];
    
    
    if (avatarImageUrl == nil) {
        
        int scale = [[UIScreen mainScreen] backwardsCompatibleScale];
        
        UIGraphicsBeginImageContext(CGSizeMake([AvatarOperation imageSize].width*scale, [AvatarOperation imageSize].height*scale));
        context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        CGRect rect = CGRectMake(0, 0, [AvatarOperation imageSize].width*scale, [AvatarOperation imageSize].height*scale);
        CGContextAddRoundRect(context, rect, 4*scale, RoundRectAllCorners);
        CGContextClip(context);
//        CGContextTranslateCTM(context, 0, [AvatarOperation imageSize].height);
//        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage (context, CGRectMake(0, 0, [AvatarOperation imageSize].width*scale, [AvatarOperation imageSize].height*scale), [UIImage imageNamed:@"wikipedia.png"].CGImage);
        CGContextRestoreGState(context);
        
        UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();        
        
        context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, shadowColor.CGColor);
        CGContextDrawImage (context, CGRectMake(9, 8, [AvatarOperation imageSize].width, [AvatarOperation imageSize].height), i.CGImage);
        CGContextRestoreGState(context);        
        
    } else if (avatarImage == nil) {
                    
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, shadowColor.CGColor);
        
        CGContextAddRoundRect(context, CGRectMake(9, 8, [WikipediaThumbOperation imageSize].width, [WikipediaThumbOperation imageSize].height), 4, RoundRectAllCorners);        
        [HEXCOLOR(0xE1E1E0ff) setFill];
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
        
    } else {
        
        CGContextDrawImage(context, CGRectMake(7, 6, [WikipediaThumbOperation sizeToFit].width, [WikipediaThumbOperation sizeToFit].height), avatarImage.CGImage);

    }    
}

- (void)setData:(NSMutableDictionary *)_data
{
    [data release];
    data = [_data retain];

    [self setAvatarImageUrl:[data objectForKey:@"thumbnailImg"]];
}

#pragma mark -
#pragma mark pre-render

+ (int) createRenderTreeWithWidth:(CGFloat)width wikiData:(NSMutableDictionary*)wikiData
{
    
    static int margin_right = 14;
    static int margin_left = 61;
    
    int height = 0;
    
    NSMutableDictionary *renderTree = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@"items"];
    NSMutableArray *renderItems = [renderTree objectForKey:@"items"]; 
    
    [wikiData setObject:renderTree forKey:@"render_tree"];
    
    if ([wikiData objectForKey:@"title"]) {
        
        [NSString parseRenderTree:renderTree fromString:[NSString stringWithFormat:@"\\b%@", [wikiData objectForKey:@"title"], nil]
                         forWidth:(width-margin_left-margin_right)
                         maxLines:2
                    lineBreakMode:UILineBreakModeTailTruncation];
        
        height += [(NSNumber*)[renderTree objectForKey:@"height"] intValue];
        
    } 
    
    if ([wikiData objectForKey:@"summary"]) {
        
        CGSize size = [[wikiData objectForKey:@"summary"] sizeWithFont:summaryFont 
                                                 constrainedToSize:CGSizeMake(240, 120) 
                                                     lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [wikiData objectForKey:@"summary"];
        item.rect = CGRectMake(0, height, size.width, size.height);
        item.font = summaryFont;
        item.color = [UIColor grayColor];
        [renderItems addObject:item];
        [item release];
        
        height = height + size.height;    
        height += 2;
    }
    
    return height += 10;
}

+ (int) calculateHeightWithWidth:(CGFloat)width wikiData:(NSMutableDictionary*)wikiData
{
    
    if (![wikiData objectForKey:@"height"]) {
        
        [wikiData setObject:[NSNumber numberWithInt:[WikipediaTableViewCell320 createRenderTreeWithWidth:width tipData:wikiData]] forKey:@"height"];
    }
    
    return MAX([(NSNumber*)[wikiData objectForKey:@"height"] intValue], 68);
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [avatarAyncLoad release]; avatarAyncLoad = nil;
    
	[avatarImage release];
	avatarImage = [i retain];
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Table anim delegate

- (void) finishedBackgroundViewFadeoutAnimationWithView:(UIView*)theBackgroundView {
    
    backgroundColor = [UIColor whiteColor];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == avatarDl && [keyPath isEqual:@"image"] && [avatarImageUrl isEqual:(NSString*)context] ) {
        
        avatarImage = [(UIImage*) [change objectForKey:NSKeyValueChangeNewKey] retain];
        [self setNeedsDisplay]; 
    }
}

- (void)dealloc {
    
    [data release];
    
    [avatarImageUrl release];
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl cancelDownload]; [avatarDl release]; avatarDl = nil;
    [avatarAyncLoad cancel];
    
    [super dealloc];
}


@end
