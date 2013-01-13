//
//  YK_BkStat_Engine.h
//  Benefit
//
//  Created by Liu Yuhui on 11-9-19.
//  Copyright 2011年 YeKe.com. All rights reserved.
//
//  后台统计引擎类，负责主要逻辑

#import <Foundation/Foundation.h>
#import "YK_BkStat_Protocol.h"
#import "YKHttpRequest.h"


@interface YK_BkStat_Engine : NSObject
        <YKHttpRequestDelegate>
{
    NSMutableDictionary*    m_ParamDic;         // 参数字典，包括所有需要的参数，有些参数自己可以获取到，有些必须由客户提供
    
    NSInteger               m_CurRequestType;   // 当前请求的类型 0=获取时间戳，1=上传客户信息，2=上传订单信息
    NSInteger               m_CurState;         // 当前请求类型的进行状态，0=获取时间戳，1=上传客户信息，2=上传订单信息
    
    NSString*               m_CurSendOrderId;   // 当前提交的orderId
}

@property(nonatomic,readonly)NSMutableDictionary* m_ParamDic;

// 外部使用获取时间戳，用于设置订单生成时间，同步方法
-(NSString*)getTimestampSyn;

// 上传客户端信息,程序启动先调用此接口
/*
 参数extraParams:
 需要客户端提供的参数有:
    productcode         // 产品编号，新项目时必须向服务器组申请备案, 例：vancl，详见附录4.1
    appversion          // 客户端版本。 例：1.0
    username            // 用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，
                           一定要和订单的账户一致，如果没有登录则留空，例：jerry@yek.me
    sourceid            // 推广ID。 例：yek_vancl_001
    sourcesubid         // 推广子ID。 例：1001
    user_agent          // 用户客户端代理信息(在head头中传递)。例：moonbasa 1.1.0
                           (iphone; iphone os 4.1; zh_cn)
 */
-(void)sendClientInfo:(NSDictionary *)extraParams;

// 上传订单信息
/*
 参数extraParams:
 需要客户端提供的参数有:
    orderid             // 订单号(如果没有向客户服务器提交成功，则填写空字符), 例：100010
    ordermessage        // 订单消息，用于说明订单提交情况，在订单号返回为空的时候必须填写客
                           户服务器返回的失败信息（失败时此字段不能为空），有订单号的时候必
                           须填写“订单提交成功 ”, 库存不足，请修改后重新提交订单
    username            // 用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，
                           一定要和订单的账户一致，如果没有登录则留空，例：jerry@yek.me
    fullname            // 收货人全名, 例：张三
    cellphone           // 收货人联系电话（手机号码或者固定电话号码）, 例：15903863890
    province            // 收货人所在省份，格式例如：安徽、上海、北京，后面的“省”字和直辖市
                           的“市”字就不要填写了, 例：江苏
    city                // 收货人所在城市，格式例如：南京、沈阳、上海、北京，后面的“市”字
                           就不要填写了, 例：南京
    county              // 收货人所在区县,例如：浦东、朝阳、崇明，后面的“县”字和“区”字就
                           不要填写了, 例：鼓楼
    address             // 详细的收货地址,例：高科中路22号412室
    amount              // 订单总金额（需要实际支付的金额，但不包括运费）,例：240
    ordertime           // 实际下单时间的时间戳，如果不是提交存在客户端本地的数据，应是和
                           time一样,例：1310969001
    itemdata            // 订单商品信息，XML格式，具体见样例
                           参数说明：
                           code：商品编号
                           name：商品全名
                           price：商品价格
                           quantity：购买的数量
                           color：商品颜色(在例如书籍等商品不需要填写颜色请留空)
                           size：商品尺码(在例如书籍等商品不需要填写尺码请留空)，另外注意XML
                           各属性一定要格式化,
                           例：<list>
                           <item code=”YM10001” name=”白色短裤” price=”100”
                           quantity=”2” color=”白色” size=”XL”/>
                           <item code=”PU132325” name=”法国红酒” price=”40”
                           quantity=”1” color=”” size=”” />
                           </list>
 */
-(void)sendOrderInfo:(NSDictionary *)extraParams;

@end
