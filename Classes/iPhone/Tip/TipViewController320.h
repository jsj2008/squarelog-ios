#import <UIKit/UIKit.h>
#import "SingleTipTableViewCell.h"

@interface TipViewController320 : UITableViewController <UIActionSheetDelegate> {

	NSMutableDictionary *tipData;
    NSDictionary *venueData;
    NSMutableArray *tableSections;
    NSMutableArray *tableSectionFooters;
	
	UIButton *markTodoButton;
    UIButton *markDone;
    
    SingleTipTableViewCell *tipCell;
    
    UIActionSheet *sharingActionSheet;
    UIActionSheet *tipOpActionSheet;
    
    NSString *tipOperation;
}

- (void) loadTableSections;

@property (nonatomic, retain) NSMutableDictionary *tipData;
@property (nonatomic, retain) NSDictionary *venueData;

@end
