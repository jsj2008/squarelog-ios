#import "CheckInTextViewCell.h"
#import "DismissibleLabel.h"
#import "CGHelper.h"
#import "CheckinCharacterCount.h"

@implementation CheckInTextViewCell

@synthesize delegate;
@dynamic textView, number;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier checkinStyle:(PostStyle)checkinStyle {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UITextView *v = nil;
        
        if (checkinStyle == PostStyleTip) v = [[UITextView alloc] initWithFrame:CGRectMake(16, 4, 250, 71+112)];
        else v = [[UITextView alloc] initWithFrame:CGRectMake(16, 4, 250, 71)];
        
		v.tag = 100;
		v.font = [UIFont systemFontOfSize:15];
        v.keyboardType = UIKeyboardTypeAlphabet;
        if (checkinStyle != PostStyleTip) v.returnKeyType = UIReturnKeyNext;
		[self addSubview:v];
		
		DismissibleLabel *l = nil;
        if (checkinStyle == PostStyleTip) l = [[DismissibleLabel alloc] initWithFrame:CGRectMake(16, 4, 288, 71+112) textView:v];
        else l = [[DismissibleLabel alloc] initWithFrame:CGRectMake(16, 4, 288, 71) textView:v];
        
        l.tag = 1000001;
		[self addSubview:l];
		l.textAlignment = UITextAlignmentCenter;
		l.backgroundColor = [UIColor whiteColor];
        if (checkinStyle == PostStyleTip) {
            l.text = @"Tap to add a tip...";
        } else {
            l.text = @"Tap to add a shout...";
        }
		l.font = [UIFont boldSystemFontOfSize:14];
		l.textColor = [UIColor grayColor];
		[l bringSubviewToFront:v];
		[l release];
        
        CheckinCharacterCount *c;
        if (checkinStyle == PostStyleTip) c = [[CheckinCharacterCount alloc] initWithFrame:CGRectMake(266, 50+112, 36, 22)];
        else c = [[CheckinCharacterCount alloc] initWithFrame:CGRectMake(267, 50, 36, 22)];
        
        c.tag = 1001;
        [self addSubview:c];        
        [c release];                          
		
		[v release];
    }
	
    return self;
}

- (void) dismissibleLabelHidden:(BOOL)hidden
{
    [self viewWithTag:1000001].hidden = hidden;
}

- (void) setNumber:(NSInteger) num
{
    ((CheckinCharacterCount*) [self viewWithTag:1001]).number = num;
}

- (void) setDelegate:(id) deleg
{
	delegate = deleg;
	((UITableView*)[self viewWithTag:100]).delegate = deleg;
}

- (UITextView*) textView
{
    return (UITextView*)[self viewWithTag:100];
}

- (void)dealloc {
	
    [super dealloc];
}

@end