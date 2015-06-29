#import <Foundation/Foundation.h>

#import "URLConnectionHandler.h"

@protocol FSBaseAuthDelegate
- (void) successfulAuthWithContext:(id)context;
- (void) failedAuthWithContext:(id)context error:(NSError*)error;
@end

@interface FSBaseAuth : URLConnectionHandler {
    
	NSString *username;
	NSString *password;
	
	id delegate;
    id context;
    
    NSDictionary *authUser;
}

+ (FSBaseAuth*)sharedInstance;

- (void) authenticatedUser;
- (void) authenticateWithUsername:(NSString*)_username 
                         password:(NSString*)_password 
                         delegate:(id<FSBaseAuthDelegate>)_delegate;

@property (nonatomic, assign) id context;
@end