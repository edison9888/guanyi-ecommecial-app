//
//  YKTimeUtility.m
//  TestTimer
//
//  Created by zhi.zhu on 11-8-10.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YKTimeUtility.h"


@implementation YKTimeUtility
NSDate *_baseDate;
NSTimer *_timer;
-(void) dealloc
{
	[_timer invalidate];
}
+(void) setBaseDate:(NSDate *)baseDate
{
	if (baseDate!=_baseDate)
	{
		_baseDate = baseDate;
	}
}
+(void) resetBaseDateAndStartTimer:(NSDate *)baseDate
{
	[self setBaseDate:baseDate];
	[self startTimer];
}
+(NSDate *) currentDate
{
	return _baseDate;
}
+(void) startTimer
{
	if (!_timer)
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
	}
	
}
+(void) stopTimer
{
	if (_timer)
	{
		[_timer invalidate];
		_timer = nil;
	}
}
+(void)timerHandler
{
	if (!_baseDate)
	{
		_baseDate = [NSDate date];
	}
	[self setBaseDate:[_baseDate dateByAddingTimeInterval:1]];
}

@end
