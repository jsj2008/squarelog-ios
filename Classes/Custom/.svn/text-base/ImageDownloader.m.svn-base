#import <QuartzCore/QuartzCore.h>
#import "UIApplication+Network.h"
#import "UIScreen+Scale.h"
#import "UIView+ShadowBug.h"
#import "ImageDownloader.h"
#import "ImageCache.h"
#import "CGHelper.h"
#import "UIImage+Helper.h"

@implementation ImageDownloader

@synthesize image;

#pragma mark

- (void)dealloc
{
    [dataToParse release];   
    [imageConnection cancel];
    [imageConnection release];
	[queue release];
    [super dealloc];
}

- (void)startDownloadUrl:(NSString*)_imageURLString imageOperationClassName:(NSString*)className
{
    imageURLString = _imageURLString;
	imageOperationClassName = className;
    
    dataToParse = [[NSMutableData data] retain];
    [imageConnection release];
    imageConnection = [[NSURLConnection alloc] initWithRequest:
                       [NSURLRequest requestWithURL:
                        [NSURL URLWithString:imageURLString]] delegate:self];
	
	[UIApplication startNetworkOperation];
}

- (void)cancelDownload
{
    [imageConnection cancel]; imageConnection = nil;
    [dataToParse release]; dataToParse = nil;
    [queue release]; queue = nil;
	
	[UIApplication endNetworkOperation];
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
	if ([((NSHTTPURLResponse*)response) statusCode] >= 400) {
		[imageConnection cancel]; [imageConnection release]; imageConnection = nil;
        [dataToParse release]; dataToParse = nil;        
        [UIApplication endNetworkOperation];
	}
	
    [dataToParse setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataToParse appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication endNetworkOperation];
    [dataToParse release];
    dataToParse = nil;
    imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    [UIApplication endNetworkOperation];
    
    queue = [[NSOperationQueue alloc] init];
    
    NSOperation *to = [[NSClassFromString(imageOperationClassName) alloc] initWithData:dataToParse delegate:self];
    [queue addOperation:to];
    [to release];
}

- (void) doneProcessingImage:(UIImage*) _image {
    
    [[ImageCache sharedImageCache] storeImage:_image
                                      withKey:[ImageCache newKeyWithKey:imageURLString className:imageOperationClassName]];
    
    if ([self respondsToSelector:@selector(setImage:)]) {
        [self performSelectorOnMainThread:@selector(setImage:) withObject:_image waitUntilDone:YES];
    }
}

@end
