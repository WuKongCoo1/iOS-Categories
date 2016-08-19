//
//  NSDate+Convert.m
//  MonkeyCalendar
//
//  Created by 吴珂 on 16/6/8.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import "NSDate+Convert.h"

@implementation NSDate (Convert)

- (NSString *)convertToDayString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    return [df stringFromDate:self];
    
}

- (NSString *)convertToTimeString:(BOOL)isTwentyHour
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = isTwentyHour ? @"HH:mm" : @"hh:mm";
    
    return [df stringFromDate:self];
}


- (NSString *)formatToStandardString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [df stringFromDate:self];
}

- (NSString *)formatToStandardStringContainsMESC
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    return [df stringFromDate:self];
}

- (NSString *)formatToString:(NSString *)formatString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = formatString;
    
    return [df stringFromDate:self];
}

- (NSDate *)replaceTimeWithDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *originalString = [self formatToStandardString];
    
    NSString *originalTimeString = [self convertToTimeString:YES];
    NSString *sourceTimeString = [date convertToTimeString:YES];
    
    NSString *resultString = [originalString stringByReplacingCharactersInRange:[originalString rangeOfString:originalTimeString] withString:sourceTimeString];
    
    NSDate *result = [df dateFromString:resultString];
    
    return result;
    
}

@end
