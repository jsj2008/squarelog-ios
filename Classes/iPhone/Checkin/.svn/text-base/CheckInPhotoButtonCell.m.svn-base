#import "CheckInPhotoButtonCell.h"
#import "DismissibleLabel.h"
#import "CGHelper.h"
#import "UIScreen+Scale.h"
#import "UIView+ShadowBug.h"
#import "ImageDownloader.h"
#import "ImageDownloaderOperations.h"

@implementation CheckInPhotoButtonCell

@synthesize delegate, imageFileNames;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        
        NSString *buttonText = @"Tap to add photos...";
        UIFont *buttonFont = [UIFont boldSystemFontOfSize:14];
        CGSize s = [buttonText sizeWithFont:buttonFont];
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake((int)(320-s.width)/2, 0, s.width, 44)];
		[self addSubview:l];
        l.tag = 222;
		l.opaque = NO;
		l.backgroundColor = [UIColor clearColor];
		l.textAlignment = UITextAlignmentCenter;
		l.text = buttonText;
		l.font = buttonFont;
		l.textColor = [UIColor grayColor];
		[l release];
		
    }
    return self;
}

- (void) setImageFileNames:(NSArray *) a
{
    [imageFileNames release];
    imageFileNames = a;
    [imageFileNames retain];
    
    if (imageFileNames == nil || [imageFileNames count] == 0) {
        
        NSString *buttonText = @"Tap to add photos...";
        UIFont *buttonFont = [UIFont boldSystemFontOfSize:14];
        CGSize s = [buttonText sizeWithFont:buttonFont];
        
        [self viewWithTag:222].frame = CGRectMake((int)(320-s.width)/2, 0, s.width, 44);

        [self viewWithTag:222].hidden = NO;
        [self viewWithTag:111].hidden = YES;
        
    } else {
    
        UIView *images = [self viewWithTag:111];
        images.hidden = NO;
        if (images == nil) {    
            images = [[UIView alloc] initWithFrame:CGRectMake(20, 3, 38*6+5*4, 38)];
            images.tag = 111;
            [self addSubview:images];
        }
        
        for (UIView *v in [images subviews]) {
            [v removeFromSuperview];
        }
        
        CGPoint pt = CGPointZero;
        
        for (NSString *imageFilePath in imageFileNames) {
            
            UIImage *img = [UIImage imageWithContentsOfFile:[imageFilePath stringByAppendingString:@"_thumb"]];
//            UIImage *shaded_img = nil;
//            {
//            
//            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
//            CGContextAddRoundRect(context, rect, 4, RoundRectAllCorners);
//            CGContextClip(context);
//            CGContextDrawImage (context, rect, img.CGImage);
//
//            UIImage *rounded_img = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//                
//            UIGraphicsBeginImageContext(CGSizeMake(img.size.width, img.size.height));    
//
//            context = UIGraphicsGetCurrentContext();
//            CGContextSaveGState(context);
//            CGContextSetShadowWithColor(context, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 2, [UIColor grayColor].CGColor);
//            CGContextDrawImage (context, CGRectMake(1, 1, rounded_img.size.width, rounded_img.size.height), rounded_img.CGImage);
//            CGContextRestoreGState(context);
//                
//            shaded_img = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();                
//            
//            }
            
            UIImage *shaded_img = [SmallAvatarOperation process:img];
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:shaded_img];
            
            iv.transform = CGAffineTransformIdentity;
            iv.transform = CGAffineTransformMakeScale(1.0, -1.0);
            
            CGFloat scale = [[UIScreen mainScreen] backwardsCompatibleScale];
            CGRect x = CGRectMake(pt.x, pt.y, iv.image.size.width/scale, iv.image.size.height/scale);
            iv.frame = x;
            [images addSubview:iv];
            [iv release];
            pt = CGPointMake(pt.x + iv.image.size.width/scale + 2, pt.y);
        }
        
        if ([imageFileNames count] < 4) {
        
            NSString *buttonText = @"Tap again to add more";
            UIFont *buttonFont = [UIFont boldSystemFontOfSize:14];
            CGSize s = [buttonText sizeWithFont:buttonFont];
            ((UILabel*)[self viewWithTag:222]).text = buttonText;
            [self viewWithTag:222].frame = CGRectMake(320-20-s.width, 0, s.width, 44);            
            
        } else {
            
            [self viewWithTag:222].hidden = YES;
        }
        
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
