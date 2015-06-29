#import "PlaceTableViewCell320.h"
#import "UIScreen+Scale.h"
#import "ImageCache.h"
#import "TableCellSelectedBackground.h"
#import "FSCheckinsLookup.h"
#import "CGHelper.h"
#import "NSDictionary+RenderTree.h"
#import "NSString+RenderTree.h"

#import "RenderTreeTextItem.h"

@implementation PlaceTableViewCell320

@synthesize placeType, venueInfo, logoImageUrl; //, placeName, distance, location, logoImageUrl;

static UIFont *placeNameFont;
static UIFont *distanceFont;
static UIFont *locationFont;

+ (void) initialize {
    
    if (self == [PlaceTableViewCell320 class]) {
        
        placeNameFont = [UIFont boldSystemFontOfSize:14];
        distanceFont = [UIFont boldSystemFontOfSize:12];
        locationFont = [UIFont systemFontOfSize:12];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.selectedBackgroundView = [[TableCellSelectedBackground alloc] initWithFrame:CGRectNull delegate:self];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        paddingPixel = 0;
        
    }
    return self;
}

- (void)setLogoImageUrl:(NSString *)s
{
    if ([[UIScreen mainScreen] backwardsCompatibleScale] > 1) {
        s = [s stringByReplacingOccurrencesOfString:@".png" withString:@"_64.png"];
    }
    
	[logoImageUrl release];
	logoImageUrl = [s copy];
    
    [avatarDl removeObserver:self forKeyPath:@"image"];
    
    [avatarDl cancelDownload];
    [avatarDl release]; avatarDl = nil;
    
	[iconAyncLoad cancel]; [iconAyncLoad release]; iconAyncLoad = nil;
    
    [logoImage release]; logoImage = nil;
    
    if (logoImageUrl != nil) {
		
		logoImage = [[[ImageCache sharedImageCache] imageForKey:logoImageUrl
                                        imageOperationClassName:@"IdentityOperation"
												 asyncOperation:(NSOperation**)&iconAyncLoad 
													   delegate:self] retain];
		
		if (logoImage == nil && !iconAyncLoad) {		
            
            [avatarDl cancelDownload];
            [avatarDl release];
            avatarDl = [ImageDownloader new];
            [avatarDl startDownloadUrl:logoImageUrl imageOperationClassName:@"IdentityOperation"];
        }
        
        [avatarDl addObserver:self
                   forKeyPath:@"image"
                      options:(NSKeyValueObservingOptionNew)
                      context:logoImageUrl];
    }
    
	[self setNeedsDisplay]; 
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [iconAyncLoad release]; iconAyncLoad = nil;
    
	[logoImage release];
	logoImage = [i retain];
	[self setNeedsDisplay];
}


#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == avatarDl && [keyPath isEqual:@"image"] && [logoImageUrl isEqual:(NSString*)context] ) {
        
        logoImage = [(UIImage*) [change objectForKey:NSKeyValueChangeNewKey] retain];
        [self setNeedsDisplay]; 
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    _selected = selected;
    
    if (selected) {
        
        backgroundColor = [UIColor clearColor];
        //textColor = [UIColor whiteColor];
        
    } else if (!selected && animated) {
        
        backgroundColor = [UIColor clearColor];
        //textColor = [UIColor blackColor];
        
        [self setNeedsDisplay];
        
    } else if (!selected && !animated) {
        
        backgroundColor = [UIColor whiteColor];
        //textColor = [UIColor blackColor];
    }
    
    [super setSelected:selected animated:animated];
}

#pragma mark -

- (void)drawContentView:(CGRect)r {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//	UIColor *backgroundColor = [UIColor whiteColor];
//	UIColor *textColor = [UIColor blackColor];
//	
//	if(self.selected) {
//		backgroundColor = [UIColor clearColor];
//		textColor = [UIColor whiteColor];
//	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
    
    [((NSDictionary*)[venueInfo objectForKey:@"render_tree"]) drawAtPoint:CGPointMake(44, 3) selected:_selected];
    
    if (logoImage != nil) {
        
        CGContextSaveGState(context);        
        CGContextTranslateCTM(context, 0, 32);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake(6, -6, 32, 32), logoImage.CGImage);
        CGContextRestoreGState(context);
        
    } else {
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, 30);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextSaveGState(context);
        CGContextAddRoundRect(context, CGRectMake(7, -7, 30, 30), 4, RoundRectAllCorners);
        [[UIColor whiteColor] setFill];
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        
        CGContextAddRoundRect(context, CGRectMake(7, -7, 30, 30), 4, RoundRectAllCorners);
        [[UIColor lightGrayColor] setStroke];
        CGContextSetLineWidth(context, 2);
        CGContextSetLineCap(context, kCGLineCapSquare);                             
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
    
    if (placeType == PlaceTypeFavorite) {
        [[UIImage imageNamed:@"star.png"] drawInRect:CGRectMake(320-6-40, (r.size.height-20)/2-1, 19, 19)];
    } else if (placeType == PlaceTypeTrending) {
        [[UIImage imageNamed:@"arrow.png"] drawInRect:CGRectMake(320-6-40, (r.size.height-20)/2-1, 17, 18)];
    }
    
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
}

#pragma mark -
#pragma mark pre-render

+ (int) createRenderTreeWithWidth:(CGFloat)width venueData:(NSMutableDictionary*)venueData
{
    
    int height = 0;
    NSMutableDictionary *renderTree = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@"items"];
    NSMutableArray *renderItems = [renderTree objectForKey:@"items"];
    
    [venueData setObject:renderTree forKey:@"render_tree"];
    [renderTree retain];
    
    if ([venueData objectForKey:@"name"]) {
        
        CGSize size = [[venueData objectForKey:@"name"] sizeWithFont:placeNameFont 
                                                          constrainedToSize:CGSizeMake(230, 200) 
                                                              lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [venueData objectForKey:@"name"];
        item.rect = CGRectMake(0, height, size.width, size.height);
        item.font = placeNameFont;
        item.color = [UIColor blackColor];
        [renderItems addObject:item];
        [item release];
        
        height = height + size.height;    
        height += 2;
        
    }
    
    if ([venueData objectForKey:@"name"]) {
        
        NSString *location = [FSCheckinsLookup formatLocationWithVenue:venueData];
        
        CGSize size = [location sizeWithFont:locationFont
                      constrainedToSize:CGSizeMake(230, 200) 
                          lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = location;
        item.rect = CGRectMake(0, height, size.width, size.height);
        item.font = locationFont;
        item.color = [UIColor grayColor];        
        [renderItems addObject:item];
        [item release];
        
        height = height + size.height;
        height += 2;
        
    }
    
    int hereNow = [(NSNumber*) [[venueData objectForKey:@"stats"] objectForKey:@"herenow"] intValue];
    
    if (hereNow > 0) {
     
        NSString *string = [NSString stringWithFormat:@"\\kHere now: \\l%d", hereNow];
        
        [renderTree setObject:[NSNumber numberWithInt:height] forKey:@"height"];
        
        height = [NSString parseRenderTree:renderTree fromString:string
                                   forWidth:100
                                   maxLines:1
                              lineBreakMode:UILineBreakModeWordWrap];
        
       height += 2;
        
    }
    
    height += 5;
    
    return height;
}

+ (int) calculateHeightWithWidth:(CGFloat)width venueData:(NSMutableDictionary*)venueData
{
    if (![venueData objectForKey:@"height"]) {
        
        [venueData setObject:[NSNumber numberWithInt:[PlaceTableViewCell320 createRenderTreeWithWidth:width venueData:venueData]] forKey:@"height"];
    }
    
    return MAX([(NSNumber*)[venueData objectForKey:@"height"] intValue], 54);
}

#pragma table anim delegate

- (void) finishedBackgroundViewFadeoutAnimationWithView:(UIView*)theBackgroundView {
    
    backgroundColor = [UIColor whiteColor];
    //textColor = [UIColor blackColor];
    
    [self setNeedsDisplay];
}

- (void)dealloc {
    
    [venueInfo release];
    
    [logoImageUrl release];
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl cancelDownload]; [avatarDl release]; avatarDl = nil;
    [iconAyncLoad cancel];
    
    [super dealloc];
}

@end
