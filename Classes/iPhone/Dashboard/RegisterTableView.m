#import <QuartzCore/QuartzCore.h>

#import "ButtonBuilder.h"

#import "RegisterTableView.h"
#import "RegisterTableViewCell.h"

#import "FSSettings.h"

#import "NSObjectAdditions.h"

@implementation RegisterTableView

@synthesize registerDelegate;

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame style:UITableViewStylePlain])) {
		
        self.delegate = self;
		self.dataSource = self;
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
		self.layer.cornerRadius = 4;
		self.layer.masksToBounds = YES;
		self.rowHeight = 44;
		self.allowsSelection = NO;
        self.opaque = YES;
        
        UIFont *headerFont = [UIFont boldSystemFontOfSize:14];
        
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 74)];
        h.opaque = YES;
        h.backgroundColor = [UIColor whiteColor];
		
        CGSize ls = [@"login with your" sizeWithFont:headerFont];
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ls.width, 74)];
		l.text = @"login with your";
		l.font = headerFont;
        [h addSubview:l];
        [l release];
        
        UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foursquare-logo.png"]];
        i.opaque = YES;
        i.backgroundColor = [UIColor whiteColor];
        i.frame = CGRectMake(ls.width+12+6, 25, 90, 25);
        [h addSubview:i];
        [i release];
        
		l = [[UILabel alloc] initWithFrame:CGRectMake(i.frame.origin.x + i.frame.size.width+4, 0, 100, 74)];
		l.text = @"account";
		l.font = headerFont;
        [h addSubview:l];
        [l release];
        
		self.tableHeaderView = h;
		[h release];
		
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 100, 260)];
        v.opaque = YES;
		v.backgroundColor = [UIColor whiteColor];
                             
        UIButton *b = [ButtonBuilder button1];
		b.frame = CGRectMake(10, 9, 260, 40);
		[b setTitle:@"login" forState:UIControlStateNormal];
        [b addTarget:self.registerDelegate action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
		[v addSubview:b];
		
		UIButton *b2 = [ButtonBuilder button1];
		b2.frame = CGRectMake(10, 154, 260, 40);
        b2.backgroundColor = [UIColor whiteColor];
		[b2 setTitle:@"create an account" forState:UIControlStateNormal];
        [b2 addTarget:self.registerDelegate action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
		[v addSubview:b2];
		
		UIButton *b3 = [ButtonBuilder button1];
		b3.frame = CGRectMake(10, 207, 260, 40);
        b3.backgroundColor = [UIColor whiteColor];
		[b3 setTitle:@"forget your password?" forState:UIControlStateNormal];
        [b3 addTarget:self.registerDelegate action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
		[v addSubview:b3];		

		self.tableFooterView = v;
		[v release];
    }
	
    return self;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    RegisterTableViewCell *cell = (RegisterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[RegisterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.delegate = self;
	
	if (indexPath.row == 0) {
    
		cell.labelText= @"username: ";
		cell.placeholderText= @"email or phone number";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        
        usernameTextField = cell.textField;
        [usernameTextField addTarget:self action:@selector(textFieldTextEntered:) forControlEvents:UIControlEventEditingChanged];
		
	} else if (indexPath.row == 1) {
		
		cell.labelText= @"password: ";
		cell.placeholderText= @"";
		cell.password = YES;
        
        passwordTextField = cell.textField;
        [passwordTextField addTarget:self action:@selector(textFieldTextEntered:) forControlEvents:UIControlEventEditingChanged];
	}
	
	return cell;
}

#pragma mark -
#pragma mark ScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

#pragma mark -
#pragma mark TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == passwordTextField && [passwordTextField.text length] > 3) {
        
        [textField resignFirstResponder];
        [self login:textField];
        return YES;
        
    } else if (textField == usernameTextField && [usernameTextField.text length] > 3) {
        
        [textField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        return YES;
    }
        
	[textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Button Event Handlers

- (void)login:(id)sender
{
//    [usernameTextField resignFirstResponder]; //slow
//    [passwordTextField resignFirstResponder];
    [registerDelegate performSelector:@selector(login:username:password:) 
                   withObject:[[NSDictionary dictionaryWithObjectsAndKeys:usernameTextField, @"usernameTextField", passwordTextField, @"passwordTextField", nil] retain]
                   withObject:usernameTextField.text 
                   withObject:passwordTextField.text];
}

- (void)createAccount:(id)sender 
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];    
    [registerDelegate performSelector:@selector(createAccount:) 
                   withObject:sender];
}

- (void)forgetPassword:(id)sender 
{
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];    
    [registerDelegate performSelector:@selector(forgetPassword:) 
                   withObject:sender];    
}

#pragma mark Notifications

- (void) textFieldTextEntered:(id)sender
{
    if ([passwordTextField.text length] > 3 && passwordTextField.returnKeyType != UIReturnKeyJoin) {
        
        passwordTextField.returnKeyType = UIReturnKeyJoin;
        
        NSString *text = passwordTextField.text;
        [passwordTextField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        passwordTextField.text = text;
    }
}

#pragma mark -

- (void)dealloc 
{
    [super dealloc];
}


@end
