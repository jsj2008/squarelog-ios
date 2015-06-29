#import "FSCheckin.h"

@implementation FSCheckin
@synthesize userId, date, renderTree, avatarUrl, checkinType, height, data;

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
    
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.date = [coder decodeObjectForKey:@"date"];
        self.renderTree = [coder decodeObjectForKey:@"renderTree"];
        self.height = [coder decodeObjectForKey:@"height"];
        self.avatarUrl = [coder decodeObjectForKey:@"avatarUrl"];
        checkinType = [coder decodeIntForKey:@"checkinType"];
        self.data = [coder decodeObjectForKey:@"data"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    //[super encodeWithCoder:coder];
    
    [coder encodeObject:userId forKey:@"userId"];
    [coder encodeObject:date forKey:@"date"];
    [coder encodeObject:renderTree forKey:@"renderTree"];
    [coder encodeObject:height forKey:@"height"];
    [coder encodeObject:avatarUrl forKey:@"avatarUrl"];
    [coder encodeInt:checkinType forKey:@"checkinType"];
    [coder encodeObject:data forKey:@"data"];    
}

- (void) dealloc 
{
    self.data = nil;
    self.renderTree = nil;
    LOG_EXPR([self.renderTree retainCount]);
    LOG_EXPR([self.data retainCount]);
    
    [super dealloc];
}
@end
