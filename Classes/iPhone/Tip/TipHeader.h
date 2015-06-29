#import <UIKit/UIKit.h>

#import "ImageDownloader.h"
#import "ImageCache.h"

@interface TipHeader : UIView <ImageCacheDelegate> {

	NSMutableDictionary *tipData;
	
	NSDictionary *renderTree;
	
	NSString *avatarImageUrl;
	ImageDownloader *avatarDl;
	UIImage *avatarImage;
	NSOperation *avatarAyncLoad;	
}

@property (nonatomic, assign) NSMutableDictionary *tipData;

@end
