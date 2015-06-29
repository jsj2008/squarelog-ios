#import "NSString+URLEncoding.h"

@implementation NSString (NSString_URLEncoding)

+ (NSString *)percentEncodeString:(NSString *)string {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
                                                                           (CFStringRef)string, 
                                                                           NULL, 
                                                                           (CFStringRef)@";/?:@&=$+{}<>,",
                                                                           kCFStringEncodingUTF8);
    return [result autorelease];
}

@end
