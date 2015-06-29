#import <UIKit/UIKit.h>

#import "ABTableViewCell.h"

#import "ImageDownloader.h"
#import "ImageDownloaderOperations.h"

#import "ImageCache.h"

@interface WikipediaTableViewCell320 : ABTableViewCell <TableCellAnimationDelegate, ImageCacheDelegate> {

    NSMutableDictionary *data;
    
    NSString *avatarImageUrl;
    UIImage *avatarImage;
    ImageDownloader *avatarDl;
    NSOperation *avatarAyncLoad;    
}

+ (int) createRenderTreeWithWidth:(CGFloat)width wikiData:(NSMutableDictionary*)wikiData;
+ (int) calculateHeightWithWidth:(CGFloat)width wikiData:(NSMutableDictionary*)wikiData;

- (void)setAvatarImageUrl:(NSString *)s;

@property (nonatomic, retain) NSMutableDictionary *data;

@end
