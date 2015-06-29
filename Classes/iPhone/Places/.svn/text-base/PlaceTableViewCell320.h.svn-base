#import <UIKit/UIKit.h>

#import "ABTableViewCell.h"
#import "ImageDownloader.h"

#import "ImageCache.h"

#import "FSVenuesLookup.h"

@interface PlaceTableViewCell320 : ABTableViewCell <TableCellAnimationDelegate, ImageCacheDelegate> {
    
    NSMutableDictionary *venueInfo;
    
    NSString *logoImageUrl;
    UIImage *logoImage;
    
    PlaceType placeType;
    
    ImageDownloader *avatarDl;
	NSOperation* iconAyncLoad;
}

+ (int) createRenderTreeWithWidth:(CGFloat)width venueData:(NSDictionary*)venueData;
+ (int) calculateHeightWithWidth:(CGFloat)width venueData:(NSDictionary*)venueData;

@property (nonatomic, assign) PlaceType placeType;
@property (nonatomic, copy) NSString *logoImageUrl;
@property (nonatomic, retain) NSMutableDictionary *venueInfo;

@end
