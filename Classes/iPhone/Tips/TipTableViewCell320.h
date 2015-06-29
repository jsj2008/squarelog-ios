#import <UIKit/UIKit.h>

#import "ABTableViewCell.h"

#import "ImageDownloader.h"
#import "ImageCache.h"

typedef enum {
    TipImageTypeUserAvatar,
    TipImageTypeVenueIcon
} TipImageType;

@interface TipTableViewCell320 : ABTableViewCell <TableCellAnimationDelegate, ImageCacheDelegate> {

    NSString *avatarImageUrl;
    UIImage *avatarImage;
    ImageDownloader *avatarDl;
    NSOperation *avatarAyncLoad;
    
    NSDictionary *tipData;
    
    TipImageType imageType;
}

+ (int) createRenderTreeWithWidth:(CGFloat)width tipData:(NSMutableDictionary*)tipData;
+ (int) calculateHeightWithWidth:(CGFloat)width tipData:(NSMutableDictionary*)tipData;

- (void)setAvatarImageUrl:(NSString *)s;

@property (nonatomic, retain) NSDictionary *tipData;

@end
