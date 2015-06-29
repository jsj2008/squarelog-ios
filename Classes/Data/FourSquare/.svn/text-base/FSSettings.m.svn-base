#import "FSSettings.h"

#import "SFHFKeychainUtils.h"
#import "GTMObjectSingleton.h"

#define SERVICE_NAME @"foursquare"

@implementation FSSettings

@dynamic username, password;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSSettings, sharedInstance)

- (void) setPassword:(NSString *)_password forUsername:(NSString*)_username 
{
    [SFHFKeychainUtils storeUsername:_username
                        andPassword:_password 
                     forServiceName:SERVICE_NAME 
                     updateExisting:YES 
                              error:nil];
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	[standardUserDefaults setObject:_username forKey:@"username"];
	[standardUserDefaults synchronize];
}

- (NSString*) username 
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString*) password
{
    return [SFHFKeychainUtils getPasswordForUsername:self.username andServiceName:SERVICE_NAME error:nil];
}

- (BOOL) isLoggedIn
{
    return [[SFHFKeychainUtils getPasswordForUsername:self.username andServiceName:SERVICE_NAME error:nil] length] > 0;
}

- (void) clearPasswordForUsername:(NSString*)_username 
{
    [SFHFKeychainUtils storeUsername:_username
                         andPassword:@"" 
                      forServiceName:SERVICE_NAME
                      updateExisting:YES 
                               error:nil];
}

- (void) clearPasswordForCurrentUser
{
    [self clearPasswordForUsername:[self username]];
}

@end
