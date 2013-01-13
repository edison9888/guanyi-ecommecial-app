//
//  Go2PageUtility.h
//  SCN
//
//  Created by zwh on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNAppDelegate.h"
#import "BaseViewController.h"
#import "LeveyTabBarController.h"
#import "SCNLoginViewController.h"
#import "SCNAddressEditViewController.h"
#import "addressData.h"

//@protocol YKshowLoginDelegate<NSObject>
//
//+(void)DealNeedlogin: action:(SEL)action;
//
//@end


@interface Go2PageUtility : NSObject  {
    
}
//搜索专区
/*
    跳转到商品列表 with 关键字
    keyword:搜索关键字
    categoryId:分类ID
    isSearch:标记是否由搜索页面跳转
    categoryName:分类名
 */
+(void)go2ProductListViewController:(BaseViewController*)viewCtrl withKeyword:(NSString*)keyword withCategoryId:(NSString*)categoryId withIsSearch:(BOOL)isSearch withCategoryName:(NSString*)categoryName withBrandId:(NSString*)brandid withTypeId:(NSString*)typeID withType:(NSString*)type;
//商品筛选页面
+(void)go2ProductFilterViewController:(BaseViewController *)viewCtrl withFilterDataDict:(NSMutableDictionary*)dict;

//秒杀专区
+(void)go2SecKillListViewController:(BaseViewController*)viewCtrl withTypeName:(NSString*)typeName withSecKillID:(NSString*)seckillID;
+(void)go2SecKillDetailViewController:(BaseViewController *)viewCtrl withProductCode:(NSString*)productCode;
//更多专区

//品牌浏览
+(void)go2BrandClassifiedViewController:(BaseViewController*)viewCtrl withFatherId:(NSString*)fatherId;

//商品浏览记录
+(void)go2AnnalViewController:(BaseViewController*)viewCtrl;


//帮助
+(void)go2HelpViewController:(BaseViewController*)viewCtrl;

//关于
+(void)go2AboutViewController:(BaseViewController*)viewCtrl;
//订单详情
+(void)go2OrderDetailViewController:(BaseViewController *)viewCtrl orderId:(NSString *)orderId;
//物流追踪
+(void)go2LogisticsTrackingViewController:(BaseViewController *)viewCtrl Logistics:(NSString *)Logistics;
//消息列表
+(void)go2MessageListViewController:(BaseViewController*)viewCtrl;

//个人资料设置
+(void)go2MyInformationViewController:(BaseViewController*)viewCtrl;

//我的优惠券
+(void)go2MyVoucherViewController:(BaseViewController *)viewCtrl;

//售前咨询(我的咨询)
+(void)go2UserConsultationViewController:(BaseViewController*)viewCtrl productCode:(NSString*)productCode;

//评论列表
+(void)go2CommentaryListViewController:(BaseViewController*)viewCtrl productCode:(NSString*)productCode;

//我的评论
+(void)go2UserCommentaryViewController:(BaseViewController *)viewCtrl;


/******************注册登陆相关******/
//判断是否登陆,并跳转下级界面
+(void)showViewControllerNeedLogin:(BaseViewController*)fromviewCtrl 
                        toViewCtrl:(BaseViewController*)toViewCtrl;
//只显示登陆界面
+(void)showloginViewControlelr:(id)target action:(SEL)action;
+(void)showloginViewControlelr:(id)target action:(SEL)action withObject:(id)object;

//只显示注册界面
+(void)showRegisterViewControlelr:(BaseViewController*)viewCtrl Target:(id)target action:(SEL)action withObject:(id)object;
//跳转注册界面
+(void)go2RegisterController:(BaseViewController*)quondamViewCtr viewCtrl:(BaseViewController*)viewCtrl 
                 nextViewCtr:(BaseViewController*)nextViewCtr;

//获取验证码
+(void)go2ChangePasswordController:(BaseViewController*)viewCtrl;

//验证验证码
+(void)go2RePasswordController:(BaseViewController*)viewCtrl username:(NSString *)username;

//修改密码
+(void)go2RejiggerPasswordController:(BaseViewController*)viewCtrl;

//密码重置
+(void)go2ResetPassWordController:(BaseViewController*)ViewCtrl;

//购物车与结算中心
//+(void)go2CashCenterViewController:(BaseViewController*)viewCtrl withProducts:(NSArray*)products;//跳转到结算中心界面

+(void)go2CashCenterViewController:(BaseViewController*)BaseviewCtrl cashCenterViewCtrl:(BaseViewController*)cashCenterViewCtrl withProducts:(NSArray*)products withCashType:(int)cashType;

+(void)go2CashCenterByShoppingType:(BaseViewController*)BaseviewCtrl cashCenterViewCtrl:(BaseViewController*)cashCenterViewCtrl withProductData:(NSString*)productData withCashType:(int)cashType;

+(void)go2CashCenterSuccessViewController:(BaseViewController*)viewCtrl withOrderId:(NSString*)_orderId withPayMoney:(NSString*)_payMoney withPayType:(NSString*)_payType;//跳转到订单提交成功页面
//首页跳转
+(void)go2WhichViewController:(BaseViewController *)viewCtrl 
                     withType:(NSString *)type 
              withProductCode:(NSString *)productCode 
                 withPStatues:(NSString *)pstatues 
                withImagesUrl:(NSString *)imagesUrl 
                    withTitle:(NSString *)title 
                withTypeValue:(NSString *)typeValue;

//分类浏览
+(void)go2ClassFiledViewController:(BaseViewController*)viewCtrl categoryID:(NSString *)caregoryId Title:(NSString *)title;
//商品详情
+(void)go2ProductDetailViewController:(BaseViewController *)viewCtrl withProductCode:(NSString *)productCode
                            withImage:(NSString*)imgUrl;

+(void)go2ProductDetailViewControllerWithNavCtrl:(UINavigationController *)navCtrl withProductCode:(NSString *)productCode
									   withImage:(NSString*)imgUrl;
/**
 判断跳转 商品详情,秒杀详情
 pstatus=0,商品详情 
 pstatus=2,秒杀详情 (imgUrl可为nil）
 */
+(void)go2ProductDetail_OR_SecKill_ViewController:(BaseViewController *)viewCtrl 
                                  withProductCode:(NSString *)productCode 
                                      withPstatus:(NSString *)pstatus
                                        withImage:(NSString *)imgUrl;
//更多商品信息
+(void)go2MoreProductInfoViewController:(BaseViewController *)viewCtrl withProdectCode:(NSString *)productcode;
//跳转大图浏览页面
+(void)go2BigImageViewController:(BaseViewController *)viewCtrl withImageUrlArr:(NSMutableArray *)imageUrlArr withIndex:(int)index;

//跳转地址页面
+(void)go2AddressListViewController:(BaseViewController*)viewCtrl;

//地址编译、添加
+(void)go2AddressModifyPage:(BaseViewController*)viewCtrl withAddress:(addressData*)addr withDelegate:(id<YK_SCN_AddressEditDelegate>)aDelegate;

//根据index跳转TabBar页
+(UIViewController *)go2ViewControllerByIndex:(NSUInteger)index;

//刷新所有需要刷新的视图
+(void)RefreshAllVisibleViewControllers;
//刷新所有视图
+(void)RefreshAllViewControllers;
@end
