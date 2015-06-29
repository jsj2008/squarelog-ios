#import "UIImage+Helper.h"
#import "CGHelper.h"
#import "UIScreen+Scale.h"

@implementation UIImage(Helper)

+ (UIImage *)roundedCornerImage:(UIImage *)image radius:(NSInteger)radius
{
    
    if(!image) return nil;
    int w = image.size.width;
    int h = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextAddRoundRect(context, rect, radius, RoundRectAllCorners);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return newImage;
}

+ (UIImage *) grayBoxWithRoundedCornersRadius:(NSInteger)radius size:(CGSize)size
{
    
    UIGraphicsBeginImageContext(CGSizeMake(75, 75));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRef maskedContextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(maskedContextRef);
    
    CGContextAddRoundRect(context, CGRectMake(0, 0, 75, 75), radius, RoundRectAllCorners);
    CGContextClip(context);
    
    [HEXCOLOR(0xE6E6E6ff) set];
    CGContextFillRect(context, CGRectMake(0, 0, 75, 75));
    
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(maskedContextRef);
    
    return i;
}

@end
