@class AppRecord;
@class RootViewController;

@interface ImageDownloader : NSObject
{
    NSMutableData *dataToParse;
    NSURLConnection *imageConnection;
    NSString *imageURLString;
    NSIndexPath *indexPath;
    UIImage *image;
    NSOperationQueue *queue;
	NSString *imageOperationClassName;
}

@property (retain) UIImage *image;

- (void)startDownloadUrl:(NSString*)_imageURLString imageOperationClassName:(NSString*)className;
- (void)cancelDownload;

@end