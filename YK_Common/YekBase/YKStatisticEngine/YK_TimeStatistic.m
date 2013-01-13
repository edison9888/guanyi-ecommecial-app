//
//  YK_TimeStatistic.m
//  Moonbasa
//
//  Created by wtfan on 11-9-20.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YK_TimeStatistic.h"

#import "YK_StatisticEngine.h"
#import "YKHttpEngine.h"

#import "GDataXMLNode.h"

@interface YK_TimeStatistic(PrivateMethods)
-(void)onTimeRequestFinished:(ASIHTTPRequest*)request;
-(void)onTimeRequestFailed:(ASIHTTPRequest*)request;
@end

@implementation YK_TimeStatistic
@synthesize delegate;

@synthesize mresult, mdesc, mtime;


-(void)postTimeRequest{
    NSString* url = [[YK_StatisticEngine sharedStatisticEngine] m_str_url_time];
	
    [[YK_StatisticEngine sharedHttpEngine] 
                startDefaultAsynchronousRequest:url 
                                     postParams:nil 
                                         object:self 
                               onFinishedAction:@selector(onTimeRequestFinished:)
                                 onFailedAction:@selector(onTimeRequestFailed:)];
}

/**
    请求成功。
    失败:
    <home result="failure" desc=”错误消息”/>
    成功:
    < home result="success" time=” 1310969879” desc=”获取成功”/>
 */
-(void)onTimeRequestFinished:(ASIHTTPRequest*)request{
	NSString *responseString = [request responseString];;
    NSError *error;
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
    
    if (error==nil) {
        [self parseFromGDataXMLElement:[xmlDoc rootElement]];
        
        if ([delegate respondsToSelector:@selector(onRequestTimeStatisticFinished:)]) {
            [delegate onRequestTimeStatisticFinished:mtime];
        }
    }else{
        if ([delegate respondsToSelector:@selector(onRequestTimeStatisticFailed:)]) {
            [delegate onRequestTimeStatisticFailed:request];
        }
    }
}

/**
    请求失败。
 */
-(void)onTimeRequestFailed:(ASIHTTPRequest*)request{
    if ([delegate respondsToSelector:@selector(onRequestTimeStatisticFailed:)]) {
        [delegate onRequestTimeStatisticFailed:request];
    }
}
@end
