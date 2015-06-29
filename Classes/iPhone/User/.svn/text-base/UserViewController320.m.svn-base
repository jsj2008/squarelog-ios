#import "UserViewController320.h"
#import "FSUserLookup.h"
#import "UserHeader.h"
#import "BadgeButton.h"
#import "FSFriendLookup.h"
#import "ActionTableViewCell.h"
#import "FSFriendOps.h"
#import "FSTipsLookup.h"
#import "SLPhotosLookup.h"
#import "UserContactTableViewCell.h"

#import "MayorshipsViewController320.h"
#import "BadgesViewController320.h"
#import "PhotosViewController320.h"

#import "UIView+ModalOverlay.h"
#import "UIApplication+TopView.h"

#import "UIApplication+TopView.h"

#import "SLTableViewController.h"
#import "UserTableViewCell.h"
#import "BadgesTableViewCell320.h"
#import "WebViewController.h"
#import "SLSettings.h"

#import "AppDelegate.h"

#import "Tips2ViewController320.h"

@implementation UserViewController320

@synthesize info, friendInfo, tipInfo;

- (void)loadView
{
    [super loadView];
    tipsButtonBadgeCount = -1;
    mayorButtonBadgeCount = -1;
    photosButtonBadgeCount = -1;
    
    viewPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"User";
	
    UserHeader *user = [[UserHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    user.info = self.info; 
    self.tableView.tableHeaderView = user;
    [user release];
	
	tableSections = [[NSMutableArray array] retain];
    tableSectionHeaders = [[NSMutableArray array] retain];
	tableSectionFooters = [[NSMutableArray array] retain];	
	
    [self loadTableSections];
}

- (void) loadTableSections
{
    
    [tableSections removeAllObjects];
    [tableSectionHeaders removeAllObjects];
	[tableSectionFooters removeAllObjects];
	
	// section 1
    NSMutableArray *section1 = [[NSMutableArray array] retain];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	
    UIView *bg = [[UIView alloc] initWithFrame:CGRectNull];
    bg.backgroundColor = [UIColor clearColor];
    cell.backgroundView = bg;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [bg release];
	
    mayorButton = [BadgeButton button];
    mayorButton.frame = CGRectMake(10, 0, 93, 44);
    [mayorButton setTitle:@"Mayor" forState:UIControlStateNormal];
    [mayorButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
	[mayorButton addTarget:self action:@selector(mayorshipButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (mayorButtonBadgeCount > 0) [mayorButton setCount:mayorButtonBadgeCount];
    [cell addSubview:mayorButton];
    
    tipsButton = [BadgeButton button];
    tipsButton.frame = CGRectMake(113, 0, 93, 44);
    [tipsButton setTitle:@"Tips" forState:UIControlStateNormal];
    [tipsButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
	[tipsButton addTarget:self action:@selector(tipsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (tipsButtonBadgeCount > 0) [tipsButton setCount:tipsButtonBadgeCount];
    [cell addSubview:tipsButton];
    
    photosButton = [BadgeButton button];
    photosButton.frame = CGRectMake(217, 0, 93, 44);
    [photosButton setTitle:@"Photos" forState:UIControlStateNormal];
    [photosButton setTitleColor:HEXCOLOR(0x3A4D85ff) forState:UIControlStateNormal];
	[photosButton addTarget:self action:@selector(photosButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (photosButtonBadgeCount > 0) [photosButton setCount:photosButtonBadgeCount];
    [cell addSubview:photosButton];
	
    [section1 addObject:cell];
    [cell release]; cell = nil;
	
    [tableSections addObject:section1];
    [tableSectionHeaders addObject:@""];
	[tableSectionFooters addObject:@""];
    [section1 release];
    
    {
        
        // section 2
		NSMutableArray *section = [[NSMutableArray array] retain];
		BadgesTableViewCell320 *cell = [[BadgesTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.info = [[self.info objectForKey:@"user"] objectForKey:@"badges"]; 
        
        [section addObject:cell];
        [cell release]; cell = nil;
        
        [tableSections addObject:section];
        [tableSectionHeaders addObject:@""];
        [tableSectionFooters addObject:@""];
        [section release];
        
    }
	
	if ([[info objectForKey:@"user"] objectForKey:@"mayorcount"]) {
		
		// section 2
		NSMutableArray *section2 = [[NSMutableArray array] retain];
		ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		
		
		/*
		 The <friendstatus> node has four possible values:
		 friend - the requested user is your friend
		 pendingyou - the requested user sent you a friend request that you have not accepted
		 pendingthem - you have sent a friend request to the requested user but they have not accepte
		 node absent - the requested user is not your friend (and neither party has made an attempt at connecting)
		 */
        
        NSDictionary *authUser = [[FSUserLookup sharedInstance] authenticatedUser:NO];
        
        if ([[[info objectForKey:@"user"] objectForKey:@"id"] isEqual:[[authUser objectForKey:@"user"] objectForKey:@"id"]]) {
            
			cell.textLabel.text = @"This is you!";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[tableSectionFooters addObject:@""];            
		
		} else if ([[[info objectForKey:@"user"] objectForKey:@"friendstatus"] isEqual:@"friend"]) {
		
			cell.textLabel.text = @"You are friends";
            //cell.tapAction = @selector(friendUnfollow:);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[tableSectionFooters addObject:@""];
			
		} else if ([[[info objectForKey:@"user"] objectForKey:@"friendstatus"] isEqual:@"pendingyou"]) {
			
			cell.textLabel.text = @"Accept or Deny";
            cell.tapAction = @selector(friendAcceptOrDeny:);
			[tableSectionFooters addObject:@"You haven't accepted their friendship yet"];
			
		} else if ([[[info objectForKey:@"user"] objectForKey:@"friendstatus"] isEqual:@"pendingthem"]) {
			
			cell.textLabel.text = @"Waiting";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.tapAction = @selector(friendUnfollow:);
			[tableSectionFooters addObject:[NSString stringWithFormat:@"%@ hasn't accepted your friendship yet", [[info objectForKey:@"user"] objectForKey:@"firstname"]]];
			
		} else { //if (![[info objectForKey:@"user"] objectForKey:@"friendstatus"]) {
			
			cell.textLabel.text = @"Follow";
            cell.tapAction = @selector(friendFollow:);
			[tableSectionFooters addObject:@""];
		}
		
		//cell.textLabel.textColor = HEXCOLOR(0x3A4D85ff);
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		
		[section2 addObject:cell];
		[cell release]; cell = nil;
		
		[tableSections addObject:section2];
		[tableSectionHeaders addObject:@""];
		[section2 release];
        
        if ([[info objectForKey:@"user"] objectForKey:@"email"] || 
            [[info objectForKey:@"user"] objectForKey:@"facebook"] ||
            [[info objectForKey:@"user"] objectForKey:@"twitter"] ||
            [[info objectForKey:@"user"] objectForKey:@"phone"]) {
        
            UserContactTableViewCell *actionCell;
            
            // section 3
            NSMutableArray *section3 = [[NSMutableArray array] retain];
                
            if ([[info objectForKey:@"user"] objectForKey:@"phone"]) {
                actionCell = [[UserContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                actionCell.contactType.text = @"sms";
                actionCell.contactDetail.text = [NSString stringWithFormat:@"sms://%@", [[info objectForKey:@"user"] objectForKey:@"phone"]];
                actionCell.tapAction = @selector(tapSMS:);
                [section3 addObject:actionCell];
                [actionCell release]; cell = nil;
            }
            
            if ([[info objectForKey:@"user"] objectForKey:@"email"]) {
                actionCell = [[UserContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                actionCell.contactType.text = @"email";
                actionCell.contactDetail.text = [[info objectForKey:@"user"] objectForKey:@"email"];
                actionCell.tapAction = @selector(tapEmail:);
                [section3 addObject:actionCell];
                [actionCell release]; actionCell = nil;
            }
            
            if ([[info objectForKey:@"user"] objectForKey:@"facebook"]) {
                actionCell = [[UserContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                actionCell.contactType.text = @"facebook";
                actionCell.contactDetail.text = [NSString stringWithFormat:@"fb://%@", [[info objectForKey:@"user"] objectForKey:@"facebook"]];
                actionCell.tapAction = @selector(tapFacebook:);
                [section3 addObject:actionCell];
                [actionCell release]; actionCell = nil;
            }
                
            if ([[info objectForKey:@"user"] objectForKey:@"twitter"]) {
                actionCell = [[UserContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                actionCell.contactType.text = @"twitter";
                actionCell.contactDetail.text = [NSString stringWithFormat:@"@%@", [[info objectForKey:@"user"] objectForKey:@"twitter"]];
                actionCell.tapAction = @selector(tapTwitter:);
                [section3 addObject:actionCell];
                [actionCell release]; actionCell = nil;
            }
                
            if ([[info objectForKey:@"user"] objectForKey:@"phone"]) {
                actionCell = [[UserContactTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                actionCell.contactType.text = @"call";
                actionCell.contactDetail.text = [[info objectForKey:@"user"] objectForKey:@"phone"];
                actionCell.tapAction = @selector(tapPhone:);
                [section3 addObject:actionCell];
                [actionCell release]; actionCell = nil;
            }
            
            [tableSections addObject:section3];
            [tableSectionHeaders addObject:@""];
            [tableSectionFooters addObject:@""];
            [section3 release];  
                
        }
        		
	} else {
	
		// section 2
		NSMutableArray *section2 = [[NSMutableArray array] retain];
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
		UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		act.center = CGPointMake(320.0f/2, 44.0f/2);
		[cell addSubview:act];
		[act startAnimating];
		[act release];
        
		[section2 addObject:cell];
		[cell release]; cell = nil;
		
		[tableSections addObject:section2];
		[tableSectionHeaders addObject:@""];
		[tableSectionFooters addObject:@""];
		[section2 release];
        
        // section 3
        NSMutableArray *section3 = [[NSMutableArray array] retain];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.center = CGPointMake(320.0f/2, 44.0f/2);
        [cell addSubview:act];
        [act startAnimating];
        [act release];
        
        [section3 addObject:cell];
        [cell release]; cell = nil;
        
        [tableSections addObject:section3];
        [tableSectionHeaders addObject:@""];
        [tableSectionFooters addObject:@""];
        [section3 release];		
        
	}
}

- (void)viewWillAppear:(BOOL)animated {
    
    [FSFriendLookup sharedInstance].info = nil;
    
    int userId = [[((NSDictionary*)[info objectForKey:@"user"]) objectForKey:@"id"] intValue];
    
    if (!friendInfo) {
        [[FSUserLookup sharedInstance] lookupWithUserId:userId];
    }
    
    if (!tipInfo) {
        [[FSTipsLookup sharedInstance] lookupWithUserId:userId];
    }    
    
    if (photosButtonBadgeCount == -1) {
        [[SLPhotosLookup sharedInstance] lookupWithUserId:userId];
    }
    
    [[FSFriendLookup sharedInstance] addObserver:self
                                      forKeyPath:@"info"
                                         options:(NSKeyValueObservingOptionNew)
                                         context:NULL];
    
    [[FSUserLookup sharedInstance] addObserver:self
                                    forKeyPath:@"info"
                                       options:(NSKeyValueObservingOptionNew)
                                       context:NULL];
    
    [[FSTipsLookup sharedInstance] addObserver:self
                                    forKeyPath:@"tips"
                                       options:(NSKeyValueObservingOptionNew)
                                       context:NULL];    
    
    [[SLPhotosLookup sharedInstance] addObserver:self
                                      forKeyPath:@"photos"
                                         options:NSKeyValueObservingOptionNew
                                         context:NULL];
    
    [[FSFriendOps sharedInstance] addObserver:self
                                   forKeyPath:@"success"
                                      options:NSKeyValueObservingOptionNew
                                      context:NULL];
    
    [[FSFriendOps sharedInstance] addObserver:self
                                   forKeyPath:@"error"
                                      options:NSKeyValueObservingOptionNew
                                      context:NULL];
    
    [self loadState];    
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[FSFriendLookup sharedInstance] removeObserver:self forKeyPath:@"info"];
    [[FSUserLookup sharedInstance] removeObserver:self forKeyPath:@"info"];
    [[FSTipsLookup sharedInstance] removeObserver:self forKeyPath:@"tips"];
    [[SLPhotosLookup sharedInstance] removeObserver:self forKeyPath:@"photos"];
    [[FSFriendOps sharedInstance] removeObserver:self forKeyPath:@"success"];
    [[FSFriendOps sharedInstance] removeObserver:self forKeyPath:@"error"];        
    
    [[FSUserLookup sharedInstance] cancel];
    [[FSFriendLookup sharedInstance] cancel];
    [[SLPhotosLookup sharedInstance] cancel];
    [[FSFriendOps sharedInstance] cancel];
    [[FSTipsLookup sharedInstance] cancel];
    
	[super viewWillDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

#pragma mark UITableView

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    if (friendInfo != nil && [tableSectionFooters count] - 1 < section) {
      
        return [NSString stringWithFormat:@"%@ follows %d friends", 
                [[self.info objectForKey:@"user"] objectForKey:@"firstname"], 
                [[self.friendInfo objectForKey:@"friends"] count]];
        
    } else if (friendInfo == nil && [tableSectionFooters count] - 1 < section) {
        
        return nil;       
        
	} else if (![[tableSectionFooters objectAtIndex:section] isEqual:@""]) {
        
        return [tableSectionFooters objectAtIndex:section];
    }
	
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableSectionHeaders count] -1 < section) {
        
        return @"Friends";
        
    } else if (![[tableSectionHeaders objectAtIndex:section] isEqual:@""]) {
        
        return [tableSectionHeaders objectAtIndex:section];
    }
	
    return nil;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{      
    return [tableSections count] + 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
     if (self.friendInfo != nil && [tableSections count] -1 < section) {
         
         return [[self.friendInfo objectForKey:@"friends"] count];
         
     } else if (self.friendInfo == nil && [tableSections count] -1 < section) {
         
         return 1;
         
     } else {
                  
        return [(NSArray*)[tableSections objectAtIndex:section] count];
         
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{      
    static NSString *userTableCells = @"user";
    
    if (self.friendInfo != nil && [tableSections count] -1 < indexPath.section) {
        
        UserTableViewCell *cell = (UserTableViewCell*)[_tableView dequeueReusableCellWithIdentifier:userTableCells];
        if (cell == nil) {
            cell = [[[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userTableCells] autorelease];
        }
        
        cell.textLabel.text = [FSUserLookup formatUserName:[[self.friendInfo objectForKey:@"friends"] objectAtIndex:indexPath.row]];
        cell.avatarImageUrl = [(NSArray*)[[self.friendInfo objectForKey:@"friends"] objectAtIndex:indexPath.row] objectForKey:@"photo"];
        
        return cell;
       
    } else if (self.friendInfo == nil && [tableSections count] -1 < indexPath.section) {
        
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        
        UIView *bg = [[UIView alloc] initWithFrame:CGRectNull];
        bg.backgroundColor = [UIColor clearColor];
        cell.backgroundView = bg;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [bg release];
        
        UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act.center = CGPointMake(320.0f/2, 44.0f/2);
        [cell addSubview:act];
        [act startAnimating];
        [act release];
        
        return cell;
        
    } else {
        
        return (UITableViewCell*)[(NSArray*)[tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        if ([[[self.info objectForKey:@"user"] objectForKey:@"badges"] count] > 0) {
            BadgesViewController320 *mayor = [[BadgesViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
            mayor.info = self.info;
            [self.navigationController pushViewController:mayor animated:YES];
            [mayor release];
            
            [self saveState:indexPath];
        }
        
    } else if (self.friendInfo != nil && [tableSections count] -1 < indexPath.section) {
        
        UserViewController320 *detailViewController = [[UserViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.info = [NSMutableDictionary dictionaryWithObject:[[self.friendInfo objectForKey:@"friends"] objectAtIndex:indexPath.row] forKey:@"user"];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        
        viewPushed = YES;
        
        [self saveState:indexPath];
        
    } else if (([cell class] == [ActionTableViewCell class] || [cell superclass] == [ActionTableViewCell class]) && ((ActionTableViewCell*)cell).tapAction != nil) {
        
        [self performSelector:((ActionTableViewCell*)cell).tapAction];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark -
#pragma mark Handlers

- (void)friendAcceptOrDeny:(id) sender
{
    _NSLog(@"friendAcceptOrDeny");
        
    friendOpActionSheet = [[UIActionSheet alloc] initWithTitle:@"This person would like to see your checkins" delegate:self 
                                             cancelButtonTitle:@"Cancel" 
                                        destructiveButtonTitle:@"Deny"
                                             otherButtonTitles:@"Accept", nil];
    
    [friendOpActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];    
}

//- (void)friendUnfollow:(id) sender
//{
//    _NSLog(@"friendUnfollow");
//
//    friendOpActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
//                                          cancelButtonTitle:@"Cancel" 
//                                     destructiveButtonTitle:@"Unfollow"
//                                          otherButtonTitles:nil];
//    
//    [friendOpActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
//    
//}

- (void)friendFollow:(id) sender
{
    _NSLog(@"friendFollow");
    
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"sending request" style:ModalOverlayStyleActivity];
    
    [[FSFriendOps sharedInstance] sendFriend:[[[self.info objectForKey:@"user"] objectForKey:@"id"] intValue]];
    
    friendOperation = @"follow";
}

- (void) tapSMS:(id) sender
{    
    
    if (NSClassFromString(@"MFMessageComposeViewController")) {
        
        if ([MFMessageComposeViewController canSendText]) {
        
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            picker.recipients = [NSArray arrayWithObject:[[info objectForKey:@"user"] objectForKey:@"phone"]];   // your recipient number or self for testing
            picker.body = @"";
            
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
        
    } else {
        
        smsActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
														cancelButtonTitle:@"Cancel" 
												   destructiveButtonTitle:nil
														otherButtonTitles:@"Open Messages app", nil ]; 
        
		[smsActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
    }
    
    _NSLog(@"sms");
}

- (void)tapSMSActionSheetButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (smsActionSheet.cancelButtonIndex == buttonIndex) {
        
	} else if (smsActionSheet.firstOtherButtonIndex == buttonIndex) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", 
                                                                         [[info objectForKey:@"user"] objectForKey:@"phone"]]]];
    }
    
}

- (void) tapEmail:(id) sender
{
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:[[info objectForKey:@"user"] objectForKey:@"email"]]];
        [self presentModalViewController:controller animated:YES];
        [controller release];
    }
    
    _NSLog(@"email");
}

- (void) tapFacebook:(id) sender
{
    
    facebookActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                            cancelButtonTitle:@"Cancel" 
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Open Facebook app", 
                                                              @"Show mobile site", nil ];
    
    [facebookActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
    
    _NSLog(@"facebook");
}

- (void)tapFacebookActionSheetButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (facebookActionSheet.cancelButtonIndex == buttonIndex) {
		
		[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] animated:YES];
        
	} else if (facebookActionSheet.firstOtherButtonIndex == buttonIndex) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"fb://profile=%@", 
                                                                         [[info objectForKey:@"user"] objectForKey:@"facebook"]]]];
        
    } else if (facebookActionSheet.firstOtherButtonIndex+1 == buttonIndex) {
        
        WebViewController *wvc = [[WebViewController alloc] init];
        wvc.url = [NSString stringWithFormat:@"http://www.facebook.com/profile.php?id=%@", [[info objectForKey:@"user"] objectForKey:@"facebook"], nil];
        [self.navigationController pushViewController:wvc animated:YES];
        [wvc release];    
    }     
}

- (void) tapTwitter:(id) sender
{
    
    twitterActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                        cancelButtonTitle:@"Cancel" 
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Open Twitter app", 
                                                          @"Show mobile site", nil ];
    
    [twitterActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
    
    _NSLog(@"twitter");
}

- (void)tapTwitterActionSheetButtonAtIndex:(NSInteger)buttonIndex
{
    
    int x = twitterActionSheet.firstOtherButtonIndex;
    
    if (twitterActionSheet.cancelButtonIndex == buttonIndex) {
		
		[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] animated:YES];
        
	} else if (twitterActionSheet.firstOtherButtonIndex == buttonIndex) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tweetie:///post?message=%@", 
                                                                         [[info objectForKey:@"user"] objectForKey:@"twitter"]]]];    
    } else if (twitterActionSheet.firstOtherButtonIndex+1 == buttonIndex) {
        
        WebViewController *wvc = [[WebViewController alloc] init];
        wvc.url = [NSString stringWithFormat:@"http://www.twitter.com/%@", [[info objectForKey:@"user"] objectForKey:@"twitter"], nil];
        [self.navigationController pushViewController:wvc animated:YES];
        [wvc release];    
    } 
}

- (void) tapPhone:(id) sender
{
    
    phoneActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Call", nil ];    
    [phoneActionSheet showInView:((AppDelegate*)[UIApplication sharedApplication].delegate).window];
    
    _NSLog(@"phone");
    
}

- (void)tapPhoneActionSheetButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (phoneActionSheet.cancelButtonIndex == buttonIndex) {
		
		[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] animated:YES];
        
	} else if (phoneActionSheet.firstOtherButtonIndex == buttonIndex) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", 
                                                                         [[info objectForKey:@"user"] objectForKey:@"phone"]]]];    
    }    
}

- (void) mayorshipButtonTapped:(id) sender
{
    
    if ([[[self.info objectForKey:@"user"] objectForKey:@"mayor"] count] > 0) {
        MayorshipsViewController320 *mayor = [[MayorshipsViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
        mayor.info = self.info;
        [self.navigationController pushViewController:mayor animated:YES];
        [mayor release];
    }
}

- (void) tipsButtonTapped:(id) sender
{
    
//    if ([[[self.info objectForKey:@"user"] objectForKey:@"badges"] count] > 0) {
//        BadgesViewController320 *mayor = [[BadgesViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
//        mayor.info = self.info;
//        [self.navigationController pushViewController:mayor animated:YES];
//        [mayor release];
//    }
    
    if (tipInfo == nil || [tipInfo count] == 0) return;
    
    Tips2ViewController320 *tip = [[Tips2ViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
    
    tip.userInfo = ((NSDictionary*)[info objectForKey:@"user"]);
    tip.tipInfo = tipInfo;
    
    [self.navigationController pushViewController:tip animated:YES];
    [tip release];
    
    viewPushed = YES;    
}

- (void) photosButtonTapped:(id) sender
{
//    PhotosViewController320 *mayor = [[PhotosViewController320 alloc] initWithStyle:UITableViewStylePlain pulldownStyle:SLPulldownNone];
//    mayor.info = self.info;
//    [self.navigationController pushViewController:mayor animated:YES];
//    [mayor release];
    
    if ([[[SLPhotosLookup sharedInstance].photos objectForKey:@"photos"] count] == 0) return;
    
    WebViewController *wvc = [[WebViewController alloc] init];
    wvc.url = [NSString stringWithFormat:@"%@user/%@?utm_source=app&utm_medium=iphone&utm_campaign=user", SL_WEBSITE_BASE_URL, [[self.info objectForKey:@"user"] objectForKey:@"id"]];
    [self.navigationController pushViewController:wvc animated:YES];
    [wvc release];

}

#pragma mark -
#pragma mark MailDelegates

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == smsActionSheet) {
     
        [self tapSMSActionSheetButtonAtIndex:buttonIndex];
        
    } else if (actionSheet == facebookActionSheet){
        
        [self tapFacebookActionSheetButtonAtIndex:buttonIndex];
        
    } else if (actionSheet == twitterActionSheet){
        
        [self tapTwitterActionSheetButtonAtIndex:buttonIndex];
        
    } else if (actionSheet == phoneActionSheet){
        
        [self tapPhoneActionSheetButtonAtIndex:buttonIndex];
        
    } else if (actionSheet == friendOpActionSheet) {
        
        if (actionSheet.destructiveButtonIndex == buttonIndex) {
        
            [self performSelector:@selector(performUnfollow) withObject:nil afterDelay:.25];
            
        } else if (actionSheet.firstOtherButtonIndex == buttonIndex) {
            
            [self performSelector:@selector(performAccept) withObject:nil afterDelay:.25];
        }
    }
    
    [actionSheet release];
}

- (void)performUnfollow
{
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"sending request" style:ModalOverlayStyleActivity];
    [[FSFriendOps sharedInstance] denyFriend:[[[self.info objectForKey:@"user"] objectForKey:@"id"] intValue]];

    friendOperation = @"deny";
}

- (void)performAccept
{
 
    [[[UIApplication sharedApplication] topView] showModalOverlayWithMessage:@"sending request" style:ModalOverlayStyleActivity];
    [[FSFriendOps sharedInstance] approveFriend:[[[self.info objectForKey:@"user"] objectForKey:@"id"] intValue]];
    
    friendOperation = @"accept";
}

#pragma mark -
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
        
    if ([object class] == [FSUserLookup class] && [keyPath isEqual:@"info"]) {
		
		if (self.info != nil) {
			[self.info addEntriesFromDictionary:[FSUserLookup sharedInstance].info];
		} else {
			self.info = [FSUserLookup sharedInstance].info;
		}
        
		[self loadTableSections];
		
        [(UITableView*)self.view reloadData];
        
        [[FSFriendLookup sharedInstance] lookupWithUserId:[(NSNumber*)[[self.info objectForKey:@"user"] objectForKey:@"id"] intValue]];
        
//        BadgesTableViewCell320 *c = (BadgesTableViewCell320*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//        c.info = [[self.info objectForKey:@"user"] objectForKey:@"badges"];                                                               
        
        mayorButtonBadgeCount = [[[self.info objectForKey:@"user"] objectForKey:@"mayor"] count];
        [mayorButton setCount:mayorButtonBadgeCount];        
        
    } else if ([object class] == [FSTipsLookup class] && [keyPath isEqual:@"tips"]) {
        
        self.tipInfo = [[FSTipsLookup sharedInstance].tips objectForKey:@"tips"];
        
        // refresh badges
        tipsButtonBadgeCount = [tipInfo count];
        [tipsButton setCount:tipsButtonBadgeCount];
        
    } else if ([object class] == [FSFriendLookup class] && [keyPath isEqual:@"info"]) {
        
        self.friendInfo = [FSFriendLookup sharedInstance].info;
        
		[self loadTableSections];
        
        [(UITableView*)self.view reloadData];
        
    } else if ([object class] == [FSFriendOps class] && [keyPath isEqual:@"success"]) {
        
        BOOL success = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if (success) {
            
            int userId = [[((NSDictionary*)[info objectForKey:@"user"]) objectForKey:@"id"] intValue];
            
            friendInfo == nil;
            [[FSUserLookup sharedInstance] lookupWithUserId:userId];
            
            [[[UIApplication sharedApplication] topView] hideModalOverlayWithSuccessMessage:@"OK" animation:YES];
            
        }
        
    } else if ([object class] == [FSFriendOps class] && [keyPath isEqual:@"error"]) {
        
        NSString *errStr = nil;
        
        NSError *_error = [change objectForKey:NSKeyValueChangeNewKey];
                           
       if ([_error userInfo] != nil) {
           
           errStr = [NSString stringWithFormat:@"%@ %@", [_error localizedDescription], [[_error userInfo] objectForKey:NSErrorFailingURLStringKey]];
           
       } else {
           
           errStr = [_error localizedDescription];
       }
       
       [[[UIApplication sharedApplication] topView] hideModalOverlayWithErrorMessage:errStr animation:YES];

    } else if ([keyPath isEqual:@"photos"]) {
        
        photosButtonBadgeCount = [[[SLPhotosLookup sharedInstance].photos objectForKey:@"photos"] count];
        [photosButton setCount:photosButtonBadgeCount];
    }
}

#pragma mark -
#pragma mark Table Selection State

- (void) loadState 
{
	
	if (lastIndex != nil) {
		
		[self.tableView selectRowAtIndexPath:lastIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
		[self.tableView deselectRowAtIndexPath:lastIndex animated:YES];
	}
	
	lastIndex = nil;	
}

- (void) saveState:(NSIndexPath *)indexPath 
{
	
    [lastIndex release]; lastIndex = nil;
	lastIndex = [indexPath retain];
}

#pragma mark -

- (void)dealloc {
    
    [tableSections release];
    [tableSectionHeaders release];
    [tableSectionFooters release];
    
    [tipsButton release];
    [mayorButton release];
	[photosButton release];
    
    [lastIndex release];
    
    [tipInfo release];
    [friendInfo release];  
    [info release];
    [super dealloc];
}

@end
