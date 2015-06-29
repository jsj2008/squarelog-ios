#import "BadgesViewController320.h"
#import "BadgeTableViewCell320.h"
#import "ViewWithDot.h"

@implementation BadgesViewController320

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"Badges (%d)", [((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) count]];

    UIView *v = [[ViewWithDot alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    tableView.tableFooterView = v;
    [v release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ceil((double)[[[self.info objectForKey:@"user"] objectForKey:@"badges"] count]/2.0);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BadgeCell";
    
    BadgeTableViewCell320 *cell = (BadgeTableViewCell320*)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BadgeTableViewCell320 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //    description = "Congrats on your first check-in!";
    //    icon = "http://foursquare.com/img/badge/newbie.png";
    //    id = 1;
    //    name = Newbie;        
    
    int leftBadgeIndex = indexPath.row * 2;
    int rightBadgeIndex = indexPath.row * 2 + 1;
    
    NSDictionary *left = [((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) objectAtIndex:leftBadgeIndex];
    cell.leftData = left;
                                      
    if ([((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) count] >= rightBadgeIndex + 1) {
        
        NSDictionary *right = [((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) objectAtIndex:rightBadgeIndex];
        cell.rightData = right;
    } else {
        cell.rightData = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int leftBadgeIndex = indexPath.row * 2;
    int rightBadgeIndex = indexPath.row * 2 + 1;
    
    NSDictionary *left = [((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) objectAtIndex:leftBadgeIndex];
    NSDictionary *right = nil;
    
    if ([((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) count] >= rightBadgeIndex + 1) {
        
        right = [((NSArray*)[[self.info objectForKey:@"user"] objectForKey:@"badges"]) objectAtIndex:rightBadgeIndex];
    }
        
    return [BadgeTableViewCell320 calculateHeightWithWidth:320 leftBadge:left rightBadge:right];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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


- (void)dealloc {
    [info release];
    [super dealloc];
}


@end

