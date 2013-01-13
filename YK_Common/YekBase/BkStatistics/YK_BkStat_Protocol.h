//
//  YK_BkStat_Protocol.h
//  Benefit
//
//  Created by Liu Yuhui on 11-9-19.
//  Copyright 2011年 YeKe.com. All rights reserved.
//
//  后台统计模块协议相关常量

#import <Foundation/Foundation.h>

///////////////// 后台统计接口服务器地址
extern const NSString* YK_BKSTAT_URL_GET_TIMESTAMP;         // 1. 获取服务器时间戳接口
extern const NSString* YK_BKSTAT_URL_SEND_CLIENTINFO;       // 2. 上传客户端信息接口
extern const NSString* YK_BKSTAT_URL_SEND_ORDERINFO;        // 3. 上传订单信息接口


///////////////// 所有接口共同的字段定义
extern const NSString* YK_BKSTAT_productcode;               // 产品编号，新项目时必须向服务器组申请备案, 例：vancl，详见附录4.1
extern const NSString* YK_BKSTAT_username;                  /* 用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，
                                                               一定要和订单的账户一致，如果没有登录则留空，例：jerry@yek.me */
extern const NSString* YK_BKSTAT_time;                      // 必须传递3.1接口中获取服务器返回的时间戳。 例：1310969879

///////////////// 获取服务器时间戳字段定义

///////////////// 上传客户端信息字段定义
// productcode 同上
// username 同上
// time 同上
extern const NSString* YK_BKSTAT_CLIENTINFO_udid;           // 客户端设备ID, 例：123qwerqwtf423246dfdh4434rhoo
extern const NSString* YK_BKSTAT_CLIENTINFO_osname;         /* 操作系统名称，全部小写目前支持的操作系统为：android、iphone、
                                                               symbian、windowsphone，如果有其他的操作系统请发给服务器端组
                                                               做备案, 例:iphone、android、symbian、windowsphone */
extern const NSString* YK_BKSTAT_CLIENTINFO_osversion;      // 操作系统版本。 例：4。1
extern const NSString* YK_BKSTAT_CLIENTINFO_appversion;     // 客户端版本。 例：1.0
extern const NSString* YK_BKSTAT_CLIENTINFO_devicename;     // 终端名称。 例：HTC Desire
extern const NSString* YK_BKSTAT_CLIENTINFO_sourceid;       // 推广ID。 例：yek_vancl_001
extern const NSString* YK_BKSTAT_CLIENTINFO_sourcesubid;    // 推广子ID。 例：1001
extern const NSString* YK_BKSTAT_CLIENTINFO_wantype;        // 网络连接类型。 例：wifi、3G    
extern const NSString* YK_BKSTAT_CLIENTINFO_carrier;        // 运营商类型。 例：中国移动
extern const NSString* YK_BKSTAT_CLIENTINFO_ver;            // 通讯协议版本，填写版本记录中的最新版本号。 例：1.1.0
extern const NSString* YK_BKSTAT_CLIENTINFO_sign;           /* 数据验证签名,32位md5,md5(productcode +udid+osname+
                                                               sourceid+sourcesubid+time) 例：4eb096d9eafa0f460
                                                               ff759e7de05e90e */
extern const NSString* YK_BKSTAT_CLIENTINFO_user_agent;     /* 用户客户端代理信息(在head头中传递)。例：moonbasa 1.1.0
                                                               (iphone; iphone os 4.1; zh_cn) */


///////////////// 上传订单信息字段定义
// productcode 同上
// username 同上
// time 同上
extern const NSString* YK_BKSTAT_ORDERINFO_sessionid;       // 3.2接口返回的, 例：128d6aaced36a08f3893d1eaf953d425
extern const NSString* YK_BKSTAT_ORDERINFO_orderid;         // 订单号(如果没有向客户服务器提交成功，则填写空字符), 例：100010
extern const NSString* YK_BKSTAT_ORDERINFO_ordermessage;    /* 订单消息，用于说明订单提交情况，在订单号返回为空的时候必须填写客
                                                               户服务器返回的失败信息（失败时此字段不能为空），有订单号的时候必
                                                               须填写“订单提交成功 ”, 库存不足，请修改后重新提交订单 */
extern const NSString* YK_BKSTAT_ORDERINFO_fullname;        // 收货人全名, 例：张三
extern const NSString* YK_BKSTAT_ORDERINFO_cellphone;       // 收货人联系电话（手机号码或者固定电话号码）, 例：15903863890
extern const NSString* YK_BKSTAT_ORDERINFO_province;        /* 收货人所在省份，格式例如：安徽、上海、北京，后面的“省”字和直辖市
                                                               的“市”字就不要填写了, 例：江苏 */
extern const NSString* YK_BKSTAT_ORDERINFO_city;            /* 收货人所在城市，格式例如：南京、沈阳、上海、北京，后面的“市”字
                                                               就不要填写了, 例：南京 */
extern const NSString* YK_BKSTAT_ORDERINFO_county;          /* 收货人所在区县,例如：浦东、朝阳、崇明，后面的“县”字和“区”字就
                                                               不要填写了, 例：鼓楼 */
extern const NSString* YK_BKSTAT_ORDERINFO_address;         // 详细的收货地址,例：高科中路22号412室
extern const NSString* YK_BKSTAT_ORDERINFO_amount;          // 订单总金额（需要实际支付的金额，但不包括运费）,例：240
extern const NSString* YK_BKSTAT_ORDERINFO_ordertime;       /* 实际下单时间的时间戳，如果不是提交存在客户端本地的数据，应是和
                                                               time一样,例：1310969001 */
extern const NSString* YK_BKSTAT_ORDERINFO_itemdata;        /* 订单商品信息，XML格式，具体见样例
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
                                                                  </list> */
extern const NSString* YK_BKSTAT_ORDERINFO_sign;            /* 数据验证签名,32位md5，md5(sessionid+orderid+ time),
                                                               例：4eb096d9eafa0f460ff759e7de05e90e */

