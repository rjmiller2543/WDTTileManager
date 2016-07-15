//
//  NSDate+DateParts.m
//  Knockdown
//
//  Created by Robert Miller on 6/23/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import "NSDate+DateParts.h"

@implementation NSDate (DateParts)

@dynamic intHour,minute,intDay,year,month,second,dayString,monthString,ampm,theHour,minuteString;

-(NSInteger)_Hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour) fromDate:self];
    return [components hour];
}

-(NSInteger)intHour {
    return ([self _Hour] <=12) ? [self _Hour] : ([self _Hour] - 12);
}

-(NSInteger)theHour {
    return [self _Hour];
}

-(NSInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute) fromDate:self];
    return [components minute];
}

-(NSInteger)intDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [components day];
}

-(NSInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear) fromDate:self];
    return [components hour];
}

-(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth) fromDate:self];
    return [components hour];
}

-(NSInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitSecond) fromDate:self];
    return [components hour];
}

-(NSString *)dayString {
    NSDateFormatter *todaysDateFormatter = [[NSDateFormatter alloc] init];
    todaysDateFormatter.dateFormat = @"EEEE";
    
    return [todaysDateFormatter stringFromDate:self];
}

-(NSString *)monthString {
    NSDateFormatter *todaysDateFormatter = [[NSDateFormatter alloc] init];
    todaysDateFormatter.dateFormat = @"MMMM";
    
    return [todaysDateFormatter stringFromDate:self];
}

-(NSString *)ampm {
    return ([self _Hour] <= 12) ? @"am" : @"pm";
}

-(NSString *)minuteString {
    NSInteger minute = self.minute;
    if (minute < 10) {
        return [NSString stringWithFormat:@"0%ld",minute];
    }
    else return [NSString stringWithFormat:@"%ld", minute];
}

+(NSDate *)formattedDateWithDateString:(NSString *)dateString withFormat:(NSString *)dateFormat {
    
    if (dateString == nil || [dateString isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormat];
        
        return [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    
    return [dateFormatter dateFromString:dateString];
    
}

@end
