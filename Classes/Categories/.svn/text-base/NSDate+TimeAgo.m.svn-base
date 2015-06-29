#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)

+ (NSNumber*) timeValWithDate:(NSDate*)_date {
    
    NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceDate:_date];
    
    if (intervalInSeconds < 60) {
        
        return [NSNumber numberWithInt:0];
        
    } else if (intervalInSeconds < 60*60) {
        
        return [NSNumber numberWithFloat:((float)intervalInSeconds/(60.0))];
        
    } else if (intervalInSeconds < 60*60*24) {
        
        return [NSNumber numberWithFloat:((float)intervalInSeconds/(60*60.0))];
        
    } else { //if (intervalInSeconds < 60*60*24) {
        
        return [NSNumber numberWithFloat:((float)intervalInSeconds/(60*60*24.0))];
    }
    
}

+ (TimeUnitType) timeUnitWithDate:(NSDate*)_date {
    
    NSTimeInterval intervalInSeconds = [[NSDate date] timeIntervalSinceDate:_date];
    
    if (intervalInSeconds < 60) {
        
        return kTimeUnitTypeNow;
        
    } else if (intervalInSeconds < 60*60) {
        
        return kTimeUnitTypeMinutes;
        
    } else if (intervalInSeconds < 60*60*24) {
        
        return kTimeUnitTypeHours;
        
    } else { //if (intervalInSeconds < 60*60*24) {
        
        return kTimeUnitTypeDays;
    }
}

+ (NSString*) timeUnit:(TimeUnitType)timeUnit withValue:(float)value;
{  
    switch (timeUnit) {
        case (kTimeUnitTypeNow):
            return @"now";
        case (kTimeUnitTypeMinutes):
			if (value <= 1.45) return @"minute";
            else return @"minutes";
        case (kTimeUnitTypeHours):
			if (value <= 1.45) return @"hour";
            else return @"hours";
        case (kTimeUnitTypeDays):
 			if (value <= 1.45) return @"day";
            else return @"days";
        default:
            return @"????";
    }
}

+ (NSString*) timeStringWithDate:(NSDate*)_date showFraction:(BOOL)showFraction
{
    
	float diff = [[NSDate timeValWithDate:_date] floatValue];
	
	if (showFraction && (diff - floor(diff)) > .45 && (ceil(diff) - diff) < .55 && diff < 5) {
	
		return [NSString stringWithFormat:@"%d½", (int)floor(diff)];
		
	} else {
		
		return [NSString stringWithFormat:@"%d", (int)round(diff)];
	}
}

@end
