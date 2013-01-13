//
//  YK_OkOrderInfoStatistic.h
//  Moonbasa
//
//  Created by wtfan on 11-9-21.
//  Copyright 2011年 Yek. All rights reserved.
//
//
// sessionid失效时：
// 1. 保存一份sessionid为空的订单信息至数据库中。
// 2. 删除数据库中该订单信息。
//
// 请求成功时：
// 1. 删除数据库中该订单信息。
//
// 请求失败时：
// 1. 拷贝并保存该订单信息至数据库中。
// 2. 删除数据库中该订单信息。

#import <Foundation/Foundation.h>

#import "YK_BaseData.h"

#import "YK_TimeStatistic.h"
#import "YK_ClientInfoStatistic.h"

@interface YK_OkOrderInfoStatistic : YK_BaseData 
<YK_TimeStatisticDelegate,
YK_ClientInfoStatisticDelegate>{
    NSString* msessionid;      // 提交客户端信息接口中返回的参数
    
    NSString* morderid;        // 订单号(如果没有向客户服务器提交成功，则填写空字符)
    NSString* mordermessage;
    NSString* musername;       // 下单的用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，一定要和订单的账户一致，如果没有登录则留空
    NSString* muserid;         // 用户id   唯一标识用户
    NSString* mfullname;       // 收货人全名
    NSString* mcellphone;      // 收货人联系电话（手机号码或者固定电话号码）
    NSString* mprovince;       // 收货人所在省份，格式例如：安徽、上海、北京，后面的“省”字和直辖市的“市”字就不要填写了
    NSString* mcity;           // 收货人所在城市，格式例如：南京、沈阳、上海、北京，后面的“市”字就不要填写了
    NSString* mcounty;         // 收货人所在区县、例如：浦东、朝阳、崇明，后面的“县”字和“区”字就不要填写了
	NSString* maddress;        // 详细的收货地址
    NSString* mamount;         // 订单总金额（需要实际支付的金额，但不包括运费）
    NSString* mordertime;      // 用户下单时的时间
    NSString* mitemdata;       // 订单商品信息，XML格式，具体见样例
    NSString* mtime;           // 提交时间的时间戳， 从3.1接口中获取
    // 参数说明：
    // code：商品编号
    // name：商品全名
    // price：商品价格
    // quantity：购买的数量
    // color：商品颜色(在例如书籍等商品不需要填写颜色请留空)
    // size：商品尺码(在例如书籍等商品不需要填写尺码请留空)，另外注意XML各属性一定要格式化
    
    NSString* mresult;         // 请求结果
    NSString* mdesc;           // 请求结果描述
}
@property (nonatomic, strong) NSString* msessionid;
@property (nonatomic, strong) NSString* morderid;
@property (nonatomic, strong) NSString* mordermessage;
@property (nonatomic, strong) NSString* musername;
@property (nonatomic, strong) NSString* muserid;
@property (nonatomic, strong) NSString* mfullname;
@property (nonatomic, strong) NSString* mcellphone;
@property (nonatomic, strong) NSString* mprovince;
@property (nonatomic, strong) NSString* mcity;
@property (nonatomic, strong) NSString* mcounty;
@property (nonatomic, strong) NSString* maddress;
@property (nonatomic, strong) NSString* mamount;
@property (nonatomic, strong) NSString* mordertime;
@property (nonatomic, strong) NSString* mitemdata;
@property (nonatomic, strong) NSString* mtime;

@property (nonatomic, strong) NSString* mresult;
@property (nonatomic, strong) NSString* mdesc;

+(id)initWithOrderInfoDict:(NSDictionary*)orderInfoDict;

-(void)postOrderInfoStatistic;

@end

