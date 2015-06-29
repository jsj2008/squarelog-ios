#import "CheckinTableViewCell.h"
#import "CheckinBubbleView.h"

@implementation CheckinTableViewCell

@synthesize info, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		UIView *bg = [[UIView alloc] initWithFrame:CGRectNull];
		bg.backgroundColor = [UIColor clearColor];
		self.backgroundView = bg;
		[bg release];
		
		CheckinBubbleView *cb = [[CheckinBubbleView alloc] initWithFrame:CGRectMake(8, 0, 304-54, 0)];
		cb.tag = 100;
		[self addSubview:cb];
		[cb release];
		
    }
    return self;
}

- (void) setDelegate:(id)_delegate {
    ((CheckinBubbleView*)[self viewWithTag:100]).delegate = _delegate;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return CGSizeMake(self.frame.size.width,[self viewWithTag:100].frame.size.height-4);
}

- (void) setInfo:(NSMutableDictionary *)i
{
    [info release];
    info = i;
    [info retain];
	
	((CheckinBubbleView*)[self viewWithTag:100]).info = i;
}

- (void)dealloc 
{
    [info release];
    [super dealloc];
}

@end
