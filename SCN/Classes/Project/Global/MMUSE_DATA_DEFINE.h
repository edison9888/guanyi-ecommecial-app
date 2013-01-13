//
//  MMUSE_DATA_DEFINE.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-25.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifdef TEST_URL

    #define MMUSE_URL @"http://appapi.loc/api.php"
    #define MMUSE_TOKEN @"b75ecf34b65f87ed3d5d674297f36e464d9ea8aa677de6e1e0fcceaa9739df35"
    #define MMUSE_MOBAPI_URL @"http://mobapi.250y.com/test/"


#else

    #define MMUSE_URL @"http://appapi.loc/api.php"
    #define MMUSE_TOKEN @"2e20fa78a023494dfcb0258ff97597c3949453c10da8f130ca231679a3181a81"
    #define MMUSE_MOBAPI_URL @"http://mobapi.250y.com/"
    
#endif


#define MMUSE_KEY_WEBLOGID				@"weblogid"
#define MMUSE_KEY_API_VERSION			@"api-version"
#define MMUSE_KEY_CLIENT_VERSION		@"client-version"
#define MMUSE_KEY_PLATFORM_N			@"platform-n"
#define MMUSE_KEY_DEVICE_ID				@"device-id"
#define MMUSE_KEY_CONTENT_TYPE			@"contenttype"
#define MMUSE_KEY_MODEL					@"model"
#define MMUSE_KEY_IMSI					@"imsi"
#define MMUSE_KEY_SOURCEID				@"sourceid"
#define	MMUSE_KEY_SUBSOURCEID			@"subsourceid"
#define MMUSE_KEY_LANGUAGE				@"language"
#define MMUSE_KEY_CN_OPERATOR			@"cn-operator"
#define MMUSE_KEY_SMS_NUMBER			@"sms-number"
#define MMUSE_KEY_SCREEN_SIZE			@"screen-size"
#define MMUSE_KEY_SCREEN_SCALE			@"screen-scale"
#define MMUSE_POSTKEY_API_VERSION		@"api_version"


#define MMUSE_KEY_APP_KEY				@"appkey"
#define MMUSE_KEY_AUTH_TYPE				@"authtype"
#define MMUSE_KEY_WANTYPE				@"wantype" 
#define MMUSE_KEY_CARRIER				@"carrier"
#define MMUSE_KEY_VER					@"ver"


#define MMUSE_VALUE_WEBLOGID			@""
#define	MMUSE_VALUE_API_VERSION         @"1.0"
#define MMUSE_VALUE_PLATFORM_N			@"ios"
#define MMUSE_VALUE_CONTENT_TYPE		@"xml"
#define MMUSE_VALUE_SCREEN_SIZE         @"320x480"
#define MMUSE_VALUE_APP_KEY             @"12087020"
#define MMUSE_VALUE_AUTH_TYPE_MD5		@"md5"
#define MMUSE_VALUE_WANTYPE             @""
#define MMUSE_VALUE_CARRIER             @""
#define MMUSE_VALUE_VER                 @""
#define MMUSE_KEY_USER_NAME             @"username"
#define MMUSE_KEY_USER_ID				@"userid"

//DATAINTERFACE METHOD
#define MMUSE_METHOD_GET_UPDATE        @"sys.version.update"           //获得升级信息的方法
#define MMUSE_METHOD_SUBMIT_TOKEN      @"submitToken"      //提交设备令牌的方法

#define MMUSE_METHOD_GET_HOTKEYWORD    @"home.view.keywords"    //获得热门关键字的方法
#define MMUSE_METHOD_GET_ASSOCIATE     @"home.view.keywords_autocomplete" //获得搜索关联关键字的方法
#define MMUSE_METHOD_GET_PRODUCTLIST   @"product.list.normal_list"   //获得商品列表的方法
#define MMUSE_METHOD_GET_SECKILLLIST   @"getSeckillList"   //获得秒杀列表的方法

#define MMUSE_METHOD_GET_HOMEINFO              @"home.view.index"              //获得首页信息
#define MMUSE_METHOD_GET_SECKILLPRODUCTINFO    @"getSeckillProductInfo"    //秒杀详情信息

//
#define MMUSE_METHOD_GET_CATEGORYLIST          @"shopcats.category.get"    //分类浏览

#define MMUSE_METHOD_GET_BRANDLIST             @"shopcats.brand.get"       //品牌浏览

#define MMUSE_METHOD_GET_BRANDLIST             @"shopcats.brand.get"       //品牌浏览
#define MMUSE_METHOD_GET_PRODUCTINFO           @"getProductInfo"           //商品详情
#define MMUSE_METHOD_GET_PRODUCTDETAIL         @"getProductDetail"         //更多商品信息
#define MMUSE_METHOD_GET_SIZECOVERLIST         @"sizeCoverList"            //尺码转换
#define MMUSE_METHOD_GET_ADDFAVORITE           @"addFavorite"              //加入收藏夹
#define MMUSE_METHOD_GET_ACTIVITYPRODUCTLIST   @"product.list.activitybrand"   //活动商品列表
//注册,登陆相关
#define MMUSE_METHOD_GET_WEBLOGID              @"getWeblogId"              //获得weblogid
#define MMUSE_METHOD_REGISTER                  @"user.operate.register"    //用户注册
#define MMUSE_METHOD_LOGIN                     @"user.operate.login"                    //登陆
#define MMUSE_METHOD_LOGOUT                    @"user.operate.logout"                   //注销
#define MMUSE_METHOD_REQUESTSECURITYCODE       @"requestSecurityCode"      //请求验证码
#define MMUSE_METHOD_VERIFYSECURITYCODE        @"verifySecurityCode"       //验证验证码
#define MMUSE_METHOD_RESETPASSWORD             @"resetPassword"            //密码重置
#define MMUSE_METHOD_GET_MODIFYPASSWORD        @"modifyPassword"           //修改密码
//我的名鞋库
#define MMUSE_METHOD_GET_USERINFO              @"getUserInfo"              //获得个人资料
#define MMUSE_METHOD_MODIFYUSERINFO            @"modifyUserInfo"           //修改个人资料
#define MMUSE_METHOD_GET_FAVORITELIST          @"more.view.fav_list"          //获得收藏夹列表
#define MMUSE_METHOD_DELFAVORITE               @"more.view.del_favorite"              //删除收藏夹列表
#define MMUSE_METHOD_GET_COMMENTLIST           @"product.info.comments"     //获得评论列表
#define MMUSE_METHOD_GET_MYCOMMENTLIST         @"getMyCommentList"         //获得我的评论列表
#define MMUSE_METHOD_COMMENT                   @"comment"                  //发表评论
#define MMUSE_METHOD_GET_CONSULTLIST           @"getConsultList"           //获得售前咨询列表
#define MMUSE_METHOD_GET_MYCONSULTLIST         @"getMyConsultList"         //获得我的咨询列表
#define MMUSE_METHOD_PRODUCTCONSULT            @"productConsult"           //发表咨询
#define MMUSE_METHOD_GET_MESSAGELIST           @"getMessageList"           //获得消息列表
#define MMUSE_METHOD_READMESSAGE               @"more.view.message_detail"      //阅读消息
#define MMUSE_METHOD_GET_COUPONLIST            @"getCouponList"            //获得优惠券列表
#define MMUSE_METHOD_GET_ORDERLIST             @"getOrderList"             //获得订单列表
#define MMUSE_METHOD_GET_ORDERINFO             @"getOrderInfo"             //订单详情

//更多
#define MMUSE_METHOD_GET_HELPLIST              @"more.view.help_list"      //获得帮助列表
#define MMUSE_METHOD_UCENTER                   @"user.operate.ucenter"     //我的名鞋库

//购物车，结算中心里面的方法
#define MMUSE_METHOD_CREATEORDER				@"createOrder"				//生成订单
#define MMUSE_METHOD_ORDERBALANCE				@"orderBalance"				//结算中心
#define MMUSE_METHOD_GET_SHOPPINGCART			@"getShoppingCart"			//查看购物车

//地址页面
#define MMUSE_METHOD_GET_ADDRESSLIST			@"getAddressList"			//获取地址
#define MMUSE_METHOD_SET_ADDRESS				@"setAddress"				//修改或添加地址	
#define MMUSE_METHOD_SET_DEFAULTADDRESS         @"setDefaultAddress"		//设置默认地址
#define MMUSE_METHOD_DEL_ADDRESS				@"delAddress"				//删除地址


//DATAINTERFACE PARAMS              // 平台
#define MMUSE_KEY_UDID							@"udid"                     // 设备号
#define MMUSE_KEY_CLIENT_V						@"client_v"                 // 分配版本号
#define MMUSE_KEY_MODEL                         @"model"                    // 手机型号
#define MMUSE_KEY_IMSI							@"imsi"                     // 手机sim卡标示
#define MMUSE_KEY_IMEI							@"imei"                     // 手机硬件识别号
#define MMUSE_KEY_SOURCE						@"source"                   // 客户端来源标识
#define MMUSE_KEY_LANGUAGE						@"language"                 // 语言
#define MMUSE_KEY_SMS_CENTER_NUMBER             @"sms_center_number"		// 短信中心号码

//订单统计需用的
#define MMUSE_KEY_PRODUCTCODE					@"productcode"
#define MMUSE_KEY_SESSIONID                     @"sessionid"
#define MMUSE_KEY_MACID                         @"macid"
#define MMUSE_KEY_OSNAME						@"osname"
#define MMUSE_KEY_OSVERSION                     @"osversion"
#define MMUSE_KEY_APPVERSION					@"appversion"
#define MMUSE_KEY_USERNAME						@"username"
#define MMUSE_KEY_DEVICENAME					@"devicename"
#define MMUSE_KEY_SOURCESUBID					@"sourcesubid"
#define MMUSE_KEY_TIME							@"time"
#define MMUSE_KEY_SIGN							@"sign"
#define MMUSE_KEY_ORDERID						@"orderid"
#define MMUSE_KEY_FULLNAME						@"fullname"
#define MMUSE_KEY_CELLPHONE                     @"cellphone"
#define MMUSE_KEY_ADDRESS						@"address"
#define MMUSE_KEY_AMOUNT						@"amount"
#define MMUSE_KEY_ORDERTIME                     @"ordertime"
#define MMUSE_KEY_PROVINCE						@"province"
#define MMUSE_KEY_CITY							@"city"
#define MMUSE_KEY_COUNTY						@"county"
#define MMUSE_KEY_ORDERMESSAGE					@"ordermessage"
#define MMUSE_KEY_ITEMDATA						@"itemdata"

//行为统计添加的
#define MMUSE_KEY_APPNAME						@"appname"
#define MMUSE_KEY_ISREALURL                     @"isrealurl"

//商品状态
#define PRODUCT_NORMAL_VALUE                    @"0"
#define PRODUCT_OFFSELL_VALUE                   @"1"//下架
#define PRODUCT_SECKILL_VALUE                   @"2"
#define PRODUCT_LACKSTOCK_VALUE                 @"3"//库存不足

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


