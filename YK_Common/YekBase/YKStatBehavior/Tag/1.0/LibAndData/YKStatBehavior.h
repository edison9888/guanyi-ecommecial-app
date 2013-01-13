//
//  YKStatBehavior.h
//  YKStatBehavior
//
//  Created by Liu Yuhui on 11-8-19.
//  Copyright 2011年 YeKe.com. All rights reserved.
//
//  行为统计模块YKStatBehavior.dll接口

#import <Foundation/Foundation.h>

@interface YKStatBehavioEngine : NSObject { 
}     

/*
 额外参数:以以下名字为key的字典（任何一项都不能为空）:
 //用于http头
 productcode：应用程序名字
 appversion：客户端版本号
 sourcesubid：子渠道号
 
 //其他
 appname：应用名称,Vancl,Vjia等
 sourceid：渠道号,Yek_001等
 isrealurl：是否是真实服务器，返回@"YES",使用真实服务器，返回@"NO"使用测试服务器，默认使用真实服务器（如果不提供此函数）
 */
// 启动行为统计
+(BOOL)start:(NSDictionary*)extraParams;

// 重置行为统计模块，重新获取时间戳，当程序切换到后台，又切回来时调用
+(BOOL)reset;

// 程序启动    runNum:启动次数，version:app版本号
+(BOOL)logEvent_AppStartup:(NSInteger)pageId runNum:(NSInteger)runNum version:(NSString*)version;

// 程序状态变化   state:状态 0异常、1后台、2前台
+(BOOL)logEvent_StateChange:(NSInteger)pageId state:(NSInteger)state;

// 程序退出     state:0异常、1正常
+(BOOL)logEvent_AppExit:(NSInteger)pageId state:(NSInteger)state;

// 页面跳转     pageId:目的页面的id  param:辅助参数
+(BOOL)logEvent_PageJump:(NSInteger)pageId aimPageId:(NSInteger)aimPageId param:(NSString*)param;

// 用户操作     operateId:操作id  param:辅助参数
+(BOOL)logEvent_Operate:(NSInteger)pageId operateId:(NSInteger)operateId param:(NSString*)param;

// 扩展指令     extendId:扩展事件id   param:辅助参数
+(BOOL)logEvent_ExtendEvent:(NSInteger)pageId extendId:(NSInteger)extendId param:(NSString*)param;

@end
