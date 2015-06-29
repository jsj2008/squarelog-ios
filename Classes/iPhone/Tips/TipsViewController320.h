#import <UIKit/UIKit.h>

#import "SlidingLabel.h"
#import "SLTableViewController.h"

@interface TipsViewController320 : SLTableViewController {

    NSDictionary *tips;
    NSDictionary *wikiPlaces;
    
	SlidingLabel *locationText;
	UISegmentedControl *pickerSegmentedControl;
}

- (void) reloadTips;
- (void) reloadWikipedia;

@property (nonatomic, retain) NSDictionary *tips;
@property (nonatomic, retain) NSDictionary *wikiPlaces;

@end
