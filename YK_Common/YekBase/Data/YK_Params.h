//
//  YK_Params.h
//  m5173
//
//  Created by blackApple-1 on 11-7-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface YK_Params : YK_BaseData {
	NSMutableDictionary* m_mut_dictionary;
}
/**
	添加int类型的参数
	@param value 参数值
	@param key 参数名
 */
-(void)setIntValue:(int)value forKey:(NSString*)key;

/**
	添加bool类型的参数
	@param value 参数值
	@param key 参数名
 */
-(void)setBoolValue:(BOOL)value forKey:(NSString*)key;
/**
	添加String类型的参数
	@param value 参数值
	@param key 参数名
 */
-(void)setStringValue:(NSString*)value forKey:(NSString*)key;

/**
	根据参数名获得int类型的参数数值
	@param key 参数名
	@returns 参数值
 */
-(int)getIntValueForKey:(NSString*)key;
/**
	根据参数名获得bool类型的参数数值
	@param key 参数名
	@returns 参数值
 */
-(BOOL)getBoolValueForKey:(NSString*)key;
/**
	根据参数名获得string类型的参数数值
	@param key 参数名
	@returns 参数值
 */
-(NSString*)getStringValueForKey:(NSString*)key;
@property (nonatomic,strong) NSMutableDictionary* m_mut_dictionary;

/**
	合并参数函数
	@param tgParams 将要与之合并的参数对象
 */
-(void)combineWithParams:(YK_Params*)tgParams;

-(void)initializeBaseParams;
@end
