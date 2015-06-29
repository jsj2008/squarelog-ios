#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "BadgeImageView.h"

@interface BadgeTableViewCell320 : ABTableViewCell {
    
    BadgeImageView *leftBadgeView;
    BadgeImageView *rightBadgeView;
}

+(int) createRenderTreeWithWidth:(CGFloat)width leftBadge:(NSDictionary*)left rightBadge:(NSDictionary*)right;
+(int) calculateHeightWithWidth:(int)width leftBadge:(NSDictionary*)left rightBadge:(NSDictionary*)right;

@property (nonatomic, copy) NSString *badgeLeftImageUrl;
@property (nonatomic, retain) NSDictionary *leftData;

@property (nonatomic, copy) NSString *badgeRightImageUrl;
@property (nonatomic, retain) NSDictionary *rightData;

@end
