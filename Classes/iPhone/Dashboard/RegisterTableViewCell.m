#import <QuartzCore/QuartzCore.h>
#import "RegisterTableViewCell.h"

@implementation RegisterTableViewCell

@synthesize textField;

@dynamic labelText, placeholderText, password, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 84, 20)];
		l.tag = 100;
		l.textAlignment = UITextAlignmentRight;
		l.font = [UIFont boldSystemFontOfSize:14];
		l.textColor = HEXCOLOR(0x4F585EFF);//[UIColor grayColor];
		l.backgroundColor = HEXCOLOR(0xeeeeeeff);
        l.opaque = YES;
		
		textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 260, 38)];
        textField.opaque = YES;
		textField.leftView = l;
		[l release];
		textField.leftViewMode = UITextFieldViewModeAlways;
		textField.tag = 101;
		textField.textAlignment = UITextAlignmentLeft;
		textField.font = [UIFont boldSystemFontOfSize:14];
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField.backgroundColor = HEXCOLOR(0xeeeeeeff);
		textField.layer.cornerRadius = 6;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.returnKeyType = UIReturnKeyNext;
		
		[self addSubview:textField];
        
        self.opaque = YES;
		
    }
    return self;
}

- (void)setDelegate:(id <UITextFieldDelegate>)_delegate {
 
    delegate = _delegate;
    UITextField *t = (UITextField*) [self viewWithTag:101];
    t.delegate = delegate;
}

- (void)setPassword:(BOOL)p 
{
	UITextField *t = (UITextField*) [self viewWithTag:101];
	t.secureTextEntry = p;
    t.clearButtonMode = UITextFieldViewModeWhileEditing;    
	[self setNeedsDisplay]; 
}

- (void)setLabelText:(NSString *)s
{
	UILabel *l = (UILabel*) ((UITextField*)[self viewWithTag:101]).leftView;
	l.text = s;
	[self setNeedsDisplay]; 
}

- (void)setPlaceholderText:(NSString *)s
{
	UITextField *t = (UITextField*) [self viewWithTag:101];
	t.placeholder = s;
	[self setNeedsDisplay]; 
}

- (void)dealloc {
    [super dealloc];
}


@end
