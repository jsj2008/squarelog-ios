#import "ViewItem.h"

#import "URLLabel.h"
#import "URLImageView.h"

#import "WebViewController.h"

@implementation ViewItem

+ (BOOL) handleTap:(id)sender controller:(UIViewController*)controller
{
    if ([sender class] == [URLLabel class]) {
        
        URLLabel *l = (URLLabel*)sender;
        
        if ([[l.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"]) {
            
            WebViewController *wvc = [[WebViewController alloc] init];
            wvc.url = [NSString stringWithFormat:@"http://twitter.com/%@", [l.text substringWithRange:NSMakeRange(1, [l.text length]-1)], nil];
            [controller.navigationController pushViewController:wvc animated:YES];
            [wvc release];
            
            return YES;
            
        } else if ([l.text length] > 9 && [[l.text substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"http://"]) {
            
            WebViewController *wvc = [[WebViewController alloc] init];
            wvc.url = l.text;
            [controller.navigationController pushViewController:wvc animated:YES];
            [wvc release];
            
            return YES;
        }
        
    } else if ([sender class] == [URLImageView class]) {
        
        URLImageView *l = (URLImageView*)sender;
        
        WebViewController *wvc = [[WebViewController alloc] init];
        wvc.url = l.imageUrl2;
        [controller.navigationController pushViewController:wvc animated:YES];
        [wvc release];
        
        return YES;
    }
    
    return NO;
    
}

@end
