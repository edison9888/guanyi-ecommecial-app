//
//  YKJudgeAppTimeout.h
//  Laredoute
//
//  Created by zwh on 11-12-8.
//  Copyright (c) 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>

//强制用来判断的测试sourceid
#define YK_TEST_SOURCEID		@"yek_iphone_test"

@interface YKJudgeAppTimeout : NSObject

/**
 判断当前包是否过期了
 @param:timeLimit超期时间 格式:2011-12-01 23:59:59
 
 示例代码: 在AppDelegate当中加入以下代码
 注:sourdId请传入项目当中的sourceId
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if([YKJudgeAppTimeout:@"2011-12-01 23:59:59" sourceId:YK_TEST_SOURCEID])
	{
		 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试版本" message:@"该测试版本已过期，请安装新包。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		 [alertView show];
		 [alertView release];
		 return YES;
	}
}
 */
+(BOOL)JudgeTimeout:(NSString*)timeLimit sourceId:(NSString*)sourceId;

@end
