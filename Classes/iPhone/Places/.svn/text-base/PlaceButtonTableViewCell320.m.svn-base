#import "PlaceButtonTableViewCell320.h"
#import "ButtonBuilder.h"

@implementation PlaceButtonTableViewCell320

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        
        UIButton *button1 = [ButtonBuilder button1];
        //[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button1 setTitle:@"Post a Shout" forState:UIControlStateNormal];
        button1.frame = CGRectMake(10, 8, 145, 38);
        button1.tag = 1000;
        [self addSubview:button1];
        
        UIButton *button2 = [ButtonBuilder button1];
        //[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button2 setTitle:@"My Checkins" forState:UIControlStateNormal];
        button2.frame = CGRectMake(165, 8, 145, 38);
        button2.tag = 1001;
        [self addSubview:button2];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDelegate:(id)_delegate
{
    delegate = _delegate;
    [(UIButton*)[self viewWithTag:1000] addTarget:self.delegate action:@selector(addShoutTapped:) forControlEvents:UIControlEventTouchUpInside];
    [(UIButton*)[self viewWithTag:1001] addTarget:self.delegate action:@selector(lastCheckinsTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) drawRect:(CGRect)r
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [HEXCOLOR(0xcdcdcdff) setStroke];
    CGContextMoveToPoint(context, 0, CGRectGetMaxY(r)-.5);
    CGContextAddLineToPoint(context, r.size.width, CGRectGetMaxY(r)-.5);
    CGContextStrokePath(context);
}

- (void)dealloc {
    [super dealloc];
}


@end
