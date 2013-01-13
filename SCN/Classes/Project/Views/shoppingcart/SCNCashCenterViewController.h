//
//  SCNCashCenterViewController.h
//  SCN
//
//  Created by huangwei on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNCashCenterSubviews.h"
#import "SCNCommonPickerView.h"
#import "SCNCashCenterData.h"
#import "addressData.h"
#import "SCNShoppingcartData.h"
#import "KeyboardView.h"
#import "YK_OkOrderInfoStatistic.h"
#import "KeyboardView.h"

@class SCNCashCenterMessageTableCell;

typedef enum
{
	SCNCashCenter_NULL = 0,
	SCNCachCenter_DealCart,
	SCNCashCenter_SubmitOrder
}CashCenterRequest;

typedef enum{
    OrderInfoSection=0,//订单信息
    CarrigeInfoSection,//收货信息
    ShippingInfoSection,//付款及配送
    CouponInfoSection,//优惠券使用
    ProductInfoSection,//商品清单
    RemarkInfoSection,//留言
}CashCenterSection;

//结算中心确认订单按钮脚
@interface SCNCashCenterConfirmBtnFootView : UIView
{
	UIButton* m_btnConfirm;
}
@property(nonatomic,strong)IBOutlet UIButton* m_btnConfirm;

-(id)initWithFrame:(CGRect)frame;
@end

//收货信息头
@interface SCNCashCenterReceiveInfoHeadView : UIView
{
	UILabel* m_labReceiveTitle;
}
@property(nonatomic,strong)UILabel* m_labReceiveTitle;

@end

//付款及配送头
@interface SCNCashCenterPayShippingHeadView : UIView
{
	UILabel* m_labPayShippingTitle;
}
@property(nonatomic,strong)UILabel* m_labPayShippingTitle;

@end

//优惠券使用
@interface SCNCashCenterCouponHeadView : UIView
{
	UILabel* m_labCouponTitle;
}
@property(nonatomic,strong)UILabel* m_labCouponTitle;

@end


//商品清单
@interface SCNCashCenterInventoryHeadView : UIView
{
	UILabel* m_labInventoryTitle;
}
@property(nonatomic,strong)UILabel* m_labInventoryTitle;

@end


//留言
@interface SCNCashCenterMessageHeadView : UIView
{
	UILabel* m_labMessageTitle;
}
@property(nonatomic,strong)UILabel* m_labMessageTitle;

@end

@interface SubmitOrderData : NSObject
{
	NSString *orderdata;    //订单数据
    NSString *couponNum;    //优惠券
	NSString *payTypeId;       //支付方式
	NSString *addressId;    //地址id
	NSString *addressed;
	NSString *addressOnly;
	NSString *tempAddressId;    //地址id
	NSString *tempAddressed;
	NSString *tempAddressOnly;
	NSString *consignee;
	NSString *phone;
}
@property (nonatomic, strong) NSString *orderdata;
@property (nonatomic, strong) NSString *couponNum;
@property (nonatomic,copy)NSString *consignee;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic, strong) NSString *payTypeId;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *addressed;
@property (nonatomic,copy)NSString *addressOnly;//不包含收货人信息的地址
@property (nonatomic, strong) NSString *tempAddressId;
@property (nonatomic, strong) NSString *tempAddressed;
@property (nonatomic,copy)NSString *tempAddressOnly;//不包含收货人信息的地址

@end

@interface SCNCashCenterViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,CouponPopViewDelegate,CouponPopMessageDelegate,CouponPopInvoiceDelegate,UITextViewDelegate,KeyboardNeedHideDelegate,UIAlertViewDelegate,KeyboardNeedHideDelegate> {
	UITableView* m_tableView;
	SCNCashCenterConfirmBtnFootView* m_confirmBtnFootView;
	SCNCashCenterReceiveInfoHeadView* m_receiveInfoHeadView;
	SCNCashCenterPayShippingHeadView* m_payShippingHeadView;
	SCNCashCenterInventoryHeadView* m_inventoryHeadView;
	SCNCashCenterCouponHeadView* m_couponHeadView;
	SCNCashCenterMessageHeadView* m_messageHeadView;
	SCNCashCenterCouponInputView* m_couponInputView;
	SCNCashCenterMessagePopView* m_messagePopView;
	
	SCNCashCenterInvoicePopView* m_invoicePopView;
	
	NSString* m_couponId;
	
	NSMutableDictionary* m_couponDic;
	
	SCNCashCenterData* m_cashCenterData;
	
	UIControl* controlArea;
	
	UITextField* __unsafe_unretained m_curTxt;
	
	SubmitOrderData *submitOrderData;
	
	addressData* m_address;
	
	NSArray *products;
	NSString* m_productData;
	
	//提交订单成功后得到的数据
	NSString* m_orderId;
	NSString* m_payMoney;
	NSString* m_payType;

	NSMutableDictionary             *addDic;                    // 收获信息
	
    CashTypeEnum            m_CashType;
	
	SCNCashCenterMessageTableCell* m_messageCell;
	NSString* m_reloadType;
	
	YK_OkOrderInfoStatistic* m_okOrderInfo;
	
	int m_RequestState;
	
	NSString* m_orderTimeStr;
}

@property(nonatomic,strong)IBOutlet UITableView* m_tableView;
@property(nonatomic,strong)IBOutlet SCNCashCenterConfirmBtnFootView* m_confirmBtnFootView;
@property(nonatomic,strong)IBOutlet SCNCashCenterReceiveInfoHeadView* m_receiveInfoHeadView;
@property(nonatomic,strong)IBOutlet SCNCashCenterPayShippingHeadView* m_payShippingHeadView;
@property(nonatomic,strong)IBOutlet SCNCashCenterInventoryHeadView* m_inventoryHeadView;
@property(nonatomic,strong)IBOutlet SCNCashCenterCouponHeadView* m_couponHeadView;
@property(nonatomic,strong)IBOutlet SCNCashCenterMessageHeadView* m_messageHeadView;
@property(nonatomic,strong)IBOutlet SCNCashCenterCouponInputView* m_couponInputView;
@property(nonatomic,strong)SCNCashCenterMessagePopView* m_messagePopView;
@property(nonatomic,strong)SCNCashCenterInvoicePopView* m_invoicePopView;
@property(nonatomic,strong)NSString* m_couponId;
@property(nonatomic,strong)NSMutableDictionary* m_couponDic;
@property(nonatomic,strong)SCNCashCenterData* m_cashCenterData;
@property(nonatomic,strong)UIControl* controlArea;
@property(nonatomic,unsafe_unretained)UITextField* m_curTxt;
@property(nonatomic,strong)SubmitOrderData *submitOrderData;
@property(nonatomic,strong)addressData* m_address;
@property(nonatomic,strong)NSArray *products;

@property(nonatomic,strong)NSString* m_orderId;
@property(nonatomic,strong)NSString* m_payMoney;
@property(nonatomic,strong)NSString* m_payType;

@property(nonatomic,strong)NSString* m_productData;

@property(nonatomic,strong)SCNCashCenterMessageTableCell* m_messageCell;
@property(nonatomic,strong)NSString* m_reloadType;
@property(nonatomic,strong)YK_OkOrderInfoStatistic* m_okOrderInfo;
@property(nonatomic,assign)int m_RequestState;
@property(nonatomic,strong)NSString* m_orderTimeStr;
@property(nonatomic,assign)CashTypeEnum m_CashType;

-(void)parseCashCenterXmlDataResponse:(GDataXMLDocument*)xmlDoc;
-(void)controllerReload:(NSString*)reloadType;
-(void)subShoppingCartChangeData:(NSString*)reloadType;

-(NSString*)getShoppingType;
-(NSString*)getProductsData;
-(void)requestShoppingCarInfo;

-(void)requestSubmitOrder;
-(void)onRequestSubmitOrder:(GDataXMLDocument*)xmlDoc;
-(void)parseSubmitOrderXml:(GDataXMLDocument*)xmlDoc;
-(NSString*)parseSubmitOrderFailureXml:(GDataXMLDocument*)xmlDoc;

-(void)changeTableViewFrame;
-(void)resizeViewFrame;

-(NSString*)getOrderProductListDataFrom:(NSArray*)array;
-(NSString*)getsubOrderProductData:(shoppingcartProductData*)p;

-(void)reloadSaveProductList:(NSArray*)list;

//-(void)genOkOrderDic;
-(BOOL)isCouponUp;
-(void)dealWithOrder;
-(void)dealWithFailOrder:(NSString*)errinfo;

-(void)goToAddAddress;

-(void)dealwithColorSizeText:(cashcenterProductData*)_productData label:(UILabel*)label;

#pragma mark 未登录情况下回调函数
-(void)reRequestShoppingcartInfo;
-(void)reRequestSubmitOrder;
-(void)selectAddressBehavior;
-(void)orderSubmitBehavior;

/*********订单统计*****/

-(void)saveSuccessOrder;
-(void)saveUnSuccessOrder:(NSString*)message;
-(void)dealShoppingcartData;

#pragma mark 行为统计
-(void)orderSuccessBehavior;
-(void)orderFailureBehavior:(NSString*)_errorInfo;

-(void)dealSourcePageIdBehavior;

-(NSString*)strFormatToxml:(NSString*)ori;
@end



