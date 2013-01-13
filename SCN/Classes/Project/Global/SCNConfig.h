//
//  SCNConfig.h
//	公共配置文件
//  SCN
//
//  Created by zwh on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark 项目相关


#define YK_LOGIN_SUCCESS		@"YK_LOGIN_SUCCESS"
#define YK_LOGIN_OUT			@"YK_LOGIN_OUT"

//未登录
#define YK_NO_LOGIN				@"YK_NO_LOGIN"			//这个是马上会回调的
#define YK_NO_PRODUCT			@"YK_NO_PRODUCT"

#define YK_COLLECTION_CHANGE    @"YK_COLLECTION_CHANGE"

#define YK_MYSCNMESSAGE_READ    @"YK_MYSCNMESSAGE_READ"

// 程序不在运行
#define YK_RESIGN_ACTIVE		@"YK_RESIGN_ACTIVE"
// 程序运行中
#define YK_BECOME_ACTIVE		@"YK_BECOME_ACTIVE"

#define YK_DEFAULTADDRESS_CHANGE @"YK_DEFAULTADDRESS_CHANGE"
#define YK_ADDRESS_DELETE		@"YK_ADDRESS_DELETE"


#define YK_SHOPPINGCART_CHANGE	@"shoppingcartChange"

#pragma mark -
#pragma mark 公共文字

//电话号码
#define YK_400PHONE_NUMBER         @"4008002222"
#define YK_DISPLAY400PHONE_NUMBER  @"400-800-2222"

#pragma mark -
#pragma mark 图片相关

#define YK_COMMONIMG_NAVI		@"com_nav.png"


#define YK_SHOPPINGTYPE_COMMON	@"common"
#define YK_SHOPPINGTYPE_SECKILL	@"seckill"
#define YK_SHOPPINGTYPE_OTHER	@"other"

#define YK_PRODUCT_COMMON	@"0"
#define YK_PRODUCT_OFFSELL	@"1"
#define YK_PRODUCT_SECKILL	@"2"
#define YK_PRODUCT_LACK		@"3"

#define YK_SHOPPINGTYPE_COMMON_BUY	@"0"
#define YK_SHOPPINGTYPE_SECKILL_BUY @"1"

#define YK_DEFAULT_UPDATE	@"defaultupdate"
#define YK_COUPON_UPDATE	@"couponupdate"
#define YK_COUPON_USE		@"couponuse"
#define YK_COUPON_CANCEL	@"couponcancel"
#define YK_ADDRESS_UPDATE	@"addressupdate"

#define YK_CELLBORDER_COLOR  ([UIColor colorWithRed:(float)(200/255.0f) green:(float)(200/255.0f) blue:(float)(200/255.0f) alpha:1.0])
#define YK_IMAGEBORDER_COLOR  ([UIColor colorWithRed:(float)(100/255.0f) green:(float)(100/255.0f) blue:(float)(100/255.0f) alpha:1.0])

typedef enum YK_SCN_ACTION_BEHAVIOR {
	ACTION_SHARE = 1001,//分享
	ACTION_SAVEIMAGETOALBUM = 1002,//保存图片到相册
	ACTION_ADDSHOPPINGCART = 1003,//添加购物车
	ACTION_BUYIMMEDIATE = 1004,//立即购买
	ACTION_ADDFAVORITE = 1005,//放入收藏夹
	ACTION_SUBMITORDER = 1006,//提交订单
	ACTION_ORDERSUCCESS = 1007,//提交订单成功
	ACTION_ORDERFAILURE = 1008,//提交订单失败
	ACTION_CANCELORDER = 1009,//取消订单
	ACTION_FILTER = 1010,//执行筛选
	ACTION_SEARCH = 1011,//执行搜索
	ACTION_MOBILE = 1012,//拨打客服电话
	ACTION_LOGIN = 1013,//用户登录
	ACTION_USERLOGOUT = 1014,//用户注销
	ACTION_EDITOPTION = 1015,//编辑选项
	ACTION_MENUOPERATE = 1017,//菜单操作
	ACTION_USERCLICK = 1018,//用户点击
	ACTION_CRAZYBUY = 1019,//抢购
	ACTION_SECKILL = 1020,//秒杀
	ACTION_SUBMITCONSULT = 1022,//提交咨询
	ACTION_SUBMITCOMMENT = 1023,//提交评论
	ACTION_SELECTADDRESS = 1024,//选择收货地址
	ACTION_SUBMITPERSONALINFO = 1025,//个人资料提交
	ACTION_COMMENTSUBMIT = 1026,//评论提交
	ACTION_REGISTER = 1021,//注册
	ACTION_REMOVESHOPPINGCART = 1103,//移除购物车
}behaviorEnum;

#pragma mark -
#pragma mark 接口相关
//购物车页面所需用到的对列表的操作常量定义字典
extern const NSString* YK_KEY_NUMBER_MODIFY;
extern const NSString* YK_KEY_SIZE_MODIFY;
extern const NSString* YK_KEY_MOVETO_FAVORITE;
extern const NSString* YK_KEY_PRODUCT_DELETE;



#pragma mark -
#pragma mark 提示相关

#define SCN_DEFAULTTIP_TITLE @"温馨提示"


#pragma mark -
#pragma mark 通知相关
//发表咨询/评论 成功
#define YK_PUBLISH_SUCCESS    @"YK_PUBLISH_SUCCESS"


//购物相关

typedef enum {
    ECashTypeCommon,
    ECashTypeSeckill,
    ECashTypeImmediately,
} CashTypeEnum;
