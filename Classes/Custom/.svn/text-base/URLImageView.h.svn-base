#import <UIKit/UIKit.h>

#import "ImageDownloader.h"
#import "ImageCache.h"

@interface URLImageView : UIImageView <ImageCacheDelegate> {

    NSString *imageUrl;
    NSString *imageUrl2;
    ImageDownloader *dl;
    NSOperation *ayncLoad;
}

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *imageUrl2;
@property (nonatomic, assign) id delegate;

@end