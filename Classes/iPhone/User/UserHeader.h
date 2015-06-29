#import <UIKit/UIKit.h>

#import "ImageCache.h"
#import "ImageDownloader.h"

@interface UserHeader : UIView <ImageCacheDelegate> {

	NSMutableDictionary *info;
	NSDictionary *renderTree;
	
	NSString *avatarImageUrl;
	ImageDownloader *avatarDl;
	UIImage *avatarImage;
	NSOperation *avatarAyncLoad;
}

@property (nonatomic,retain) NSMutableDictionary *info;

@end
