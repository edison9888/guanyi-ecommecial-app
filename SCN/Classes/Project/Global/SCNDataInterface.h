//
//  SCNDataInterface.h
//  SCN
//
//  Created by zwh on 11-10-8.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//	120.42.54.106:810/api.php
//	test.skomart.cn:810/api.php

#import <Foundation/Foundation.h>

#ifdef TEST_URL

#define SCN_URL @"http://120.42.54.106:810/api.php"
#define SCN_TOKEN @"b75ecf34b65f87ed3d5d674297f36e464d9ea8aa677de6e1e0fcceaa9739df35"
#define YK_MOBAPI_URL @"http://mobapi.250y.com/test/"


//#define SCN_URL @"http://w106.skomart.kbu.shopex123.com/api.php"
//#define SCN_TOKEN @"2e20fa78a023494dfcb0258ff97597c3949453c10da8f130ca231679a3181a81"

#else

#define SCN_URL @"http://www.s.cn/api.php"
#define YK_MOBAPI_URL @"http://mobapi.250y.com/"
#define SCN_TOKEN @"2e20fa78a023494dfcb0258ff97597c3949453c10da8f130ca231679a3181a81"

#endif




#define YK_KEY_WEBLOGID				@"weblogid"
#define YK_KEY_API_VERSION			@"api-version"
#define YK_KEY_CLIENT_VERSION		@"client-version"
#define YK_KEY_PLATFORM_N			@"platform-n"
#define YK_KEY_DEVICE_ID			@"device-id"
#define YK_KEY_CONTENT_TYPE			@"contenttype"
#define YK_KEY_MODEL				@"model"
#define YK_KEY_IMSI					@"imsi"
#define YK_KEY_SOURCEID				@"sourceid"
#define	YK_KEY_SUBSOURCEID			@"subsourceid"
#define YK_KEY_LANGUAGE				@"language"
#define YK_KEY_CN_OPERATOR			@"cn-operator"
#define YK_KEY_SMS_NUMBER			@"sms-number"
#define YK_KEY_SCREEN_SIZE			@"screen-size"
#define YK_KEY_SCREEN_SCALE			@"screen-scale"
#define YK_POSTKEY_API_VERSION		@"api_version"


#define YK_KEY_APP_KEY				@"appkey"
#define YK_KEY_AUTH_TYPE			@"authtype"
#define YK_KEY_WANTYPE				@"wantype" 
#define YK_KEY_CARRIER				@"carrier"
#define YK_KEY_VER					@"ver"


#define YK_VALUE_WEBLOGID			@""
#define	YK_VALUE_API_VERSION		@"1.0"
#define YK_VALUE_PLATFORM_N			@"ios"
#define YK_VALUE_CONTENT_TYPE		@"xml"
#define YK_VALUE_SCREEN_SIZE		@"320x480"
#define YK_VALUE_APP_KEY			@"12087020"
#define YK_VALUE_AUTH_TYPE_MD5		@"md5"
#define YK_VALUE_WANTYPE			@""
#define YK_VALUE_CARRIER			@""
#define YK_VALUE_VER				@""
#define YK_KEY_USER_NAME			@"username"
#define YK_KEY_USER_ID				@"userid"

//DATAINTERFACE METHOD
#define YK_METHOD_GET_UPDATE        @"update"           //获得升级信息的方法
#define YK_METHOD_SUBMIT_TOKEN      @"submitToken"      //提交设备令牌的方法

#define YK_METHOD_GET_HOTKEYWORD    @"getHotKeyword"    //获得热门关键字的方法
#define YK_METHOD_GET_ASSOCIATE     @"getAssociateWord" //获得搜索关联关键字的方法
#define YK_METHOD_GET_PRODUCTLIST   @"getProductList"   //获得商品列表的方法
#define YK_METHOD_GET_SECKILLLIST   @"getSeckillList"   //获得秒杀列表的方法

#define YK_METHOD_GET_HOMEINFO              @"getHomeInfo"              //获得首页信息
#define YK_METHOD_GET_SECKILLPRODUCTINFO    @"getSeckillProductInfo"    //秒杀详情信息
#define YK_METHOD_GET_CATEGORYLIST          @"getCategoryList"          //分类浏览
#define YK_METHOD_GET_BRANDLIST             @"getBrandList"             //品牌浏览
#define YK_METHOD_GET_PRODUCTINFO           @"getProductInfo"           //商品详情
#define YK_METHOD_GET_PRODUCTDETAIL         @"getProductDetail"         //更多商品信息
#define YK_METHOD_GET_SIZECOVERLIST         @"sizeCoverList"            //尺码转换
#define YK_METHOD_GET_ADDFAVORITE           @"addFavorite"              //加入收藏夹
#define YK_METHOD_GET_ACTIVITYPRODUCTLIST   @"getActivityProductList"   //活动商品列表
//注册,登陆相关
#define YK_METHOD_GET_WEBLOGID              @"getWeblogId"              //获得weblogid
#define YK_METHOD_REGISTER                  @"register"                 //用户注册
#define YK_METHOD_LOGIN                     @"login"                    //登陆
#define YK_METHOD_LOGOUT                    @"logout"                   //注销
#define YK_METHOD_REQUESTSECURITYCODE       @"requestSecurityCode"      //请求验证码
#define YK_METHOD_VERIFYSECURITYCODE        @"verifySecurityCode"       //验证验证码
#define YK_METHOD_RESETPASSWORD             @"resetPassword"            //密码重置
#define YK_METHOD_GET_MODIFYPASSWORD        @"modifyPassword"           //修改密码
//我的名鞋库
#define YK_METHOD_GET_USERINFO              @"getUserInfo"              //获得个人资料
#define YK_METHOD_MODIFYUSERINFO            @"modifyUserInfo"           //修改个人资料
#define YK_METHOD_GET_FAVORITELIST          @"getFavoriteList"          //获得收藏夹列表
#define YK_METHOD_DELFAVORITE               @"delFavorite"              //删除收藏夹列表
#define YK_METHOD_GET_COMMENTLIST           @"getCommentList"           //获得评论列表
#define YK_METHOD_GET_MYCOMMENTLIST         @"getMyCommentList"         //获得我的评论列表
#define YK_METHOD_COMMENT                   @"comment"                  //发表评论
#define YK_METHOD_GET_CONSULTLIST           @"getConsultList"           //获得售前咨询列表
#define YK_METHOD_GET_MYCONSULTLIST         @"getMyConsultList"         //获得我的咨询列表
#define YK_METHOD_PRODUCTCONSULT            @"productConsult"           //发表咨询
#define YK_METHOD_GET_MESSAGELIST           @"getMessageList"           //获得消息列表
#define YK_METHOD_READMESSAGE               @"readMessage"              //阅读消息
#define YK_METHOD_GET_COUPONLIST            @"getCouponList"            //获得优惠券列表
#define YK_METHOD_GET_ORDERLIST             @"getOrderList"             //获得订单列表
#define YK_METHOD_GET_ORDERINFO             @"getOrderInfo"             //订单详情

//更多
#define YK_METHOD_GET_HELPLIST              @"getHelpList"              //获得帮助列表
#define YK_METHOD_MYSCNG                    @"myscn"                    //我的名鞋库

//购物车，结算中心里面的方法
#define YK_METHOD_CREATEORDER				@"createOrder"				//生成订单
#define YK_METHOD_ORDERBALANCE				@"orderBalance"				//结算中心
#define YK_METHOD_GET_SHOPPINGCART			@"getShoppingCart"			//查看购物车

//地址页面
#define YK_METHOD_GET_ADDRESSLIST			@"getAddressList"			//获取地址
#define YK_METHOD_SET_ADDRESS				@"setAddress"				//修改或添加地址	
#define YK_METHOD_SET_DEFAULTADDRESS		@"setDefaultAddress"		//设置默认地址
#define YK_METHOD_DEL_ADDRESS				@"delAddress"				//删除地址


//DATAINTERFACE PARAMS              // 平台
#define YK_KEY_UDID							@"udid"                     // 设备号
#define YK_KEY_CLIENT_V						@"client_v"                 // 分配版本号
#define YK_KEY_MODEL						@"model"                    // 手机型号
#define YK_KEY_IMSI							@"imsi"                     // 手机sim卡标示
#define YK_KEY_IMEI							@"imei"                     // 手机硬件识别号
#define YK_KEY_SOURCE						@"source"                   // 客户端来源标识
#define YK_KEY_LANGUAGE						@"language"                 // 语言
#define YK_KEY_SMS_CENTER_NUMBER			@"sms_center_number"		// 短信中心号码

//订单统计需用的
#define YK_KEY_PRODUCTCODE					@"productcode"
#define YK_KEY_SESSIONID					@"sessionid"
#define YK_KEY_MACID						@"macid"
#define YK_KEY_OSNAME						@"osname"
#define YK_KEY_OSVERSION					@"osversion"
#define YK_KEY_APPVERSION					@"appversion"
#define YK_KEY_USERNAME						@"username"
#define YK_KEY_DEVICENAME					@"devicename"
#define YK_KEY_SOURCESUBID					@"sourcesubid"
#define YK_KEY_TIME							@"time"
#define YK_KEY_SIGN							@"sign"
#define YK_KEY_ORDERID						@"orderid"
#define YK_KEY_FULLNAME						@"fullname"
#define YK_KEY_CELLPHONE					@"cellphone"
#define YK_KEY_ADDRESS						@"address"
#define YK_KEY_AMOUNT						@"amount"
#define YK_KEY_ORDERTIME					@"ordertime"
#define YK_KEY_PROVINCE						@"province"
#define YK_KEY_CITY							@"city"
#define YK_KEY_COUNTY						@"county"
#define YK_KEY_ORDERMESSAGE					@"ordermessage"
#define YK_KEY_ITEMDATA						@"itemdata"

//行为统计添加的
#define YK_KEY_APPNAME						@"appname"
#define YK_KEY_ISREALURL					@"isrealurl"

//商品状态
#define PRODUCT_NORMAL_VALUE				@"0"
#define PRODUCT_OFFSELL_VALUE				@"1"//下架
#define PRODUCT_SECKILL_VALUE				@"2"
#define PRODUCT_LACKSTOCK_VALUE				@"3"//库存不足

#define MAX_BROWSER       50
//@interface SCNDataInterface : NSObject{
//	
//}
//+(void) setCommonParam:(id)key value:(id)value;
//+(id) commonParam:(id) key;
//+(NSMutableDictionary *)commonParams;
//+(void)walkDataInterface;
//+(NSDictionary*)extraHeaders;
//@end

#pragma mark -
#pragma mark SourceId相关
extern NSString *getSourceID(void);
extern NSString *getSubSourceID(void);
extern BOOL isTestSourceID(void);


