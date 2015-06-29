#import <UIKit/UIKit.h>

@interface CheckInPhotoButtonCell : UITableViewCell {

    id delegate;
    NSArray *imageFileNames;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSArray *imageFileNames;

@end