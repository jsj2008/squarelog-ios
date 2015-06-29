#import <UIKit/UIKit.h>

#import "ImageDownloader.h"
#import "SmallBadgeImageView.h"
#import "ImageCache.h"

@interface SmallBadgeImageView : UIImageView <ImageCacheDelegate> {
    
    NSString *imageUrl;
    ImageDownloader *dl;
    NSOperation *ayncLoad;
}

@property (nonatomic, retain) NSString *imageUrl;

@end
