#import <UIKit/UIKit.h>

@interface RegisterTableView : UITableView <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate> {

    UITextField *usernameTextField;
    UITextField *passwordTextField;
    
    id registerDelegate;
}

@property (nonatomic, assign) id registerDelegate;

@end
