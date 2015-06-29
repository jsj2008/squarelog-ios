#import "NSMutableURLRequest+BasicAuth.h"

#import "NSData+Base64.h"

@implementation NSMutableURLRequest (NSURLRequest_BasicAuth)

- (void) basicAuthUsername:(NSString*)username password:(NSString*)password {

    // Set header for HTTP Basic authentication explicitly, to avoid problems with proxies and other intermediaries
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
    [self setValue:authValue forHTTPHeaderField:@"Authorization"];
    
}

@end
