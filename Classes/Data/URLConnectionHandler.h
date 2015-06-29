#import <Foundation/Foundation.h>

#define TIMEOUT_INTERVAL 10.0

@interface URLConnectionHandler : NSObject {
	
    NSURLConnection *theConnection;
    NSMutableData *receivedData;
    NSError *error;
    
    NSDate *lastLookup;
    
    double contentTotalSize;
    double contentDownloadedSize;    
}

- (BOOL)inProgress;
- (void)cancel;
- (void)sendRequest:(NSMutableURLRequest*)theRequest;
- (void)handleError:(NSError*)error;

@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) NSDate *lastLookup;

@end
