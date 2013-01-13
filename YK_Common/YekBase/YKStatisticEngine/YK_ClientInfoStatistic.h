//
//  YK_ClientInfoStatistic.h
//  Moonbasa
//
//  Created by wtfan on 11-9-21.
//  Copyright 2011年 Yek. All rights reserved.
//
// 成功时步骤：
// 1. 删除本地数据库中该条纪录。
// 2. 通知代理请求成功。
//
// 失败时：
// 1. 拷贝一份数据，保存到本地数据库中。
// 2. 从数据库中删除该纪录。
// 为什么按照以上步骤的原因是：
// 1. 外部接口调用，即为请求成功时，应该纪录到服务器，待下次请求。
// 2. 统计引擎定时器调用，即在数据库中已经存在该纪录。

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"
#import "YK_TimeStatistic.h"

@protocol YK_ClientInfoStatisticDelegate <NSObject>

@optional
-(void)onRequestClientInfoStatisticFailed:(ASIHTTPRequest*)request;
-(void)onRequestClientInfoStatisticFinished:(NSString*)sessionid;

@end

@interface YK_ClientInfoStatistic : YK_BaseData 
<YK_TimeStatisticDelegate>{
    id<YK_ClientInfoStatisticDelegate> __unsafe_unretained delegate;
    YK_TimeStatistic* _timeStatistic;
    
	NSString* musername;      // 用户名
	NSString* muserid;        // 用户id   唯一标识用户
    
    NSString* mresult;        // 提交客户端是否成功标志位
    NSString* msessionid;     // 供提交订单信息接口使用的参数
    NSString* mdesc;          // 提交客户端信息返回的描述
}
@property (nonatomic, unsafe_unretained) id<YK_ClientInfoStatisticDelegate> delegate;

@property (nonatomic, strong) NSString* musername;
@property (nonatomic, strong) NSString* muserid;

@property (nonatomic, strong) NSString* mresult;
@property (nonatomic, strong) NSString* msessionid;
@property (nonatomic, strong) NSString* mdesc;

-(void)postClientinfo;
-(void)onPostClientinfoFinished:(ASIHTTPRequest*)request;
-(void)onPostClientinfoFailed:(ASIHTTPRequest*)request;
@end

