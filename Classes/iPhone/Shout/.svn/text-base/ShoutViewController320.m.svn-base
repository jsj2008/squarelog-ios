#import "ShoutViewController320.h"
#import "CheckinTableViewCell.h"
#import "UserViewController320.h"
#import "ViewItem.h"
#import "UserHeader.h"

@implementation ShoutViewController320

@synthesize info;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
    [super loadView];
    
    UserHeader *user = [[UserHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    user.info = self.info; 
    self.tableView.tableHeaderView = user;
    [user release];
    
    tableSections = [[NSMutableArray array] retain];
    tableSectionHeaders = [[NSMutableArray array] retain];
    
    [self loadTableSections];
}

- (void) loadTableSections
{
    
    [tableSections removeAllObjects];
    [tableSectionHeaders removeAllObjects];
    
    // section 2
    NSMutableArray *section0 = [[NSMutableArray array] retain];
    CheckinTableViewCell *cell = [[CheckinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.delegate = self;
    cell.info = self.info;
    [section0 addObject:cell];
    [cell release]; cell = nil;
    [tableSections addObject:section0];
    [tableSectionHeaders addObject:@""];
    [section0 release];        
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [(UIView*)[[tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] sizeThatFits:CGSizeZero].height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (![[tableSectionHeaders objectAtIndex:section] isEqual:@""]) {
        return [tableSectionHeaders objectAtIndex:section];
    }
    
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

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	
	if ([self.info objectForKey:@"user"] && indexPath.section == 0) {
		UserViewController320 *detailViewController = [[UserViewController320 alloc] initWithStyle:UITableViewStyleGrouped];
		detailViewController.info = self.info;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

#pragma mark -
#pragma mark BubbleView Delegate

-(void)viewItemTapped:(id)sender
{
    [ViewItem handleTap:sender controller:self];
}

- (void)dealloc
{
    LOG_EXPR([info retainCount]);
    [info release];
    [tableSections release];
    [tableSectionHeaders release];
    [super dealloc];
}


@end

