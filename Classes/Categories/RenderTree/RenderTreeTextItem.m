#import "RenderTreeTextItem.h"

@implementation RenderTreeTextItem

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        
        self.text = [coder decodeObjectForKey:@"text"];
        point = [coder decodeCGPointForKey:@"point"];
        rect = [coder decodeCGRectForKey:@"rect"];
        self.font = [coder decodeObjectForKey:@"font"];
        self.color = [coder decodeObjectForKey:@"color"];
        self.shadowColor = [coder decodeObjectForKey:@"shadowColor"];
        self.alignment = [coder decodeIntForKey:@"alignment"];        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:text forKey:@"text"];
    [coder encodeCGPoint:point forKey:@"point"];
    [coder encodeCGRect:rect forKey:@"rect"];
    [coder encodeObject:font forKey:@"font"];
    [coder encodeObject:color forKey:@"color"];
    [coder encodeObject:shadowColor forKey:@"shadowColor"];
    [coder encodeInt:alignment forKey:@"alignment"];
}

- (id) init
{
    if (self = [super init]) {
        self.alignment = -1;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [text release];
    [font release];
    [color release];
    [shadowColor release];
}

@synthesize text, point, rect, color, shadowColor, alignment, font;
@end
