#import <UIKit/UIKit.h>

#import "ActionTableViewCell.h"

@interface UserContactTableViewCell : ActionTableViewCell {
    UILabel *contactType;
    UILabel *contactDetail;
}

@property (nonatomic, assign) UILabel *contactType;
@property (nonatomic, assign) UILabel *contactDetail;
@end
