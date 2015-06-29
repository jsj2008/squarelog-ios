#import "UIApplication+Network.h"

static int count;

@implementation UIApplication(Network)
+ (void) startNetworkOperation 
{
	count++;
	if (count == 1) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
	}	
}

+ (void) endNetworkOperation
{
	count = MAX(count--,0);
	if (count == 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	}
}
@end