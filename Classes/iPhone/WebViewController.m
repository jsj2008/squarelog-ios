#import "WebViewController.h"
#import "AppDelegate.h"
#import "UIApplication+Network.h"
#import "UIApplication+TopView.h"
#import "UIView+ModalOverlay.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation WebViewController

@synthesize url, location;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)loadView {
    
    [super loadView];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,460-44)];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [self.view addSubview:webView];
    [webView release];
    
    _NSLog([self.view recursiveDescription]);
    
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];    
    
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                  UIBarButtonSystemItemRewind target:self action:@selector(backButtonTapped:)];
    
    forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                     UIBarButtonSystemItemFastForward target:self action:@selector(forwardButtonTapped:)];
    
    refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonTapped:)];
    
    stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemStop target:self action:@selector(stopButtonTapped:)];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460 - 44, 320, 44)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    toolbar.items = [NSArray arrayWithObjects: backButton, space, forwardButton, space, refreshButton, space, nil];
    [self.view addSubview:toolbar];
    [toolbar release];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];  
    
    //self.title = url;
}

#pragma mark -
#pragma mark Events

- (void)backButtonTapped:(id)sender
{
    [webView goBack];
}

- (void)forwardButtonTapped:(id)sender
{
    [webView goForward];
}

- (void)refreshButtonTapped:(id)sender
{
    [webView reload];
}

- (void)stopButtonTapped:(id)sender
{
    [webView stopLoading];
}

- (void)actionButtonTapped:(id)sender
{
    
    UIActionSheet *actionSheet;
    
    if (location.latitude != 0) {
        
       actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Open Link in Safari", @"Copy Link", @"Open in Maps", nil ];
        
    } else {
        
       actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Open Link in Safari", @"Copy Link", nil ];
    }
    
    [actionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];    
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)_webView shouldStartLoadWithRequest:(NSURLRequest*)request
            navigationType:(UIWebViewNavigationType)navigationType {

    backButton.enabled = [_webView canGoBack];
    forwardButton.enabled = [webView canGoForward];
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)_webView {
	self.title = @"Loading...";
    
	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
	toolbar.items = [NSArray arrayWithObjects:
					  backButton, space, forwardButton, space, stopButton, space, nil];
    
	backButton.enabled = [_webView canGoBack];
	forwardButton.enabled = [_webView canGoForward];
    
    [UIApplication startNetworkOperation];
}

- (void)webViewDidFinishLoad:(UIWebView*)_webView {
    
	self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

	UIBarItem* space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
						 UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	toolbar.items = [NSArray arrayWithObjects:
					  backButton, space, forwardButton, space, refreshButton, space, nil];
    
	backButton.enabled = [_webView canGoBack];
	forwardButton.enabled = [_webView canGoForward];
    
    [UIApplication endNetworkOperation];
}

- (void)webView:(UIWebView*)_webView didFailLoadWithError:(NSError*)error {
    
//    NSString *errStr = [error localizedDescription];
//    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:errStr style:ModalOverlayStyleError]; 

	[self webViewDidFinishLoad:_webView];
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        
	} else if (actionSheet.firstOtherButtonIndex == buttonIndex) {
     
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

    } else if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:
                              url, @"public.utf8-plain-text", [NSURL URLWithString:url],
                              (NSString *)kUTTypeURL,
                              nil];
        pasteboard.items = [NSArray arrayWithObject:item];
        
    } else if (actionSheet.firstOtherButtonIndex + 2 == buttonIndex) {
        
        NSString *_url = [NSString stringWithFormat:@"http://maps.google.com/maps?ll=%f,%f",
                         location.latitude,
                         location.longitude];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url]];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
