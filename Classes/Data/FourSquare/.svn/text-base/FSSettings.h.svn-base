#define FS_API_BASE_URL @"https://api.foursquare.com/v1"
//#define FS_API_BASE_URL @"http://localhost:8894/api_copy/v1"
//#define FS_API_BASE_URL @"http://squarelogappdev.appspot.com/api_copy/v1"

//#define USE_TEST_CHECKIN_ACCOUNT

#define REFRESH_EXPIRE_SECONDS 5*60

@interface FSSettings : NSObject {
}

+ (FSSettings*)sharedInstance;
- (void) setPassword:(NSString *)_password forUsername:(NSString*)_username;
- (void) clearPasswordForCurrentUser;
- (BOOL) isLoggedIn;

@property (readonly) NSString* username;
@property (readonly) NSString* password;

@end