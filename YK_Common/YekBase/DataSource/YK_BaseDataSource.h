//
//  YK_BaseDataSource.h
//  m5173
//
//  Created by blackApple-1 on 11-7-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseActivityIndicator.h"

@class YK_BaseDataSource;
@class YK_Params;
@class YK_BaseData;
@class BaseActivityIndicator;

@protocol YK_DataRequestDelegate <NSObject>

/**
	发出请求时的代理
	@param params dataSource将自己所需的数据(params)作为参数传递给代理对象，代理对象
	再将该参数填充并返回dataSource
 */
-(void)YK_DataRequestDelegateWillSendRequest:(YK_Params*)params withDataSource:(YK_BaseDataSource*)dataSource;

/**
	请求返回时的代理
	@param response 可以是GDataXmlDocument类型对象或json对象等
 */
-(void)YK_DataRequestDelegateDataResponse:(NSObject*)response withDataSource:(YK_BaseDataSource*)dataSource;

@end


@interface YK_BaseDataSource : NSObject {
	/**
	m_data对象的值由外部传入
	m_params对象的值由外部传入
 */
	YK_BaseData* m_data;
	YK_Params* m_params;

	BaseActivityIndicator* m_activityIndicator;
	id<YK_DataRequestDelegate> delegate;
	
	int tag;
}
@property (nonatomic,strong) id<YK_DataRequestDelegate> delegate;
@property (nonatomic,strong) YK_BaseData* m_data;
@property (nonatomic,strong) YK_Params* m_params;
@property (nonatomic,strong) BaseActivityIndicator* m_activityIndicator;
@property (nonatomic,assign) int tag;
/**
	开始发出请求
 */
-(void)startAsyncData;

/**
	请求返回
	@param response 可以是GDataXmlDocument类型对象或json对象等
 */
-(void)onAsyncDataResponse:(NSObject*)response;

/**
	通过webDataSource设置内部m_param参数
 */
-(void)setIntValue:(int)value forKey:(NSString*)key;
-(void)setBoolValue:(BOOL)value forKey:(NSString*)key;
-(void)setStringValue:(NSString*)value forKey:(NSString*)key;

/**
 通过webDataSource获取内部m_param参数
 */
-(int)getIntValueForKey:(NSString*)key;
-(BOOL)getBoolValueForKey:(NSString*)key;
-(NSString*)getStringValueForKey:(NSString*)key;
@end
