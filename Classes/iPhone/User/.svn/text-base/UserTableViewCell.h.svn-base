#import <UIKit/UIKit.h>

#import "ABTableViewCell.h"

#import "ImageDownloader.h"
#import "ImageCache.h"

@interface UserTableViewCell : UITableViewCell <ImageCacheDelegate> {

    NSString *avatarImageUrl;
    ImageDownloader *avatarDl;
    NSOperation *avatarAyncLoad;
}

@property (nonatomic, copy) NSString *avatarImageUrl;

@end
