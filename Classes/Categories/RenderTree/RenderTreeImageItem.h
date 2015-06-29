#import <Foundation/Foundation.h>

@interface RenderTreeImageItem : NSObject {
    UIImage *image;
    CGRect rect;
}

@property (nonatomic, retain) UIImage *image;
@property CGRect rect;

@end
