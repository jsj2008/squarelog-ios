#import "DashboardTableViewCell320.h"
#import "TableCellSelectedBackground.h"
#import "TableCellBackground.h"
#import "FSCheckinsLookup.h"

#import "NSDateFormatter+RFC822.h"
#import "NSString+RenderTree.h"
#import "NSDictionary+RenderTree.h"
#import "RenderTreeTextItem.h"
#import "ImageCache.h"
#import "ImageDownloaderOperations.h"

#import "UIView+ShadowBug.h"
#import "UIScreen+Scale.h"
#import "UIDevice+Machine.h"

#import "CGHelper.h"

@implementation DashboardTableViewCell320

@synthesize avatarImageUrl, checkin, renderItems;

static UIColor *shadowColor;
static UIFont *timeFont;
static UIFont *timeUnitFont;
static UIFont *shoutFont;
static UIFont *locationFont;

+ (void) initialize {
 
    if (self == [DashboardTableViewCell320 class]) {
        
        shadowColor = [HEXCOLOR(0x00000066) retain];
        timeFont = [UIFont boldSystemFontOfSize:12];
        timeUnitFont = [UIFont systemFontOfSize:12];
        shoutFont = [UIFont systemFontOfSize:14];
        locationFont = [UIFont systemFontOfSize:12];
        
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[TableCellSelectedBackground alloc] initWithFrame:CGRectNull delegate:self];
        self.backgroundView = [[TableCellBackground alloc] initWithFrame:CGRectNull];
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        paddingPixel = 0;
    }
    return self;
}

- (void) finishedBackgroundViewFadeoutAnimationWithView:(UIView*)theBackgroundView {
    
    backgroundColor = whiteColor;
    [self setNeedsDisplay];
}

- (void)setAvatarImageUrl:(NSString *)s
{
    
    //s = @"http://a3.twimg.com/profile_images/546338003/gruber-sxsw-final_bigger.png";
    
    [avatarImageUrl release];
    avatarImageUrl = [s copy];

    [avatarAyncLoad cancel]; [avatarAyncLoad release]; avatarAyncLoad = nil;
    
    [avatarImage release]; avatarImage = nil;
    avatarImage = [[[ImageCache sharedImageCache] imageForKey:avatarImageUrl
                                      imageOperationClassName:@"AvatarOperation"
                                               asyncOperation:(NSOperation**)&avatarAyncLoad 
                                                     delegate:self] retain];
    
    [avatarDl cancelDownload];
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl release]; avatarDl = nil;
    
    if (avatarImage == nil && !avatarAyncLoad) {
        
        avatarDl = [ImageDownloader new];
        [avatarDl startDownloadUrl:avatarImageUrl imageOperationClassName:@"AvatarOperation"];
        
        [avatarDl addObserver:self
                   forKeyPath:@"image"
                      options:(NSKeyValueObservingOptionNew)
                      context:avatarImageUrl];        
    }
    
	[self setNeedsDisplay]; 
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [avatarAyncLoad release]; avatarAyncLoad = nil;
    
	[avatarImage release];
	avatarImage = [i retain];
	[self setNeedsDisplay];
}

- (void)setCheckin:(FSCheckin *)d
{
	[checkin release];
	checkin = [d retain];
    
    if (checkin.checkinType != FSCheckinTypeOffGrid) {
     
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    } else {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    self.renderItems = checkin.renderTree; //[[checkinData objectForKey:@"render_tree"] objectForKey:@"items"];
    
	[self setNeedsDisplay]; 
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == avatarDl && [keyPath isEqual:@"image"]) {
            
        avatarImage = (UIImage*)[change objectForKey:NSKeyValueChangeNewKey];
        [self setNeedsDisplay]; 
    }
}

#pragma mark -

- (void)drawContentView:(CGRect)r
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (backgroundColor == whiteColor) {
        
        if (![[UIDevice currentDevice] highQuality]) {
            [whiteColor set];
            CGContextFillRect(context, r);
        } 
		
		[whiteColor setStroke];
		CGContextSetLineWidth(context, 1);
		CGContextMoveToPoint(context, 0, .5);
		CGContextAddLineToPoint(context, r.size.width, .5);
		CGContextStrokePath(context);
		
		[superLightGrayColor setStroke];
		CGContextMoveToPoint(context, 0, CGRectGetMaxY(r)-.5);
		CGContextAddLineToPoint(context, r.size.width, CGRectGetMaxY(r)-.5);
		CGContextStrokePath(context);
        
        if ([[UIDevice currentDevice] highQuality]) {
		
            CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
            size_t num_locations = 2;
            CGFloat locations[2] = { 0.0, 1.0 };
            CGFloat colors[8] = {HEXCHANNEL(0xfe), HEXCHANNEL(0xfe), HEXCHANNEL(0xfe), HEXCHANNEL(0xFF), 
                                 HEXCHANNEL(0xf6), HEXCHANNEL(0xf6), HEXCHANNEL(0xf6), HEXCHANNEL(0xFF)};
            
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, num_locations);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMinX(r), 1), CGPointMake(CGRectGetMinX(r), CGRectGetMaxY(r)-1), 0);
            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorspace);
        }
		
	} else {
    
		[backgroundColor set];
		CGContextFillRect(context, r);
		
		[superLightGrayColor setStroke];
		CGContextMoveToPoint(context, 0, CGRectGetMaxY(r)-.5);
		CGContextAddLineToPoint(context, r.size.width, CGRectGetMaxY(r)-.5);
		CGContextStrokePath(context);
	}

    DrawRenderItems(renderItems, CGPointMake(66, 7), _selected);
    
    if (avatarImage == nil) {
        
//        CGFloat scale = [[UIScreen mainScreen] backwardsCompatibleScale];
//        
//        UIGraphicsBeginImageContext(CGSizeMake([AvatarOperation imageSize].width*scale, [AvatarOperation imageSize].height*scale));
//        context = UIGraphicsGetCurrentContext();
//        
//        CGRect rect = CGRectMake(0, 0, [AvatarOperation imageSize].width*scale, [AvatarOperation imageSize].height*scale);
//        CGContextAddRoundRect(context, rect, 4*scale, RoundRectAllCorners);
//        CGContextClip(context);
//        [lightGrayColor setFill];
//        CGContextFillRect(context, rect);
//        
//        UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();        
//        
//        context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, shadowColor.CGColor);
//        CGContextDrawImage (context, CGRectMake(9, 8, [AvatarOperation imageSize].width, [AvatarOperation imageSize].height), i.CGImage);
//        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, shadowColor.CGColor);
        
        CGContextAddRoundRect(context, CGRectMake(9, 8, [WikipediaThumbOperation imageSize].width, [WikipediaThumbOperation imageSize].height), 4, RoundRectAllCorners);        
        [HEXCOLOR(0xE1E1E0ff) setFill];
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);        
        
    } else {
        
        CGContextDrawImage(context, CGRectMake(7, 6, [AvatarOperation sizeToFit].width, [AvatarOperation sizeToFit].height), avatarImage.CGImage);
    }
}

+ (int) createRenderTreeWithWidth:(CGFloat)width checkinData:(NSMutableDictionary*)checkinData {
    
    static int margin_right = 42;
    static int margin_left = 61;
    
    [FSCheckinsLookup computeTransientValues:checkinData];
    
    CGSize timeSize = CGSizeZero;
    CGSize timeUnitSize = CGSizeZero;
    NSMutableDictionary *renderTree = [NSMutableDictionary dictionaryWithObject:[NSMutableArray arrayWithCapacity:10] forKey:@"items"];
    [checkinData setObject:renderTree forKey:@"render_tree"];
    NSMutableArray *renderItems = [renderTree objectForKey:@"items"];
    
    {
        
        NSNumber *timeValueNumber = (NSNumber*)[checkinData objectForKey:@"created_time_ago_val"]; // 2.45
        TimeUnitType timeUnit = [(NSNumber*)[checkinData objectForKey:@"created_time_ago_unit"] intValue]; //"minutes"
        NSString *timeString = [checkinData objectForKey:@"created_time_ago_string"]; //"2 1/2"
        NSString *timeUnitString = [NSDate timeUnit:timeUnit withValue:[timeValueNumber floatValue]];
        
        if (timeUnit!=kTimeUnitTypeNow) {
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
        
        if (timeUnit!=kTimeUnitTypeNow) 
        {
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
    
    // title
    [NSString parseRenderTree:renderTree fromString:[checkinData objectForKey:@"rndr_formatted_title"] 
                                forWidth:(width-margin_left-margin_right-timeUnitSize.width-3-timeSize.width-4)
                               maxLines:2
                          lineBreakMode:UILineBreakModeTailTruncation];
    
    int height = [(NSNumber*)[renderTree objectForKey:@"height"] intValue];
    
    height += 2;
    
    // shout
    if ([checkinData objectForKey:@"shout"]) {
        
        CGSize shoutSize = [[checkinData objectForKey:@"shout"] sizeWithFont:shoutFont 
                                                          constrainedToSize:CGSizeMake(210, 200) 
                                                              lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [checkinData objectForKey:@"shout"];
        item.rect = CGRectMake(0, height, shoutSize.width, shoutSize.height);
        item.font = shoutFont;
        item.color = [UIColor blackColor];
        [renderItems addObject:item];
        [item release];
                                
        height = height + shoutSize.height;    
        height += 2;
    }
    
    // location
    if ([checkinData objectForKey:@"formatted_location"]) {
        
        CGSize locationSize = [[checkinData objectForKey:@"formatted_location"] sizeWithFont:locationFont 
                                                          constrainedToSize:CGSizeMake(210, 200) 
                                                              lineBreakMode:UILineBreakModeWordWrap];
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [checkinData objectForKey:@"formatted_location"];
        item.rect = CGRectMake(0, height, locationSize.width, locationSize.height);
        item.font = locationFont;
        item.color = [UIColor grayColor];
        [renderItems addObject:item];
        [item release];
        
        height = height + locationSize.height;    
        //height += 2;        
    }
    
    return height;
}

+ (int) calculateHeightWithWidth:(CGFloat)width checkinData:(NSDictionary*)checkinData {
 
    return MAX([(NSNumber*)[checkinData objectForKey:@"height"] intValue] + 14, 68);
}

- (void)dealloc {
    
    [checkin release];
    [renderItems release];
    
    [avatarImageUrl release];
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl cancelDownload]; [avatarDl release]; avatarDl = nil;
    [avatarAyncLoad cancel];
    [super dealloc];
}

@end
