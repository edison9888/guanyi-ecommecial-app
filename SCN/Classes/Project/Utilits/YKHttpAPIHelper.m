//
//  YKHttpAPIHelper.m
//  SCN
//
//  Created by zwh on 11-10-3.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "YKHttpAPIHelper.h"
#import "YKHttpEngine.h"
#import "SCNStatusUtility.h"
#import "YKStringUtility.h"
#import "YKStringHelper.h"
#import "YKUserInfoUtility.h"
#import "JSONKit.h"

@interface PostParamsData : NSObject
{
	NSString* m_key;
	NSString* m_value;
}

@property(nonatomic, strong)NSString* m_key;
@property(nonatomic, strong)NSString* m_value;

-(id)initWithKey:(NSString*)key Value:(NSString*)value;
- (NSComparisonResult)myCompareMethodWithData:(PostParamsData*)anotherData;

@end

@implementation PostParamsData

@synthesize m_key, m_value;

-(id)initWithKey:(NSString*)key Value:(NSString*)value
{
	if (self = [super init])
	{
		m_key = key;
		m_value = value;
	}
	return self;
}

- (NSComparisonResult)myCompareMethodWithData:(PostParamsData*)anotherData
{
	//return [firstDate compare: secondDate];
	return [self.m_key compare: anotherData.m_key];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"key=%@ :value=%@", m_key, m_value];
}


@end



static YKHttpEngine* s_httpEngine = nil;

@interface YKHttpAPIHelper(hidden)
+(NSDictionary *)getHttpHeadDic;
+(NSDictionary *)getFinalpostParams:(NSDictionary *)postparams;
@end


@implementation YKHttpAPIHelper

+(YKHttpEngine*)shareHttpEngine
{
	@synchronized(self)
	{
		if (s_httpEngine == nil)
		{
			//初始化网络请求的公共http头
			NSDictionary* headerDic = [[self class] getHttpHeadDic];
			s_httpEngine = [YKHttpEngine engineWithHeaderParams:headerDic];
		}
	}
	return s_httpEngine;
}

-(void)dealloc
{
	s_httpEngine = nil;
}

+(NSDictionary *)getHttpHeadDic
{
	NSString* clientversion = strOrEmpty([SCNStatusUtility getClientVersion]);
	NSString* sourceid = strOrEmpty([SCNStatusUtility getSourceId]);
	
	UIDevice* dev=[UIDevice currentDevice];
	NSString* devModel=strOrEmpty([dev model]);
	NSString* devId=strOrEmpty([dev uniqueIdentifier]);
	
	NSString* lang=strOrEmpty([[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]);
	NSString* carrierName = strOrEmpty([SCNStatusUtility getCarrierName]);
	NSString* screenscale = strOrEmpty([SCNStatusUtility getScreenScaleForString]);
	NSString* weblogid = strOrEmpty([YKUserInfoUtility getWebLogid]);
	
	NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] initWithCapacity:15];
	[headerDic setObject:weblogid				forKey:YK_KEY_WEBLOGID];
	[headerDic setObject:YK_VALUE_API_VERSION	forKey:YK_KEY_API_VERSION];
	[headerDic setObject:clientversion			forKey:YK_KEY_CLIENT_VERSION];
	[headerDic setObject:YK_VALUE_PLATFORM_N	forKey:YK_KEY_PLATFORM_N];
	[headerDic setObject:devId					forKey:YK_KEY_DEVICE_ID];
	[headerDic setObject:YK_VALUE_CONTENT_TYPE	forKey:YK_KEY_CONTENT_TYPE];
	[headerDic setObject:devModel				forKey:YK_KEY_MODEL];
	[headerDic setObject:@""					forKey:YK_KEY_IMSI];
	[headerDic setObject:sourceid				forKey:YK_KEY_SOURCEID];
	[headerDic setObject:lang					forKey:YK_KEY_LANGUAGE];
	[headerDic setObject:carrierName			forKey:YK_KEY_CN_OPERATOR];
	[headerDic setObject:@""					forKey:YK_KEY_SMS_NUMBER];
	[headerDic setObject:YK_VALUE_SCREEN_SIZE	forKey:YK_KEY_SCREEN_SIZE];
	[headerDic setObject:screenscale			forKey:YK_KEY_SCREEN_SCALE];
	
	return headerDic;
}

+(NSDictionary *)getFinalpostParams:(NSDictionary *)postparams
{
	if (!postparams || [postparams count] == 0)
	{
		return nil;
	}
	
	NSMutableDictionary* finalParams = [[NSMutableDictionary alloc] initWithCapacity:[postparams count] + 5];
	
	
	@autoreleasepool {
		NSMutableArray* postarray = [[NSMutableArray alloc] init];
		NSMutableString* strForSign = [[NSMutableString alloc] init];
		
		for (id dickey in postparams)
		{
			PostParamsData* pp = [[PostParamsData alloc] initWithKey:dickey Value:[postparams objectForKey:dickey]];
			[postarray addObject:pp];
		}
		
		PostParamsData* ppd = [[PostParamsData alloc] initWithKey:YK_POSTKEY_API_VERSION Value:YK_VALUE_API_VERSION];
		[postarray addObject:ppd];
		
		NSString* weblogid = strOrEmpty([YKUserInfoUtility getWebLogid]);
		ppd = [[PostParamsData alloc] initWithKey:YK_KEY_WEBLOGID Value:weblogid];
		[postarray addObject:ppd];
		
		
		NSString* timeStamp = strOrEmpty([SCNStatusUtility getNowTimeStamp]);
		ppd = [[PostParamsData alloc] initWithKey:@"t" Value:timeStamp];
		[postarray addObject:ppd];
		
		// 开始排序
		[postarray sortUsingSelector:@selector(myCompareMethodWithData:)];
		
		for (PostParamsData* data in postarray)
		{
			//NSLog(@"%@\n", data);
			[strForSign appendString:data.m_value];
			[finalParams setObject:data.m_value forKey:data.m_key];
		}
		
		// 加上token
		[strForSign appendString:SCN_TOKEN];
		
		// MD5加密
		[finalParams setObject:[YKStringUtility YKMD5:strForSign] forKey:@"ac"];
		
	}
	
	return finalParams;
}

+(void)resetweblogidInHead
{
	NSString* weblogid = strOrEmpty([YKUserInfoUtility getWebLogid]);
	
	NSMutableDictionary* headDic = (NSMutableDictionary*)[YKHttpAPIHelper shareHttpEngine].m_dict_header;
	[headDic setObject:weblogid forKey:YK_KEY_WEBLOGID];
	
	if ([weblogid length])
	{
		NSString* cookie = [NSString stringWithFormat:@" PHPSESSID=%@", strOrEmpty(weblogid)];
		[headDic setObject:cookie forKey:@"Cookie"];
	}
	else
	{
		[headDic removeObjectForKey:@"Cookie"];
	}
}

+(NSNumber*)startLoad:(NSString*) url
		  extraParams:(NSDictionary*) extraParams
			   object:(id)object
			 onAction:(SEL)action
{
	NSLog(@"web_url:%@", url);
	YKHttpEngine* httpEngine = [YKHttpAPIHelper shareHttpEngine];
	NSDictionary* postdata = [[self class] getFinalpostParams:extraParams];
	[[self class] resetweblogidInHead];
	
	YKHttpRequestHelper* helper = [[YKHttpRequestHelper alloc] initWithObject:object action:action];
	NSNumber* ret = [httpEngine startDefaultAsynchronousRequest:url
													 postParams:postdata
														 object:helper 
											   onFinishedAction:@selector(onLoadFinish:) 
												 onFailedAction:@selector(onLoadFailed:)];
	return ret;
}


+(NSNumber*)startLoadJSON:(NSString*) url
		  extraParams:(NSDictionary*) extraParams
			   object:(id)object
			 onAction:(SEL)action
{
	NSLog(@"web_url:%@", url);
	YKHttpEngine* httpEngine = [YKHttpAPIHelper shareHttpEngine];
	NSDictionary* postdata = [[self class] getFinalpostParams:extraParams];
	[[self class] resetweblogidInHead];
	
	YKHttpRequestHelper* helper = [[YKHttpRequestHelper alloc] initWithObject:object action:action];
	NSNumber* ret = [httpEngine startDefaultAsynchronousRequest:url
													 postParams:postdata
														 object:helper 
											   onFinishedAction:@selector(onLoadFinishJSON:) 
												 onFailedAction:@selector(onLoadFailed:)];
	return ret;
}

+(NSNumber*)startLoadJSONWithExtraParams:(NSDictionary*) extraParams
                   object:(id)object
                 onAction:(SEL)action
{
    NSLog(@"web_url:%@", MMUSE_URL);
	YKHttpEngine* httpEngine = [YKHttpAPIHelper shareHttpEngine];
	NSDictionary* postdata = [[self class] getFinalpostParams:extraParams];
	[[self class] resetweblogidInHead];
	
	YKHttpRequestHelper* helper = [[YKHttpRequestHelper alloc] initWithObject:object action:action];
	NSNumber* ret = [httpEngine startDefaultAsynchronousRequest:MMUSE_URL
													 postParams:postdata
														 object:helper
											   onFinishedAction:@selector(onLoadFinishJSON:)
												 onFailedAction:@selector(onLoadFailed:)];
	return ret;
}



+(void)cancelRequestByID:(NSNumber *)requestID
{
	YKHttpEngine* httpEngine = [YKHttpAPIHelper shareHttpEngine];
	[httpEngine cancelRequestByID:requestID];
}

+(void)cancelAllRequest
{
	YKHttpEngine* httpEngine = [YKHttpAPIHelper shareHttpEngine];
	[httpEngine cancelAllRequest];
}

@end

@implementation YKHttpRequestHelper

-(id) initWithObject:(id)aobj action:(SEL)aaction
{
	if(self=[super init])
	{
		//assert(aobj!=nil);
		m_object=aobj;
		m_action=aaction;
	}
	return self;
}



-(void)onLoadFinishJSON:(ASIHTTPRequest*)request
{
    //	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/temp.xml"] ;
    //	[[request responseString] writeToFile:cacheDirectory atomically:YES];
    //	NSLog(@"!!-onLoadFinished: responseString:\n%@\n",[request responseString]);
	if ([m_object respondsToSelector:m_action])
	{
		@autoreleasepool {
        [m_object performSelector:m_action withObject:[[request responseString]objectFromJSONString]];
	
		}
	}
}

-(void)onLoadFinish:(ASIHTTPRequest*)request
{
//	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Documents/temp.xml"] ;
//	[[request responseString] writeToFile:cacheDirectory atomically:YES];
//	NSLog(@"!!-onLoadFinished: responseString:\n%@\n",[request responseString]);
	if ([m_object respondsToSelector:m_action])
	{
		@autoreleasepool {
		
        
			NSError* error;
			GDataXMLDocument* xmlDoc=[[GDataXMLDocument alloc] initWithXMLString:[request responseString] options:0 error:&error];
			[m_object performSelector:m_action withObject:xmlDoc];
		
		}
	}
}

-(void)onLoadFailed:(ASIHTTPRequest*)request
{
//	NSLog(@"!!!!warning %@ onLoadFailed ...%@ ", [m_object class],request);
	if ([m_object respondsToSelector:m_action])
	{
		[m_object performSelector:m_action withObject:nil];
	}
}

@end

