#import <UIKit/UIKit.h>

#import "CheckinBubbleView.h"

@interface CheckinTableViewCell : UITableViewCell {

	NSMutableDictionary *info;
}

@property (nonatomic, retain) NSMutableDictionary *info;
@property (nonatomic, assign) id delegate;

@end
