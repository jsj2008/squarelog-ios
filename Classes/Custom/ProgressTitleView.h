#import <UIKit/UIKit.h>

//typedef enum {
//    ProgressTitleStateUp,
//    ProgressTitleStateNormal
//} ProgressTitleState;

@interface ProgressTitleView : UIView {
    
    CADisplayLink *displayLink;
    //ProgressTitleState progressState;
    //NSDate *dateErrorReceived;
    
    CGPoint titlePointUp;
    CGPoint titlePointNormal;
}

- (void)adjustTitle:(NSString*)direction;

@property (nonatomic, assign) NSString *title;

@end
