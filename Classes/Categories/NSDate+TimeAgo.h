#import <Foundation/Foundation.h>

typedef enum {
    kTimeUnitTypeNow,
    kTimeUnitTypeMinutes,
    kTimeUnitTypeHours,
    kTimeUnitTypeDays,
} TimeUnitType;

@interface NSDate (TimeAgo) 
+ (NSNumber*) timeValWithDate:(NSDate*)_date;
+ (TimeUnitType) timeUnitWithDate:(NSDate*)_date;
+ (NSString*) timeStringWithDate:(NSDate*)_date showFraction:(BOOL)showFraction;
+ (NSString*) timeUnit:(TimeUnitType)timeUnit withValue:(float)value;
@end
