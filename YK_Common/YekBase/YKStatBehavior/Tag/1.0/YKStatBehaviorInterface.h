//
//  YKStatBehaviorInterface.h
//  Moonbasa
//
//  Created by zhi.zhu on 11-9-14.
//  Copyright 2011 Yek. All rights reserved.
//
//  描述:初始化行为统计需要用到的一些初始数据,提供一些获取映射的方法

/**
 页面跳转统计以通知的方式添加在MoonbasaAppDelegate里,通知在BaseViewController的
 viewWillAppear里发送.
 */
#import <Foundation/Foundation.h>

/**
  用户操作ID
 */
extern const int YK_STATBEHAVIOR_OPERATION_CLICK;//用户点击
extern const int YK_STATBEHAVIOR_OPERATION_ADD_TO_SHOPPINGCART;//加入购物车
extern const int YK_STATBEHAVIOR_OPERATION_ADD_TO_FAVOURITE;//加入收藏夹
extern const int YK_STATBEHAVIOR_OPERATION_SUBMITORDER_FAIlED;//提交订单失败
extern const int YK_STATBEHAVIOR_OPERATION_SUBMITORDER_SUCCESS;//提交订单成功

@interface YKStatBehaviorInterface : NSObject <NSXMLParserDelegate>{
    
}

/**
    提交统计数据
 */

// 启动行为统计
+(BOOL)start:(NSDictionary*)extraParams;

// 重置行为统计模块，重新获取时间戳，当程序切换到后台，又切回来时调用
+(BOOL)reset;

// 程序启动    runNum:启动次数，version:app版本号
+(BOOL)logEvent_AppStartupWithRunNum:(NSInteger)runNum version:(NSString*)version;

// 程序状态变化   state:状态 0异常、1后台、2前台
+(BOOL)logEvent_StateChange:(NSInteger)state;

// 程序退出     state:0异常、1正常
+(BOOL)logEvent_AppExit:(NSInteger)state;

// 页面跳转     aimPath:目的页面的Path
+(BOOL)logEvent_PageJumpWithAimPath:(NSString *)aimPath paramObject:(id)pObject;
+(BOOL)logEvent_PageJumpWithAimPath:(NSString *)aimPath param:(NSString *)param;

// 用户操作     operateId:操作id  param:辅助参数
+(BOOL)logEvent_OperateWithOperateId:(NSInteger)operateId param:(NSString*)param;

// 扩展指令     extendId:扩展事件id   param:辅助参数
+(BOOL)logEvent_ExtendEventWithExtendId:(NSInteger)extendId param:(NSString*)param;

// 获取当前的商品来源页面id
+(NSInteger)currentSourcePageId;

// 保存商品的来源页面id
+(BOOL)saveSourcePageId:(NSInteger)sourcePageId withSku:(NSString *)sku;

// 获取商品的来源页面id
+(NSInteger)sourcePageIdWithSku:(NSString *)sku;

// 删除某件商品的来源页面id缓存
+(BOOL)clearSourcePageIdWithSku:(NSString *)sku;

// 清空保存的商品来源id缓存
+(BOOL)clearAllSourcePageId;

@end