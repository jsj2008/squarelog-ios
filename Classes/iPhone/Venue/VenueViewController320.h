#import <UIKit/UIKit.h>

#import "ImageCache.h"
#import "ImageDownloader.h"
#import "BadgeButton.h"

#import "NSString+RenderTree.h"

typedef enum {
    VenueViewControllerStyleNormal,
    VenueViewControllerStyleAddPhotos
} VenueViewControllerStyle;

@class VenueHeader;

@interface VenueViewController320 : UITableViewController <RSViewTreeDelegate> {

    VenueViewControllerStyle controllerStyle;
    NSDictionary *info;
    NSDictionary *venueInfo;
    
    NSMutableArray *tableSections;
    NSMutableArray *tableSectionHeaders;
    
    BadgeButton *photosButton;
    BadgeButton *tipsButton;

    int photosButtonBadgeCount;
    int tipsButtonBadgeCount;
    
    UIButton *checkinButton;
    UIButton *addPhotosButton;
    
    BOOL viewPushed;
}

- (void) loadTableSections;
- (id) initWithStyle:(UITableViewStyle)_tableStyle 
          venueStyle:(VenueViewControllerStyle)_controllerStyle;

@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) NSDictionary *venueInfo;

@end

