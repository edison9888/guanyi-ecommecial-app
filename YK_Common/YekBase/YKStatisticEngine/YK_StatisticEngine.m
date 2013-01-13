//
//  YK_StatisticEngine.m
//  Moonbasa
//
//  Created by wtfan on 11-9-21.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YK_StatisticEngine.h"

#import "YK_ClientInfoStatistic.h"
#import "YK_OkOrderInfoStatistic.h"
#import "YKHttpEngine.h"
static NSString *defaultUserAgent=nil;
static NSTimer *_TIMER_DAEMON;
static NSTimer *_CSTIMER_DAEMON;
static YK_StatisticEngine *_s_statisticEngine;

@implementation YK_StatisticEngine
@synthesize m_str_url_time;
@synthesize m_str_url_clientInfo;
@synthesize m_str_url_orderInfo;
@synthesize delegate;
@synthesize m_httpEngine = _m_httpEngine;
@synthesize m_date_CS = _m_date_CS;

- (id)init
{
    self = [super init];
    if (self) {
        [self setCSDate:nil];
    }
    return self;
}

-(void)setDelegate:(id<YK_StatisticEngineDelegate>)_delegate{
    delegate = _delegate;
    
    // 创建统计数HttpEngine及设置默认头文件
    NSString *l_str_userAgent=[[self class] defaultUserAgentString];
    NSDictionary* l_dict = [[NSDictionary alloc] initWithObjectsAndKeys:l_str_userAgent,@"User_Agent", nil];
    self.m_httpEngine = [YKHttpEngine engineWithHeaderParams:l_dict];
}

+ (NSString *)defaultUserAgentString
{
	@synchronized (self) {
        
		if (!defaultUserAgent) {
            
			NSBundle *bundle = [NSBundle bundleForClass:[self class]];
			// Attempt to find a name for this application
            
            NSString *appName = [[YK_StatisticEngine sharedStatisticEngine] productcode];
            
			NSData *latin1Data = [appName dataUsingEncoding:NSUTF8StringEncoding];
			appName = [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
            
			// If we couldn't find one, we'll give up (and ASIHTTPRequest will use the standard CFNetwork user agent)
			if (!appName) {
				return nil;
			}
            
			NSString *appVersion = nil;
			NSString *marketingVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
			NSString *developmentVersionNumber = [bundle objectForInfoDictionaryKey:@"CFBundleVersion"];
			if (marketingVersionNumber && developmentVersionNumber) {
				if ([marketingVersionNumber isEqualToString:developmentVersionNumber]) {
					appVersion = marketingVersionNumber;
				} else {
					appVersion = [NSString stringWithFormat:@"%@ rv:%@",marketingVersionNumber,developmentVersionNumber];
				}
			} else {
				appVersion = (marketingVersionNumber ? marketingVersionNumber : developmentVersionNumber);
			}
            
			NSString *deviceName;
			NSString *OSName;
			NSString *OSVersion;
            
#if TARGET_OS_IPHONE
            UIDevice *device = [UIDevice currentDevice];
            deviceName = [device model];
            OSName = [device systemName];
            OSVersion = [device systemVersion];
            
#else
            deviceName = @"Macintosh";
            OSName = @"Mac OS X";
            
            // From http://www.cocoadev.com/index.pl?DeterminingOSVersion
            // We won't bother to check for systems prior to 10.4, since ASIHTTPRequest only works on 10.5+
            OSErr err;
            SInt32 versionMajor, versionMinor, versionBugFix;
            err = Gestalt(gestaltSystemVersionMajor, &versionMajor);
            if (err != noErr) return nil;
            err = Gestalt(gestaltSystemVersionMinor, &versionMinor);
            if (err != noErr) return nil;
            err = Gestalt(gestaltSystemVersionBugFix, &versionBugFix);
            if (err != noErr) return nil;
            OSVersion = [NSString stringWithFormat:@"%u.%u.%u", versionMajor, versionMinor, versionBugFix];
#endif
            
			// Takes the form "My Application 1.0 (Macintosh; Mac OS X 10.5.7; en_GB)"
			[[self class] setDefaultUserAgentString:[NSString stringWithFormat:@"%@/%@(%@;%@ %@)", appName, appVersion, deviceName, OSName, OSVersion]];	
		}
		return defaultUserAgent;
	}
}
+ (void)setDefaultUserAgentString:(NSString *)agent
{
	@synchronized (self) {
		if (defaultUserAgent == agent) {
			return;
		}
		defaultUserAgent = [agent copy];
	}
}
-(void)dealloc{
    
    
    [_CSTIMER_DAEMON invalidate];
    [_TIMER_DAEMON invalidate];
    
}

-(void)updateCSDateBySecond{
    if (_m_date_CS!=nil) {
        NSDate *_date = [_m_date_CS dateByAddingTimeInterval:1.0];
        self.m_date_CS = _date;
    }
}

+(YK_StatisticEngine*)sharedStatisticEngine{
    if (_s_statisticEngine == nil) {
        _s_statisticEngine = [[YK_StatisticEngine alloc] init];
    }
    return _s_statisticEngine;
}

+(YKHttpEngine*)sharedHttpEngine{
    assert(_s_statisticEngine!=nil);
    return _s_statisticEngine.m_httpEngine;
}

-(void)setCSDate:(NSDate*)csDate{
    if (_CSTIMER_DAEMON!=nil) {
        [_CSTIMER_DAEMON invalidate];
        _CSTIMER_DAEMON = nil;
    }
    // 设置计时器, 1秒钟刷新一次客户服务器时间
    _CSTIMER_DAEMON = [NSTimer timerWithTimeInterval:1 
                                              target:self
                                            selector:@selector(updateCSDateBySecond)
                                            userInfo:nil 
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_CSTIMER_DAEMON forMode:NSRunLoopCommonModes];
    
    if (csDate!=nil) {
        self.m_date_CS = csDate;
    }
}

-(NSDate*)csDate{
    return _m_date_CS;
}

+(void)startStatisticDaemon:(NSTimeInterval)timeInterval
{
    if (_TIMER_DAEMON==nil) {
        _TIMER_DAEMON = [NSTimer timerWithTimeInterval:timeInterval 
                                                target:self 
                                              selector:@selector(postStatistic) 
                                              userInfo:nil 
                                               repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_TIMER_DAEMON forMode:NSRunLoopCommonModes];
    }

}

+(void)stopStatisticDaemon
{
    [_TIMER_DAEMON invalidate];
    _TIMER_DAEMON = nil;
}

+(void)postStatistic
{
    NSLog(@"[SYS] - ****** PostStatistic ******");
    //从本地数据库读取尚未发送的订单信息,并发送
    for (YK_OkOrderInfoStatistic* _o in [YK_OkOrderInfoStatistic allObjects]) {
        NSLog(@"[SYS] - Post YK_OkOrderInfoStatistic: %@", _o);
        [[self class] postOrderInfoStatistic:_o];
    }
}

+(void)postClientInfoStatistic:(YK_ClientInfoStatistic *)_clientInfoStatistic
{
    //发送客户端信息
    [_clientInfoStatistic postClientinfo];
}

+(void)postClientInfoStatistic:(NSString*)_username userid:(NSString*)_userid{
    YK_ClientInfoStatistic* l_ClientInfoStatistic = [[YK_ClientInfoStatistic alloc] init];
    l_ClientInfoStatistic.musername = _username;
    l_ClientInfoStatistic.muserid = _userid;
    [[self class] postClientInfoStatistic:l_ClientInfoStatistic];
}

+(void)postOrderInfoStatistic:(YK_OkOrderInfoStatistic *)_orderInfoStatistic
{
    // 提前保存订单，待发送成功后删除
    [_orderInfoStatistic save];
    //发送订单信息
    [_orderInfoStatistic postOrderInfoStatistic];
}

+(void)postOrderInfoStatisticWithOrderInfoDict:(NSDictionary*)_orderInfoDict{
    YK_OkOrderInfoStatistic* l_orderInfoStatistic = [YK_OkOrderInfoStatistic initWithOrderInfoDict:_orderInfoDict];
    [[self class] postOrderInfoStatistic:l_orderInfoStatistic];
}

#pragma mark -
#pragma mark delegate Methods
/**
 获取Sourceid
 */
-(NSString*)sourceid{
    if ([delegate respondsToSelector:@selector(sourceid)]){
        return [delegate sourceid];
    }
    return @"";
}

/**
 获取推广子ID
 */
-(NSString*)sourcesubid{
    if ([delegate respondsToSelector:@selector(sourcesubid)]){
        return [delegate sourcesubid];
    }
    return @"";
}

/**
 获取productcode
 */
-(NSString*)productcode{
    if ([delegate respondsToSelector:@selector(productcode)]){
        return [delegate productcode];
    }
    return @"";
}

/**
 获取通信协议版本
 */
-(NSString*)ver{
    if ([delegate respondsToSelector:@selector(ver)]){
        return [delegate ver];
    }
    return @"";   
}

@end
