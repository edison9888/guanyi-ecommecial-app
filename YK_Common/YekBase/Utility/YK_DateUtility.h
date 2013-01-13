//
//  YK_DateUtility.h
//  YK_B2C
//
//  Created by yekwhoami on 11-6-23.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _YKDatePrecisionWords{
	YKDayCalendarUnit = 0,
	YKNSHourCalendarUnit,
	YKNSMinuteCalendarUnit,
}YKDatePrecisionWords;

@interface YK_DateUtility : NSObject {
	
}
+(NSDate*)sysTime;
+(void)setSysTime:(NSDate*)date;

+(BOOL)isOverDue:(NSString*)dateStr withDateFormat:(NSString*)dateFormat;
+(BOOL)isNotBegin:(NSString*)dateStr withDateFormat:(NSString*)dateFormat;
+(NSDate*)NSStringDateToNSDate:(NSString *)string withDateFormat:(NSString*)dateFormat;
+(NSDate *)NSStringDateToNSDateTrimWhiteSpace:(NSString *)string withDateFormat:(NSString*)dateFormat;//功能同上，自动去除string里的所有空格
+(NSString*)NSDateToNSString:(NSDate*)date withDateFormat:(NSString*)dateFormat;
+(NSDateComponents*)NSDateToNSDateComponents:(NSDate*)date;
+(NSDateComponents*)DateTransformation:(int)second withPrecision:(int)precision;

@end
