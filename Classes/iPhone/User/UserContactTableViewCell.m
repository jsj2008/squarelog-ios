#import "UserContactTableViewCell.h"

@implementation UserContactTableViewCell

@synthesize contactType, contactDetail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        
        contactType = [[UILabel alloc] init];
        contactType.font = [UIFont boldSystemFontOfSize:13];
        contactType.textAlignment = UITextAlignmentRight;
        contactType.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
        contactType.frame = CGRectMake(20, (44-13)/2+2, 60, 13);
        [self addSubview:contactType];
        
        contactDetail = [[UILabel alloc] initWithFrame:CGRectZero];
        contactDetail.font = [UIFont boldSystemFontOfSize:15];
        contactDetail.textColor = [UIColor blackColor];
        contactDetail.frame = CGRectMake(90, (44-20)/2, 220, 20);
        contactDetail.adjustsFontSizeToFitWidth = YES;
        [self addSubview:contactDetail];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    if (selected) {
        
        contactDetail.textColor = [UIColor whiteColor]; 
        contactType.textColor = [UIColor whiteColor];
        
    } else {
        
        contactDetail.textColor = [UIColor blackColor]; 
        contactType.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];       
    }
}


- (void)dealloc {
    [contactType release];
    [contactDetail release];
    [super dealloc];
}

@end
