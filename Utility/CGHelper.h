#import <CoreGraphics/CoreGraphics.h>

#ifndef M_PI 
#define M_PI 3.1415926535897932385 
#endif

//#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
//                                green:((c>>16)&0xFF)/255.0 \
//                                blue:((c>>8)&0xFF)/255.0 \
//                                alpha:((c)&0xFF)/255.0]

enum {
	RoundRectNoCorners = 0,
	RoundRectTopLeftCorner = 1 << 0,
	RoundRectTopRightCorner = 1 << 1,
	RoundRectBottomRightCorner = 1 << 2,
	RoundRectBottomLeftCorner = 1 << 3,
};
typedef int RoundRectCorners;

extern const RoundRectCorners RoundRectTopCorners;
extern const RoundRectCorners RoundRectBottomCorners;
extern const RoundRectCorners RoundRectLeftCorners;
extern const RoundRectCorners RoundRectRightCorners;
extern const RoundRectCorners RoundRectAllCorners;

void CGContextAddConversationBubble(CGContextRef context, CGRect rect, float radius, RoundRectCorners corners, NSArray *colors);
void CGContextAddRoundRect(CGContextRef context, CGRect rect, float radius, RoundRectCorners corners);