#import "UIDevice+Machine.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice(Machine)

- (NSString *)machine
{
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *machine = [NSString stringWithUTF8String:name];
    
    // Done with this
    free(name);
    
    return machine;
}

- (BOOL) highQuality 
{
    static int highQuality = -1;
    if (highQuality != -1) return highQuality;
    
    highQuality = !([[[UIDevice currentDevice] machine] isEqualToString:@"iPhone1,1"] || 
    [[[UIDevice currentDevice] machine] isEqualToString:@"iPhone1,2" ]);
    
    return highQuality;
}

- (BOOL) isMultitaskingDevice 
{
    BOOL multTask = NO;
    
    if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
        multTask = [self isMultitaskingSupported];
    }
        
    return multTask;
}

@end