#include "CGHelper.h"

#include "UIView+ShadowBug.h"

const RoundRectCorners RoundRectTopCorners = RoundRectTopLeftCorner | RoundRectTopRightCorner;
const RoundRectCorners RoundRectBottomCorners = RoundRectBottomLeftCorner | RoundRectBottomRightCorner;
const RoundRectCorners RoundRectAllCorners = RoundRectTopLeftCorner | RoundRectTopRightCorner | RoundRectBottomLeftCorner | RoundRectBottomRightCorner;
const RoundRectCorners RoundRectLeftCorners = RoundRectTopLeftCorner | RoundRectBottomLeftCorner;
const RoundRectCorners RoundRectRightCorners = RoundRectTopRightCorner | RoundRectBottomRightCorner;

void CGContextAddConversationBubble(CGContextRef context, CGRect rect, float radius, RoundRectCorners corners, NSArray *colors)
{
    
	// main cell with shadow
	{
        
		CGContextSaveGState(context);
		CGContextSetShadowWithColor(context, CGSizeMake(0, 2*[UIView shadowVerticalMultiplier]), 2, HEXCOLOR(0x66666699).CGColor);
		CGContextAddRoundRect(context, CGRectMake(2, 2, rect.size.width, rect.size.height), radius, corners);
		[[UIColor whiteColor] setFill];
		CGContextFillPath(context);
		CGContextRestoreGState(context);		
	}
	
	// shadow and body
    
	{
		CGContextSaveGState(context);
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		
		// main
		
		CGContextAddRoundRect(context, CGRectMake(2, 2, rect.size.width, rect.size.height), radius, corners);
		CGContextClip(context);
		
		CGFloat locations[4];
		NSMutableArray *colors1 = [NSMutableArray arrayWithCapacity:4];
		[colors1 addObject:(id)[[colors objectAtIndex:0] CGColor]];
		locations[0] = 0.0f;
		[colors1 addObject:(id)[[colors objectAtIndex:1] CGColor]];
		locations[1] = (float)radius/rect.size.height;
		[colors1 addObject:(id)[[colors objectAtIndex:2] CGColor]];
		locations[2] = 1.0f - (float)radius/rect.size.height;
		[colors1 addObject:(id)[[colors objectAtIndex:3] CGColor]];
		locations[3] = 1.0f;
        
		CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors1, locations);
		CGContextDrawLinearGradient(context, gradient, 
									CGPointMake(0, 1),
									CGPointMake(0, rect.size.height+2),
									0); //(kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation)
		
		//side shadow
		
		CGContextAddRoundRect(context, CGRectMake(2, 2, rect.size.width, rect.size.height), radius, corners);
		CGContextClip(context);
		
		colors1 = [NSMutableArray arrayWithCapacity:4];
		[colors1 addObject:(id)[[colors objectAtIndex:4] CGColor]];
		locations[0] = 0.0f;
		[colors1 addObject:(id)[[colors objectAtIndex:5] CGColor]];
		locations[1] = ((float)radius/2.0)/rect.size.width;
		[colors1 addObject:(id)[[colors objectAtIndex:6] CGColor]];
		locations[2] = 1.0f - ((float)radius/2.0)/rect.size.width;
		[colors1 addObject:(id)[[colors objectAtIndex:7] CGColor]];
		locations[3] = 1.0f;
		
		gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors1, locations);
		CGContextDrawLinearGradient(context, gradient, 
									CGPointMake(3, 0),
									CGPointMake(rect.size.width+2, 0),
									0); //(kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation)		
		
		CGGradientRelease(gradient);
		CGColorSpaceRelease(space);
		
		//glare
		
		CGContextAddRoundRect(context, CGRectMake(8, 3, rect.size.width-(radius)-1, radius), (int)(float)radius/2.0f, corners);
		CGContextClip(context);
		
		CGFloat locations_glare[2];
		
		colors1 = [NSMutableArray arrayWithCapacity:2];
		[colors1 addObject:(id)[[colors objectAtIndex:8] CGColor]];
		locations_glare[0] = 0.0f;
		[colors1 addObject:(id)[[colors objectAtIndex:9] CGColor]];
		locations_glare[1] = 1.0f;
		
		gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors1, locations_glare);
		CGContextDrawLinearGradient(context, gradient, 
									CGPointMake(0, 3),
									CGPointMake(0, 13),
									0); //(kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation)		
		
		CGGradientRelease(gradient);
		CGColorSpaceRelease(space);	
		CGContextRestoreGState(context);
	}
	
	{
		float alignStroke = 0.5f;//fmodf(0.5f * stroke, 1.0f);
		
		[(UIColor*)[colors objectAtIndex:10] setStroke];
		CGContextAddRoundRect(context, CGRectMake(2+alignStroke, 2+alignStroke, rect.size.width, rect.size.height), radius, RoundRectAllCorners);
		CGContextSetLineWidth(context, 1);
		CGContextSetLineCap(context, kCGLineCapSquare);
		CGContextStrokePath(context);
	}
    
}

void CGContextAddRoundRect(CGContextRef context, CGRect rect, float radius, RoundRectCorners corners)
{
    
	int pad = 0;
	
	CGFloat minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect); //midx = CGRectGetMidX(rect),
	CGFloat miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
	
	//top left
	if ((corners & RoundRectTopLeftCorner) == RoundRectTopLeftCorner){
        
        CGContextMoveToPoint(context, minx + radius - pad, miny - pad);
		
	} else {
		
		CGContextMoveToPoint(context, minx - pad, miny - pad);
	}
	
	//top right
	if ((corners & RoundRectTopRightCorner) == RoundRectTopRightCorner) {		
		CGContextAddArc(context, 
						maxx - radius + pad, 
						miny + radius - pad, radius, 3 * M_PI / 2, 0, 0);
		
	} else {
		
		CGContextAddLineToPoint(context, maxx + pad, 
                                miny - pad);
		
	}
	
	//bottom right
	if ((corners & RoundRectBottomRightCorner) == RoundRectBottomRightCorner) {
		
		
		CGContextAddArc(context, 
						maxx - radius + pad, 
						maxy - radius + pad, radius, 0, M_PI / 2, 0);
		
	} else {
		
		CGContextAddLineToPoint(context, maxx + pad, 
                                maxy + pad);		
	}
	
	//bottom right
	if ((corners & RoundRectBottomLeftCorner) == RoundRectBottomLeftCorner) {
		CGContextAddArc(context, 
						minx + radius - pad, 
						maxy - radius + pad, radius, M_PI / 2, M_PI, 0);
	}
	else {
		CGContextAddLineToPoint(context, minx - pad, 
                                maxy + pad);	
	}
    
	//bottom left
	if ((corners & RoundRectTopLeftCorner) == RoundRectTopLeftCorner) {
		CGContextAddArc(context, 
						minx + radius - pad, 
						miny + radius - pad, radius, M_PI, 3 * M_PI / 2, 0);
	} else {
		CGContextAddLineToPoint(context, minx - pad, 
                                miny - pad);	
	}
    
}