#import "NSString+Path.h"

@implementation NSString(Path)

- (void) createFilePathStructure
{
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDirectory])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:&error];
        [error release];
    }
}

@end
