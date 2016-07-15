//
//  NSDate+DateParts.h
//  Knockdown
//
//  Created by Robert Miller on 6/23/16.
//  Copyright © 2016 Silversphere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateParts)

@property(nonatomic) NSInteger intHour;
@property(nonatomic) NSInteger minute;
@property(nonatomic) NSInteger second;
@property(nonatomic) NSInteger intDay;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger theHour;

@property(nonatomic,retain) NSString *dayString;
@property(nonatomic,retain) NSString *monthString;

@property(nonatomic,retain) NSString *ampm;

@property(nonatomic,retain) NSString *minuteString;

+(NSDate *)formattedDateWithDateString:(NSString *)dateString withFormat:(NSString *)dateFormat;

@end
