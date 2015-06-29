#import "NSDictionary+RenderTree.h"
#import "UIView+ShadowBug.h"

#import "RenderTreeImageItem.h"
#import "RenderTreeTextItem.h"

void DrawRenderItems(NSArray *items, CGPoint point, BOOL selected) {
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    for (id uncastItem in items) {
		
		if ([uncastItem class] == [RenderTreeImageItem class]) {
            
            RenderTreeImageItem *item = (RenderTreeImageItem*)uncastItem;
            
			[item.image drawInRect:CGRectOffset(item.rect, point.x, point.y)];
			
		} else { // text
            
            RenderTreeTextItem *item = (RenderTreeTextItem*)uncastItem;
			
            if (selected) [[UIColor whiteColor] set];
            else [item.color set];
            
            if (item.shadowColor) {
                CGContextSaveGState(c);	
                CGContextSetShadowWithColor(c, CGSizeMake(0, 1*[UIView shadowVerticalMultiplier]), 1, item.shadowColor.CGColor);
            }
            
            if (!CGRectEqualToRect(item.rect, CGRectZero)) {
                
                if (item.alignment != -1) {
                    
                    [item.text
                     drawInRect:CGRectMake(item.rect.origin.x + point.x, item.rect.origin.y + point.y, item.rect.size.width, item.rect.size.height)
                     withFont:item.font
                     lineBreakMode:UILineBreakModeTailTruncation 
                     alignment:item.alignment];
                    
                } else {
                    
                    [item.text
                     drawInRect:CGRectMake(item.rect.origin.x + point.x, item.rect.origin.y + point.y, item.rect.size.width, item.rect.size.height) 
                     withFont:item.font
                     lineBreakMode:UILineBreakModeTailTruncation];                    
                }
                
            } else {        
                
                [item.text 
                 drawAtPoint:CGPointMake(item.point.x + point.x, item.point.y + point.y) 
                 withFont:item.font];
            }
            
            if (item.shadowColor) {
                
                CGContextRestoreGState(c);	
            }            
		}
	}
}

@implementation NSDictionary(RenderTree)

+ (CGSize) drawAtPoint:(CGPoint)point withRenderTree:(NSDictionary*)renderTree selected:(BOOL)selected;
{
	NSArray *items = (NSArray*)[renderTree objectForKey:@"items"];
    DrawRenderItems(items, point, selected);
	return CGSizeZero;
}
- (CGSize) drawAtPoint:(CGPoint)point selected:(BOOL)selected
{
    return [NSDictionary drawAtPoint:point withRenderTree:self selected:selected];
}
@end
