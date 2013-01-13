//
//  Go2PageUtility.m
//  SCN
//
//  Created by zwh on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  xuxie添加搜索专区 11-10-8 
//

#import "Go2PageUtility.h"
#import "SCNConfig.h"
//更多专区
#import "SCNProductListViewController.h"
#import "GY_Brands_Controller.h"
#import "SCNAnnalViewController.h"
#import "SCNMySCNController.h"
#import "SCNHelpViewController.h"
#import "SCNAboutViewController.h"
#import "SCNOrderDetailViewController.h"
//我的名鞋库
#import "SCNMessageListViewController.h"
#import "SCNMyInformationViewController.h"
#import "SCNMyVoucherViewController.h"
#import "SCNUserConsultationViewController.h"
#import "SCNUserCommentaryViewController.h"
#import "SCNCommentaryListViewController.h"
#import "SCNLogisticsTrackingViewController.h"
//账号注册,登陆,修改专区
#import "SCNLoginViewController.h"
#import "SCNRegistViewController.h"
#import "SCNChangePasswordViewController.h"
#import "SCNRePasswordViewController.h"
#import "SCNRejiggerPasswordViewController.h"
#import "SCNResetPassWordViewController.h"
#import "YKUserInfoUtility.h"

#import "SCNCashCenterViewController.h"
#import "SCNCashCenterSuccessViewController.h"

//秒杀列表
#import "SCNSecKillListViewController.h"
//秒杀详情
#import "SCNSecKillDetailViewController.h"
//商品列表
#import "SCNProductListViewController.h"
//商品筛选
#import "SCNProductFilterViewController.h"
//分类浏览
#import "SCNClassifiedViewController.h"
//商品详情
#import "SCN_productDetailViewController.h"
//大图浏览
#import "SCN_BigImageViewController.h"
//更多商品信息
#import "SCNMoreProductInfoViewController.h"
//地址
#import "SCNAddressListViewController.h"

#import "SCNViewController.h"

//static UINavigationController* loginnavgation=nil;
  
@implementation Go2PageUtility
//搜索专区
//跳转到商品列表 with 关键字
+(void)go2ProductListViewController:(BaseViewController*)viewCtrl withKeyword:(NSString*)keyword withCategoryId:(NSString*)categoryId withIsSearch:(BOOL)isSearch  withCategoryName:(NSString*)categoryName  withBrandId:(NSString*)brandid withTypeId:(NSString*)typeID withType:(NSString*)type{
    //处理参数传递和页面跳转 (typeID 是productcode)
    SCNProductListViewController *productListController=[[SCNProductListViewController  alloc] initWithNibName:@"SCNProductListViewController" bundle:nil keyword:keyword categoryId:categoryId isSearch:isSearch brandID:brandid typeId:typeID type:type];
    if(isSearch)
    {
        productListController.navigationItem.title = [[YKStringUtility stripWhiteSpaceAndNewLineCharacter:keyword] isEqualToString:@""]?@"搜索结果":keyword;
    }
    else
    {
        if (categoryId!=nil&&[categoryId isEqualToString:@""]) 
        {
            productListController.navigationItem.title = [[YKStringUtility stripWhiteSpaceAndNewLineCharacter:categoryName] isEqualToString:@""]?@"商品列表":categoryName;
        }
        else
        {
            productListController.navigationItem.title = [[YKStringUtility stripWhiteSpaceAndNewLineCharacter:categoryName] isEqualToString:@""]?@"商品列表":categoryName;
        }
        
        if ([type isEqualToString:@"1"]) {
            //是从首页专题过来的（包括普通专题和秒杀)
            productListController.m_string_typeName = categoryName;
        }
        
    }
    [viewCtrl.navigationController pushViewController:productListController animated:YES];
}

//秒杀列表
+(void)go2SecKillListViewController:(BaseViewController*)viewCtrl withTypeName:(NSString*)typeName withSecKillID:(NSString*)seckillID{
    SCNSecKillListViewController *secKillViewController=[[SCNSecKillListViewController alloc] initWithNibName:@"SCNSecKillListViewController" bundle:nil withSecKillID:seckillID];
    secKillViewController.navigationItem.title = @"秒杀";
    secKillViewController.m_string_typeName = typeName;
    [viewCtrl.navigationController pushViewController:secKillViewController animated:YES];
}
//秒杀详情
+(void)go2SecKillDetailViewController:(BaseViewController *)viewCtrl withProductCode:(NSString*)productCode{
    SCNSecKillDetailViewController *secKillDetailViewController=[[SCNSecKillDetailViewController alloc] initWithNibName:@"SCNSecKillDetailViewController" bundle:nil withProductCode:productCode];
	[viewCtrl.navigationController pushViewController:secKillDetailViewController animated:YES];
}
//商品筛选
+(void)go2ProductFilterViewController:(BaseViewController *)viewCtrl withFilterDataDict:(NSMutableDictionary*)dict{
    SCNProductFilterViewController *productFilterController=[[SCNProductFilterViewController alloc] initWithNibName:@"SCNProductFilterViewController" bundle:nil withFilterDict:dict];
    productFilterController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    productFilterController.m_delegate_filter=(SCNProductListViewController*)viewCtrl;

    [viewCtrl presentModalViewController:productFilterController animated:YES];
}
//首页跳转
+(void)go2WhichViewController:(BaseViewController *)viewCtrl 
                     withType:(NSString *)type 
              withProductCode:(NSString *)productCode 
                 withPStatues:(NSString *)pstatues 
                withImagesUrl:(NSString *)imagesUrl 
                    withTitle:(NSString *)title 
                withTypeValue:(NSString *)typeValue
{

    if ([type isEqualToString:@"single"]) 
    {
        [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:viewCtrl withProductCode:productCode withPstatus:pstatues withImage:imagesUrl];
    }
    else if([type isEqualToString:@"seckill"])
    {
        [Go2PageUtility go2SecKillListViewController:viewCtrl withTypeName:title withSecKillID:productCode];
    }
    else if([type isEqualToString:@"brand"])
    {
        [Go2PageUtility go2BrandClassifiedViewController:viewCtrl withFatherId:productCode];
    }    
    else if([type isEqualToString:@"category"])
    {
        [Go2PageUtility go2ProductListViewController:viewCtrl withKeyword:nil withCategoryId:productCode withIsSearch:NO withCategoryName:title withBrandId:nil withTypeId:nil withType:nil];
    }
    else if([type isEqualToString:@"keyword"])
    {
        [Go2PageUtility go2ProductListViewController:viewCtrl withKeyword:nil withCategoryId:productCode withIsSearch:NO withCategoryName:title withBrandId:nil withTypeId:nil withType:nil];
    }
    else
    {
        if ([typeValue intValue]==1 || [typeValue intValue]==2) 
        {
            [Go2PageUtility go2ProductListViewController:viewCtrl withKeyword:nil withCategoryId:nil withIsSearch:NO withCategoryName:title withBrandId:nil withTypeId:productCode withType:typeValue];
        }
        else 
        {
        [Go2PageUtility go2ProductListViewController:viewCtrl withKeyword:nil withCategoryId:nil withIsSearch:NO withCategoryName:title withBrandId:nil withTypeId:productCode withType:type];
        }
    }


}
//分类浏览
+(void)go2ClassFiledViewController:(BaseViewController*)viewCtrl categoryID:(NSString *)caregoryId Title:(NSString *)title
{
    SCNClassifiedViewController *classFiledVC = [[SCNClassifiedViewController alloc]initWithNibName:@"SCNClassifiedViewController" bundle:nil FatherId:caregoryId Title:title];
    [viewCtrl.navigationController pushViewController:classFiledVC animated:YES];
}
#pragma mark -
#pragma mark 商品详情专区
//商品详情
+(void)go2ProductDetailViewController:(BaseViewController *)viewCtrl withProductCode:(NSString *)productCode
                            withImage:(NSString*)imgUrl
{
    SCN_productDetailViewController *productDetailVC = 
                                    [[SCN_productDetailViewController alloc]initWithNibName:@"SCN_productDetailViewController"
                                                                                     bundle:nil 
                                                                            withProductCode:productCode
                                                                              withwithImage:imgUrl];
    [viewCtrl.navigationController pushViewController:productDetailVC animated:YES];
}

//商品详情
+(void)go2ProductDetailViewControllerWithNavCtrl:(UINavigationController *)navCtrl withProductCode:(NSString *)productCode
                            withImage:(NSString*)imgUrl
{
    SCN_productDetailViewController *productDetailVC = 
	[[SCN_productDetailViewController alloc]initWithNibName:@"SCN_productDetailViewController"
													 bundle:nil 
											withProductCode:productCode
											  withwithImage:imgUrl];
    [navCtrl pushViewController:productDetailVC animated:YES];
}

//判断跳转 商品详情,秒杀详情
+(void)go2ProductDetail_OR_SecKill_ViewController:(BaseViewController *)viewCtrl 
                                  withProductCode:(NSString *)productCode 
                                      withPstatus:(NSString *)pstatus
                                        withImage:(NSString *)imgUrl
{
    if ([pstatus intValue]==2) {
        [Go2PageUtility go2SecKillDetailViewController:viewCtrl withProductCode:productCode];
    }
    else
    {
        [Go2PageUtility go2ProductDetailViewController:viewCtrl withProductCode:productCode withImage:imgUrl];
    }
}
//更多商品信息
+(void)go2MoreProductInfoViewController:(BaseViewController *)viewCtrl withProdectCode:(NSString *)productcode
{
    SCNMoreProductInfoViewController *moreProductDetail = [[SCNMoreProductInfoViewController alloc] initWithNibName:@"SCNMoreProductInfoViewController" bundle:nil withProductCode:productcode];
    [viewCtrl.navigationController pushViewController:moreProductDetail animated:YES];
}
//跳转到大图浏览页面
+(void)go2BigImageViewController:(BaseViewController *)viewCtrl withImageUrlArr:(NSMutableArray *)imageUrlArr withIndex:(int)index
{
    SCN_BigImageViewController  *bigVC = [[SCN_BigImageViewController alloc]initWithNibName:@"SCN_BigImageViewController" bundle:nil withimageUrlArr:imageUrlArr withIndex:index];
    [viewCtrl.navigationController pushViewController:bigVC animated:YES];
}
#pragma mark -
#pragma mark 更多专区

#pragma mark -
#pragma mark 品牌浏览
+(void)go2BrandClassifiedViewController:(BaseViewController*)viewCtrl withFatherId:(NSString*)fatherId{
    GY_Brands_Controller *BrandClassField = [[GY_Brands_Controller alloc]initWithNibName:nil bundle:nil withFatherId:fatherId];
    [viewCtrl.navigationController pushViewController:BrandClassField animated:YES];
}
#pragma mark -
#pragma mark 商品浏览记录
+(void)go2AnnalViewController:(BaseViewController*)viewCtrl{
    SCNAnnalViewController *Annal = [[SCNAnnalViewController alloc]initWithNibName:@"SCNAnnalViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:Annal animated:YES];
    
}

#pragma mark -
#pragma mark 判断登陆才能进入界面 
+(void)showViewControllerNeedLogin:(BaseViewController*)fromviewCtrl 
                        toViewCtrl:(BaseViewController*)toViewCtrl{ 
    
    if ([YKUserInfoUtility isUserLogin]) {
        [[fromviewCtrl navigationController] pushViewController:toViewCtrl animated:YES];
    }
    else{
        SCNLoginViewController*	logincontroller = [[SCNLoginViewController alloc] 
                                                   initWithNibName:@"SCNLoginViewController" 
                                                   quondamViewCtr:fromviewCtrl 
                                                   nextViewCtr:toViewCtrl
                                                   bundle:nil];

        UINavigationController* loginnavgation = [[UINavigationController alloc] initWithRootViewController:logincontroller];
        [KAppDelegate.viewController presentModalViewController:loginnavgation animated:YES];
    }
}

//+(void)DealNeedlogin:(id)target action:(SEL)action
//{
//    
//}
#pragma mark -
#pragma mark 只显示登录界面 
+(void)showloginViewControlelr:(id)target action:(SEL)action
{
	if ([YKUserInfoUtility isUserLogin]) {
        
        if ([target respondsToSelector:action ]) {
            
            [target performSelector:action withObject:nil];
        }    
    }
	else
	{
        
		SCNLoginViewController*	logincontroller = [[SCNLoginViewController alloc] initWithNibName:@"SCNLoginViewController" bundle:nil target:target action:action withobject:nil];
		
		UINavigationController* loginnavgation = [[UINavigationController alloc] initWithRootViewController:logincontroller];
		[KAppDelegate.viewController presentModalViewController: loginnavgation animated:YES];
        
    }
}

+(void)showloginViewControlelr:(id)target action:(SEL)action withObject:(id)object {
    if ([YKUserInfoUtility isUserLogin]) {
        
        if ([target respondsToSelector:action ]) {
            
            [target performSelector:action withObject:object];
        }    
    }else{
        
    SCNLoginViewController*	logincontroller = [[SCNLoginViewController alloc] initWithNibName:@"SCNLoginViewController" bundle:nil target:target action:action withobject:object];
    
    UINavigationController* loginnavgation = [[UINavigationController alloc] initWithRootViewController:logincontroller];
    [KAppDelegate.viewController presentModalViewController: loginnavgation animated:YES];
    }
}
#pragma mark -我的名鞋库
#pragma mark 订单详情
+(void)go2OrderDetailViewController:(BaseViewController *)viewCtrl orderId:(NSString *)orderId{
    
    SCNOrderDetailViewController *OrderDetail = [[SCNOrderDetailViewController alloc]initWithNibName:@"SCNOrderDetailViewController" bundle:nil orderId:orderId];
    [[viewCtrl navigationController] pushViewController:OrderDetail animated:YES];

}
#pragma mark -我的名鞋库
#pragma mark 订单详情
+(void)go2LogisticsTrackingViewController:(BaseViewController *)viewCtrl Logistics:(NSString *)Logistics
{
    SCNLogisticsTrackingViewController * logisticsTracking = [[SCNLogisticsTrackingViewController alloc]initWithNibName:@"SCNLogisticsTrackingViewController" bundle:nil logistics:Logistics];
    [[viewCtrl navigationController] pushViewController:logisticsTracking animated:YES ];


}
//+(UINavigationController*)initWithRootViewController:(SCNLoginViewController*)logincontroller 
//{
//	@synchronized(self)
//	{
//		if (loginnavgation == nil)
//		{ 
//            loginnavgation = [[UINavigationController  alloc] initWithRootViewController:logincontroller];
//            
//        }
//        
//	}
//    return loginnavgation;	
//}
#pragma mark -
#pragma mark 帮助
+(void)go2HelpViewController:(BaseViewController*)viewCtrl{
    SCNHelpViewController *Help = [[SCNHelpViewController alloc]initWithNibName:@"SCNHelpViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:Help animated:YES];
}
#pragma mark -
#pragma mark 关于
+(void)go2AboutViewController:(BaseViewController*)viewCtrl{
    SCNAboutViewController *About = [[SCNAboutViewController alloc]initWithNibName:@"SCNAboutViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:About animated:YES];
}
#pragma mark - 我的名鞋库
#pragma mark   消息列表
+(void)go2MessageListViewController:(BaseViewController*)viewCtrl{
    
    SCNMessageListViewController * messagelist = [[SCNMessageListViewController alloc] initWithNibName:@"SCNMessageListViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:messagelist animated:YES];

}
#pragma mark - 我的名鞋库
#pragma mark 个人资料设置
+(void)go2MyInformationViewController:(BaseViewController*)viewCtrl{
    SCNMyInformationViewController* myinformation = [[SCNMyInformationViewController alloc]initWithNibName:@"SCNMyInformationViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:myinformation animated:YES];
}
#pragma mark - 我的名鞋库
#pragma mark 我的优惠券
+(void)go2MyVoucherViewController:(BaseViewController *)viewCtrl
{
    SCNMyVoucherViewController* myvoucher = [[SCNMyVoucherViewController alloc]initWithNibName:@"SCNMyVoucherViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:myvoucher animated:YES];

}
#pragma mark - 我的名鞋库
#pragma mark 我的咨询
+(void)go2UserConsultationViewController:(BaseViewController*)viewCtrl productCode:(NSString*)productCode
{
    SCNUserConsultationViewController* userconsultation = [[SCNUserConsultationViewController alloc]initWithNibName:@"SCNUserConsultationViewController" bundle:nil productCode:productCode];
    [[viewCtrl navigationController] pushViewController:userconsultation animated:YES];

}
#pragma mark - 我的名鞋库
#pragma mark 我的评论
+(void)go2UserCommentaryViewController:(BaseViewController *)viewCtrl
{
    SCNUserCommentaryViewController* usercommentary = [[SCNUserCommentaryViewController alloc] initWithNibName:@"SCNUserCommentaryViewController" bundle:nil];
    [[viewCtrl navigationController] pushViewController:usercommentary animated:YES];

}
#pragma mark 评论列表
+(void)go2CommentaryListViewController:(BaseViewController*)viewCtrl productCode:(NSString*)productCode
{

    SCNCommentaryListViewController* commentarylist = [[SCNCommentaryListViewController alloc] initWithNibName:@"SCNCommentaryListViewController" bundle:nil productCode:productCode];
    [[viewCtrl navigationController] pushViewController:commentarylist animated:YES];
    
}
#pragma mark -
#pragma mark 用户注册
//只显示注册界面
+(void)showRegisterViewControlelr:(BaseViewController*)viewCtrl Target:(id)target action:(SEL)action withObject:(id)object {
    SCNRegistViewController *Show_Requestcontroller = [[SCNRegistViewController alloc]initWithNibName:@"SCNRegistViewController" bundle:nil target:target action:action withobject:object];
    [[viewCtrl navigationController] pushViewController:Show_Requestcontroller animated:YES];
    
}
//跳转注册界面
+(void)go2RegisterController:(BaseViewController*)quondamViewCtr viewCtrl:(BaseViewController*)viewCtrl 
                                                              nextViewCtr:(BaseViewController*)nextViewCtr {
    SCNRegistViewController *RequestController = [[SCNRegistViewController alloc] 
                                                  initWithNibName:@"SCNRegistViewController" 
                                                  quondamViewCtr:quondamViewCtr 
                                                     nextViewCtr:nextViewCtr 
                                                          bundle:nil];
    
    [viewCtrl.navigationController pushViewController:RequestController animated:YES];
    
}
//获取验证码
+(void)go2ChangePasswordController:(BaseViewController*)viewCtrl
{
    SCNChangePasswordViewController *ChangePasswordController = [[SCNChangePasswordViewController alloc]initWithNibName:@"SCNChangePasswordViewController" bundle:nil];
    [viewCtrl.navigationController pushViewController:ChangePasswordController animated:YES];

}
//校验验证码
+(void)go2RePasswordController:(BaseViewController*)viewCtrl username: (NSString *)username
{
    SCNRePasswordViewController *RePasswordController = [[SCNRePasswordViewController alloc]initWithNibName:@"SCNRePasswordViewController" bundle:nil username:username];
    [viewCtrl.navigationController pushViewController:RePasswordController animated:YES];

}
//密码修改
+(void)go2RejiggerPasswordController:(BaseViewController*)viewCtrl
{
    SCNRejiggerPasswordViewController *RejiggerPasswordController= [[SCNRejiggerPasswordViewController alloc]initWithNibName:@"SCNRejiggerPasswordViewController" bundle:nil];
    [viewCtrl.navigationController pushViewController:RejiggerPasswordController animated:YES];
}
//密码重置
+(void)go2ResetPassWordController:(BaseViewController*)ViewCtrl 
{
    SCNResetPassWordViewController *setpasswordcontroller = [[SCNResetPassWordViewController alloc]
        initWithNibName:@"SCNResetPassWordViewController" bundle:nil];
    [ViewCtrl.navigationController pushViewController:setpasswordcontroller animated:YES];

}

+(void)go2CashCenterByShoppingType:(BaseViewController*)BaseviewCtrl 
				cashCenterViewCtrl:(BaseViewController*)cashCenterViewCtrl 
				   withProductData:(NSString*)productData 
					  withCashType:(int)cashType{
	
	SCNCashCenterViewController* _cashCenterViewCtrl = (SCNCashCenterViewController*)cashCenterViewCtrl;
	_cashCenterViewCtrl.m_productData = productData;
    
    _cashCenterViewCtrl.m_CashType = cashType;
	
	
	if ([YKUserInfoUtility isUserLogin]) {
        [[BaseviewCtrl navigationController] pushViewController:cashCenterViewCtrl animated:YES];
    }
    else{
        SCNLoginViewController*	logincontroller = [[SCNLoginViewController alloc] 
												   initWithNibName:@"SCNLoginViewController" 
												   quondamViewCtr:BaseviewCtrl 
												   nextViewCtr:cashCenterViewCtrl
												   bundle:nil];
		UINavigationController* loginnavgation = [[UINavigationController alloc] initWithRootViewController:logincontroller];
        [KAppDelegate.viewController presentModalViewController:loginnavgation animated:YES];
    }
}


//结算中心页面
+(void)go2CashCenterViewController:(BaseViewController*)BaseviewCtrl 
                cashCenterViewCtrl:(BaseViewController*)cashCenterViewCtrl
				withProducts:(NSArray*)products 
					  withCashType:(int)cashType{
	
	SCNCashCenterViewController* _cashCenterViewCtrl = (SCNCashCenterViewController*)cashCenterViewCtrl;
	_cashCenterViewCtrl.products = products;
    _cashCenterViewCtrl.m_CashType = cashType;
	
	if ([YKUserInfoUtility isUserLogin]) {
        [[BaseviewCtrl navigationController] pushViewController:cashCenterViewCtrl animated:YES];
    }
    else{
        SCNLoginViewController*	logincontroller = [[SCNLoginViewController alloc] 
													initWithNibName:@"SCNLoginViewController" 
													quondamViewCtr:BaseviewCtrl 
													nextViewCtr:cashCenterViewCtrl
													bundle:nil];
		UINavigationController* loginnavgation = [[UINavigationController alloc] initWithRootViewController:logincontroller];
        [KAppDelegate.viewController presentModalViewController:loginnavgation animated:YES];
    }
}

//+(void)go2CashCenterViewController:(BaseViewController*)viewCtrl withProducts:(NSArray*)products{
//	SCNCashCenterViewController* cashCenterViewController = [[SCNCashCenterViewController alloc]initWithNibName:@"SCNCashCenterViewController" bundle:nil];
//	cashCenterViewController.products = products;
//	[[viewCtrl navigationController] pushViewController:cashCenterViewController animated:YES];
//    [cashCenterViewController release];
//}

+(void)go2CashCenterSuccessViewController:(BaseViewController*)viewCtrl withOrderId:(NSString*)_orderId withPayMoney:(NSString*)_payMoney withPayType:(NSString*)_payType{
	SCNCashCenterSuccessViewController* successViewController = [[SCNCashCenterSuccessViewController alloc]initWithNibName:@"SCNCashCenterSuccessViewController" withOrderId:_orderId withPayMoney:_payMoney withPayType:_payType bundle:nil];
	
	[[viewCtrl navigationController] pushViewController:successViewController animated:YES];
}

+(void)go2AddressListViewController:(BaseViewController*)viewCtrl{
	SCNAddressListViewController* addressListViewController = [[SCNAddressListViewController alloc]initWithNibName:@"SCNAddressListViewController" bundle:nil];
	[[viewCtrl navigationController]pushViewController:addressListViewController animated:YES];
}

+(void)go2AddressModifyPage:(BaseViewController*)viewCtrl withAddress:(addressData*)addr withDelegate:(id<YK_SCN_AddressEditDelegate>)aDelegate{
	SCNAddressEditViewController* addressEditViewcontroller = [[SCNAddressEditViewController alloc] initWithNibName:@"SCNAddressEditViewController" withAddress:addr bundle:nil];
	addressEditViewcontroller.delegate = aDelegate;
	//NSString *title = strOrEmpty(viewCtrl.navigationItem.title);
//	addressEditViewcontroller.backButtonTitle = [title isEqualToString:@""]?@"  返回":[NSString stringWithFormat:@"  %@",title];
	[[viewCtrl navigationController] pushViewController:addressEditViewcontroller animated:YES];
}

//根据index跳转TabBar页
+(UIViewController *)go2ViewControllerByIndex:(NSUInteger)index{
	SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
	SCNViewController* viewCtrl = (SCNViewController*)delegate.viewController;
	[viewCtrl setSelectedIndex:index];
    UINavigationController *navC = [viewCtrl.viewControllers objectAtIndex:index];
    [navC popToRootViewControllerAnimated:YES];
    return navC.topViewController;
}

+(void)RefreshAllVisibleViewControllers
{
	SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
	SCNViewController* viewCtrl = (SCNViewController*)delegate.viewController;
	for (UINavigationController* navc in viewCtrl.viewControllers)
	{
		UIViewController* vc = [navc visibleViewController];
		if ([vc respondsToSelector:@selector(reFreshVc)])
		{
			[vc performSelector:@selector(reFreshVc)];
		}
	}
}

+(void)RefreshAllViewControllers
{
	SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
	SCNViewController* viewCtrl = (SCNViewController*)delegate.viewController;
	for (UINavigationController* navc in viewCtrl.viewControllers)
	{
		for (UIViewController* vc in navc.viewControllers)
		{
			if ([vc respondsToSelector:@selector(reFreshVc)])
			{
				[vc performSelector:@selector(reFreshVc)];
			}
		}
	}
}

@end