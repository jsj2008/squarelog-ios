#import <Foundation/Foundation.h>

typedef enum {
    FSCheckinTypeCheckin,
    FSCheckinTypeShout,
    FSCheckinTypeOffGrid
} FSCheckinType;

@interface FSCheckin : NSObject <NSCoding> {

    NSNumber *userId;
    NSDate *date;
    NSArray *renderTree;
    NSNumber *height;
    NSString *avatarUrl;
    FSCheckinType checkinType;
    NSMutableDictionary *data;
}

@property (nonatomic, retain) NSNumber *userId;

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSArray *renderTree;
@property (nonatomic, retain) NSString *avatarUrl;

@property FSCheckinType checkinType;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSMutableDictionary *data;

@end
