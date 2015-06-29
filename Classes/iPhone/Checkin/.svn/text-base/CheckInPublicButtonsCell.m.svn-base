#import "CheckInPublicButtonsCell.h"
#import "CGHelper.h"

@implementation CheckInPublicButtonsCell

@synthesize delegate;
@dynamic switch1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, 140, 40)];
        l.text = @"Public?";
        l.textColor = HEXCOLOR(0x3A4D85ff);
        l.font =[UIFont boldSystemFontOfSize:14];
        [self addSubview: l];
        [l release];
        
        UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectMake(204, 9, 0, 0)];
        s.tag = 100;
        [self addSubview:s];
        [s release];
    }
    return self;
}

- (UISwitch*) switch1
{
    return (UISwitch*)[self viewWithTag:100];
}

- (void)dealloc {
    [super dealloc];
}


@end
