#import <UIKit/UIKit.h>

#import "ImageDownloader.h"
#import "ImageCache.h"

@interface BadgeImageView : UIImageView <ImageCacheDelegate> {

    NSString *imageUrl;
    ImageDownloader *dl;
    NSOperation *ayncLoad;
}

@property (nonatomic, retain) NSString *imageUrl;

@end
