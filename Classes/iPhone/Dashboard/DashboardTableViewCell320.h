#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "NSDate+TimeAgo.h"

#import "ImageDownloader.h"
#import "ImageCache.h"

#import "FSCheckin.h"

@interface DashboardTableViewCell320 : ABTableViewCell <TableCellAnimationDelegate, ImageCacheDelegate> 
{    
    NSString *avatarImageUrl;
    UIImage *avatarImage;
    
    ImageDownloader *avatarDl;
    NSOperation *avatarAyncLoad;
    
    UIColor *textColor;
    
    FSCheckin *checkin;
    
    NSArray *renderItems;
}

+ (int) createRenderTreeWithWidth:(CGFloat)width checkinData:(NSMutableDictionary*)checkinData;
+ (int) calculateHeightWithWidth:(CGFloat)width checkinData:(NSDictionary*)checkinData;

@property (nonatomic, retain) FSCheckin *checkin;
@property (nonatomic, copy) NSString *avatarImageUrl;
@property (nonatomic, retain) NSArray *renderItems;

@end
