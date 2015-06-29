#import <Foundation/Foundation.h>

@protocol RSViewTreeDelegate
-(void)viewItemTapped:(id)sender;
@end

@interface NSString(RenderTree)

+ (CGFloat) parseRenderTree:(NSDictionary*)renderTree fromString:(NSString*)string
                forWidth:(int)width
                maxLines:(int)maxLines
           lineBreakMode:(UILineBreakMode)lineBreakMode;

+ (CGFloat) parseUIViewTree:(UIView *)parentTree fromString:(NSString*)string
                    forFont:(UIFont*)currentFont
                   forWidth:(int)width
                   maxLines:(int)maxLines
              lineBreakMode:(UILineBreakMode)lineBreakMode
   parseImageViewsFromLinks:(BOOL)parseImageViewsFromLinks
            backgroundColor:(UIColor*)backgroundColor
                   delegate:(id)delegate;

@end
