#import <UIKit/UIKit.h>

@interface RegisterTableViewCell : UITableViewCell {

    id<UITextFieldDelegate> delegate;
    UITextField *textField;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,assign) id<UITextFieldDelegate> delegate;
@property (nonatomic,assign) BOOL password;
@property (nonatomic,assign) NSString* labelText;
@property (nonatomic,assign) NSString* placeholderText;
@property (nonatomic,assign) UITextField *textField;

@end
