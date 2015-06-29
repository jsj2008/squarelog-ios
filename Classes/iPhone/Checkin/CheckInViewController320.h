#import <UIKit/UIKit.h>

@class CheckInTextViewCell;

typedef enum {
	PostStyleCheckin = 0,
    PostStyleCheckinAddPhotos,
	PostStyleShout,
    PostStyleTip,
} PostStyle;

@interface CheckInViewController320 : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIActionSheetDelegate> {

	NSMutableDictionary *info;
	PostStyle controllerStyle;
	
    NSMutableArray *tableSections;
    NSMutableArray *tableSectionHeaders;
	
	UITextView *textView;
	
	UINavigationController *parentNavigationController;
    
    NSMutableArray *imageFileNames;
    
    BOOL savedUserValues;
    NSString *userShout;
    BOOL userPublicShout;
    BOOL userTwitterShare;
    BOOL userFacebookShare;
    
    int checkinItemSection;
}

- (id) initWithStyle:(UITableViewStyle)UITableViewStyleGrouped checkinStyle:(PostStyle)checkinStyle;
- (void) characterCountLimit:(CheckInTextViewCell*)cell;
- (void) loadTableSections;
- (void) saveUserValues;
- (void) removeImages;
//- (NSString *)applicationTempDirectory;
- (void) mainActionItemTappedWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void) doneWithTextView:(id)sender;

@property (nonatomic, retain) NSMutableDictionary *info;
@property (nonatomic, retain) UINavigationController *parentNavigationController;
@property PostStyle controllerStyle;

@end
