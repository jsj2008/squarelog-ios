#import <QuartzCore/QuartzCore.h>

#import "UserTableViewCell.h"
#import "UIScreen+Scale.h"
#import "UIView+ShadowBug.h"
#import "CGHelper.h"
#import "ImageDownloaderOperations.h"

static UIColor* shadowColor;

@implementation UserTableViewCell

@synthesize avatarImageUrl;

+ (void) initialize {
    
    if (self == [UserTableViewCell class]) {
        shadowColor = [HEXCOLOR(0x00000066) retain];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
    }
    return self;
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [avatarAyncLoad release]; avatarAyncLoad = nil;
	self.imageView.image = i;
}

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    self.imageView.frame = CGRectMake(5, 2, [NSClassFromString(@"SmallAvatarOperation") sizeToFit].width, [NSClassFromString(@"SmallAvatarOperation") sizeToFit].height);
    
    self.textLabel.frame = CGRectMake(48, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    
//    self.imageView.opaque = !self.selected;
//    self.imageView.backgroundColor = [UIColor whiteColor]; //doesn't work
}
    
//- (void)setSelected:(BOOL)s
//{
//    self.imageView.opaque = !s; // doesn't work
//}

- (void)setAvatarImageUrl:(NSString *)s
{
    
    //s = @"http://a3.twimg.com/profile_images/546338003/gruber-sxsw-final_bigger.png";
    
    [avatarImageUrl release];
    avatarImageUrl = [s copy];
    
    [avatarAyncLoad cancel]; [avatarAyncLoad release]; avatarAyncLoad = nil;
    
    self.imageView.image = [[[ImageCache sharedImageCache] imageForKey:avatarImageUrl
                                      imageOperationClassName:@"SmallAvatarOperation"
                                               asyncOperation:(NSOperation**)&avatarAyncLoad
                                                     delegate:self] retain];
    
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl cancelDownload];
    [avatarDl release]; avatarDl = nil;
    
    if (self.imageView.image == nil) {
         
        CGFloat scale = [[UIScreen mainScreen] backwardsCompatibleScale];
        
        UIGraphicsBeginImageContext(CGSizeMake([SmallAvatarOperation sizeToFit].width*scale, [SmallAvatarOperation sizeToFit].height*scale));
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect rect = CGRectMake(2*scale, 3*scale, [SmallAvatarOperation imageSize].width*scale, [SmallAvatarOperation imageSize].height*scale);
        CGContextAddRoundRect(context, rect, 4*scale, RoundRectAllCorners);
        CGContextClip(context);
        [lightGrayColor setFill];
        CGContextFillRect(context, rect);
        
        UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView.image = i;
        
        if (!avatarAyncLoad) {
            
            avatarDl = [ImageDownloader new];
            [avatarDl startDownloadUrl:avatarImageUrl imageOperationClassName:@"SmallAvatarOperation"];
            
            [avatarDl addObserver:self
                       forKeyPath:@"image"
                          options:(NSKeyValueObservingOptionNew)
                          context:avatarImageUrl];
        }
        
    }
    
	[self setNeedsDisplay]; 
}

//- (void)drawRect:(CGRect)r
//{
//
//    CGContextRef context;
//    
//    if (avatarImage == nil) {
//        
//        CGFloat scale = [[UIScreen mainScreen] backwardsCompatibleScale];
//        
//        UIGraphicsBeginImageContext(CGSizeMake([SmallAvatarOperation imageSize].width*scale, [SmallAvatarOperation imageSize].height*scale));
//        context = UIGraphicsGetCurrentContext();
//        
//        CGRect rect = CGRectMake(0, 0, [SmallAvatarOperation imageSize].width*scale, [SmallAvatarOperation imageSize].height*scale);
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
//        CGContextDrawImage (context, CGRectMake(9, 9, [SmallAvatarOperation imageSize].width, [SmallAvatarOperation imageSize].height), i.CGImage);
//        CGContextRestoreGState(context);
//        
//    } else {
//        
//        context = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context, CGRectMake(7, 7, [SmallAvatarOperation sizeToFit].width, [SmallAvatarOperation sizeToFit].height), avatarImage.CGImage);
//    }
//}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == avatarDl && [keyPath isEqual:@"image"]) {

        self.imageView.image = (UIImage*)[change objectForKey:NSKeyValueChangeNewKey];
    }
}

- (void)dealloc {
    
    [avatarImageUrl release];
    [avatarDl removeObserver:self forKeyPath:@"image"]; 
    [avatarDl cancelDownload]; [avatarDl release]; avatarDl = nil;
    [avatarAyncLoad cancel];
    [super dealloc];
}


@end
