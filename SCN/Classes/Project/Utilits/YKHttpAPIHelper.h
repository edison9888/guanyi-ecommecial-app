//
//  YKHttpAPIHelper.h
//  SCN
// 此网络类主要用于对接品的请求,不包含对行为统计及后台统计的请求,由于header不一样
//
//  Created by yekapple on 11-10-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "ASIHTTPRequest.h"
#import "SCNDataInterface.h"


@interface YKHttpAPIHelper : NSObject 
{
	
}

/*
 异步POST 加载url 获取 xml document object 
 完成或出错后会调用[object action:xmlDoc];
 params:
 url:
 网址
 extraParams:
 附加参数
 object:
 网址内容下载完成后调用此对象的action方法，action方法格式同下
 action:
 -(void) ****:(GDataXMLDocument*) xmlDoc;
 如果出错 xmlDoc=nil;
 /
 api_version
 weblogid
 t
 ac
 /
 四个参数不需要
 */
+(NSNumber*)startLoad:(NSString*) url 
		  extraParams:(NSDictionary*) extraParams 
			   object:(id)object 
			 onAction:(SEL)action;


+(NSNumber*)startLoadJSON:(NSString*) url
              extraParams:(NSDictionary*) extraParams
                   object:(id)object
                 onAction:(SEL)action;

+(NSNumber*)startLoadJSONWithExtraParams:(NSDictionary*) extraParams
                                  object:(id)object
                                onAction:(SEL)action;

/**
 根据requestID终止数据请求，并从Engine的请求数组中移出该请求(释放请求)。
 */
+(void)cancelRequestByID:(NSNumber *)requestID;

/**
 终止所有数据请求。
 */
+(void)cancelAllRequest;

+(void)resetweblogidInHead;

@end


@interface YKHttpRequestHelper : NSObject
{
	id m_object;
	SEL m_action;
}
-(id) initWithObject:(id)aobj action:(SEL)aaction;
-(void)onLoadFinish:(ASIHTTPRequest*)request;
-(void)onLoadFailed:(ASIHTTPRequest*)request;
@end
