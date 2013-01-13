//
//  YK_BkStat_Engine.m
//  Benefit
//
//  Created by Liu Yuhui on 11-9-19.
//  Copyright 2011年 YeKe.com. All rights reserved.
//

#import "YK_BkStat_Engine.h"
#import "YKStringUtility.h"
#import "GDataXMLNode.h"
#import "Reachability.h"
//#import "CTTelephonyNetworkInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import "CTCarrier.h"
#import <CoreTelephony/CTCarrier.h>

#import "YK_BkStat_Order.h"

// YK_BkStat_Engine分类
@interface YK_BkStat_Engine(private)

// 初始化模块自己可以获取的一些参数
-(void)initKnownParams;

// 获取时间戳
-(void)getTimestamp;

// 发送客户端信息
-(void)sendClientInfo;

// 发送订单信息
-(void)sendOrderInfo;

// 返回响应
-(void)onRequestDataResponse:(GDataXMLElement*)xmlElement;

@end


@implementation YK_BkStat_Engine
@synthesize m_ParamDic;


- (id)init
{
    if (self == [super init]) {
        m_ParamDic = [[NSMutableDictionary alloc] init];
        m_CurRequestType = 0;
        m_CurState = 0;
        
        [self initKnownParams];
    }
	
	return self;  
}

-(void)initKnownParams
{
    ///////////////// 所有接口共同的字段定义
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_productcode];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_username];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_time];
    
    ///////////////// 获取服务器时间戳字段定义
    
    ///////////////// 上传客户端信息字段定义
    // 获取运行商名称
    NSString* carrierName = @"";
    if (nil!=NSClassFromString(@"CTTelephonyNetworkInfo")){
        CTTelephonyNetworkInfo* netInfo=[[CTTelephonyNetworkInfo alloc] init];
        if(netInfo!=nil){
            CTCarrier* carrier=netInfo.subscriberCellularProvider;
            if(carrier!=nil){
                carrierName = carrier.carrierName;
            }
        }
    }
    //
    
    [m_ParamDic setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:YK_BKSTAT_CLIENTINFO_udid];
    [m_ParamDic setObject:@"iphone" forKey:YK_BKSTAT_CLIENTINFO_osname];
    [m_ParamDic setObject:[[UIDevice currentDevice] systemVersion] forKey:YK_BKSTAT_CLIENTINFO_osversion];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_CLIENTINFO_appversion];
    [m_ParamDic setObject:[[UIDevice currentDevice] model] forKey:YK_BKSTAT_CLIENTINFO_devicename];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_CLIENTINFO_sourceid];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_CLIENTINFO_sourcesubid];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_CLIENTINFO_wantype];
    [m_ParamDic setObject:carrierName forKey:YK_BKSTAT_CLIENTINFO_carrier];
    [m_ParamDic setObject:@"1.2.0" forKey:YK_BKSTAT_CLIENTINFO_ver];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_CLIENTINFO_sign];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_CLIENTINFO_user_agent];
    
    ///////////////// 上传订单信息字段定义
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_sessionid];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_orderid];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_ordermessage];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_fullname];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_cellphone];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_province];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_city];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_county];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_address];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_amount];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_ordertime];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_itemdata];
    [m_ParamDic setObject:@"" forKey:YK_BKSTAT_ORDERINFO_sign];
}

-(NSString*)getTimestampSyn
{
    return [YKHttpRequest loadUrlString:(NSString*)YK_BKSTAT_URL_GET_TIMESTAMP params:nil extraHeaders:nil];
}

-(void)getTimestamp
{
    m_CurState = 0;
    
    [YKHttpRequest startLoadUrlString:(NSString*)YK_BKSTAT_URL_GET_TIMESTAMP delegate:self params:nil extraHeaders:nil];
}

-(void)sendClientInfo:(NSDictionary *)extraParams
{    
    // 设置外部参数
    [m_ParamDic addEntriesFromDictionary:extraParams];
    
    m_CurRequestType = 1;
    [self getTimestamp];
}

-(void)sendOrderInfo:(NSDictionary *)extraParams
{
    YK_BkStat_Order* ordeObj = [[YK_BkStat_Order alloc] initWithDictionary:extraParams];
    
    // 只有缓存里面没有的才缓存
    NSString* criteriaString = [NSString stringWithFormat:@"WHERE orderid = %@",ordeObj.orderid];
    YK_BkStat_Order* cacheOrder = (YK_BkStat_Order*)[YK_BkStat_Order findFirstByCriteria:criteriaString];
    if (cacheOrder == nil) {
        [ordeObj save];
    }
    
    m_CurSendOrderId = ordeObj.orderid;
    
    // 设置外部参数
    [m_ParamDic addEntriesFromDictionary:extraParams];
    
    m_CurRequestType = 2;
    [self getTimestamp];
}

#pragma mark -
#pragma mark YKHttpRequestDelegate methods
-(void) onLoadFinished:(NSString*) responseString
{
    NSLog(@"%@",responseString);
    
    NSError* error;
    GDataXMLDocument* xmlDoc=[[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
    
    [self onRequestDataResponse:[xmlDoc rootElement]];
    
    
    return ;
}

-(void) onLoadFailed:(NSError*) error
{
    NSLog(@"error");
}

-(void)onRequestDataResponse:(GDataXMLElement*)xmlElement
{
    if (xmlElement == nil) {
        return ;
    }
    
    GDataXMLNode* node = nil;
    
    node = [xmlElement oneNodeForXPath:@"/home/@result" error:nil];
    if (![[node stringValue] isEqualToString:@"success"]) {
        // 如果sessionid失效，则重新发送客户端信息，获取新的sessionid，再提交订单
        if (m_CurRequestType == 2 && m_CurState == 2 && [[node stringValue] isEqualToString:@"sessionerror"]) {
            m_CurState = 1;
            [self sendClientInfo];
        }
        else
            return ;
    }
    
    if (m_CurState == 0) {
        node = [xmlElement oneNodeForXPath:@"/home/@time" error:nil];
        [m_ParamDic setObject:[node stringValue] forKey:YK_BKSTAT_time];
        
        if (m_CurRequestType == 1) {
            m_CurState = 1;
            [self sendClientInfo];
        }
        else if(m_CurRequestType == 2)
        {
            if ([[m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_sessionid] length] > 0) {
                m_CurState = 2;
                [self sendOrderInfo];
            }
            else
            {
                m_CurState = 1;
                [self sendClientInfo];
            }
        }
    }
    else if(m_CurState == 1)
    {
        node = [xmlElement oneNodeForXPath:@"/home/@sessionid" error:nil];
        [m_ParamDic setObject:[node stringValue] forKey:YK_BKSTAT_ORDERINFO_sessionid];
        
        if(m_CurRequestType == 2)
        {
            m_CurState = 2;
            [self sendOrderInfo];
        }
    }
    else if(m_CurState == 2)
    {
        // 先删除已经发送成功的订单，再查询是否还有订单信息要发送，如果又继续发送
        NSString* criteriaString = [NSString stringWithFormat:@"WHERE orderid = %@",m_CurSendOrderId];
        NSArray* orderItems = [YK_BkStat_Order findByCriteria:criteriaString];
        for (YK_BkStat_Order* item in orderItems) {
            [item deleteObject];
        }
        
        m_CurSendOrderId = nil;
        
        YK_BkStat_Order* order = (YK_BkStat_Order*)[YK_BkStat_Order findFirstByCriteria:@""];
        if (order) {
            m_CurSendOrderId = order.orderid;
            
            [self sendOrderInfo:[order dictionary]];
        }
    }
}

-(void)sendClientInfo
{
    // 设置签名sign
    NSString* signStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                         [m_ParamDic objectForKey:YK_BKSTAT_productcode],
                         [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_udid],
                         [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_osname],
                         [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_sourceid],
                         [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_sourcesubid],
                         [m_ParamDic objectForKey:YK_BKSTAT_time]];
    [m_ParamDic setObject:[YKStringUtility YKMD5:signStr] forKey:YK_BKSTAT_CLIENTINFO_sign];
    
    // 网络类型
    Reachability* reach=[Reachability reachabilityForInternetConnection];
    NSString* wantypeStr = nil;
    switch ([reach currentReachabilityStatus]) {
        case kNotReachable:
            wantypeStr = @"NO";
            break;
        case kReachableViaWWAN:
            wantypeStr = @"3G";
            break;
        case kReachableViaWiFi:
            wantypeStr = @"wifi";
            break;
        default:
            break;
    }
    [m_ParamDic setObject:wantypeStr forKey:YK_BKSTAT_CLIENTINFO_wantype];
    
    NSDictionary* clientInfo = @{YK_BKSTAT_productcode: [m_ParamDic objectForKey:YK_BKSTAT_productcode],
                                YK_BKSTAT_username: [m_ParamDic objectForKey:YK_BKSTAT_username],
                                YK_BKSTAT_time: [m_ParamDic objectForKey:YK_BKSTAT_time],
                                YK_BKSTAT_CLIENTINFO_udid: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_udid],
                                YK_BKSTAT_CLIENTINFO_osname: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_osname],
                                YK_BKSTAT_CLIENTINFO_osversion: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_osversion],
                                YK_BKSTAT_CLIENTINFO_appversion: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_appversion],
                                YK_BKSTAT_CLIENTINFO_devicename: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_devicename],
                                YK_BKSTAT_CLIENTINFO_sourceid: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_sourceid],
                                YK_BKSTAT_CLIENTINFO_sourcesubid: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_sourcesubid],
                                YK_BKSTAT_CLIENTINFO_wantype: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_wantype],
                                YK_BKSTAT_CLIENTINFO_carrier: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_carrier],
                                YK_BKSTAT_CLIENTINFO_ver: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_ver],
                                YK_BKSTAT_CLIENTINFO_sign: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_sign],
                                YK_BKSTAT_CLIENTINFO_user_agent: [m_ParamDic objectForKey:YK_BKSTAT_CLIENTINFO_user_agent]};
    
    [YKHttpRequest startLoadUrlString:(NSString*)YK_BKSTAT_URL_SEND_CLIENTINFO delegate:self params:clientInfo extraHeaders:nil];
}

-(void)sendOrderInfo
{
    // 设置签名sign
    NSString* signStr = [NSString stringWithFormat:@"%@%@%@",
                         [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_sessionid],
                         [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_orderid],
                         [m_ParamDic objectForKey:YK_BKSTAT_time]];
    [m_ParamDic setObject:[YKStringUtility YKMD5:signStr] forKey:YK_BKSTAT_CLIENTINFO_sign];
    
    NSDictionary* orderInfo = @{YK_BKSTAT_productcode: [m_ParamDic objectForKey:YK_BKSTAT_productcode],
                               YK_BKSTAT_username: [m_ParamDic objectForKey:YK_BKSTAT_username],
                               YK_BKSTAT_time: [m_ParamDic objectForKey:YK_BKSTAT_time],
                               
                               YK_BKSTAT_ORDERINFO_sessionid: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_sessionid],
                               YK_BKSTAT_ORDERINFO_orderid: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_orderid],
                               YK_BKSTAT_ORDERINFO_ordermessage: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_ordermessage],
                               YK_BKSTAT_ORDERINFO_fullname: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_fullname],
                               YK_BKSTAT_ORDERINFO_cellphone: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_cellphone],
                               YK_BKSTAT_ORDERINFO_province: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_province],
                               YK_BKSTAT_ORDERINFO_city: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_city],
                               YK_BKSTAT_ORDERINFO_county: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_county],
                               YK_BKSTAT_ORDERINFO_address: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_address],
                               YK_BKSTAT_ORDERINFO_amount: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_amount],
                               YK_BKSTAT_ORDERINFO_ordertime: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_ordertime],
                               YK_BKSTAT_ORDERINFO_itemdata: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_itemdata],
                               YK_BKSTAT_ORDERINFO_sign: [m_ParamDic objectForKey:YK_BKSTAT_ORDERINFO_sign]};
    
    [YKHttpRequest startLoadUrlString:(NSString*)YK_BKSTAT_URL_SEND_ORDERINFO delegate:self params:orderInfo extraHeaders:nil];
}

@end
