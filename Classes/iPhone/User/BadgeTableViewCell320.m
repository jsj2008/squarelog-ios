#import "BadgeTableViewCell320.h"
#import "NSDictionary+RenderTree.h"

#import "RenderTreeTextItem.h"

@implementation BadgeTableViewCell320

@synthesize badgeLeftImageUrl, leftData;
@synthesize badgeRightImageUrl, rightData;

static UIFont *nameFont;
static UIFont *descriptionFont;

+ (void) initialize {
    
    if (self == [BadgeTableViewCell320 class]) {
        
        nameFont = [UIFont boldSystemFontOfSize:14];
        descriptionFont = [UIFont systemFontOfSize:12];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        leftBadgeView = [[BadgeImageView alloc] initWithFrame:CGRectMake(30, 10, 100, 100)];
        [self addSubview:leftBadgeView];
        
        rightBadgeView = [[BadgeImageView alloc] initWithFrame:CGRectMake(190, 10, 100, 100)];
        [self addSubview:rightBadgeView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //paddingPixel = 0;
    }
    
    return self;
}

- (void)setRightData:(NSDictionary *)right
{
    [rightData release];
    rightData = right;
    [right retain];
    
    if (rightData) {
        rightBadgeView.imageUrl = [[rightData objectForKey:@"icon"] stringByReplacingOccurrencesOfString:@".png" withString:@"_big.png"];  
    } else {
        rightBadgeView.imageUrl = nil;
    }
    
    [self setNeedsDisplay];
}

- (void)setLeftData:(NSDictionary *)left
{
    [leftData release];
    leftData = left;
    [left retain];
    
    if (leftData) {
        leftBadgeView.imageUrl = [[leftData objectForKey:@"icon"] stringByReplacingOccurrencesOfString:@".png" withString:@"_big.png"];
    } else {
        leftBadgeView.imageUrl = nil;
    }
    
    [self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
//- (void)drawRect:(CGRect)r {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //[backgroundColor set];
    [[UIColor whiteColor] set];
    CGContextFillRect(context, r);
    
    // _NSLog([leftData description]);
    
    [((NSDictionary*)[leftData objectForKey:@"render_tree"]) drawAtPoint:CGPointMake(0, 120) selected:FALSE];
}

#pragma mark -
#pragma mark pre-render

+ (int) createRenderTreeWithWidth:(CGFloat)width leftBadge:(NSDictionary*)left rightBadge:(NSDictionary*)right
{
    
    int leftHeight = 0;
    
    NSMutableDictionary *renderTree = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:@"items"];
    NSMutableArray *renderItems = [renderTree objectForKey:@"items"];
    
    [left setObject:renderTree forKey:@"render_tree"];
    [renderTree retain];
    
    // left
    
    if ([left objectForKey:@"name"]) {
        
        CGSize size = [[left objectForKey:@"name"] sizeWithFont:nameFont 
                                             constrainedToSize:CGSizeMake(140, 200) 
                                                 lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [left objectForKey:@"name"];
        item.rect = CGRectMake(10, leftHeight, 140, size.height);
        item.font = nameFont;
        item.alignment = UITextAlignmentCenter;
        item.color = blackColor;
        [renderItems addObject:item];
        [item release];
        
        leftHeight = leftHeight + size.height;    
        leftHeight += 2;
    }
    
    if ([left objectForKey:@"description"]) {
        
        CGSize size = [[left objectForKey:@"description"] sizeWithFont:descriptionFont 
                                                    constrainedToSize:CGSizeMake(140, 200) 
                                                        lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [left objectForKey:@"description"];
        item.rect = CGRectMake(10, leftHeight, size.width, size.height);
        item.font = descriptionFont;
        item.color = [UIColor grayColor];
        [renderItems addObject:item]; 
        [item release];
        
        leftHeight = leftHeight + size.height;    
        leftHeight += 2;
    }
    
    leftHeight += 10;
    
    
    int rightHeight = 0;
    
    // right
    
    if ([right objectForKey:@"name"]) {
        
        CGSize size = [[right objectForKey:@"name"] sizeWithFont:nameFont 
                                              constrainedToSize:CGSizeMake(140, 200) 
                                                  lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [right objectForKey:@"name"];
        item.rect = CGRectMake(170, rightHeight, 140, size.height);
        item.font = nameFont;
        item.alignment = UITextAlignmentCenter;
        item.color = blackColor;
        [renderItems addObject:item];
        [item release];
        
        rightHeight = rightHeight + size.height;    
        rightHeight += 2;
    }
    
    if ([right objectForKey:@"description"]) {
        
        CGSize size = [[right objectForKey:@"description"] sizeWithFont:descriptionFont 
                                                     constrainedToSize:CGSizeMake(140, 200) 
                                                         lineBreakMode:UILineBreakModeWordWrap];
        
        RenderTreeTextItem *item = [RenderTreeTextItem new];
        item.text = [right objectForKey:@"description"];
        item.rect = CGRectMake(170, rightHeight, size.width, size.height);
        item.font = descriptionFont;
        item.color = [UIColor grayColor];
        [renderItems addObject:item];  
        [item release];
        
        rightHeight = rightHeight + size.height;    
        rightHeight += 2;
    }
    
    rightHeight += 10;    
    
    return MAX(leftHeight, rightHeight);
}

+(int) calculateHeightWithWidth:(int)width leftBadge:(NSDictionary*)left rightBadge:(NSDictionary*)right
{
    if (![left objectForKey:@"height"]) {
        
        [left setObject:[NSNumber numberWithInt:[BadgeTableViewCell320 createRenderTreeWithWidth:width leftBadge:left rightBadge:right]] forKey:@"height"];
    }
    
    return MAX(120+[[(NSNumber*)left objectForKey:@"height"] intValue], 120);
}

- (void)dealloc {
    self.leftData = nil;
    self.rightData = nil;
    [leftBadgeView release];
    [rightBadgeView release];
    [super dealloc];
}


@end