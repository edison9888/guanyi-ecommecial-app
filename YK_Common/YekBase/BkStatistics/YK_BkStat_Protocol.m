//
//  YK_BkStat_Protocol.m
//  Benefit
//
//  Created by Liu Yuhui on 11-9-19.
//  Copyright 2011年 YeKe.com. All rights reserved.
//

#import "YK_BkStat_Protocol.h"

///////////////// 后台统计接口服务器地址
const NSString* YK_BKSTAT_URL_GET_TIMESTAMP         = @"http://mobapi.250y.com/time.php";
const NSString* YK_BKSTAT_URL_SEND_CLIENTINFO       = @"http://mobapi.250y.com/client.php";
const NSString* YK_BKSTAT_URL_SEND_ORDERINFO        = @"http://mobapi.250y.com/order.php";


///////////////// 所有接口共同的字段定义
const NSString* YK_BKSTAT_productcode               = @"productcode";
const NSString* YK_BKSTAT_username                  = @"username";
const NSString* YK_BKSTAT_time                      = @"time";

///////////////// 获取服务器时间戳字段定义

///////////////// 上传客户端信息字段定义
// productcode 同上
// username 同上
// time 同上
const NSString* YK_BKSTAT_CLIENTINFO_udid           = @"udid";
const NSString* YK_BKSTAT_CLIENTINFO_osname         = @"osname";
const NSString* YK_BKSTAT_CLIENTINFO_osversion      = @"osversion";
const NSString* YK_BKSTAT_CLIENTINFO_appversion     = @"appversion";
const NSString* YK_BKSTAT_CLIENTINFO_devicename     = @"devicename";
const NSString* YK_BKSTAT_CLIENTINFO_sourceid       = @"sourceid";
const NSString* YK_BKSTAT_CLIENTINFO_sourcesubid    = @"sourcesubid";
const NSString* YK_BKSTAT_CLIENTINFO_wantype        = @"wantype";   
const NSString* YK_BKSTAT_CLIENTINFO_carrier        = @"carrier";
const NSString* YK_BKSTAT_CLIENTINFO_ver            = @"ver";
const NSString* YK_BKSTAT_CLIENTINFO_sign           = @"sign";
const NSString* YK_BKSTAT_CLIENTINFO_user_agent     = @"user_agent";


///////////////// 上传订单信息字段定义
// productcode 同上
// username 同上
// time 同上
const NSString* YK_BKSTAT_ORDERINFO_sessionid       = @"sessionid";
const NSString* YK_BKSTAT_ORDERINFO_orderid         = @"orderid";
const NSString* YK_BKSTAT_ORDERINFO_ordermessage    = @"ordermessage";
const NSString* YK_BKSTAT_ORDERINFO_fullname        = @"fullname";
const NSString* YK_BKSTAT_ORDERINFO_cellphone       = @"cellphone";
const NSString* YK_BKSTAT_ORDERINFO_province        = @"province";
const NSString* YK_BKSTAT_ORDERINFO_city            = @"city";
const NSString* YK_BKSTAT_ORDERINFO_county          = @"county";
const NSString* YK_BKSTAT_ORDERINFO_address         = @"address";
const NSString* YK_BKSTAT_ORDERINFO_amount          = @"amount";
const NSString* YK_BKSTAT_ORDERINFO_ordertime       = @"ordertime";
const NSString* YK_BKSTAT_ORDERINFO_itemdata        = @"itemdata";
const NSString* YK_BKSTAT_ORDERINFO_sign            = @"sign";


