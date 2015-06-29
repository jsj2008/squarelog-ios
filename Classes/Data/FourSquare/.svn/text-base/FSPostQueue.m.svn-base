#import "GTMObjectSingleton.h"

#import "FSPostQueue.h"
#import "FSCheckin.h"
#import "FSCheckinsLookup.h"
#import "FSSettings.h"
#import "SLSettings.h"

#import "ReachabilityHelper.h"

#import "PostModel.h"
#import "ImageModel.h"
#import "AppDelegate.h"

#import "NSObject+YAJL.h"
#import "NSDictionary+REST.h"
#import "UIApplication+Network.h"
#import "NSMutableURLRequest+BasicAuth.h"

#import "PostModel+Extra.h"
#import "UIDevice+Machine.h"

#import "UIView+ModalOverlay.h"

#import "UIApplication+TopView.h"

#define API_CALL_LENGTH 50000

@implementation FSPostQueue

@synthesize progress, failedDate;

#pragma mark -
#pragma mark Singleton definition

GTMOBJECT_SINGLETON_BOILERPLATE(FSPostQueue, sharedInstance)

#pragma mark -
#pragma mark class instance methods

+ (void) addTipWithVenueId:(NSInteger)venueId
                      text:(NSString*)text
                      type:(FSTipType)type
                  location:(CLLocation*)location
                    images:(NSArray*)tempImagesPaths
{
    
    /*
	 vid - (optional, not necessary if you are 'shouting' or have a venue name). ID of the venue where you want to check-in
	 venue - (optional, not necessary if you are 'shouting' or have a vid) if you don't have a venue ID or would rather prefer a 'venueless' checkin, pass the venue name as a string using this parameter. it will become an 'orphan' (no address or venueid but with geolat, geolong)
	 shout - (optional) a message about your check-in. the maximum length of this field is 140 characters
	 private - (optional). "1" means "don't show your friends". "0" means "show everyone"
	 twitter - (optional, defaults to the user's setting). "1" means "send to Twitter". "0" means "don't send to Twitter"
	 facebook - (optional, defaults to the user's setting). "1" means "send to Facebook". "0" means "don't send to Facebook"
	 geolat - (optional, but recommended)
	 geolong - (optional, but recommended)
	 */
	
	PostModel *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:ManagedObjectContext()];
    post.type = [NSNumber numberWithInt:PostStyleTip];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSNumber numberWithInt:venueId] stringValue], @"vid",
                                   [[NSNumber numberWithFloat:location.coordinate.latitude] stringValue], @"geolat",
                                   [[NSNumber numberWithFloat:location.coordinate.longitude] stringValue], @"geolon",
                                   text, @"text",
                                   type==FSTipTypeTip?@"tip":@"todo", @"type",
                                   nil];
    
    for (NSString *path in [tempImagesPaths reverseObjectEnumerator]) {
        
        ImageModel *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:ManagedObjectContext()];
        image.dateCreated = [NSDate date];
        image.localPath = path;
        [post addImagesObject:image];
        
        [self preProcessReqDataForImagePath:path params:params];
    }    
    
	post.request = [NSKeyedArchiver archivedDataWithRootObject:params];
	post.dateCreated = [NSDate date];
	[[post managedObjectContext] save:nil];
    
    NSError *err = nil;
    [ManagedObjectContext() save:&err];
    NSAssert(!err, @"err saving PostModel");    
    
    [[FSPostQueue sharedInstance] computeQueuedBytes];
	[[FSPostQueue sharedInstance] uploadNext];
}

+ (void) addCheckinWithVenueId:(NSInteger)venueId
						  shout:(NSString*)shout 
					   location:(CLLocation*)location 
						offgrid:(BOOL)offgrid 
						twitter:(BOOL)twitter 
					   facebook:(BOOL)facebook
						 images:(NSArray*)tempImagesPaths
                          style:(PostStyle)checkinStyle
                           data:(NSDictionary*)data //extra
{
	
	/*
	 vid - (optional, not necessary if you are 'shouting' or have a venue name). ID of the venue where you want to check-in
	 venue - (optional, not necessary if you are 'shouting' or have a vid) if you don't have a venue ID or would rather prefer a 'venueless' checkin, pass the venue name as a string using this parameter. it will become an 'orphan' (no address or venueid but with geolat, geolong)
	 shout - (optional) a message about your check-in. the maximum length of this field is 140 characters
	 private - (optional). "1" means "don't show your friends". "0" means "show everyone"
	 twitter - (optional, defaults to the user's setting). "1" means "send to Twitter". "0" means "don't send to Twitter"
	 facebook - (optional, defaults to the user's setting). "1" means "send to Facebook". "0" means "don't send to Facebook"
	 geolat - (optional, but recommended)
	 geolong - (optional, but recommended)
	 */
	
	PostModel *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:ManagedObjectContext()];
    post.type = [NSNumber numberWithInt:checkinStyle];
    post.dateCreated = [NSDate date];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
  																	  [[NSNumber numberWithBool:twitter] stringValue], @"twitter",
																	  [[NSNumber numberWithBool:facebook] stringValue], @"facebook",
                                                                      shout, @"shout",
																	  nil];

    if (venueId) {
        [params setObject:[[NSNumber numberWithInt:venueId] stringValue] forKey:@"vid"];
    }
    
    if (checkinStyle != PostStyleShout) {
        
        [params setObject:[[NSNumber numberWithBool:offgrid] stringValue] forKey:@"private"];
    }
    
    NSMutableDictionary *venue_copy = [NSMutableDictionary dictionary];
    if (location.coordinate.latitude != 0 && location.coordinate.longitude != 0) {
        
        [venue_copy setObject:[[NSNumber numberWithFloat:location.coordinate.latitude] stringValue] forKey:@"geolat"];
        [venue_copy setObject:[[NSNumber numberWithFloat:location.coordinate.longitude] stringValue] forKey:@"geolong"];         
    }
    
    if ([[data objectForKey:@"venue"] objectForKey:@"city"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"city"] forKey:@"city"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"state"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"state"] forKey:@"state"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"distance"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"distance"] forKey:@"distance"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"address"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"address"] forKey:@"address"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"name"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"name"] forKey:@"name"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"crossstreet"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"crossstreet"] forKey:@"crossstreet"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"id"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"id"] forKey:@"id"];
    }
    if ([[data objectForKey:@"venue"] objectForKey:@"iconurl"]) {
        [venue_copy setObject:[[data objectForKey:@"venue"] objectForKey:@"iconurl"] forKey:@"iconurl"];
    }

    data = [NSMutableDictionary dictionaryWithObjectsAndKeys:venue_copy, @"venue", nil];
    
    [(NSMutableDictionary*)data setObject:shout forKey:@"shout"]; 
    
    for (NSString *path in [tempImagesPaths reverseObjectEnumerator]) {
     
        ImageModel *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:ManagedObjectContext()];
        image.dateCreated = [NSDate date];
        image.localPath = path;
        [post addImagesObject:image];
        
        NSMutableDictionary *uploadParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [uploadParams setObject:[[NSNumber numberWithDouble:[post.dateCreated timeIntervalSince1970]] stringValue] forKey:@"batchid"];
        
        if ([[data objectForKey:@"venue"] objectForKey:@"address"]) {
            [uploadParams setObject:[[data objectForKey:@"venue"] objectForKey:@"address"] forKey:@"venue_address"];
        }
        if ([[data objectForKey:@"venue"] objectForKey:@"name"]) {
            [uploadParams setObject:[[data objectForKey:@"venue"] objectForKey:@"name"] forKey:@"venue_name"];
        }
        if ([[data objectForKey:@"venue"] objectForKey:@"crossstreet"]) {
            [uploadParams setObject:[[data objectForKey:@"venue"] objectForKey:@"crossstreet"] forKey:@"venue_crossstreet"];
        }
        if ([[data objectForKey:@"venue"] objectForKey:@"city"]) {
            [uploadParams setObject:[[data objectForKey:@"venue"] objectForKey:@"city"] forKey:@"venue_city"];
        }
        if ([[data objectForKey:@"venue"] objectForKey:@"state"]) {
            [uploadParams setObject:[[data objectForKey:@"venue"] objectForKey:@"state"] forKey:@"venue_state"];
        }
        
        _NSLog(@"Post postVals: %@",[uploadParams description]);
        
        [FSPostQueue preProcessReqDataForImagePath:path params:uploadParams];
    }
    
    _NSLog(@"Post postVals: %@",[params description]);
	
	post.request = [NSKeyedArchiver archivedDataWithRootObject:params];
    post.data = [NSKeyedArchiver archivedDataWithRootObject:data];
    
    NSError *err = nil;
	[ManagedObjectContext() save:&err];
    NSAssert(!err, @"err saving PostModel");

    [[FSPostQueue sharedInstance] computeQueuedBytes];
	[[FSPostQueue sharedInstance] uploadNext];
}

+ (void) preProcessReqDataForImagePath:(NSString*)path params:(NSDictionary*)params
{
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    NSMutableDictionary *postVals = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [postVals setObject:SQUARELOG_API_KEY forKey:@"api-key"];
    
    _NSLog(@"Image postVals: %@",[postVals description]);
    
    [postVals setObject:fileData forKey:@"image"];
    NSData *restData = [postVals RESTMultipartHTTPPostDataWithBoundary:[NSString stringWithFormat:@"bound%d", 1234567]];
    [restData writeToFile:[path stringByAppendingString:@"_rest"] atomically:YES];
}

#pragma mark -

- (id) init 
{
    if (self = [super init]) {
 
        [[ReachabilityHelper sharedInstance] addObserver:self
                                              forKeyPath:@"networkStatus"
                                                 options:(NSKeyValueObservingOptionNew)
                                                 context:NULL];
        
        active = FALSE;
    }
    return self;
}

- (void) computeProgress
{
    if (totalBytesUploaded>totalBytesQueued) {
        self.progress = [NSNumber numberWithFloat:.99];
    } else if (totalBytesQueued != 0 && totalBytesUploaded != 0) {
        self.progress = [NSNumber numberWithFloat:MIN((totalBytesUploaded/(float)totalBytesQueued),.99)];
    } else {
        self.progress = [NSNumber numberWithFloat:.05];
    }
    
    _NSLog(@"computeProgress");
}

- (void) computeQueuedBytes
{
    
    totalBytesQueued = 0;
    
    NSArray* results = [PostModel notUploadedPosts];

    for (PostModel *post in results) {
        
		for (ImageModel *image in post.sortedImages) {
            
			if (image.dateUploaded == nil) {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[image.localPath stringByAppendingString:@"_rest"] error:nil];
                
                if (fileAttributes != nil) {
                    totalBytesQueued += [fileAttributes fileSize];         
                }
			}
		}
        
        if (post.dateUploaded == nil) {
            
            totalBytesQueued += API_CALL_LENGTH;
        }
	}
    
    if (totalBytesQueued > 0) {
        [self computeProgress];
    }
}

#pragma mark -

- (void) startUploadingImage:(ImageModel*) image {

    [current release];
	current = [image retain];
	
    NSString *url = [NSString stringWithFormat:@"%@/photo.json",
					 SL_API_BASE_URL,
                     nil];
    
    _NSLog(@"startUploadingImage: %@", url);
	
    // Create the request.
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:TIMEOUT_INTERVAL];
                         
    [theRequest setHTTPMethod:@"POST"];
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[image.localPath stringByAppendingString:@"_rest"] error:nil];
    
    [theRequest addValue:[[NSNumber numberWithLongLong:[fileAttributes fileSize]] stringValue] forHTTPHeaderField: @"Content-Length"];
    [theRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [NSString stringWithFormat:@"bound%d", 1234567]] forHTTPHeaderField: @"Content-Type"];
    [theRequest setHTTPBodyStream:[NSInputStream inputStreamWithFileAtPath:[image.localPath stringByAppendingString:@"_rest"]]];
                                                   
#ifdef USE_TEST_CHECKIN_ACCOUNT
    [theRequest basicAuthUsername:@"robspychala+test@gmail.com" password:@"friday"];
#else
    [theRequest basicAuthUsername:[FSSettings sharedInstance].username password:[FSSettings sharedInstance].password];
#endif

    [theConnection cancel]; [theConnection release];
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
      currentUploaded = 0;
      receivedData = [[NSMutableData data] retain];
      [UIApplication startNetworkOperation];
    } else {
        NSError *e = [NSError errorWithDomain:@"no network" code:0 userInfo:nil];
        self.error = e;
    }
}

- (void) startUploadingTip:(PostModel*) post {
    
    [current release];
	current = [post retain];
	
	if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
	NSMutableDictionary *params = [NSKeyedUnarchiver unarchiveObjectWithData:post.request];

    NSNumber *picCount = nil;
    ImageModel *image = [post lastUploadedImage:&picCount];
    [params setObject:[PostModel addURLToShout:[params objectForKey:@"text"] url:image.uploadedUrl numberOfPics:[picCount intValue]] forKey:@"text"];
    
	NSString *postString = [params RESTURLEncodedHTTPPostData];
    
    NSString *url = [NSString stringWithFormat:@"%@/addtip.json?%@",
					 FS_API_BASE_URL,
                     postString,
                     nil];
    
    _NSLog(@"startUploadingTip %@ %@",url,postString);
	
    // Create the request.
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:TIMEOUT_INTERVAL];
	
	//Set the request method to post
    [theRequest setHTTPMethod:@"POST"];	
    
#ifdef USE_TEST_CHECKIN_ACCOUNT
    [theRequest basicAuthUsername:@"robspychala+test@gmail.com" password:@"friday"];
#else
    [theRequest basicAuthUsername:[FSSettings sharedInstance].username password:[FSSettings sharedInstance].password];
#endif    
    
    [theConnection cancel];
    [theConnection release];
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [[NSMutableData data] retain];
		[UIApplication startNetworkOperation];
    } else {
        NSError *e = [NSError errorWithDomain:@"no network" code:0 userInfo:nil];
        self.error = e;
    }
}

- (void) startUploadingCheckin:(PostModel*) post {
	
    [current release];
	current = [post retain];
	
	if (![[FSSettings sharedInstance] isLoggedIn]) return;
    
	NSMutableDictionary *params = [NSKeyedUnarchiver unarchiveObjectWithData:post.request];
    NSMutableDictionary *extraData = [NSKeyedUnarchiver unarchiveObjectWithData:post.data];
    
    NSNumber *picCount = nil;
    ImageModel *image = [post lastUploadedImage:&picCount];
    if (![extraData objectForKey:@"shout_with_url"]) {
        [params setObject:[PostModel addURLToShout:[params objectForKey:@"shout"] url:image.uploadedUrl numberOfPics:[picCount intValue]] forKey:@"shout"];
        [extraData setObject:[NSNumber numberWithBool:TRUE] forKey:@"shout_with_url"];
    }
    
    if (post.type == [NSNumber numberWithInt:PostStyleCheckinAddPhotos]) {
        [params removeObjectForKey:@"vid"];
    }
    
    post.request = [NSKeyedArchiver archivedDataWithRootObject:params];
    post.data = [NSKeyedArchiver archivedDataWithRootObject:extraData];
    
    NSError *err = nil;
	[ManagedObjectContext() save:&err];
    NSAssert(!err, @"err saving PostModel");    
    
	NSString *postString = [params RESTURLEncodedHTTPPostData];
    
    NSString *url = [NSString stringWithFormat:@"%@/checkin.json?%@",
					 FS_API_BASE_URL,
                     postString,
                     nil];
    
    _NSLog(@"startUploadingCheckin %@ %@",url,postString);
	
    // Create the request.
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:TIMEOUT_INTERVAL];
	
	//Set the request method to post
    [theRequest setHTTPMethod:@"POST"];	
    
#ifdef USE_TEST_CHECKIN_ACCOUNT
    [theRequest basicAuthUsername:@"robspychala+test@gmail.com" password:@"friday"];
#else
    [theRequest basicAuthUsername:[FSSettings sharedInstance].username password:[FSSettings sharedInstance].password];
#endif    
    
    [theConnection cancel];
    [theConnection release];
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        receivedData = [[NSMutableData data] retain];
		[UIApplication startNetworkOperation];
    } else {
        NSError *e = [NSError errorWithDomain:@"no network" code:0 userInfo:nil];
        self.error = e;
    }
}

- (void) stop 
{
    [theConnection cancel];
    [theConnection release]; theConnection = nil;
    
    self.progress = [NSNumber numberWithInt:1];
}

- (void) resume
{
    if ([self inProgress]) return;

    if ([[ReachabilityHelper sharedInstance] isConnected]) {
        
        _NSLog(@"resuming FSPostQueue");
        
        [self computeQueuedBytes];
        [self uploadNextRetry];
        
    } else if ([[PostModel notUploadedPosts] count] > 0) {
        
        NSError *e = [NSError errorWithDomain:@"no network" code:1 userInfo:nil];
        self.error = e;
    }
}

- (void) uploadNextRetry 
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.failedDate = nil;
    [self uploadNext];
}

- (void) uploadNext
{
    if (self.failedDate) return;
    
    if ([self inProgress]) return;

	NSArray* results = [PostModel notUploadedPosts];
    
    if ([results count] == 0) {
        
        if (active) [self didFinishQueue];
        active = FALSE;
        return;
        
    } else if ([results count] == 1 && !active) {
        
        [self didStartQueue];
        active = TRUE;
        
    } else {
        
        [self computeProgress];
    }
	
	for (PostModel *post in results) {
	
		for (ImageModel *image in post.sortedImages) {
						
			if (image.dateUploaded == nil) {
			
				[self startUploadingImage:image];
				goto done;
			}
		}
        
        if (post.dateUploaded == nil) {
        
            if (post.type == [NSNumber numberWithInt:PostStyleTip]) {
                [self startUploadingTip:post];
            } else {
                [self startUploadingCheckin:post];
            }
            goto done;
        }
	}
    
    done:
    
    return;
}

- (void)handleError:(NSError*)_error
{
    [theConnection release]; theConnection = nil;
    
    totalBytesUploaded -= currentUploaded;
    
    _NSLog(@"Connection failed! FSPostQueue Error: %@ %@",
           [_error localizedDescription],
           [[_error userInfo] objectForKey:NSErrorFailingURLStringKey]);   
    
    if (!self.failedDate && [ReachabilityHelper sharedInstance].isConnected) {
        [self performSelector:@selector(uploadNextRetry) withObject:nil afterDelay:RETRY_TIME_SECONDS];
        self.failedDate = [NSDate date];
    }
    
    self.error = _error;
}

#pragma mark -
#pragma mark NSURLConnection delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    _NSLog(@"FSPostQueue connectionDidFinishLoading");
    
    NSDictionary *responseData = [receivedData yajl_JSON];
    [receivedData release];
    
    [UIApplication endNetworkOperation];
    
    if ([current class] == [PostModel class] && ![responseData objectForKey:@"error"]) {
        
        totalBytesUploaded += API_CALL_LENGTH;
        
        ((PostModel*)current).dateUploaded = [NSDate date];
        
        NSError* _error = nil;
        [ManagedObjectContext() save:&_error];
        NSAssert(!_error, @"err saving PostModel");
        
        if (((PostModel*)current).type != [NSNumber numberWithInt:PostStyleTip]) {
            
            FSCheckin *c = [[[[FSCheckin alloc] init] autorelease] retain];
            c.date = [NSDate date];
            NSMutableDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:((PostModel*)current).data];
            NSMutableDictionary *request = [NSKeyedUnarchiver unarchiveObjectWithData:((PostModel*)current).request];
            [data setObject:[request valueForKey:@"shout"] forKey:@"shout"];
            
            if ([[request objectForKey:@"private"] boolValue]) {
                [data removeObjectForKey:@"venue"];
            }
            
            c.data = [data retain];
            PostStyle style = [((PostModel*)current).type intValue];    
            
            if (style == PostStyleCheckinAddPhotos || style == PostStyleShout) {
                c.checkinType = FSCheckinTypeShout;
                [data setObject:@"shouted" forKey:@"display"];
            } else if ([[data objectForKey:@"venue"] objectForKey:@"name"]) {
                c.checkinType = FSCheckinTypeCheckin;
            } else {
                c.checkinType = FSCheckinTypeOffGrid;
            }            
            
            [[FSCheckinsLookup sharedInstance] performSelector:@selector(addPostedCheckin:) withObject:c afterDelay:0];
            
            [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"Posted." style:ModalOverlayStyleSuccess];
            
            _NSLog(@"addPostedCheckin");

        } else {
            
            [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"Posted tip." style:ModalOverlayStyleSuccess];
        }
        
    } else if ([current class] == [ImageModel class]) {

        ((ImageModel*)current).dateUploaded = [NSDate date];
        ((ImageModel*)current).uploadedUrl = [responseData objectForKey:@"url"];
        
        NSError *_error = nil;
        [ManagedObjectContext() save:&_error];
        NSAssert(!_error, @"err saving ImageModel");        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        [fileManager removeItemAtPath:[((ImageModel*)current).localPath stringByAppendingString:@"_rest"] error:&_error];
        //[error release]; error = nil;

        [fileManager removeItemAtPath:[((ImageModel*)current).localPath stringByAppendingString:@"_thumb"] error:&_error];
        //[error release]; error = nil;

        [fileManager removeItemAtPath:((ImageModel*)current).localPath error:&_error];
        //[error release]; error = nil;
    }
    
    [theConnection release]; theConnection = nil;
    
	[self uploadNext];
}

- (void)connection:(NSURLConnection *)connection 
           didSendBodyData:(NSInteger)bytesWritten 
         totalBytesWritten:(NSInteger)totalBytesWritten 
        totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
 
    totalBytesUploaded += bytesWritten;
    currentUploaded += bytesWritten;
    
    [self computeProgress];
}

#pragma mark -
#pragma mark Queue delegate

- (void) didStartQueue
{
    self.progress = [NSNumber numberWithFloat:0.05];
    
    if ([UIDevice currentDevice].isMultitaskingDevice) {
        backgroundTask = (UIBackgroundTaskIdentifier)
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            _NSLog(@"Expiration Handler");
            [theConnection release]; theConnection = nil;
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            localNotif.alertBody = NSLocalizedString(@"There was a problem communicating with the network. Please open the app to resume.", nil);
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
            [localNotif release];
        }];
    }
    
    _NSLog(@"didStartQueue");
}

- (void) didFinishQueue
{
    if (backgroundTask && [UIDevice currentDevice].isMultitaskingDevice) {
        [[UIApplication sharedApplication] endBackgroundTask:(UIBackgroundTaskIdentifier)backgroundTask];
        backgroundTask = 0;
    }
    
    totalBytesQueued = 0;
    totalBytesUploaded = 0;
    
    self.progress = [NSNumber numberWithInt:1];
    
    _NSLog(@"didFinishQueue");
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"networkStatus"] 
        && [[change objectForKey:NSKeyValueChangeNewKey] intValue] != NotReachable) {
        
        [self resume];
        
    } else if ([keyPath isEqual:@"networkStatus"] 
               && [[change objectForKey:NSKeyValueChangeNewKey] intValue] == NotReachable
               && theConnection != nil) {
        
        [UIApplication endNetworkOperation];
        
        totalBytesUploaded -= currentUploaded;
        
        [theConnection cancel];
        [theConnection release]; theConnection = nil;
        
        NSError *e = [NSError errorWithDomain:@"err" code:1 userInfo:nil]; 
        self.error = e;
    }
}

- (BOOL) isActive
{
    return active;
}

- (void) dealloc
{
    [super dealloc];
    [[ReachabilityHelper sharedInstance] removeObserver:self forKeyPath:@"networkStatus"];
}

@end
