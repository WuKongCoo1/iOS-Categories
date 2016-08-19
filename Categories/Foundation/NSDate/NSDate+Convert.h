//
//  NSDate+Convert.h
//  MonkeyCalendar
//
//  Created by 吴珂 on 16/6/8.
//  Copyright © 2016年 吴珂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Convert)

/**
 *  格式化为 yyyy-MM-dd
 *
 *
 *  @return eg:2015-11-15
 */
- (NSString *)convertToDayString;

/**
 *  格式化为 hh:mm
 *
 *  @param isTwentyHour 是否为24小时
 *
 *  @return eg: 14:18
 */
- (NSString *)convertToTimeString:(BOOL)isTwentyHour;

/**
 *  转换为标准时间
 *
 *  @return
 */
- (NSString *)formatToStandardString;

/**
 *  转换为包含毫秒标准时间
 *
 *  @return
 */
- (NSString *)formatToStandardStringContainsMESC;

/**
 *  格式化为指定的样式
 *
 *  @param formatString 格式化样式
 *
 *  @return 格式化结果
 */
- (NSString *)formatToString:(NSString *)formatString;

- (NSDate *)replaceTimeWithDate:(NSDate *)date;

@end
