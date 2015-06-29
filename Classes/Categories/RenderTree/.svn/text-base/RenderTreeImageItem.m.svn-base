#import "RenderTreeImageItem.h"

@implementation RenderTreeImageItem

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        
        self.image = [coder decodeObjectForKey:@"image"];
        rect = [coder decodeCGRectForKey:@"rect"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:image forKey:@"image"];
    [coder encodeCGRect:rect forKey:@"rect"];
}

- (void) dealloc
{
    [super dealloc];
    [image release];
}

@synthesize image, rect;
@end
