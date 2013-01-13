//
//  YK_ClientInfoStatistic.m
//  Moonbasa
//
//  Created by wtfan on 11-9-21.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YK_ClientInfoStatistic.h"

#import <sys/utsname.h>

#import "YK_StatisticEngine.h"
#import "YKHttpEngine.h"
#import "YK_NSStringAdditions.h"

#import "Reachability.h"
#import "GDataXMLNode.h"
#import "UIDevice+IdentifierAddition.h"
//#import "YKStringHelper.h"
#import "YKStringUtility.h"
@implementation YK_ClientInfoStatistic
@synthesize delegate;

@synthesize musername;
@synthesize muserid;

@synthesize mresult, msessionid, mdesc;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"musername", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"muserid", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mresult", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"msessionid", @"@\"NSString\""),
                   DECLARE_PROPERTY(@"mdesc", @"@\"NSString\"")
				   )

- (NSString *)description
{
	return [NSString stringWithFormat:@"<UserStatistic.%d> musername:%@, muserid:%@", 
			[self pk], musername, muserid];
}

+(NSArray *)transients
{
    return @[@"delegate"];
}


#pragma mark -
#pragma mark 提交请求
-(void)postClientinfo{
    /**
        1. 优先我方服务器的时间。
     */
    @synchronized(self){
        _timeStatistic = [[YK_TimeStatistic alloc] init];
        _timeStatistic.delegate = self;
        [_timeStatistic postTimeRequest];
    }
}

-(void)onRequestTimeStatisticFinished:(NSString*)timeStr{
	/**
     productcode    产品编号，新项目时必须向服务器组申请备案    vancl，详见附录4.1
     udid           客户端设备ID                            123qwerqwtf423246dfdh4434rhoo
     macid          第二设备号，为了预防第一设备号无法获取特设立此参数，一般建议为无线设备的MAC地址。
     如果某些平台无法获取MAC地址或其他能标示唯一设备的参数，请保持第二设备号与第一设备号内容一致。
                                                            A088B418EDD4
     osname         操作系统名称，全部小写                    目前支持的操作系统为：android、iphone、symbian、windowsphone，如果有其他的操作系统请发给服务器端组做备案  iphone、android、symbian、windowsphone
     osversion      操作系统版本                             4.1
     appversion     客户端版本                               1.0
     username       用户名，请传递登录窗口填写的用户，不要传递客户接口给到的数据，一定要和订单的账户一致，如果没有登录则留空      jerry@yek.me
     devicename     终端名称                                HTC Desire, iPhone版特别注意，请返回Machine type
     sourceid       推广ID                                 yek_vancl_001
     sourcesubid    推广子ID                               1001
     wantype        网络连接类型                            wifi、3G
     carrier        运营商类型                             中国移动
     ver            通讯协议版本，填写版本记录中的最新版本号    1.1.0
     time           必须传递3.1接口中获取服务器返回的时间戳    1310969879
     sign           数据验证签名,32位md5                    md5(productcode +udid+osname+sourceid+sourcesubid+time) 4eb096d9eafa0f460ff759e7de05e90e
     user_agent     用户客户端代理信息(在head头中传递)        moonbasa 1.1.0 (iphone; iphone os 4.1; zh_cn)
     
	 */
    Reachability *reachability =  [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    NSString* wantype = @"";
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            wantype = @"3G";
            break;
        }
        case ReachableViaWiFi:
        {
            wantype = @"WIFI";
            break;
        }   
    }
    
	NSString* url = [[YK_StatisticEngine sharedStatisticEngine] m_str_url_clientInfo];
    
    NSString* productcode = [[YK_StatisticEngine sharedStatisticEngine] productcode];
    NSString* udid = [[UIDevice currentDevice] uniqueIdentifier];
    NSString* macid = [[[UIDevice currentDevice] macaddress] stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString* osname = @"iphone";
    NSString* osversion = [[UIDevice currentDevice] systemVersion];
    NSString* appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
   // NSString* username = strOrEmpty(musername);
    NSString* username = [YKStringUtility strOrEmpty:musername];
    struct utsname name;
	uname(&name);
    NSString* devicename = @(name.machine);
    NSString* sourceid = [[YK_StatisticEngine sharedStatisticEngine] sourceid];
    NSString* sourcesubid = [[YK_StatisticEngine sharedStatisticEngine] sourcesubid];
    NSString* carrier = @"其他";
	NSString* ver = [[YK_StatisticEngine sharedStatisticEngine] ver];
    NSString* time = [NSString stringWithFormat:@"%@", timeStr];
    NSString* sign = [[NSString stringWithFormat:@"%@%@%@%@%@%@", productcode, udid, osname, sourceid, sourcesubid, time] md5Hash];
	
	NSDictionary* extraParam = @{@"productcode": productcode==nil?@"":productcode,
                                @"udid": udid==nil?@"":udid,
                                @"macid": macid==nil?@"":macid,
                                @"osname": osname==nil?@"":osname,
                                @"osversion": osversion==nil?@"":osversion,
                                @"appversion": appversion==nil?@"":appversion,
                                @"username": username==nil?@"":username,
                                @"devicename": devicename==nil?@"":devicename,
                                @"sourceid": sourceid==nil?@"":sourceid,
                                @"sourcesubid": sourcesubid==nil?@"":sourcesubid,
                                @"wantype": wantype==nil?@"":wantype,
                                @"carrier": carrier==nil?@"":carrier,
                                @"ver": ver==nil?@"":ver,
                                @"time": time==nil?@"":time,
                                @"sign": sign==nil?@"":sign};
	
    [[YK_StatisticEngine sharedHttpEngine] startDefaultAsynchronousRequest:url
                                                             postParams:extraParam 
                                                                 object:self
                                                       onFinishedAction:@selector(onPostClientinfoFinished:)
                                                         onFailedAction:@selector(onPostClientinfoFailed:)];
}

/**
    请求成功。
     失败：
     <home result="failure" desc=”数据提交超时”/>
     成功：
     <home result="success" sessionid=”4eb096d9eafa0f460ff759e7de05e90e” desc=”提交成功” >
 */
-(void)onPostClientinfoFinished:(ASIHTTPRequest*)request{
    NSString *responseString = [request responseString];;
    NSError *error;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
    
    if (error==nil) {
        [self parseFromGDataXMLElement:[xmlDoc rootElement]];
        if ([@"success" isEqualToString:self.mresult]) {
            /**
             成功时步骤：
             1. 删除本地数据库中该条纪录。
             2. 通知代理请求成功。
             */
            // 删除本地数据库中该条纪录
            [self deleteObject];
            
            if ([delegate respondsToSelector:@selector(onRequestClientInfoStatisticFinished:)]) {
                [delegate onRequestClientInfoStatisticFinished:self.msessionid];
            }
            
        }else{
            [self onPostClientinfoFailed:request];
        }
    }else{
        /**
            失败时，回调失败函数。
         */
        [self onPostClientinfoFailed:request];
    }
}

-(void)onPostClientinfoFailed:(ASIHTTPRequest*)request{
    // 失败时不做任何处理
    
}

@end