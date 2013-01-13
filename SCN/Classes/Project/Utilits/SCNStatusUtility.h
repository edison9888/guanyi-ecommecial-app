//
//  SCNStatusUtility.h
//  SCN
//
//  Created by zwh on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingCartData.h"
#import "OffShoppingCartData.h"
#import "YKUserInfoUtility.h"
#import "SCNRequestResultData.h"

#import "SCNProductDetailData.h"
#import "SCNBrowserData.h"



#define DEVICETYPE_DESC_IPHONE @"iPhone"
#define DEVICETYPE_DESC_IPOD @"iPod"
#define DEVICETYPE_DESC_IPAD @"iPad"

//错误Code说明
/**
	100以内的优先级高于100到1000的优先级
 */

typedef enum
{
	EBE_WeblogidFailOrChange	= 1,//WEBLOGID 失败
	EBE_HasntLogin				= 2,//未登录
	
	
	EBE_ProductFail				= 101,//商品未找到
}BussindessErr;


@interface SCNStatusUtility : NSObject 
{
}



+(CGFloat)getNavigationBarHeight;
+(CGFloat)getTabBarHeight;
+(CGFloat)getShowViewHeight;
// 获取客户端版本号
+(NSString *)getClientVersion;
// 获取SourceId
+(NSString *)getSourceId;
//获取SubSourceId
+(NSString*)getSubSourceId;
// 获取屏幕放大系数
+(CGFloat)getScreenScale;
+(NSString *)getScreenScaleForString;

//获取手机push的DeviceToken
+(NSString *)getDeviceToken;
//获取运行商名称
+(NSString*)getCarrierName;

//获取当前时间戳
+(NSString*)getNowTimeStamp;

//获取当前时间戳
+(NSTimeInterval)getNowTime;

//获取当前时间（与服务器同步后的）
+(NSDate*)getNowDate;

//默认格式为2011-11-23 23:59:59
+(NSDate*)getDateFromStr:(NSString*)timestr formate:(NSString*)formatestr;
+(NSTimeInterval)getTimeIntervalFromStr:(NSString*)timestr formate:(NSString*)formatestr;

+(void)setServerTimeStamp:(NSString*)timeStamp;
/**
 价格保留小数点后两位
 ¥500.00
 */
+(NSString *)getPriceString:(NSString *)priceStr;
//获取当前时间格式
//+(NSString*)getNowTimeFormat;

/**
 显示购物车数量
 */
+(void)showShoppingcartNumber;

/**
 保存数据到购物车
 */
+(void)saveShoppingcart:(ShoppingCartData*)aData;

/**
 保存缺货数据到购物车
 */
+(void)saveOffShoppingcart:(OffShoppingCartData*)aData;
/**
 清除购物车数据
 */
+(void)clearShoppingcart;

/**
 清除缺货购物车数据
 */
+(void)clearOffShoppingcart;

/**
 加载购物车数据
 @return 购物车数组
 */
+(NSArray*)loadShoppingcart;

/**
 加载购物车中可购买和不可购买的数据
 @return 购物车数组
 */
+(NSMutableArray*)loadShoppingcartAndOffShoppingcart;

/**
 得到购物车数据
 @returns 拼装好的购物车数据
 */
+(NSString*)getShoppingcartDataAndOffShoppingcartData;

/**
 得到购物车数据
 @returns 拼装好的购物车数据
 */
+(NSString*)getShoppingcartData;

/**
 得到购物车数据
 @returns 拼装好购物车无法购买的数据
 */
+(NSString*)getOffShoppingcartData;


/**
 删除购物车不可买商品记录
 @param data 删除购物车不可买商品记录
 */
+(void)deleteOffShoppingcartData:(CartData*)data;

/**
 删除购物车可买商品记录
 @param data 删除购物车可买商品记录
 */
+(void)deleteShoppingcartData:(CartData*)data;

/**
 判断是否有网络
 */
+(BOOL)isNetworkReachable;
/**
 判断请求是否成功
 失败时通知请求失败
 */
+(BOOL)isRequestSuccess:(GDataXMLDocument*)xmlDoc;

/**
 判断请求是否成功
 失败时通知请求失败
 */
+(BOOL)isRequestSuccess:(GDataXMLDocument*)xmlDoc requestData:(SCNRequestResultData*)requestData;


/**
 判断请求是否成功
 失败时通知请求失败 json 版本
 */
+(BOOL)isRequestSuccessJSON:(id)json_obj;
+(BOOL)isRequestSuccessJSON:(id)json_obj requestData:(SCNRequestResultData*)requestData;



+(void)DealWithBussinessErrorCode:(SCNRequestResultData*)requestData;

/**
 判断是否需要更新
 */
+(void)updateApp;

+(GDataXMLElement*)paserDataInfoNode:(GDataXMLDocument*)xmlDoc;

#pragma mark -
/**
 保存历史浏览记录
 @param data 商品详情数据
 productCode 商品id
 imageUrl    小图片地址
 */
+(void)save2BrowserData:(productDetail_Data*)data withProductCode:(NSString *)productCode withProductBn:(NSString*)productBn withImageUrl:(NSString *)imageUrl;


/**
 获取历史浏览记录
 */
+(NSArray*)getAllBrowserData;


/**
 删除历史浏览记录
 @param data 历史浏览数据
 */
+(void)deleteBrowserData:(SCNBrowserData*)data;

/**
	拨打电话
 */
+(void)makeCall:(NSString*)telnum;

/**
 判断设备类型
 @param name 设备描述字符串
 @returns 是否是此类设备
 */
+(BOOL)checkDevice:(NSString*)name;

@end
