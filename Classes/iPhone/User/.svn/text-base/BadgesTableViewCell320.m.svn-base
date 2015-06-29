#import "BadgesTableViewCell320.h"
#import "SmallBadgeImageView.h"

@implementation BadgesTableViewCell320

@synthesize info;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        BadgesTableViewCellPlaceholder320 *p = [[BadgesTableViewCellPlaceholder320 alloc] initWithFrame:CGRectMake(17, 2, 284, 40)];
        p.tag = 1111;
        [self addSubview:p];
        [p release];
    }
    return self;
}

//- (void) setSelected:(BOOL) s
//{
//    [super setSelected:s];
//    
//    ((BadgesTableViewCellPlaceholder320*)[self viewWithTag:1111]).backgroundColor = s?[UIColor clearColor]:[UIColor whiteColor];
//}

- (void) setInfo:(NSMutableDictionary *) i
{
    [info release];
    info = [i retain];
    
    int cnt = 0;
    
    if ([i count] > 0) {
        
        
        for (NSDictionary *d in i) {
            
            SmallBadgeImageView *view = [[SmallBadgeImageView alloc] initWithFrame:CGRectMake(19+cnt*41, 4, 36, 36)];
            view.imageUrl = [[d objectForKey:@"icon"] stringByReplacingOccurrencesOfString:@".png" withString:@"_big.png"];
            [self addSubview:view];
            [view release];
            
            if (cnt > 4) {
                break;
            }
            
            cnt++;
        }
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
    } else {
//        
//        [((BadgesTableViewCellPlaceholder320*)[self viewWithTag:1111]) removeFromSuperview];
//        
//        self.textLabel.text = @"No Badges.";
//        self.textLabel.textAlignment = UITextAlignmentCenter;
//        self.textLabel.textColor = [UIColor grayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;        
    }
}

- (void)dealloc {
    [super dealloc];
}

@end

@implementation BadgesTableViewCellPlaceholder320

@synthesize backgroundColor;

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    
    return self;
}

- (void) drawRect:(CGRect)r
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [backgroundColor set];
    CGContextFillRect(ctx, r);
    
    for (int cnt = 0; cnt < 6; cnt++) {
        
        //Create circle and fill it in
        
        CGContextAddArc(ctx, (20 + ((36+5)*cnt)), 20, 20, 0, 2*M_PI, 0);
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillPath(ctx);        
        
        CGContextAddArc(ctx, (20 + ((36+5)*cnt)), 20, 16, 0, 2*M_PI, 0);
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR(0xeeeeeeff) CGColor]);
        CGContextFillPath(ctx);
    
    }
}

@end
