#import "SmallBadgeImageView.h"

@implementation SmallBadgeImageView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.opaque = YES;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setImageUrl:(NSString *)s
{
    
    if (!s) {
        self.image = nil; [imageUrl release]; imageUrl = nil; return;
    }    
    
    //s = @"http://a3.twimg.com/profile_images/546338003/gruber-sxsw-final_bigger.png";
    
    [imageUrl release];
    imageUrl = [s copy];
    
    [ayncLoad release]; ayncLoad = nil;
    
    self.image = [[[ImageCache sharedImageCache] imageForKey:imageUrl
                                     imageOperationClassName:@"BadgeSmallOperation"
                                              asyncOperation:(NSOperation**)&ayncLoad
                                                    delegate:self] retain];
    
    [dl removeObserver:self forKeyPath:@"image"];
    [dl cancelDownload];
    [dl release]; dl = nil;
    
    if (self.image == nil) {
        
        //self.contentMode = UIViewContentModeScaleAspectFit;
        
        if (!ayncLoad) {
            
            dl = [ImageDownloader new];
            [dl startDownloadUrl:imageUrl imageOperationClassName:@"BadgeSmallOperation"];
            
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
        
        [dl removeObserver:self forKeyPath:@"image"];
        [dl release]; dl = nil;
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
