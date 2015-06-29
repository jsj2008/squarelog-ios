#import "CheckInShareButtonsCell.h"
#import "CGHelper.h"
#import "ShareToggleButton.h"

@implementation CheckInShareButtonsCell

@synthesize delegate, spinner;
@dynamic twitterButton, facebookButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 100, 40)];
        l.text = @"Share on ...";
        l.textColor = HEXCOLOR(0x3A4D85ff);
        l.font =[UIFont boldSystemFontOfSize:14];
        [self addSubview: l];
        [l release];
        
        UIButton *b = [ShareToggleButton facebook];
        [b addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b.frame = CGRectMake(226, 7, 32, 32);
        b.tag = 101;
        [self addSubview:b];
        
        b = [ShareToggleButton twitter];
        [b addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        b.frame = CGRectMake(268, 7, 30, 31);
        b.tag = 102;
        [self addSubview:b];
        
    }
    return self;
}

- (void)buttonTapped:(id)sender 
{
 
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
}

- (void)setSpinner:(BOOL)_spinner {
    
    spinner = _spinner;
    
    if (spinner) {
        UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        v.tag = 1000;
        [v startAnimating];
        v.center = CGPointMake(254, 44/2.0);
        [self addSubview:v];
        [v release];
        
        [self viewWithTag:101].hidden = YES;
        [self viewWithTag:102].hidden = YES;
    } else {
        
        [self viewWithTag:101].hidden = NO;
        [self viewWithTag:102].hidden = NO;
        
        [[self viewWithTag:1000] removeFromSuperview];
    }
    
    [self setNeedsDisplay];
}

- (UIButton*) twitterButton {
    
    return (UIButton*)[self viewWithTag:102];
}

- (UIButton*) facebookButton {
    
    return (UIButton*)[self viewWithTag:101];
}

- (void) layoutSubviews 
{
    CGPoint point = CGPointMake(298, 7);
    
    NSArray *buttons = [NSArray arrayWithObjects:self.twitterButton, self.facebookButton, nil];
    
    for (UIButton *button in buttons) {
     
        if (!button.hidden) {
            
            button.frame = CGRectMake(point.x-button.frame.size.width, point.y, button.frame.size.width, button.frame.size.height);
            point = CGPointMake(point.x-button.frame.size.width-10, point.y);
        }
    }
}

- (void) showTwitterButton:(BOOL)show {
    self.twitterButton.hidden = !show;
}

- (void) showFacebookButton:(BOOL)show {
    self.facebookButton.hidden = !show;
}

- (void)dealloc {
    [super dealloc];
}


@end
