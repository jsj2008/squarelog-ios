#import "UIImage+Resize.h"
#import "UIScreen+Scale.h"
#import "UIView+ModalOverlay.h"
#import "UIApplication+TopView.h"
#import "CheckInViewController320.h"
#import "CheckInTextViewCell.h"
#import "CheckInShareButtonsCell.h"
#import "CheckInPhotoButtonCell.h"
#import "CheckInPublicButtonsCell.h"
#import "LocationHelper.h"

#import "FSPostQueue.h"
#import "FSUserLookup.h"
#import "VenueHeader.h"
#import "AppDelegate.h"

#import "FSVenuesLookup.h"
#import "FSTipsLookup.h"
#import "GNFindNearbyLookup.h"

@implementation CheckInViewController320

@synthesize info;
@synthesize controllerStyle;
@synthesize parentNavigationController;

- (id) initWithStyle:(UITableViewStyle)_tableStyle checkinStyle:(PostStyle)_controllerStyle
{
 
    if (self = [super initWithStyle:_tableStyle]) {
        
        self.controllerStyle = _controllerStyle;
        userPublicShout = YES;
        savedUserValues = NO;
    }
    
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	if (self.controllerStyle == PostStyleCheckinAddPhotos) {
		self.title = @"Add Photos";
        if (!userShout) userShout = [[NSString stringWithFormat:@"Photos from %@", [[self.info objectForKey:@"venue"] objectForKey:@"name"]] retain];
	} else if (self.controllerStyle == PostStyleShout) {
		self.title = @"Shout";
	} else if (self.controllerStyle == PostStyleTip) {
		self.title = @"Add a Tip";
	} else {
		self.title = @"Check in";
	}
	
	// venue
	
	if (self.controllerStyle != PostStyleShout) {
	
		VenueHeader *venue = [[VenueHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
		venue.info = self.info; 
		CGSize venueSize = [venue sizeThatFits:CGSizeZero];
		venue.frame = CGRectMake(0, 0, venueSize.width, venueSize.height);
		self.tableView.tableHeaderView = venue;
		[venue release];
	}
	
	// table
	
	tableSections = [[NSMutableArray array] retain];
    tableSectionHeaders = [[NSMutableArray array] retain];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDialog:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
    
    [self loadTableSections];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[FSUserLookup sharedInstance] addObserver:self
                                    forKeyPath:@"info"
                                       options:NSKeyValueObservingOptionNew
                                       context:NULL];
    
    [[FSUserLookup sharedInstance] addObserver:self
                                    forKeyPath:@"error"
                                       options:NSKeyValueObservingOptionNew
                                       context:NULL];
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [[FSUserLookup sharedInstance] removeObserver:self forKeyPath:@"info"];
    [[FSUserLookup sharedInstance] removeObserver:self forKeyPath:@"error"];
    
    [[FSUserLookup sharedInstance] cancel];
    
}

- (void)didReceiveMemoryWarning {

    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) loadTableSections
{
	[tableSections removeAllObjects];
    [tableSectionHeaders removeAllObjects];
	
    // section 1
    NSMutableArray *section1 = [[NSMutableArray array] retain];
    CheckInTextViewCell *cell = [[CheckInTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil checkinStyle:controllerStyle];
    [self characterCountLimit:cell];
    cell.textView.text = userShout;
    if ([cell.textView.text length] > 0) [cell dismissibleLabelHidden:YES];
    textView = cell.textView;
	cell.delegate = self;
    [section1 addObject:cell];
    [cell release]; cell = nil;
    [tableSections addObject:section1];
    [tableSectionHeaders addObject:@""];
    [section1 release];
	
	// section 2
    
    NSMutableArray *section3 = [[NSMutableArray array] retain];
    cell = [[CheckInPhotoButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ((CheckInPhotoButtonCell*)cell).imageFileNames = imageFileNames;
    [section3 addObject:cell];
    [cell release]; cell = nil;
    [tableSections addObject:section3];
    [tableSectionHeaders addObject:@""];
    [section3 release];
    
    // section 3
    NSMutableArray *section2 = [[NSMutableArray array] retain];
    
    if (controllerStyle != PostStyleShout && 
        controllerStyle != PostStyleTip &&
        controllerStyle != PostStyleCheckinAddPhotos) {
        
        cell = [[CheckInPublicButtonsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        ((CheckInPublicButtonsCell*)cell).switch1.on = userPublicShout;
        [section2 addObject:cell];
        [cell release]; cell = nil;
    }
    
    if (controllerStyle != PostStyleTip) {
        
        NSDictionary *authUser = [FSUserLookup sharedInstance].authenticatedUser;
        
        if ([authUser valueForKeyPath:@"user.twitter"] || [authUser valueForKeyPath:@"user.facebook"]) {
        
            cell = [[CheckInShareButtonsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            [((CheckInShareButtonsCell*)cell) showTwitterButton:[authUser valueForKeyPath:@"user.twitter"]!=nil?YES:NO];
            [((CheckInShareButtonsCell*)cell) showFacebookButton:[authUser valueForKeyPath:@"user.facebook"]!=nil?YES:NO]; 
            
            if (savedUserValues) {
                
                ((CheckInShareButtonsCell*)cell).twitterButton.selected = userTwitterShare;
                ((CheckInShareButtonsCell*)cell).facebookButton.selected = userFacebookShare;

            } else {

                ((CheckInShareButtonsCell*)cell).twitterButton.selected = [[authUser valueForKeyPath:@"user.settings.sendtotwitter"] boolValue];
                ((CheckInShareButtonsCell*)cell).facebookButton.selected = [[authUser valueForKeyPath:@"user.settings.sendtofacebook"] boolValue];
            }
            
            
            [((CheckInShareButtonsCell*)cell) setNeedsLayout];
            
            [section2 addObject:cell];
            [cell release]; cell = nil;
            
        } else if (!authUser) {
            
            cell = [[CheckInShareButtonsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            ((CheckInShareButtonsCell*)cell).spinner = YES;
            
            [section2 addObject:cell];
            [cell release]; cell = nil;            
            
            [[FSUserLookup sharedInstance] lookupAuthenticatedUser];
        }
    }
    
    if ([section2 count] > 0) {
        [tableSections addObject:section2];
        [tableSectionHeaders addObject:@""];
    }
    [section2 release];

    // section 4
    NSMutableArray *section4 = [[NSMutableArray array] retain];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	
	if (self.controllerStyle == PostStyleCheckinAddPhotos) {
		cell.textLabel.text = @"Add Photos";
	} else if (self.controllerStyle == PostStyleShout) {
		cell.textLabel.text = @"Shout";
	} else if (self.controllerStyle == PostStyleTip) {
		cell.textLabel.text = @"Add a Tip";
	} else {
		cell.textLabel.text = @"Check in";
	}
    
    checkinItemSection = [tableSections count];
	
    cell.textLabel.textColor = HEXCOLOR(0x3A4D85ff);
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    [section4 addObject:cell];
    [cell release]; cell = nil;
    [tableSections addObject:section4];
    [tableSectionHeaders addObject:@""];
    [section4 release];		
}

- (void) characterCountLimit:(CheckInTextViewCell*)cell {
    
    
    int limit = 140;
    if (controllerStyle == PostStyleTip) limit = 200;
    
    if ([imageFileNames count] > 0) {
        
        limit = 110;
    }
    
    if (cell == nil) {
        cell = (CheckInTextViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    if ([cell.textView.text length] > limit) {
        cell.textView.text = [cell.textView.text substringToIndex:limit];
    }
    
    cell.number = limit - [cell.textView.text length];
}
    
#pragma mark -
#pragma mark TextView delegate

- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (controllerStyle == PostStyleTip) return TRUE;
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDialog:)];
        self.navigationItem.rightBarButtonItem = item;
        [item release];
        
        return FALSE;
    }
    
    textView.contentInset = UIEdgeInsetsZero;
    
    return TRUE;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)_textView
{
    [self doneWithTextView:_textView];
    return YES;
}

- (void)textViewDidChange:(UITextView *)_textView
{
    [self characterCountLimit:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)_textView
{
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithTextView:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
    
    if (controllerStyle == PostStyleTip) {
        [UIView beginAnimations:@"modal-view-1" context:nil];
        [UIView setAnimationDuration:.25];
        self.tableView.contentOffset = CGPointMake(0, -6);
        [UIView commitAnimations];
    }
}

#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		
        if (controllerStyle == PostStyleTip) {
            return 190;
        } else {
            return 78;
        }
		
	} else {
		
		return 44;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{	
    return nil;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [tableSections count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [(NSArray*)[tableSections objectAtIndex:section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return (UITableViewCell*)[(NSArray*)[tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    BOOL showDelete = imageFileNames!=nil&&[imageFileNames count] > 0;
	
	if ([imageFileNames count] < 7 && indexPath.section == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
        [self doneWithTextView:nil];
        
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Attach a photo" delegate:self 
													   cancelButtonTitle:@"Cancel" 
												  destructiveButtonTitle:showDelete?@"Remove Photos":nil
													   otherButtonTitles:@"Saved Photo Library", @"Camera", nil ];    
		[actionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
		
	} else if ([imageFileNames count] < 7 && indexPath.section == 1) {
		
        [self doneWithTextView:nil];
        
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Attach a photo" delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:showDelete?@"Remove Photos":nil
														otherButtonTitles:@"Saved Photos Library", nil ];    
		[actionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];		
		
    } else if ([imageFileNames count] >= 7 && indexPath.section == 1) {
        
        [self doneWithTextView:nil];
        
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:showDelete?@"Remove Photos":nil
														otherButtonTitles:nil ];    
		[actionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];		        
        
	} else if (indexPath.section == checkinItemSection) {
        
        [self mainActionItemTappedWithTableView:tableView indexPath:indexPath];
	}
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        
        [self removeImages];
        
        CheckInPhotoButtonCell *cell = (CheckInPhotoButtonCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.imageFileNames = imageFileNames;
        [cell setNeedsDisplay];      
        
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES];
        
        [self characterCountLimit:nil];
        
	} else if (actionSheet.cancelButtonIndex == buttonIndex) {
		
		[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES];
	
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        
        [self saveUserValues];
		
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = NO;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:picker animated:YES];

	} else if (buttonIndex == actionSheet.firstOtherButtonIndex+1) {
        
        [self saveUserValues];
	
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = NO;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:picker animated:YES];
	}
    
    //[[[UIApplication sharedApplication] topView] exploreViewAtLevel:0];
}

#pragma mark -
#pragma mark UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)_info
{
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"saving photo" style:ModalOverlayStyleActivity];
    //[v release];
    
    [self performSelector:@selector(processMedia:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:picker, @"picker", _info, @"info", nil] afterDelay:0];
}

- (void) processMedia:(NSDictionary*) stuff
{
    
    UIImagePickerController *picker = [stuff objectForKey:@"picker"];
    NSDictionary *_info = [stuff objectForKey:@"info"];

	UIImage *image = [_info objectForKey:UIImagePickerControllerOriginalImage];
    
    // save to album
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum (image,
                                        nil,
                                        nil,
                                        nil
                                        );
    }
	
    // main image
    
    int fileSize = 0;
    CGSize size = image.size;
    NSString *fileName = nil;
    
    do {
        
        image = [image resizedImage:size interpolationQuality:kCGInterpolationHigh];
        
        {
            NSData *file = UIImageJPEGRepresentation(image, 0.5f);
            NSString *cacheDirectoryName = [((AppDelegate*)[UIApplication sharedApplication].delegate) applicationUploadTempDirectory];
            fileName = [cacheDirectoryName stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", [[NSDate date] timeIntervalSince1970]]];
            [file writeToFile:fileName atomically:YES];
        }
        
        // Get file size
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fileName error:nil];
        fileSize = [fileAttributes fileSize];
        
        size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(.9, .9));
        
    } while (fileSize >= 1000000); // make sure image is < 1MB
    
    // thumb
    UIImage *thumb = [image thumbnailImage:38*[[UIScreen mainScreen] backwardsCompatibleScale] transparentBorder:1 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
    NSData *thumbFile = UIImagePNGRepresentation(thumb);
    NSString *thumbFileName = [fileName stringByAppendingString:@"_thumb"];
    [thumbFile writeToFile:thumbFileName atomically:YES];
        
    
    // save
    if (imageFileNames == nil) {
        imageFileNames = [[NSMutableArray arrayWithCapacity:7] retain];
    }
    
    [imageFileNames addObject:fileName];
    
    CheckInPhotoButtonCell *photoCell = (CheckInPhotoButtonCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    photoCell.imageFileNames = imageFileNames;
    [photoCell setNeedsDisplay];
    
    [[[UIApplication sharedApplication] topView] hideModalOverlayWithAnimation:YES];
    
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];
    
    [self characterCountLimit:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	_NSLog(@"img cancel");
	
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];
}

#pragma mark -
#pragma mark Checkin Handler


- (void) saveUserValues
{
    
    savedUserValues = YES;
    
    CheckInPublicButtonsCell *ce1 = nil;
    
    if (controllerStyle != PostStyleShout && 
        controllerStyle != PostStyleTip &&
        controllerStyle != PostStyleCheckinAddPhotos) {
        ce1 = (CheckInPublicButtonsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    }
    
    CheckInShareButtonsCell *ce2 = nil;
    if (controllerStyle != PostStyleTip) {
        ce2 = (CheckInShareButtonsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
        
        if (!ce2) {
            ce2 = (CheckInShareButtonsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        }
        
        if ([ce2 class] != [CheckInShareButtonsCell class]) {
            
            ce2 = nil;
        }
    }
    
    [userShout release];
    userShout = [[textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] retain];
    userPublicShout = ce1.switch1.on;
    userTwitterShare = ce2.twitterButton.selected;
    userFacebookShare = ce2.facebookButton.selected;
}

- (void) mainActionItemTappedWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    if ((controllerStyle == PostStyleTip || controllerStyle == PostStyleShout)
        && ((textView.text == nil || [textView.text length] == 0) 
            && [imageFileNames count] == 0)) {
            
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (controllerStyle == PostStyleCheckinAddPhotos && [imageFileNames count] == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    NSNumber *venueId = [[info objectForKey:@"venue"] objectForKey:@"id"];
    
    [self saveUserValues];
    
    if (controllerStyle == PostStyleTip)
    {
        
        [FSPostQueue addTipWithVenueId:[venueId integerValue]
                                  text:userShout
                                  type:FSTipTypeTip
                              location:[LocationHelper sharedInstance].latestLocation
                                images:imageFileNames];
        
    } else {             
        
        [FSPostQueue  addCheckinWithVenueId:[venueId integerValue]
                                      shout:textView.text 
                                   location:[LocationHelper sharedInstance].latestLocation
                                    offgrid:!userPublicShout
                                    twitter:userTwitterShare
                                   facebook:userFacebookShare
                                     images:imageFileNames
                                      style:controllerStyle
                                       data:self.info];
    }
    
    if (self.parentNavigationController.parentViewController) {
        [self.parentNavigationController.parentViewController dismissModalViewControllerAnimated:YES];
    } else {
        [self.parentNavigationController popToRootViewControllerAnimated:NO];
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

#pragma mark -
#pragma mark Handlers

- (void) dismissDialog: (id)sender
{
    [self removeImages];
	[self dismissModalViewControllerAnimated:YES];
}

- (void) doneWithTextView:(id)sender 
{
	[textView resignFirstResponder];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissDialog:)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
    
    if (textView.text == nil || [textView.text length] == 0) {
        [(CheckInTextViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] dismissibleLabelHidden:NO];
    } else {
        [textView flashScrollIndicators];
    }
}

- (void)checkIn:(id)sender 
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqual:@"info"]) {
        
        NSDictionary *authUser = (NSDictionary*)[change objectForKey:NSKeyValueChangeNewKey];
        [FSUserLookup sharedInstance].authenticatedUser = authUser;
        
        if ((![authUser valueForKeyPath:@"user.twitter"] && ![authUser valueForKeyPath:@"user.facebook"])) {
            
            [self loadTableSections];
            
//            [self.tableView beginUpdates];
//            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:2], nil] 
//                                  withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView endUpdates];
            
            [self.tableView reloadData];
            
        } else {
            
            CheckInShareButtonsCell *cell;
            
            if (controllerStyle == PostStyleShout) {
            
                cell = (CheckInShareButtonsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                
            } else {
                
                cell = (CheckInShareButtonsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
            }
            
            [((CheckInShareButtonsCell*)cell) showTwitterButton:[authUser valueForKeyPath:@"user.twitter"]!=nil?YES:NO];
            [((CheckInShareButtonsCell*)cell) showFacebookButton:[authUser valueForKeyPath:@"user.facebook"]!=nil?YES:NO]; 

            ((CheckInShareButtonsCell*)cell).twitterButton.selected = [[authUser valueForKeyPath:@"user.settings.sendtotwitter"] boolValue];
            ((CheckInShareButtonsCell*)cell).facebookButton.selected = [[authUser valueForKeyPath:@"user.settings.sendtofacebook"] boolValue];
            
            [cell setNeedsLayout];
            cell.spinner = NO;
            
        }
        
    } else if ([keyPath isEqual:@"error"]) {
     
        [[FSUserLookup sharedInstance] lookupAuthenticatedUser];
    }
}

#pragma mark -

- (void) removeImages 
{
    for (NSString *file in imageFileNames) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        [fileManager removeItemAtPath:[file stringByAppendingString:@"_rest"] error:nil];
        [fileManager removeItemAtPath:[file stringByAppendingString:@"_thumb"] error:nil];
        [fileManager removeItemAtPath:file error:nil];
    }
    
    [imageFileNames removeAllObjects];
}

- (void)dealloc 
{
    [tableSectionHeaders release];
    [tableSections release];
    [imageFileNames release];
    [userShout release];
    [info release];
    
    [super dealloc];
}

@end
