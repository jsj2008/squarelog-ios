#import "URLImageView.h"
#import "ImageCache.h"
#import "UIScreen+Scale.h"
#import "CGHelper.h"
#import "UIImage+Helper.h"

@implementation URLImageView

@synthesize imageUrl, imageUrl2, delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.alpha = .75;
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{   
    self.alpha = 1;
    [self.delegate performSelector:@selector(viewItemTapped:) withObject:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1;
}

- (void)setImageUrl:(NSString *)s
{
    
    //s = @"http://a3.twimg.com/profile_images/546338003/gruber-sxsw-final_bigger.png";
    
    [imageUrl release];
    imageUrl = [s copy];
    
    [ayncLoad release]; ayncLoad = nil;
    
    self.image = [[[ImageCache sharedImageCache] imageForKey:imageUrl
                                               imageOperationClassName:@"ThumbOperation"
                                                        asyncOperation:(NSOperation**)&ayncLoad
                                                              delegate:self] retain];
    
    //self.image = [UIImage roundedCornerImage:i radius:6];
    
    [dl cancelDownload];
    [dl removeObserver:self forKeyPath:@"image"]; 
    [dl release]; dl = nil;
    
    if (self.image == nil) {
    
        self.image = [UIImage grayBoxWithRoundedCornersRadius:6 size:CGSizeMake(75, 75)];
        
        if (!ayncLoad) {
      
            dl = [ImageDownloader new];
            [dl startDownloadUrl:imageUrl imageOperationClassName:@"ThumbOperation"];
            
            [dl addObserver:self
                       forKeyPath:@"image"
                          options:(NSKeyValueObservingOptionNew)
                          context:imageUrl];
        }
        
    }
    
	[self setNeedsDisplay]; 
}

#pragma mark ImageCacheDelegate

-(void)imageCache:(ImageCache*)cache imageFromCache:(UIImage*)i;
{
    [ayncLoad release]; ayncLoad = nil;
    self.image = i;
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == dl && [keyPath isEqual:@"image"]) {
        
        self.image = (UIImage*)[change objectForKey:NSKeyValueChangeNewKey];
    }
}

- (void)dealloc {
    [imageUrl release];
    [dl removeObserver:self forKeyPath:@"image"]; 
    [dl cancelDownload]; [dl release];
    [ayncLoad cancel];
    [super dealloc];
}

@end
