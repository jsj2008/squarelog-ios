#import <UIKit/UIKit.h>

#import "ImageCache.h"
#import "ImageDownloader.h"

@interface VenueHeader : UIView <ImageCacheDelegate>
{
    
    NSMutableDictionary *info;
    NSDictionary *renderTree;
    
    NSString *logoImageUrl;
    UIImage *logoImage;
    ImageDownloader *logoDl;
    NSOperation *logoAyncLoad;
}

@property (nonatomic, retain) NSMutableDictionary *info;

@end