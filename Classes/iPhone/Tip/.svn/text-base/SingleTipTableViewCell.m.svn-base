#import "SingleTipTableViewCell.h"
#import "SingleTipView.h"

@implementation SingleTipTableViewCell

@synthesize tipData, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		SingleTipView *cb = [[SingleTipView alloc] initWithFrame:CGRectMake(10, 10, 280, 0)];
		cb.tag = 100;
		[self addSubview:cb];
		[cb release];
		
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return CGSizeMake(self.frame.size.width,[self viewWithTag:100].frame.size.height+20);
}

- (void) setDelegate:(id)_delegate {
    ((SingleTipView*)[self viewWithTag:100]).delegate = _delegate;
}

- (void) setTipData:(NSMutableDictionary *)i
{
    [tipData release];
    tipData = i;
    [tipData retain];
	
	((SingleTipView*)[self viewWithTag:100]).tipData = i;
}

- (void)dealloc {
    [tipData release];
    [super dealloc];
}


@end
