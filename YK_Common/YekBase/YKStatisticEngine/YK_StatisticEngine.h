//
//  YK_StatisticEngine.h
//  Moonbasa
//
//  Created by wtfan on 11-9-21.
//  Copyright 2011年 Yek. All rights reserved.
//
//  功能：后台统计
//    1. 客户端统计。装机量统计，开机即统计。
//    2. 订单统计，当用户提交订单成功时提交订单统计。
//  YK_StatisticEngine作为后台统计引擎，在程序启动时就调用。
//  该类为单例模式，定时5分钟无限循环。
//
//  接口测试、日志查看地址（用浏览器访问，提交后查看源文件，可以看到提交的返回结果）
//  http://mobapi.250y.com/test/clientTest.php
//

#import <UIKit/UIKit.h>

@class YK_ClientInfoStatistic;
@class YK_OkOrderInfoStatistic;
@class YKHttpEngine;

@protocol YK_StatisticEngineDelegate <NSObject>

/**
    获取推广ID
 */
-(NSString*)sourceid;

/**
    获取推广子ID
 */
-(NSString*)sourcesubid;

/**
    获取productcode
 */
-(NSString*)productcode;

/**
    获取通信协议版本
 */
-(NSString*)ver;

@end

@interface YK_StatisticEngine : NSObject{
    id<YK_StatisticEngineDelegate> __unsafe_unretained delegate;
    
    NSString* m_str_url_time;
    NSString* m_str_url_clientInfo;
    NSString* m_str_url_orderInfo;
    
    YKHttpEngine* _m_httpEngine;
    NSDate* _m_date_CS;
}
@property (nonatomic, strong) NSString* m_str_url_time;
@property (nonatomic, strong) NSString* m_str_url_clientInfo;
@property (nonatomic, strong) NSString* m_str_url_orderInfo;

@property (nonatomic, unsafe_unretained) id<YK_StatisticEngineDelegate> delegate;
@property (nonatomic, strong) YKHttpEngine* m_httpEngine;
@property (nonatomic, strong) NSDate* m_date_CS;

/**
    获取Sourceid
 */
-(NSString*)sourceid;

/**
 获取推广子ID
 */
-(NSString*)sourcesubid;

/**
 获取productcode
 */
-(NSString*)productcode;

/**
 获取通信协议版本
 */
-(NSString*)ver;

/**
    获取统计后台引擎的单例对象。
 */
+(YK_StatisticEngine*)sharedStatisticEngine;

/**
    获取HttpEngine
 */
+(YKHttpEngine*)sharedHttpEngine;

/**
    设置客户的系统时间
 */
-(void)setCSDate:(NSDate*)csDate;

/**
    获取客户的系统时间
 */
-(NSDate*)csDate;

/**
    开启后台统计，每间隔一段时间(timeInterval秒)循环一次。
    参数:
    1. (NSTimeInterval)timeInterval 提交统计数据的间隔时间,单位是"秒".
    调用方法:
    1. 循环YK_ClientInfoStatistic数据库，发送请求。
    2. 循环OrderInfoStatistic数据库，发送请求。
 */
+(void)startStatisticDaemon:(NSTimeInterval)timeInterval;

/**
    关闭后台统计。
 */
+(void)stopStatisticDaemon;

/**
    由StatisticDaemon循环调用,从本地数据库读取未发送成功的请求,并发送
 */

+(void)postStatistic;

/**
    @description 客户端启动以后，在网络连接成功时应立即把信息发送到接口上。
    本流程只调用ClientInfoStatistic的请求方法，具体的业务逻辑在它自己的类中实现。
    流程：1. 发送请求。
         2. 请求失败时，保存YK_ClientInfoStatistic数据至本地Sqlite中。
 */
+(void)postClientInfoStatistic:(YK_ClientInfoStatistic*)_clientInfoStatistic;

/**
    @description 客户端启动以后，在网络连接成功时应立即把信息发送到接口上。
    本流程只调用YK_ClientInfoStatistic的请求方法，具体的业务逻辑在它自己的类中实现。
    流程：1. 发送请求。
         2. 请求失败时，保存YK_ClientInfoStatistic数据至本地Sqlite中。
    @param _username: 用户名
    @param _userid:   用户ID
 */
+(void)postClientInfoStatistic:(NSString*)_username userid:(NSString*)_userid;

/**
    @description 上传订单统计信息。
    客户端在向客户服务器提交订单信息以后，如果成功返回订单号，应立即向服务器发送订单信息，如果服务器没有响应（网络连接不上等原因，不包括服务器返回错误数据）则应把订单信息保存在客户端数据库或者文件队列中，等待下次服务器有响应的时候再发送（建议5分钟检查一次）。
    本流程只调用OrderInfoStatistic的请求方法，具体的业务逻辑在它自己的类中实现。
    流程：1. 发送请求。
         2. 请求失败时，保存OrderInfoStatistic数据至本地Sqlite中。
 */
+(void)postOrderInfoStatistic:(YK_OkOrderInfoStatistic*)_orderInfoStatistic;

/**
    @description 上传订单统计信息。
    客户端在向客户服务器提交订单信息以后，如果成功返回订单号，应立即向服务器发送订单信息，如果服务器没有响应（网络连接不上等原因，不包括服务器返回错误数据）则应把订单信息保存在客户端数据库或者文件队列中，等待下次服务器有响应的时候再发送（建议5分钟检查一次）。
    本流程只调用OrderInfoStatistic的请求方法，具体的业务逻辑在它自己的类中实现。
    流程：1. 发送请求。
         2. 请求失败时，保存OrderInfoStatistic数据至本地Sqlite中。
    @param _orderInfoDict: 用户订单信息
        说明：需要包含以下字段：
         orderid            订单号(如果没有向客户服务器提交成功，则填写空字符)                        100010
         username           下单的用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，
         一定要和订单的账户一致，如果没有登录则留空
         userid             用户ID
         fullname           收货人全名                                                           张三
         cellphone          收货人联系电话（手机号码或者固定电话号码）                                15903863890
         province           收货人所在省份，格式例如：安徽、上海、北京，                               江苏
         后面的“省”字和直辖市的“市”字就不要填写了                          
         city               收货人所在城市，格式例如：南京、沈阳、上海、北京，                          南京
         后面的“市”字就不要填写了
         
         county             收货人所在区县、例如：浦东、朝阳、崇明，后面的“县”字和“区”字就不要填写了      鼓楼
         address            详细的收货地址                                                        高科中路22号412室
         amount             订单总金额（需要实际支付的金额，但不包括运费）                             240
         time               提交时间的时间戳， 从3.1接口中获取                                      1310969879
         ordertime          实际下单时间的时间戳，如果不是提交存在客户端本地的数据，应是和time一样       1310969001
         itemdata           订单商品信息，XML格式，具体见样例
         参数说明：
         code：商品编号
         name：商品全名
         price：商品价格
         quantity：购买的数量
         color：商品颜色(在例如书籍等商品不需要填写颜色请留空)
         size：商品尺码(在例如书籍等商品不需要填写尺码请留空)，另外注意XML各属性一定要格式化
         <list>
         <item code=”YM10001” name=”白色短裤” price=”100” quantity=”2” color=”白色” size=”XL”/>
         <item code=”PU132325” name=”法国红酒” price=”40” quantity=”1” color=”” size=”” />
         </list>
 */
+(void)postOrderInfoStatisticWithOrderInfoDict:(NSDictionary*)_orderInfoDict;

@end
