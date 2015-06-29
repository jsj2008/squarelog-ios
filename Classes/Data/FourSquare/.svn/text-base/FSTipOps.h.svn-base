#import <Foundation/Foundation.h>

#import "URLConnectionHandler.h"

@interface FSTipOps : URLConnectionHandler {
    
    BOOL success;
}

+ (FSTipOps*)sharedInstance;

- (void)marktodo:(NSInteger)tipId;
- (void)markdone:(NSInteger)tipId;
- (void)unmark:(NSInteger)tipId;

@property BOOL success;

@end
