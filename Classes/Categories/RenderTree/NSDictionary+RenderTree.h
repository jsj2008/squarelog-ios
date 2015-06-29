#import <UIKit/UIKit.h>
void DrawRenderItems(NSArray *items, CGPoint point, BOOL selected);
@interface NSDictionary(RenderTree)
+ (CGSize) drawAtPoint:(CGPoint)point withRenderTree:(NSDictionary*)renderTree selected:(BOOL)selected;
- (CGSize) drawAtPoint:(CGPoint)point selected:(BOOL)selected;
@end
