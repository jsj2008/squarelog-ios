#import "TipTableViewCell320.h"
#import "NSDictionary+RenderTree.h"
#import "NSString+RenderTree.h"
#import "RenderTreeTextItem.h"
#import "TableCellSelectedBackground.h"
#import "UIScreen+Scale.h"
#import "NSDate+TimeAgo.h"
#import "CGHelper.h"
#import "UIView+ShadowBug.h"
#import "FSUserLookup.h"
#import "FSVenueLookup.h"
#import "ImageDownloaderOperations.h"

@implementation TipTableViewCell320

@synthesize tipData;

static UIFont *placeNameFont;
static UIFont *tipFont;
static UIFont *userFont;
static UIFont *timeFont;
static UIFont *timeUnitFont;

static UIColor *shadowColor;

+ (void) initialize {
    
    if (self == [TipTableViewCell320 class]) {
        
        shadowColor = [HEXCOLOR(0x00000066) retain];
        placeNameFont = [UIFont boldSystemFontOfSize:14];
        tipFont = [UIFont systemFontOfSize:14];
        userFont = [UIFont systemFontOfSize:12];
        
        timeFont = [UIFont boldSystemFontOfSize:12];
        timeUnitFont = [UIFont systemFontOfSize:12];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.selectedBackgroundView = [[TableCellSelectedBackground alloc] initWithFrame:CGRectNull delegate:self];
		paddingPixel = 0;
    }
    return self;
}

- (void)setTipData:(NSDictionary *)data
{
    [tipData release];
    tipData = [data retain];
    
    if ([[tipData objectForKey:@"user"] objectForKey:@"photo"]) {
        
        imageType = TipImageTypeUserAvatar;
        [self setAvatarImageUrl:[(NSDictionary*)[tipData objectForKey:@"user"] objectForKey:@"photo"]];
        
    } else {
        imageType = TipImageTypeVenueIcon;
        
        NSString *logoImageUrl = [[(NSDictionary*)[tipData objectForKey:@"venue"] objectForKey:@"primarycategory"] objectForKey:@"iconurl"];
        
        // image
        if ([[UIScreen mainScreen] backwardsCompatibleScale] > 1) {
            logoImageUrl = [[logoImageUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_256.png"] retain];
        } else {
            logoImageUrl = [[logoImageUrl stringByReplacingOccurrencesOfString:@".png" withString:@"_64.png"] retain];
        }
        
        [self setAvatarImageUrl:logoImageUrl];
    }
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
                                          imageOperationClassName:((imageType == TipImageTypeUserAvatar)?@"AvatarOperation":@"IdentityOperation")
                                                   asyncOperation:(NSOperation**)&avatarAyncLoad 
                                                         delegate:self] retain];
		
		if (avatarImage == nil && !avatarAyncLoad) {		
            
            [avatarDl cancelDownload];
            [avatarDl release];
            avatarDl = [ImageDownloader new];
            [avatarDl startDownloadUrl:avatarImageUrl imageOperationClassName:((imageType == TipImageTypeUserAvatar)?@"AvatarOperation":@"IdentityOperation")];
        }
        
        [avatarDl addObserver:self
                   forKeyPath:@"image"
                      options:(NSKeyValueObservingOptionNew)
                      context:avatarImageUrl];
    }
    
	[self setNeedsDisplay]; 
    
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
    
    [((NSDictionary*)[tipData objectForKey:@"render_tree"]) drawAtPoint:CGPointMake(66, 5) selected:_selected];
    
    if (avatarImage == nil) {
        
        if (imageType == TipImageTypeUserAvatar) {

            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, shadowColor.CGColor);
            
            CGContextAddRoundRect(context, CGRectMake(8, 7, [AvatarOperation imageSize].width, [AvatarOperation imageSize].height), 4, RoundRectAllCorners);        
            [HEXCOLOR(0xE1E1E0ff) setFill];
            CGContextFillPath(context);
            
            CGContextRestoreGState(context);               
            
        } else {
            
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, shadowColor.CGColor);
            
            CGContextAddRoundRect(context, CGRectMake(9, 7, [AvatarOperation imageSize].width-2, [AvatarOperation imageSize].height-1), 8, RoundRectAllCorners);
            [HEXCOLOR(0xE1E1E0ff) setFill];
            CGContextFillPath(context);
            
            CGContextRestoreGState(context);   
        }
        
    } else {
        
        if (imageType == TipImageTypeUserAvatar) {
            
            CGContextDrawImage(context, CGRectMake(6, 5, [AvatarOperation sizeToFit].width, [AvatarOperation sizeToFit].height), avatarImage.CGImage);
            
        } else {
            
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, HEXCOLOR(0x00000066).CGColor);      
            
            CGContextTranslateCTM(context, 0, [AvatarOperation imageSize].height);
            CGContextScaleCTM(context, 1.0, -1.0);
            
            CGContextDrawImage(context, CGRectMake(8, -7, [AvatarOperation imageSize].width, [AvatarOperation imageSize].height), avatarImage.CGImage);
            
            CGContextRestoreGState(context);
        }
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

#pragma mark -
#pragma mark Table anim delegate

- (void) finishedBackgroundViewFadeoutAnimationWithView:(UIView*)theBackgroundView {
    
    backgroundColor = [UIColor whiteColor];
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark pre-render

+ (int) createRenderTreeWithWidth:(CGFloat)width tipData:(NSMutableDictionary*)tipData
{
    static int margin_right = 14;
    static int margin_left = 61;
    
    int height = 0;
    
    CGSize timeSize = CGSizeZero;
    CGSize timeUnitSize = CGSizeZero;
    NSMutableDictionary *renderTree = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@"items"];
    NSMutableArray *renderItems = [renderTree objectForKey:@"items"];
    
    [FSVenueLookup computeTipTransientValues:tipData];
    
    [tipData setObject:renderTree forKey:@"render_tree"];
    
    {
        
        NSNumber *timeValueNumber = (NSNumber*)[tipData objectForKey:@"created_time_ago_val"]; // 2.45
        TimeUnitType timeUnit = [(NSNumber*)[tipData objectForKey:@"created_time_ago_unit"] intValue]; //"minutes"
        NSString *timeString = [tipData objectForKey:@"created_time_ago_string"]; //"2 1/2"
        NSString *timeUnitString = [NSDate timeUnit:timeUnit withValue:[timeValueNumber floatValue]];        
        
        if (timeUnit != kTimeUnitTypeNow) {
            timeUnitSize = [timeUnitString sizeWithFont:timeUnitFont];
        }
        timeSize = [timeString sizeWithFont:timeFont];
        
        // time
        UIColor *currentColor = nil;
        if (timeUnit == kTimeUnitTypeNow || timeUnit == kTimeUnitTypeMinutes || (timeUnit == kTimeUnitTypeHours && [timeValueNumber intValue] <= 4)) {
            currentColor = HEXCOLOR(0x519CE8FF);
        } else {
            currentColor = [UIColor grayColor];
        }
        
        if (timeUnit!=kTimeUnitTypeNow) {
            
            RenderTreeTextItem *item = [RenderTreeTextItem new];
            item.text = timeUnitString;
            item.point = CGPointMake(width-margin_right-margin_left-timeUnitSize.width, 1);
            item.font = timeUnitFont;
            item.color = currentColor;
            [renderItems addObject:item];
            [item release];
        }    
        
        {
            RenderTreeTextItem *item = [RenderTreeTextItem new];
            item.text = timeString;
            item.point = CGPointMake(width-margin_right-margin_left-timeUnitSize.width-3-timeSize.width, 1);
            item.font = timeFont;
            item.color = currentColor;
            [renderItems addObject:item];
            [item release];
        }    
        
    }    
    
    if ([tipData objectForKey:@"venue"]) {
        
        [NSString parseRenderTree:renderTree fromString:[NSString stringWithFormat:@"\\r@ \\b%@", [[tipData objectForKey:@"venue"] objectForKey:@"name"], nil]
                         forWidth:(width-margin_left-margin_right-timeUnitSize.width-3-timeSize.width-4)
                         maxLines:2
                    lineBreakMode:UILineBreakModeTailTruncation];
        
        height += [(NSNumber*)[renderTree objectForKey:@"height"] intValue];
        
    } else {
        
        [NSString parseRenderTree:renderTree fromString:[NSString stringWithFormat:@"\\rvia \\b%@", [FSUserLookup formatUserName:[tipData objectForKey:@"user"]], nil]
                         forWidth:(width-margin_left-margin_right-timeUnitSize.width-3-timeSize.width-4)
                         maxLines:2
                    lineBreakMode:UILineBreakModeTailTruncation];
        
        height += [(NSNumber*)[renderTree objectForKey:@"height"] intValue];          
        
    }
    
    if ([tipData objectForKey:@"text"]) {
        
        CGSize size = [[tipData objectForKey:@"text"] sizeWithFont:tipFont 
                                                  constrainedToSize:CGSizeMake(240, 200) 
                                                      lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [tipData objectForKey:@"text"];
        item.rect = CGRectMake(0, height, size.width, size.height);
        item.font = tipFont;
        item.color = [UIColor grayColor];
        [renderItems addObject:item];
        [item release];
        
        height = height + size.height;    
        height += 2;
    }
    
    return height += 10;
}

+ (int) calculateHeightWithWidth:(CGFloat)width tipData:(NSMutableDictionary*)tipData
{
    if (![tipData objectForKey:@"height"]) {
        
        [tipData setObject:[NSNumber numberWithInt:[TipTableViewCell320 createRenderTreeWithWidth:width tipData:tipData]] forKey:@"height"];
    }
          
    return MAX([(NSNumber*)[tipData objectForKey:@"height"] intValue], 68);
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
    
    [tipData release];
    
    [avatarImageUrl release];
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl cancelDownload]; [avatarDl release]; avatarDl = nil;
    [avatarAyncLoad cancel];
    
    [super dealloc];
}

@end
