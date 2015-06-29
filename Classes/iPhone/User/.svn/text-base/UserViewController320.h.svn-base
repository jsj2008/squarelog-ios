#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "BadgeButton.h"

@interface UserViewController320 : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {

    NSMutableDictionary *info;
    NSMutableDictionary *friendInfo;
    NSMutableArray *tipInfo;
	
    NSMutableArray *tableSections;
    NSMutableArray *tableSectionHeaders;
	NSMutableArray *tableSectionFooters;
	
    BadgeButton *tipsButton;
    BadgeButton *mayorButton;
	BadgeButton *photosButton;
    
    int tipsButtonBadgeCount;
    int mayorButtonBadgeCount;
    int photosButtonBadgeCount;
    
    UIActionSheet *smsActionSheet;
    UIActionSheet *facebookActionSheet;
    UIActionSheet *twitterActionSheet;
    UIActionSheet *phoneActionSheet;
    
    UIActionSheet *friendOpActionSheet;
    
    NSString *friendOperation;
    
    BOOL viewPushed;
    
    NSIndexPath *lastIndex;
}

- (void) loadTableSections;

- (void) loadState;
- (void) saveState:(NSIndexPath *)indexPath;

@property (nonatomic,retain) NSMutableDictionary *info;
@property (nonatomic,retain) NSMutableDictionary *friendInfo;
@property (nonatomic,retain) NSMutableArray *tipInfo;

@end
