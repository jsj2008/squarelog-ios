#import "DismissibleLabel.h"

@implementation DismissibleLabel

- (id)initWithFrame:(CGRect)frame textView:(UITextView*)_textView {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
		textView = _textView;
    }
    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.hidden = YES;
	[textView becomeFirstResponder];
	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc {
    [super dealloc];
}


@end
