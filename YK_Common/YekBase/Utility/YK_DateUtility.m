//
//  YK_DateUtility.m
//  YK_B2C
//
//  Created by yekwhoami on 11-6-23.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YK_DateUtility.h"



@implementation YK_DateUtility
static NSDate* s_date;
static NSDate* s_nowDate;
+(void)setSysTime:(NSDate*)date{
	s_date = date;
	
	s_nowDate = [NSDate date];
}

+(NSDate*)sysTime{
	NSTimeInterval _second = [[NSDate date] timeIntervalSinceDate:s_nowDate];// 计算时间差
	_second = fabs(_second);
	if (_second>1.0) {
		_second = 1.0;
	}
	NSDate *_date = [s_date dateByAddingTimeInterval:fabs(_second)];
	[[self class] setSysTime:_date];
	return s_date;
}

+(BOOL)isOverDue:(NSString*)dateStr withDateFormat:(NSString*)dateFormat{
	@autoreleasepool{
	
        NSDate* _endDate = [YK_DateUtility NSStringDateToNSDate:dateStr withDateFormat:dateFormat];
        
        NSDate* _nowDate = [NSDate date];
        int _second = [_endDate timeIntervalSinceDate:_nowDate];
        
        if (_second<0) {
            return YES;
        }else {
            return NO;
        }
    }
}

+(BOOL)isNotBegin:(NSString*)dateStr withDateFormat:(NSString*)dateFormat{
	@autoreleasepool{	
        NSDate* _startDate = [YK_DateUtility NSStringDateToNSDate:dateStr withDateFormat:dateFormat];
        
        NSDate* _nowDate = [NSDate date];
        int _second = [_startDate timeIntervalSinceDate:_nowDate];
        
        if (_second<0) {
            return NO;
        }else {

            return YES;
        }
    }
}

+(NSDate *)NSStringDateToNSDate:(NSString *)string withDateFormat:(NSString*)dateFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd'T'HH:mm:ss'Z'")
    [formatter setDateFormat:dateFormat];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+(NSDate *)NSStringDateToNSDateTrimWhiteSpace:(NSString *)string withDateFormat:(NSString*)dateFormat{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd'T'HH:mm:ss'Z'")
    [formatter setDateFormat:dateFormat];
	NSString *afterTrimWhiteSpace = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDate *date = [formatter dateFromString:afterTrimWhiteSpace];
    return date;
}

+(NSString*)NSDateToNSString:(NSDate*)date withDateFormat:(NSString*)dateFormat{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];	
    [formatter setDateFormat:dateFormat];
	NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSDateComponents*)NSDateToNSDateComponents:(NSDate*)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = nil;
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	comps = [calendar components:unitFlags fromDate:date];
    return comps;
}
	
+(NSDateComponents*)DateTransformation:(int)_second withPrecision:(int)precision{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	switch (precision) {
		case YKNSMinuteCalendarUnit:{
			int tmpTime = _second;
			
			int second = tmpTime%60;
			tmpTime = (tmpTime - second)/60;
			int minute = tmpTime/60;
			
			[comps setSecond:second];
			[comps setMinute:minute];
			break;
		}
		case YKNSHourCalendarUnit:{
			int tmpTime = _second;
			
			int second = tmpTime%60;
			tmpTime = (tmpTime - second)/60;
			int minute = tmpTime%60;
			tmpTime = (tmpTime-minute)/60;
			int hour = tmpTime;
			
			[comps setSecond:second];
			[comps setMinute:minute];
			[comps setHour:hour];
			break;
		}
		case YKDayCalendarUnit:{
			int tmpTime = _second;
			
			int second = tmpTime%60;
			tmpTime = (tmpTime - second)/60;
			int minute = tmpTime%60;
			tmpTime = (tmpTime-minute)/60;
			int hour = tmpTime%24;
			int day = (tmpTime-hour)/24;
			
			[comps setSecond:second];
			[comps setMinute:minute];
			[comps setHour:hour];
			[comps setDay:day];
			break;
		}
		default:
			[comps setSecond:_second];
			break;
	}
	return comps;
}

@end


