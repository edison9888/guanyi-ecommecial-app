//
//  YKTimeUtility.h
//  TestTimer
//
//  Created by zhi.zhu on 11-8-10.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YKTimeUtility : NSObject {

	
}

+(void)resetBaseDateAndStartTimer:(NSDate *)baseDate;//重置时间并启动定时器
+(void)startTimer;//启动定时器
+(void)stopTimer;//停止定时器
+(NSDate *)currentDate;//获取当前时间(baseDate通过计时器累加的结果)
@end
