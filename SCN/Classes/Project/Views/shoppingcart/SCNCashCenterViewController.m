//
//  SCNCashCenterViewController.m
//  SCN
//
//  Created by huangwei on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCashCenterViewController.h"
#import "SCNShoppingcartTableCell.h"
#import "SCNAddressListViewController.h"
#import "SCNCashCenterTableCell.h"
#import "Go2PageUtility.h"
#import "SCNStatusUtility.h"
#import "YK_StatisticEngine.h"
#import "SCNShoppingcartData.h"
#import "YKTimeUtility.h"
#import "YKStatBehaviorInterface.h"
#import "ModalAlert.h"


@implementation SCNCashCenterConfirmBtnFootView
@synthesize m_btnConfirm;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.m_btnConfirm = [YKButtonUtility initSimpleButton:CGRectMake(30, 13, 258, 35)
												   title:@"确定下单"
											 normalImage:@"com_button_normal.png"
											 highlighted:@"com_button_select.png"];
		m_btnConfirm.titleLabel.font = [UIFont boldSystemFontOfSize:16];
		[self addSubview:m_btnConfirm];
	}
	return self;
}

-(BOOL)isNeedLogin
{
	return YES;
}

@end

#pragma mark-
#pragma mark SCNCashCenterReceiveInfoHeadView

@implementation SCNCashCenterReceiveInfoHeadView
@synthesize m_labReceiveTitle;


@end

#pragma mark-
#pragma mark SCNCashCenterPayShippingHeadView

@implementation SCNCashCenterPayShippingHeadView
@synthesize m_labPayShippingTitle;


@end

#pragma mark-
#pragma mark SCNCashCenterCouponHeadView
@implementation SCNCashCenterCouponHeadView
@synthesize m_labCouponTitle;


@end


#pragma mark-
#pragma mark SCNCashCenterInventoryHeadView

@implementation SCNCashCenterInventoryHeadView
@synthesize m_labInventoryTitle;


@end

#pragma mark-
#pragma mark SCNCashCenterMessageHeadView

@implementation SCNCashCenterMessageHeadView
@synthesize m_labMessageTitle;


@end

@implementation SubmitOrderData
@synthesize couponNum;
@synthesize payTypeId;
@synthesize addressId;
@synthesize orderdata;
@synthesize addressOnly;
@synthesize consignee;
@synthesize phone;
@synthesize addressed;
@synthesize tempAddressId;
@synthesize tempAddressed;
@synthesize tempAddressOnly;

-(id) init
{
	if ((self=[super init])) {
        self.couponNum=@"";
		self.payTypeId=@"";
		self.addressId=@"";
		self.orderdata=@"";
		self.addressed=@"";
		self.tempAddressed=@"";
		self.tempAddressId=@"";
	}
	return self;
}

-(void) dealloc
{	
	couponNum = nil;
	addressId = nil;
	orderdata = nil;
	payTypeId = nil;
	addressed = nil;
	tempAddressed = nil;
	tempAddressId = nil;
	//[addressOnly release], addressOnly = nil;
}
@end

#pragma mark-
#pragma mark SCNCashCenterViewController

@implementation SCNCashCenterViewController
@synthesize m_tableView;
@synthesize m_confirmBtnFootView;
@synthesize m_payShippingHeadView;
@synthesize m_receiveInfoHeadView;
@synthesize m_inventoryHeadView;
@synthesize m_couponHeadView;
@synthesize m_messageHeadView;
@synthesize m_couponInputView;
@synthesize m_messagePopView;
@synthesize m_invoicePopView;
@synthesize m_couponId;
@synthesize m_couponDic;
@synthesize m_cashCenterData;
@synthesize controlArea;
@synthesize m_curTxt;
@synthesize submitOrderData;
@synthesize m_address;
@synthesize products;
@synthesize m_orderId;
@synthesize m_payMoney;
@synthesize m_payType;
@synthesize m_productData;
@synthesize m_CashType;
@synthesize m_messageCell;
@synthesize m_reloadType;
@synthesize m_okOrderInfo;
@synthesize m_RequestState;
@synthesize m_orderTimeStr;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        submitOrderData=[[SubmitOrderData alloc] init];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    addDic = [[NSMutableDictionary alloc] init];
	self.pathPath = @"/cashcenter";
	self.navigationItem.title = @"订单结算";
	
	((KeyboardView*)self.view).m_keyboardDelegate = self;

	
	self.m_confirmBtnFootView = [[SCNCashCenterConfirmBtnFootView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
	[self.m_confirmBtnFootView.m_btnConfirm addTarget:self action:@selector(popCashCenterView) forControlEvents:UIControlEventTouchUpInside];
	
	[self resizeViewFrame];
	
	[m_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWasHidden:) 
												 name:UIKeyboardDidHideNotification object:nil];
	
	BOOL isNeedForceRefresh = NO;
    
    if (self.m_CashType == ECashTypeCommon)
    {
        //非正常流程需要重刷
        if ([m_reloadType isEqualToString:YK_DEFAULT_UPDATE])
        {
            //说明是结算中心跳转到商品详情页，再加入的购物车，故没有经过pageutility跳转
			self.m_productData = [SCNStatusUtility getShoppingcartData];
			isNeedForceRefresh = YES;
        }
    }
    
	[self.m_tableView setSeparatorColor:YK_CELLBORDER_COLOR];
	
	if (!self.isGoBack || isNeedForceRefresh)
	{
		[self requestShoppingCarInfo];
	}
}

-(NSString*)getShoppingType
{
    switch (self.m_CashType)
    {
        case ECashTypeSeckill:
            return YK_SHOPPINGTYPE_SECKILL_BUY;
            break;
        default:
            break;
    }
    return YK_SHOPPINGTYPE_COMMON_BUY;
}

-(void)viewWillDisappear:(BOOL)animated{
	//self.m_shoppingType = @"-1";//把购买类型清除
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)resizeViewFrame{
	CGRect viewFrame = [m_tableView frame];
	viewFrame.size.height = [SCNStatusUtility getShowViewHeight];
	m_tableView.frame = viewFrame;
}

-(NSString*)getProductsData{
	int nTag = 0;
	NSMutableString* skuRootString = [[NSMutableString alloc] init];
	for (shoppingcartProductData* _data in self.products) {
		NSString* skuString;
		
		if (nTag == 0) {
			skuString	=	[NSString stringWithFormat:@"%@-%@-%@", _data.mproductCode,_data.msku,_data.mnumber];
		}else {
			skuString	=	[NSString stringWithFormat:@"|%@-%@-%@",_data.mproductCode, _data.msku,_data.mnumber];
		}
		
		nTag = 1;
		
		[skuRootString appendString:skuString];
	}
	return skuRootString;
	
}

-(void)subShoppingCartChangeData:(NSString*)reloadType{
	[self startLoading];
	
	self.m_reloadType = reloadType;
	
	//NSString* method = [YKStringUtility strOrEmpty:@"orderBalance"];
	NSString* _data = self.m_productData;//[self getProductsData];
	NSString* _couponNum = [YKStringUtility strOrEmpty:submitOrderData.couponNum];
	NSString* _payTypeId = [YKStringUtility strOrEmpty:submitOrderData.payTypeId];
	NSString* _addressId = nil;
	if (reloadType == YK_ADDRESS_UPDATE) {
		_addressId = [YKStringUtility strOrEmpty:submitOrderData.tempAddressId];
	}else {
		_addressId = [YKStringUtility strOrEmpty:submitOrderData.addressId];
	}

	NSString* _shoppingType = [self getShoppingType];
	NSLog(@"%@",_shoppingType);
	
	NSDictionary* extraParam = @{@"act": YK_METHOD_ORDERBALANCE,
								@"data": _data,
								@"couponNum": _couponNum,
								@"payTypeId": _payTypeId,
								@"addressId": _addressId,
								@"shoppingType": _shoppingType};
    self.m_RequestState = SCNCachCenter_DealCart;
	[YKHttpAPIHelper startLoad:SCN_URL 
				   extraParams:extraParam
						object:self 
					  onAction:@selector(onRequestShoppingcarXmlDataResponse:)];
}

-(void)requestShoppingCarInfo{

	[self startLoading];
	
	self.m_reloadType = YK_DEFAULT_UPDATE;
	//NSString* method = [YKStringUtility strOrEmpty:@"orderBalance"];
	
	NSString* _data = self.m_productData;

	NSLog(@"%@",_data);
	
	NSString* _shoppingType = [self getShoppingType];//[self getShoppingType];
	NSLog(@"%@",_shoppingType);
	
	NSString* _couponNum = [YKStringUtility strOrEmpty:submitOrderData.couponNum];
	NSString* _payTypeId = [YKStringUtility strOrEmpty:submitOrderData.payTypeId];
	NSString* _addressId = [YKStringUtility strOrEmpty:submitOrderData.addressId];
	NSLog(@"%@",_couponNum);
	NSLog(@"%@",_payTypeId);
	NSLog(@"%@",_addressId);
	NSDictionary* extraParam = @{@"act": YK_METHOD_ORDERBALANCE,
								@"data": _data,
								@"couponNum": _couponNum,
								@"payTypeId": _payTypeId,
								@"addressId": _addressId,
								@"shoppingType": _shoppingType};
	NSLog(@"%@",extraParam);
    
	self.m_RequestState = SCNCachCenter_DealCart;
	[YKHttpAPIHelper startLoad:SCN_URL 
				   extraParams:extraParam
						object:self 
					  onAction:@selector(onRequestShoppingcarXmlDataResponse:)];
}

-(void)onRequestShoppingcarXmlDataResponse:(GDataXMLDocument*)xmlDoc{
	[self stopLoading];
	
	SCNRequestResultData* _requestData = [[SCNRequestResultData alloc]init];

	if ([SCNStatusUtility isRequestSuccess:xmlDoc requestData:_requestData]) 
	{
		self.m_cashCenterData = nil;
		[self parseCashCenterXmlDataResponse:xmlDoc];
		if ([m_reloadType isEqualToString:YK_ADDRESS_UPDATE]) {
			submitOrderData.addressId = submitOrderData.tempAddressId;
			submitOrderData.addressed = submitOrderData.tempAddressed;
			submitOrderData.addressOnly = submitOrderData.tempAddressOnly;
		}
		if ([m_reloadType isEqualToString:YK_COUPON_USE]) {
			//使用优惠券成功
			UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
															  message:@"优惠券使用成功！" 
															 delegate:nil 
													cancelButtonTitle:@"确定" 
													otherButtonTitles:nil];
			[alertView show];
		}else if([m_reloadType isEqualToString:YK_COUPON_CANCEL]){
			//取消使用优惠券成功
			UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
															  message:@"已成功取消使用优惠券！" 
															 delegate:nil 
													cancelButtonTitle:@"确定" 
													otherButtonTitles:nil];
			[alertView show];
		}
	}
	else 
	{
		
		if (_requestData.merror_Code == EBE_WeblogidFailOrChange || _requestData.merror_Code == EBE_HasntLogin) 
		{
			//weblogid失效或未登录
			if (_requestData.mSelectConfirm != ERequestSelectCancel)
			{
				//重新请求结算中心数据
				[Go2PageUtility showloginViewControlelr:self action:@selector(reRequestShoppingcartInfo) withObject:nil];
			}
			else
			{
				[self goBack];
			}
		}
		else 
		{
			if ([m_reloadType isEqualToString:YK_COUPON_USE]) 
			{
				submitOrderData.couponNum = nil;
				//m_cashCenterData.mCoupon = nil;
			}else if ([m_reloadType isEqualToString:YK_ADDRESS_UPDATE]) {
				NSLog(@"更新地址错误,请您选个靠谱点的地儿行不？！");
				
			}
		}
	}

    if ([m_cashCenterData.mprompt length]>0 && m_CashType == ECashTypeCommon) {
        [self reloadSaveProductList:m_cashCenterData.mProductListData];
	}
    
    if ([m_cashCenterData.mprompt length]>0) {
        //提示
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
														  message:m_cashCenterData.mprompt 
														 delegate:nil 
												cancelButtonTitle:@"确定" 
												otherButtonTitles:nil];
		[alertView show];
    }
	
	submitOrderData.tempAddressed = nil;
	submitOrderData.tempAddressId = nil;
	submitOrderData.tempAddressOnly = nil;
	self.m_reloadType = nil;

	[m_tableView reloadData];
}

#pragma mark reloadProductList
-(void)reloadSaveProductList:(NSArray*)list
{
	NSMutableArray *l_array_shoppingCartData = [NSMutableArray array];
	for (shoppingcartProductData* _data in list) {
		ShoppingCartData* cartData = [[ShoppingCartData alloc]init];
		cartData.msku = _data.msku;
		cartData.mproductCode = _data.mproductCode;
		cartData.mnumber = [_data.mnumber intValue];
		
		[l_array_shoppingCartData addObject:cartData];
	}
	[SCNStatusUtility clearShoppingcart];
	for (ShoppingCartData* _product in l_array_shoppingCartData) {
		[SCNStatusUtility saveShoppingcart:_product];
	}
	
}

- (void)NotifyNoLogin:(NSNotification *)notify
{
	
}

#pragma mark UIAlertView delegate

-(void)reRequestShoppingcartInfo{
	[self requestShoppingCarInfo];
}

-(void)reRequestSubmitOrder{
	[self requestSubmitOrder];
	
}

-(void)requestSubmitOrder{
	//提交订单前先把订单数据保存起来
	//[self genOkOrderDic];
	//提交订单动作行为统计
	[self orderSubmitBehavior];
	
	[self startLoading];
	
	NSString* _addressId = [YKStringUtility strOrEmpty:submitOrderData.addressId];
	NSString* _couponNum = [YKStringUtility strOrEmpty:submitOrderData.couponNum];
	NSString* _payTypeId = [YKStringUtility strOrEmpty:submitOrderData.payTypeId];
	NSString* _shoppingType = [self getShoppingType];//[self getShoppingType];
	NSLog(@"%@",_shoppingType);
	NSString* _msg = self.m_messageCell.m_txtViewMessage.text;
	
	NSString* _data = self.m_productData;//[self getProductsData];
	
	NSDictionary* extraParam = @{@"act": YK_METHOD_CREATEORDER,
								@"data": _data,
								@"couponNum": _couponNum,
								@"payTypeId": _payTypeId,
								@"addressId": _addressId,
								@"shoppingType": _shoppingType,
								@"msg": _msg};
	NSLog(@"%@",extraParam);
    self.m_RequestState = SCNCashCenter_SubmitOrder;
	
	[YKHttpAPIHelper startLoad:SCN_URL 
				   extraParams:extraParam
						object:self 
					  onAction:@selector(onRequestSubmitOrder:)];
}

-(void)dealShoppingcartData
{
	if (self.m_CashType == ECashTypeCommon) 
    {
        //如果不是立即购买的商品，才要去删除购物车中的数据!
		[SCNStatusUtility clearShoppingcart];
		[SCNStatusUtility clearOffShoppingcart];
	}
	
	[Go2PageUtility go2CashCenterSuccessViewController:self withOrderId:m_orderId withPayMoney:m_payMoney withPayType:m_payType];
}

-(void)dealSourcePageIdBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	//把已经提交的订单中的商品在行为统计的sourcePageId管理中删除
	for (cashcenterProductData* _data in m_cashCenterData.mProductListData){
		[YKStatBehaviorInterface clearSourcePageIdWithSku:_data.mproductCode];
	}
	
    if (self.m_CashType == ECashTypeCommon){
        [YKStatBehaviorInterface clearAllSourcePageId];
    }
#endif
}

-(void)onRequestSubmitOrder:(GDataXMLDocument*)xmlDoc{
	//if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
//		[self parseSubmitOrderXml:xmlDoc];
//		//订单提交成功行为统计
//		[self orderSuccessBehavior];
//	}else {
//		NSString* _errorInfo = [self parseSubmitOrderFailureXml:xmlDoc];
//		//订单提交失败行为统计
//		[self orderFailureBehavior:_errorInfo];
//	}
	
	[self stopLoading];
	SCNRequestResultData* _requestData = [[SCNRequestResultData alloc]init];
	
	if ([SCNStatusUtility isRequestSuccess:xmlDoc requestData:_requestData]) 
	{
		[self parseSubmitOrderXml:xmlDoc];
		[self dealWithOrder];//订单提交成功行为统计
		[self dealSourcePageIdBehavior];//订单提交成功后需把存储的sourcepageid清除
		[self dealShoppingcartData];//处理购物车里的商品以及页面跳转
	}
	else 
	{
		if (_requestData.merror_Code == EBE_WeblogidFailOrChange || _requestData.merror_Code == EBE_HasntLogin) 
		{
			//weblogid失效或未登录
			if (_requestData.mSelectConfirm != ERequestSelectCancel)
			{
				//重新提交订单
				[Go2PageUtility showloginViewControlelr:self action:@selector(reRequestSubmitOrder) withObject:nil];
			}
			else
			{
				[self dealWithFailOrder:_requestData.merror_info];
                [self saveUnSuccessOrder:_requestData.merror_info];
			}
		}
		else
		{
			[self dealWithFailOrder:_requestData.merror_info];
             [self saveUnSuccessOrder:_requestData.merror_info];
		}
	}
}

-(void)dealWithOrder
{
	//订单提交成功行为统计
	[self orderSuccessBehavior];
}

-(void)dealWithFailOrder:(NSString*)errinfo
{
	//订单提交失败行为统计
	[self orderFailureBehavior:errinfo];
}

//-(void)genOkOrderDic{
//	[addDic setObject:self.m_cashCenterData.mAddressData.mprovince forKey:@"province"];
//	[addDic setObject:self.m_cashCenterData.mAddressData.mcity forKey:@"city"];
//	[addDic setObject:self.m_cashCenterData.mAddressData.marea forKey:@"county"];
//	
//	[addDic setObject:self.submitOrderData.phone  forKey:@"cellphone"];
//	[addDic setObject:self.m_cashCenterData.mAddressData.maddressInfo forKey:@"address"];
//	NSString* _username = [YKStringUtility strOrEmpty:[SCNDataInterface commonParam:YK_KEY_USER_NAME]];
//	[addDic setObject:_username forKey:@"username"];
//	[addDic setObject:self.submitOrderData.consignee forKey:@"fullname"];
//	[addDic setObject:@"" forKey:@"ordertime"];
//}

-(BOOL)isCouponUp
{
	if ([self.view viewWithTag:520])
	{
		return YES;
	}
	return NO;
}

#pragma mark - 订单统计
-(void)saveSuccessOrder{
#ifdef USE_STATISTIC_ENGINE
	/*
	 <list>
	 <item code=”YM10001” name=”白色短裤” price=”100” quantity=”2” color=”白色” size=”XL”/>
	 <item code=”PU132325” name=”法国红酒” price=”40” quantity=”1” color=”” size=”” />
	 </list>
	 颜色尺码等如果有就填充，没有就保持为空
     */
	
	NSMutableString* xmlRootStr = [[NSMutableString alloc] init];
    [xmlRootStr appendString:@"<list>"];
	
    switch (self.m_CashType) {
        case ECashTypeCommon:
        {
            for (ShoppingCartData* _data in [ShoppingCartData allObjects]) 
            {
                for (cashcenterProductData* _item in m_cashCenterData.mProductListData) 
                {
                    if ([_item.msku isEqualToString:_data.msku]) {
                        _data.msellPrice = _item.msellPrice;
                        _data.mname = [self strFormatToxml:_item.mname];//_item.mname;
                        _data.mcolor = [self strFormatToxml:_item.mcolor];//_item.mcolor;
                        _data.msize = _item.msize;
                        break;
                    }
                }
                NSString* itemStr = [NSString stringWithFormat:@"<item code=\"%@\" name=\"%@\" price=\"%@\" quantity=\"%i\" color=\"%@\" size=\"%@\"/>",_data.msku,_data.mname,_data.msellPrice,_data.mnumber,_data.mcolor,_data.msize];
                [xmlRootStr appendString:itemStr];
            }
        }
            break;
        case ECashTypeSeckill:
        case ECashTypeImmediately:
        {
            NSString* itemStr = nil;
            for (cashcenterProductData* _item in m_cashCenterData.mProductListData){
                itemStr = [NSString stringWithFormat:@"<item code=\"%@\" name=\"%@\" price=\"%@\" quantity=\"%@\" color=\"%@\" size=\"%@\"/>",_item.msku,[self strFormatToxml:_item.mname],_item.msellPrice,_item.mnumber,[self strFormatToxml:_item.mcolor],_item.msize];
            }
            [xmlRootStr appendString:itemStr]; 
        }
            break;
        default:
            break;
    }
    
    [xmlRootStr appendString:@"</list>"];
    NSLog(@"%@",xmlRootStr);
	
	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
    NSDictionary* l_dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                            strOrEmpty(self.m_orderId), @"orderid",
                            strOrEmpty(userdata.musername), @"username",
                            strOrEmpty(userdata.mweblogid), @"userid",
                            @"订单提交成功", @"ordermessage",
                            strOrEmpty(submitOrderData.consignee), @"fullname",
                            strOrEmpty(submitOrderData.phone), @"cellphone",
                            strOrEmpty(m_cashCenterData.mAddressData.mprovince), @"province",
                            strOrEmpty(m_cashCenterData.mAddressData.mcity), @"city",
                            strOrEmpty(m_cashCenterData.mAddressData.marea), @"county",
                            strOrEmpty(m_cashCenterData.mAddressData.maddressInfo), @"address",
                            strOrEmpty(self.m_payMoney), @"amount",
                            strOrEmpty(self.m_orderTimeStr), @"ordertime",
                            strOrEmpty(xmlRootStr), @"itemdata",nil];
    [YK_StatisticEngine postOrderInfoStatisticWithOrderInfoDict:l_dict];
#endif
}

-(void)saveUnSuccessOrder:(NSString*)message
{
#ifdef USE_STATISTIC_ENGINE
	/*
	 <list>
	 <item code=”YM10001” name=”白色短裤” price=”100” quantity=”2” color=”白色” size=”XL”/>
	 <item code=”PU132325” name=”法国红酒” price=”40” quantity=”1” color=”” size=”” />
	 </list>
	 颜色尺码等如果有就填充，没有就保持为空
     */
	
	NSMutableString* xmlRootStr = [[NSMutableString alloc] init];
    [xmlRootStr appendString:@"<list>"];
	
	switch (self.m_CashType) {
        case ECashTypeCommon:
        {
            for (ShoppingCartData* _data in [ShoppingCartData allObjects]) 
            {
                for (cashcenterProductData* _item in m_cashCenterData.mProductListData) 
                {
                    if ([_item.msku isEqualToString:_data.msku]) {
                        _data.msellPrice = _item.msellPrice;
                        _data.mname = [self strFormatToxml:_item.mname];//_item.mname;
                        _data.mcolor = [self strFormatToxml:_item.mcolor];//_item.mcolor;
                        _data.msize = _item.msize;
                        break;
                    }
                }
                NSString* itemStr = [NSString stringWithFormat:@"<item code=\"%@\" name=\"%@\" price=\"%@\" quantity=\"%i\" color=\"%@\" size=\"%@\"/>",_data.msku,_data.mname,_data.msellPrice,_data.mnumber,_data.mcolor,_data.msize];
                [xmlRootStr appendString:itemStr];
            }
        }
            break;
        case ECashTypeSeckill:
        case ECashTypeImmediately:
        {
            NSString* itemStr = nil;
            for (cashcenterProductData* _item in m_cashCenterData.mProductListData){
                itemStr = [NSString stringWithFormat:@"<item code=\"%@\" name=\"%@\" price=\"%@\" quantity=\"%@\" color=\"%@\" size=\"%@\"/>",_item.msku,[self strFormatToxml:_item.mname],_item.msellPrice,_item.mnumber,[self strFormatToxml:_item.mcolor],_item.msize];
            }
            [xmlRootStr appendString:itemStr]; 
        }
            break;
        default:
            break;
    }
    
    [xmlRootStr appendString:@"</list>"];
    NSLog(@"%@",xmlRootStr);
	
	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
    NSDictionary* l_dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"", @"orderid",
                            strOrEmpty(userdata.musername), @"username",
                            strOrEmpty(userdata.mweblogid), @"userid",
                            strOrEmpty(message), @"ordermessage",
                            strOrEmpty(submitOrderData.consignee), @"fullname",
                            strOrEmpty(submitOrderData.phone), @"cellphone",
                            strOrEmpty(m_cashCenterData.mAddressData.mprovince), @"province",
                            strOrEmpty(m_cashCenterData.mAddressData.mcity), @"city",
                            strOrEmpty(m_cashCenterData.mAddressData.marea), @"county",
                            strOrEmpty(m_cashCenterData.mAddressData.maddressInfo), @"address",
                            strOrEmpty(self.m_payMoney), @"amount",
                            strOrEmpty(self.m_orderTimeStr), @"ordertime",
                            strOrEmpty(xmlRootStr), @"itemdata",nil];
    [YK_StatisticEngine postOrderInfoStatisticWithOrderInfoDict:l_dict];
#endif
}

-(NSString*)strFormatToxml:(NSString*)ori
{
    if (!ori || [ori length] == 0) {
        return ori;
    }
    NSMutableString* decstr = [[NSMutableString alloc] initWithCapacity:10];
    int nLen = [ori length];
    NSRange strindex;
    strindex.length = 1;
    
    for (int i = 0; i < nLen; i++) {
        strindex.location = i;
        NSString* st = [ori substringWithRange:strindex];
        if ([st isEqualToString:@"<"])
        {
            [decstr appendString:@"&lt;"];
        }
        else if ([st isEqualToString:@">"])
        {
            [decstr appendString:@"&gt;"];
        }
        else if ([st isEqualToString:@"'"])
        {
            [decstr appendString:@"&apos;"];
        }
        else if ([st isEqualToString:@"\""])
        {
            [decstr appendString:@"&quot;"];
        }
        else if ([st isEqualToString:@"&"])
        {
            [decstr appendString:@"&amp;"];
        }
        else
        {
            [decstr appendString:st];
        }
    }
    return decstr;
}

-(NSString*)parseSubmitOrderFailureXml:(GDataXMLDocument*)xmlDoc{
	
	/*
	 <?xml version=”1.0” encoding=”utf-8”?>
	 <shopex>
	 <result>fail</result>
	 <msg/>
	 <info>
	 <error_code>0002</error_code>
	 <error_info>未登录</error_info>
	 </info>
	 </shopex>	 
	 */
	
	NSString* _errorInfoPath = [NSString stringWithFormat:@"//shopex/info/error_info"];
	GDataXMLElement* _errorInfoNode = [xmlDoc oneNodeForXPath:_errorInfoPath error:nil];
	NSString* _errorInfo = [_errorInfoNode stringValue];
	return _errorInfo;
}
		 
-(void)parseSubmitOrderXml:(GDataXMLDocument*)xmlDoc{
	
	NSString* timePath = @"//shopex/info/stime";
	GDataXMLNode* timeNode = [xmlDoc oneNodeForXPath:timePath error:nil];
	self.m_orderTimeStr = [timeNode stringValue];
	
	GDataXMLElement* datainfoNode = [SCNStatusUtility paserDataInfoNode:xmlDoc];
	
	GDataXMLNode* orderIdNode = [datainfoNode oneNodeForXPath:@"orderId" error:nil];
	m_orderId	= [orderIdNode stringValue];
	
	GDataXMLNode* payMoneyNode = [datainfoNode oneNodeForXPath:@"payMoney" error:nil];
	GDataXMLNode* payTypeNode = [datainfoNode oneNodeForXPath:@"payType" error:nil];
	
	m_payMoney = [payMoneyNode stringValue];
	m_payType = [payTypeNode stringValue];
	
	//写入订单信息数据库,并提交后台订单统计
	[self saveSuccessOrder];
	
}

-(void)parseCashCenterXmlDataResponse:(GDataXMLDocument*)xmlDoc{
	m_cashCenterData = [[SCNCashCenterData alloc]init];
	
	//NSString *path = [[NSBundle mainBundle]pathForResource:@"cashCenterTest" ofType:@"xml"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"------%@",aStr);
//    xmlDoc =[[GDataXMLDocument alloc] initWithXMLString:aStr options:0 error:nil];
//    [aStr release];
	
	GDataXMLElement* datainfoNode = [SCNStatusUtility paserDataInfoNode:xmlDoc];
    
    NSString* promptPath = [NSString stringWithFormat:@"prompt"];
	GDataXMLNode* promptNode = [datainfoNode oneNodeForXPath:promptPath error:nil];
	m_cashCenterData.mprompt = [promptNode stringValue];

	cashcenterOrderInfoData* _orderInfo = [[cashcenterOrderInfoData alloc]init];
	
	NSString* orderInfoPath = [NSString stringWithFormat:@"orderInfo"];
	NSString* pricePath = [NSString stringWithFormat:@"totalMoney"];
	NSString* savePricePath = [NSString stringWithFormat:@"savePrice"];
	NSString* freightPath = [NSString stringWithFormat:@"freight"];
	NSString* sellPricePath = [NSString stringWithFormat:@"payMoney"];
	NSString* savePhonePricePath = [NSString stringWithFormat:@"savePhonePrice"];
	NSString* numberPath = [NSString stringWithFormat:@"number"];
	
	//orderInfoId
	NSString* orderInfoIdPath = [NSString stringWithFormat:@"shopex/info/data_info/orderInfo"];
	GDataXMLElement* orderInfoEle = [xmlDoc oneNodeForXPath:orderInfoIdPath error:nil];
	_orderInfo.morderId = [[orderInfoEle attributeForName:@"orderId"] stringValue];	
	
	GDataXMLNode* orderInfoNode = [datainfoNode oneNodeForXPath:orderInfoPath error:nil];
	
	GDataXMLNode* totalMoneyNode = [orderInfoNode oneNodeForXPath:pricePath error:nil];
	NSString* strTotalMoney = [totalMoneyNode stringValue];
	NSLog(@"--strTotalMoney--%@",strTotalMoney);
	_orderInfo.mprice = strTotalMoney;
	
	GDataXMLNode* savePriceNode = [orderInfoNode oneNodeForXPath:savePricePath error:nil];
	NSString* strSavePrice = [savePriceNode stringValue];
	NSLog(@"--strSavePrice--%@",strSavePrice);
	_orderInfo.msavePrice = strSavePrice;
	
	GDataXMLNode* freightNode = [orderInfoEle oneNodeForXPath:freightPath error:nil];
	NSString* strFreight = [freightNode stringValue];
	_orderInfo.mfreight = strFreight;
	
	GDataXMLNode* payMoneyNode = [orderInfoNode oneNodeForXPath:sellPricePath error:nil];
	NSString* strPayMoney = [payMoneyNode stringValue];
	_orderInfo.msellPrice = strPayMoney;
	
	GDataXMLNode* savePhonePriceNode = [orderInfoNode oneNodeForXPath:savePhonePricePath error:nil];
	NSString* strSavePhonePrice = [savePhonePriceNode stringValue];
	_orderInfo.msavePhonePrice = strSavePhonePrice;
	
	GDataXMLNode* numberNode = [orderInfoNode oneNodeForXPath:numberPath error:nil];
	NSString* strNumber = [numberNode stringValue];
	_orderInfo.mnumber = strNumber;
	
	m_cashCenterData.mPriceInfoData = _orderInfo;
	
	//address
	NSString* addressPath = [NSString stringWithFormat:@"shopex/info/data_info/address"];
	cashcenterAddressData* _address = [[cashcenterAddressData alloc]init];
	
	GDataXMLElement* addrEle = [xmlDoc oneNodeForXPath:addressPath error:nil];
	_address.maddressId = [[addrEle attributeForName:@"addressId"]stringValue];
	_address.mconsignee = [[addrEle attributeForName:@"consignee"] stringValue];
	_address.mphone = [[addrEle attributeForName:@"phone"] stringValue];
	_address.mprovince = [[addrEle attributeForName:@"province"] stringValue];
	_address.mcity = [[addrEle attributeForName:@"city"] stringValue];
	_address.marea = [[addrEle attributeForName:@"area"] stringValue];
	
	_address.maddressInfo = [addrEle stringValue];
	m_cashCenterData.mAddressData = _address;
	
	//payType
	NSMutableArray* _payTypeArr = [[NSMutableArray alloc] initWithCapacity:3];
	NSString* payTypePath = [NSString stringWithFormat:@"payType"];
	GDataXMLNode* payTypeNode = [datainfoNode oneNodeForXPath:payTypePath error:nil];
	
	NSString* payTypeItemPath = [NSString stringWithFormat:@"item"];
	NSArray* payTypeItemArray = [payTypeNode nodesForXPath:payTypeItemPath error:nil];
	if ([payTypeItemArray count]>0) {
		for (GDataXMLElement* item in payTypeItemArray) {
			cashcenterPayTypeData* _payType = [[cashcenterPayTypeData alloc] init];
			_payType.mpayTypeId = [[item attributeForName:@"payTypeId"] stringValue];
			_payType.mselected = [[item attributeForName:@"selected"] stringValue];
			_payType.mpayTypeName = [item stringValue];
			[_payTypeArr addObject:_payType];
		}
		m_cashCenterData.mPayTypeArray = _payTypeArr;
	}
	
	//couponNum
	NSString* couponPath = [NSString stringWithFormat:@"couponNum"];
	GDataXMLNode* couponNumNode = [datainfoNode oneNodeForXPath:couponPath error:nil];
	m_cashCenterData.mCoupon = [couponNumNode stringValue];
	
	//productList
	NSMutableArray* _productArr = [[NSMutableArray alloc]initWithCapacity:10];
	NSString* productPath = [NSString stringWithFormat:@"productList"];
	NSString* productItemPath = [NSString stringWithFormat:@"item"];
	
	GDataXMLNode* productNode = [datainfoNode oneNodeForXPath:productPath error:nil];
	NSArray* productNodeArr = [productNode nodesForXPath:productItemPath error:nil];
		
	if ([productNodeArr count]>0) {
		for (GDataXMLElement* item in productNodeArr) {
			cashcenterProductData* productData = [[cashcenterProductData alloc]init];
			[productData parseFromGDataXMLElement:item];
			NSLog(@">>>>>>---==%@",productData.mimage);
			[_productArr addObject:productData];
		}
	}
	
	m_cashCenterData.mProductListData = _productArr;
	
	//组装submitOrderData
	for (cashcenterPayTypeData* item in m_cashCenterData.mPayTypeArray) {
		if ([[item mselected] isEqualToString:@"1"]) {
			submitOrderData.payTypeId = [item mpayTypeId];
			break;
		}
	}
	
	submitOrderData.addressId = m_cashCenterData.mAddressData.maddressId;
	submitOrderData.orderdata = [SCNStatusUtility getShoppingcartData];
	submitOrderData.couponNum = m_cashCenterData.mCoupon;
	[submitOrderData setAddressOnly:[NSString stringWithFormat:@"%@",m_cashCenterData.mAddressData.maddressInfo]];
	[submitOrderData setConsignee:[NSString stringWithFormat:@"%@",m_cashCenterData.mAddressData.mconsignee]];
	[submitOrderData setPhone:[NSString stringWithFormat:@"%@",m_cashCenterData.mAddressData.mphone]];

}


-(void)popCashCenterView{
	
	if (!m_cashCenterData || [m_cashCenterData.mProductListData count]==0) {
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
														  message:@"无法提交订单！" 
														 delegate:nil 
												cancelButtonTitle:@"确定" 
												otherButtonTitles:nil];
		[alertView show];
		return;
	}
	
	if (!m_cashCenterData.mAddressData.maddressId 
		|| [m_cashCenterData.mAddressData.maddressId isEqualToString:@""]
		|| [m_cashCenterData.mAddressData.maddressId length] == 0) {
		//没有地址，提示用户去添加地址
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
														  message:@"您尚未选择地址,请选择收货地址!" 
														 delegate:self 
												cancelButtonTitle:@"确定" 
												otherButtonTitles:nil];
		[alertView show];
		return;
	}
	
	[self requestSubmitOrder];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    addDic = nil;
}

- (void)keyboardWasHidden:(NSNotification*)aNotification
{
	if (!self.isKeyboardPopup)
	{
		return;
	}
	self.isKeyboardPopup = NO;
	[self KeyboardNeedHide:nil];
//	[self resizeViewFrame];
	
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
	if ([self isCouponUp]) 
	{
		return;
	}
	self.isKeyboardPopup = YES;
	NSDictionary* info = [aNotification userInfo];
	if(info!=nil)
	{
		// Get the size of the keyboard.
		NSValue* aValue = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
		CGSize keyboardSize = [aValue CGRectValue].size;
		
		// Resize the scroll view (which is the root view of the window)
		CGRect viewFrame = [m_tableView frame];
		viewFrame.size.height = [SCNStatusUtility getShowViewHeight] + [SCNStatusUtility getTabBarHeight] - keyboardSize.height;
		
//		[UIView beginAnimations:nil context:nil];
//		[UIView setAnimationDuration:2];
		m_tableView.frame = viewFrame;
        
		CGFloat showheight = viewFrame.size.height;
		NSLog(@"%@",[NSString stringWithFormat:@"%f",self.m_tableView.contentSize.height]);
		[self.m_tableView setContentOffset:CGPointMake(0, self.m_tableView.contentSize.height - showheight) animated:NO];
//		[UIView commitAnimations];
	}
}

- (void)KeyboardNeedHide:(id)keyboard{
	//isKeyboardPopup = NO;
	if (!self.isKeyboardPopup)
	{
		return;
	}
	[keyboard resignFirstResponder];
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.3];
	
	[self resizeViewFrame];
	[self.m_tableView setContentOffset:CGPointMake(0,self.m_tableView.contentSize.height - m_tableView.frame.size.height) animated:NO];
	
//	[UIView commitAnimations];
}



#pragma mark-
#pragma mark UITableViewDelegates Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	float height = 0.0;
	if (indexPath.section == OrderInfoSection) {
		if (indexPath.row == 0) {
			height = 80.0;
			if ([m_cashCenterData.mPriceInfoData.msavePhonePrice length] == 0 || m_cashCenterData.mPriceInfoData.msavePhonePrice == nil || [m_cashCenterData.mPriceInfoData.msavePhonePrice isEqualToString:@"0"]){
				height -=20;
			}
			
			if ([m_cashCenterData.mPriceInfoData.msavePrice length] == 0 || m_cashCenterData.mPriceInfoData.msavePrice == nil || [m_cashCenterData.mPriceInfoData.msavePrice isEqualToString:@"0"]) {
				height -=20;
			}
		}else if (indexPath.row == 1) {
			height = 44.0;
		}
	}else if (indexPath.section == CarrigeInfoSection) {
		if ([m_cashCenterData.mAddressData.maddressId length] == 0) {
			height = 30;
		}else {
			height = 64;
		}
	}else if (indexPath.section == ShippingInfoSection) {
		height = 43;
	}else if (indexPath.section == CouponInfoSection) {
		if (self.m_CashType != ECashTypeSeckill) 
        {
			height = 30;
		}
        else 
        {
			//可售商品
			shoppingcartProductData* _productData = [m_cashCenterData.mProductListData objectAtIndex:indexPath.row];
			if ([_productData.msavePrice floatValue] > 0.0){
				height = 83;
			}else {
				height = 63;
			}
		}

	}else if (indexPath.section == ProductInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			//可售商品
			shoppingcartProductData* _productData = [m_cashCenterData.mProductListData objectAtIndex:indexPath.row];
			if ([_productData.msavePrice floatValue] > 0.0){
				height = 83;
			}else {
				height = 63;
			}
		}
        else 
        {
			height = 65;
		}
	
	}else if (indexPath.section == RemarkInfoSection)
    {
        if (self.m_CashType != ECashTypeSeckill)
        {
			height = 77;
		}else{
			height = 0;
		}
		
	}
	
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	float height = 0.0;
	if (section == OrderInfoSection) {
		height = 0;
	}else{
		height = 45;
	}
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	float height = 0.0;
	if (section == OrderInfoSection) {
		height = 55;
	}else{
		height = 0;
	}
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
		UIView *_v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
		_v.backgroundColor = [UIColor clearColor];
		
		
		UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
		[backImageView setBackgroundColor:[UIColor colorWithRed:(float)(68/255.0f) green:(float)(68/255.0f) blue:(float)(68/255.0f) alpha:1.0f]];
		[_v addSubview:backImageView];
	
	if (section == OrderInfoSection) {
		return nil;
	}else if (section == CarrigeInfoSection){
		UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
		labTitle.text = [NSString stringWithFormat:@"%@",@"收货信息"];
		labTitle.backgroundColor = [UIColor clearColor];
		labTitle.textColor = [UIColor whiteColor];
		labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		[_v addSubview:labTitle];
		
		return _v;
	}else if (section == ShippingInfoSection) {
		UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
		labTitle.text = [NSString stringWithFormat:@"%@",@"付款与配送"];
		labTitle.backgroundColor = [UIColor clearColor];
		labTitle.textColor = [UIColor whiteColor];
		labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		[_v addSubview:labTitle];
		
		return _v;
	}else if (section == CouponInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
			labTitle.text = [NSString stringWithFormat:@"%@",@"优惠券使用"];
			labTitle.backgroundColor = [UIColor clearColor];
			labTitle.textColor = [UIColor whiteColor];
			labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
			[_v addSubview:labTitle];
		}else {
			UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
			labTitle.text = [NSString stringWithFormat:@"%@",@"商品清单"];
			labTitle.backgroundColor = [UIColor clearColor];
			labTitle.textColor = [UIColor whiteColor];
			labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
			[_v addSubview:labTitle];
		}
		return _v;
	}else if (section == ProductInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
			labTitle.text = [NSString stringWithFormat:@"%@",@"商品清单"];
			labTitle.backgroundColor = [UIColor clearColor];
			labTitle.textColor = [UIColor whiteColor];
			labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
			[_v addSubview:labTitle];
		}else {
			UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
			labTitle.text = [NSString stringWithFormat:@"%@",@"留言"];
			labTitle.backgroundColor = [UIColor clearColor];
			labTitle.textColor = [UIColor whiteColor];
			labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
			[_v addSubview:labTitle];
		}
		return _v;
	}else if (section == RemarkInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
			labTitle.text = [NSString stringWithFormat:@"%@",@"留言"];
			labTitle.backgroundColor = [UIColor clearColor];
			labTitle.textColor = [UIColor whiteColor];
			labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
			[_v addSubview:labTitle];
		}else {
		}

		return _v;
	}else {
		return nil;
	}

	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if (section == OrderInfoSection) {
		return m_confirmBtnFootView;
	}else{
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (self.isKeyboardPopup) 
	{
//		if (m_curTxt) {
//			[m_curTxt resignFirstResponder];
//		}
		return;
	}
	
	if (indexPath.section == CarrigeInfoSection) {
		[self goToAddAddress];
	}
	
    if (indexPath.section == ProductInfoSection && self.m_CashType == ECashTypeCommon)
    {
        self.m_reloadType = YK_DEFAULT_UPDATE;
        
        cashcenterProductData* _product = [self.m_cashCenterData.mProductListData objectAtIndex:indexPath.row];
        [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:_product.mproductCode withPstatus:_product.mpstatus withImage:nil];
    }
}


#pragma mark-
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//if (m_haveSecKill == NO) {
//		if (section == OrderInfoSection) {//收货信息
//			return 2;
//		}else if(section == CarrigeInfoSection || section == ShippingInfoSection || section == CouponInfoSection || section == RemarkInfoSection){
//			return 1;
//		}else if (section == ProductInfoSection) {//商品清单
//			return [m_cashCenterData.mProductListData count];
//		}else{
//			return 0;
//		}
//	}else {
//		if (section == OrderInfoSection) {//收货信息
//			return 2;
//		}else if(section == CarrigeInfoSection || section == ShippingInfoSection || section == ProductInfoSection ){
//			return 1;
//		}else if (section == CouponInfoSection) {//商品清单
//			return [m_cashCenterData.mProductListData count];
//		}else{
//			return 0;
//		}
//	}
//////////////////////////////
	NSInteger nRow = 0;
	if (section == OrderInfoSection) {
		nRow = 2;
	}else if (section == CarrigeInfoSection) {
		nRow = 1;
	}else if (section == ShippingInfoSection) {
		nRow = 1;
	}else if (section == CouponInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			nRow = 1;
		}else {
			//可售商品
			nRow = [m_cashCenterData.mProductListData count];
		}
		
	}else if (section == ProductInfoSection) {
		if (self.m_CashType != ECashTypeSeckill) {
			//可售商品
			nRow = [m_cashCenterData.mProductListData count];
		}else {
			nRow = 1;
		}
		
	}else if (section == RemarkInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			nRow = 1;
		}else{
			nRow = 0;
		}
		
	}
	return nRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	int section = indexPath.section;
	UITableViewCell* tableCell = nil;
	
	if (section == OrderInfoSection) {
		if (indexPath.row == 0) {
			
			NSString* orderInfoIdentifier = @"SCNCashCenterOrderInfoTableCellId";
			SCNCashCenterOrderInfoTableCell* orderInfoCell = nil;
			
			orderInfoCell = (SCNCashCenterOrderInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:orderInfoIdentifier];
			
			if (!orderInfoCell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterOrderInfoTableCell class]]) {
						orderInfoCell = (SCNCashCenterOrderInfoTableCell*)object;
						break;
					}
				}
			}
			
			//设置颜色:
			orderInfoCell.m_labTotalAmount.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
			orderInfoCell.m_labCarrige.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
			orderInfoCell.m_labPreferentAmount.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
			orderInfoCell.m_labMobileSave.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
			
			orderInfoCell.m_labTotalAmount.text = [NSString stringWithFormat:@"¥%.02f",[m_cashCenterData.mPriceInfoData.mprice floatValue]];
			orderInfoCell.m_labCarrige.text = [NSString stringWithFormat:@"¥%.02f",[m_cashCenterData.mPriceInfoData.mfreight floatValue]];
			orderInfoCell.m_labPreferentAmount.text = [NSString stringWithFormat:@"¥%.02f",[m_cashCenterData.mPriceInfoData.msavePrice floatValue]];

			BOOL _savePriceTag = NO;
			BOOL _saveMobilePriceTag = NO;
			
			if ([m_cashCenterData.mPriceInfoData.msavePrice length] == 0 || m_cashCenterData.mPriceInfoData.msavePrice == nil || [m_cashCenterData.mPriceInfoData.msavePrice isEqualToString:@"0"]) {
				orderInfoCell.m_labPreferentAmount.hidden = YES;
				orderInfoCell.m_labPreferentAmountTxt.hidden = YES;	
				
			}else {
				_savePriceTag = YES;
				orderInfoCell.m_labPreferentAmount.hidden = NO;
				orderInfoCell.m_labPreferentAmountTxt.hidden = NO;
				orderInfoCell.m_labPreferentAmount.text = [NSString stringWithFormat:@"¥%.02f",[m_cashCenterData.mPriceInfoData.msavePrice floatValue]];
			}
			
			if ([m_cashCenterData.mPriceInfoData.msavePhonePrice length] == 0 || m_cashCenterData.mPriceInfoData.msavePhonePrice == nil || [m_cashCenterData.mPriceInfoData.msavePhonePrice isEqualToString:@"0"]) {
				orderInfoCell.m_labMobileSave.hidden = YES;
				orderInfoCell.m_labMobileSaveTxt.hidden = YES;	
			}else {
				_saveMobilePriceTag = YES;
				if (_savePriceTag == YES) {
					//有普通商品优惠
					[orderInfoCell.m_labMobileSaveTxt setFrame:CGRectMake(13, 58, 106, 21)];
					[orderInfoCell.m_labMobileSave setFrame:CGRectMake(154, 58, 140, 21)];
				}else {
					//无普通商品优惠
					[orderInfoCell.m_labMobileSaveTxt setFrame:CGRectMake(13, 39, 106, 21)];
					[orderInfoCell.m_labMobileSave setFrame:CGRectMake(154, 39, 140, 21)];
				}

				orderInfoCell.m_labMobileSave.hidden = NO;
				orderInfoCell.m_labMobileSaveTxt.hidden = NO;
				orderInfoCell.m_labMobileSave.text = [NSString stringWithFormat:@"¥%.02f",[m_cashCenterData.mPriceInfoData.msavePhonePrice floatValue]];
			}
			orderInfoCell.m_imgSepar.image = [UIImage imageNamed:@"com_separate.png"];
			if (_savePriceTag && _saveMobilePriceTag) {
				[orderInfoCell.m_imgSepar setFrame:CGRectMake(0, 79, 300, 1)];
			}else if (_savePriceTag) {
				[orderInfoCell.m_imgSepar setFrame:CGRectMake(0, 59, 300, 1)];	
			}else if (_saveMobilePriceTag) {
				[orderInfoCell.m_imgSepar setFrame:CGRectMake(0, 59, 300, 1)];
			}else {
				[orderInfoCell.m_imgSepar setFrame:CGRectMake(0, 29, 300, 1)];
			}



			[orderInfoCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			orderInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
			orderInfoCell.accessoryType = UITableViewCellAccessoryNone;
			
			tableCell = orderInfoCell;
		}else if (indexPath.row == 1) {
			NSString* orderInfoDownIdentifier = @"SCNCashCenterOrderInfoDownTableCellId";
			SCNCashCenterOrderInfoDownTableCell* orderInfoDownCell = nil;
			
			orderInfoDownCell = (SCNCashCenterOrderInfoDownTableCell*)[tableView dequeueReusableCellWithIdentifier:orderInfoDownIdentifier];
			
			if (!orderInfoDownCell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterOrderInfoDownTableCell class]]) {
						orderInfoDownCell = (SCNCashCenterOrderInfoDownTableCell*)object;
						break;
					}
				}
			}
			
			orderInfoDownCell.m_labProductCount.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
			
			orderInfoDownCell.m_labProductCount.text = [NSString stringWithFormat:@"%@件",[YKStringUtility strOrEmpty:m_cashCenterData.mPriceInfoData.mnumber] ];
			orderInfoDownCell.m_labPayAmount.text = [NSString stringWithFormat:@"¥%.02f",[m_cashCenterData.mPriceInfoData.msellPrice floatValue]];
			orderInfoDownCell.m_labPayAmount.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			[orderInfoDownCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			orderInfoDownCell.selectionStyle = UITableViewCellSelectionStyleNone;
			orderInfoDownCell.accessoryType = UITableViewCellAccessoryNone;
			
			tableCell = orderInfoDownCell;
		}
		
	}else if (section == CarrigeInfoSection && [m_cashCenterData.mAddressData.maddressId length]>0) {
		
		NSString* cellReceiveInfoIndentifier = @"SCNCashCenterReceiveInfoTableCellId";
		SCNCashCenterReceiveInfoTableCell* receiveInfoCell = nil;
		
		receiveInfoCell = (SCNCashCenterReceiveInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:cellReceiveInfoIndentifier];
		
		if (!receiveInfoCell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNCashCenterReceiveInfoTableCell class]]) {
					receiveInfoCell = (SCNCashCenterReceiveInfoTableCell*)object;
					break;
				}
			}
		}	
		//设置颜色
		receiveInfoCell.m_labAddress.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
		receiveInfoCell.m_labName.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
		receiveInfoCell.m_labMobile.textColor = [UIColor colorWithRed:(float)(66/255.0f) green:(float)(66/255.0f) blue:(float)(66/255.0f) alpha:1.0f];
		
		receiveInfoCell.m_labAddress.text = [NSString stringWithFormat:@"%@",[YKStringUtility strOrEmpty:submitOrderData.addressOnly]];
		receiveInfoCell.m_labName.text = [NSString stringWithFormat:@"%@",[YKStringUtility strOrEmpty:submitOrderData.consignee]];
		receiveInfoCell.m_labMobile.text = [NSString stringWithFormat:@"%@",[YKStringUtility strOrEmpty:submitOrderData.phone]];
		[receiveInfoCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		tableCell = receiveInfoCell;
	}else if (section == CarrigeInfoSection && [m_cashCenterData.mAddressData.maddressId length]==0) {
		NSString* cellNoReceiveInfoIndentifier = @"SCNCashCenterNoReceiveInfoTableCellId";
		SCNCashCenterNoReceiveInfoTableCell* noReceiveInfoCell = nil;
		noReceiveInfoCell = (SCNCashCenterNoReceiveInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:cellNoReceiveInfoIndentifier];
		if (!noReceiveInfoCell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNCashCenterNoReceiveInfoTableCell class]]) {
					noReceiveInfoCell = (SCNCashCenterNoReceiveInfoTableCell*)object;
					break;
				}
			}
		}
		
		[noReceiveInfoCell.m_btnAddAddress addTarget:self action:@selector(goToAddAddress) forControlEvents:UIControlEventTouchUpInside];
		[noReceiveInfoCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		tableCell = noReceiveInfoCell;
	}else if (section == ShippingInfoSection) {
		NSString* cellPayShippingUpIndentifier = @"SCNCashCenterPayShippingUpTableCellId";
		SCNCashCenterPayShippingUpTableCell* payShippingUpCell = nil;
		
		payShippingUpCell = (SCNCashCenterPayShippingUpTableCell*)[tableView dequeueReusableCellWithIdentifier:cellPayShippingUpIndentifier];
		
		if (!payShippingUpCell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNCashCenterPayShippingUpTableCell class]]) {
					payShippingUpCell = (SCNCashCenterPayShippingUpTableCell*)object;
					break;
				}
			}	
			
		}	
		[payShippingUpCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		tableCell = payShippingUpCell;	
	}else if (section == CouponInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {//非秒杀商品
			NSString* cellPayShippingDownIndentifier = @"SCNCashCenterCouponPopTableCellId";
			SCNCashCenterCouponPopTableCell* payShippingDownCell = nil;
			
			payShippingDownCell = (SCNCashCenterCouponPopTableCell*)[tableView dequeueReusableCellWithIdentifier:cellPayShippingDownIndentifier];
			
			if (!payShippingDownCell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterCouponPopTableCell class]]) {
						payShippingDownCell = (SCNCashCenterCouponPopTableCell*)object;
						break;
					}
				}
			}
			NSLog(@"%@",m_cashCenterData.mCoupon);
			NSLog(@"%@",submitOrderData.couponNum);
			if (m_cashCenterData.mCoupon != nil && [m_cashCenterData.mCoupon length]>0) {
				payShippingDownCell.m_labCoupon.text = [NSString stringWithFormat:@"已使用优惠券(%@)",m_cashCenterData.mCoupon];
				payShippingDownCell.m_btnCouponSelect.hidden = YES;
				payShippingDownCell.m_btnCouponCancel.hidden = NO;
				[payShippingDownCell.m_btnCouponCancel setFrame:CGRectMake(239, 4, 48, 23)];
				//[payShippingDownCell.m_btnTouch addTarget:self action:@selector(selectCouponBtn:) forControlEvents:UIControlEventTouchUpInside];
				[payShippingDownCell.m_btnCouponCancel addTarget:self action:@selector(CouponCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
			}else {
				payShippingDownCell.m_labCoupon.text = @"使用优惠券";
				payShippingDownCell.m_btnCouponSelect.hidden = NO;
				payShippingDownCell.m_btnCouponCancel.hidden = YES;
				[payShippingDownCell.m_btnCouponSelect setFrame:CGRectMake(275, 5, 20, 20)];
				[payShippingDownCell.m_btnTouch setBackgroundColor:[UIColor clearColor]];
				[payShippingDownCell.m_btnCouponSelect addTarget:self action:@selector(selectCouponBtn:) forControlEvents:UIControlEventTouchUpInside];
				[payShippingDownCell.m_btnTouch addTarget:self action:@selector(selectCouponBtn:) forControlEvents:UIControlEventTouchUpInside];
			}
			[payShippingDownCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			tableCell = payShippingDownCell;
		}else {
			NSString* cellIndentifier = @"SCNCashCenterTableCellId";
			SCNCashCenterTableCell* cell = nil;
			
			cell = (SCNCashCenterTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
			
			if (!cell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterTableCell class]]) {
						cell = (SCNCashCenterTableCell*)object;
						break;
					}
				}
			}
			cell.m_txtNumber.hidden = YES;
			cell.m_txtNumber.enabled = NO;
			
			cashcenterProductData* _productData = [m_cashCenterData.mProductListData objectAtIndex:indexPath.row];
			NSString* clearName = [_productData.mname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			cell.m_labName.text = clearName;
			cell.m_labNumber.text = [_productData mnumber];
			
			[self dealwithColorSizeText:_productData label:cell.m_labStyle];
			
			cell.m_image.image = [UIImage imageNamed:@"com_loading53x50.png"];
			
			BOOL _savePriceTag = NO;
			if ([_productData.msavePrice floatValue] > 0.0) {
				_savePriceTag = YES;
				[cell.m_labPriceTitle setFrame:CGRectMake(68, 60, 42, 21)];
				[cell.m_labPriceValue setFrame:CGRectMake(110, 60, 70, 21)];
				cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
				cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				
				cell.m_labSaveTitle.hidden = NO;
				cell.m_labSaveValue.hidden = NO;
				[cell.m_labSaveTitle setFrame:CGRectMake(170, 60, 61, 21)];
				[cell.m_labSaveValue setFrame:CGRectMake(235, 60, 70, 21)];
				cell.m_labSaveValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msavePrice floatValue]];
				cell.m_labSaveValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			}else {
				[cell.m_labPriceTitle setFrame:CGRectMake(177, 40, 42, 21)];
				[cell.m_labPriceValue setFrame:CGRectMake(215, 40, 70, 21)];
				cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
				cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				
				cell.m_labSaveTitle.hidden = YES;
				cell.m_labSaveValue.hidden = YES;
			}
			
			cell.m_labTag.hidden = YES;
			cell.m_imgBack.layer.borderWidth = 1;
			cell.m_imgBack.layer.borderColor = [[UIColor lightGrayColor] CGColor];
			
			if (_savePriceTag == YES) {
				//有优惠
				[cell.m_imgBack setFrame:CGRectMake(7, 15, 55, 52)];
				[cell.m_image setFrame:CGRectMake(8, 16, 53, 50)];
			}
			[cell.m_image setImage:[UIImage imageNamed:@"com_loading53x50.png"]];
			[HJImageUtility queueLoadImageFromUrl:_productData.mimage imageView:(HJManagedImageV*)cell.m_image];
			
			[cell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			tableCell = cell;
		}

		
	}
	else if (section == ProductInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			NSString* cellIndentifier = @"SCNCashCenterTableCellId";
			SCNCashCenterTableCell* cell = nil;
			
			cell = (SCNCashCenterTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
			
			if (!cell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterTableCell class]]) {
						cell = (SCNCashCenterTableCell*)object;
						break;
					}
				}
			}
			cell.m_txtNumber.hidden = YES;
			cell.m_txtNumber.enabled = NO;
			
			cashcenterProductData* _productData = [m_cashCenterData.mProductListData objectAtIndex:indexPath.row];
			NSString* clearName = [_productData.mname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
			cell.m_labName.text = clearName;
			cell.m_labNumber.text = [_productData mnumber];
			[self dealwithColorSizeText:_productData label:cell.m_labStyle];
			cell.m_image.image = [UIImage imageNamed:@"com_loading53x50.png"];
			
			BOOL _savePriceTag = NO;
			if ([_productData.msavePrice floatValue] > 0.0) {
				_savePriceTag = YES;
				[cell.m_labPriceTitle setFrame:CGRectMake(68, 60, 42, 21)];
				[cell.m_labPriceValue setFrame:CGRectMake(110, 60, 70, 21)];
				cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
				cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				
				cell.m_labSaveTitle.hidden = NO;
				cell.m_labSaveValue.hidden = NO;
				[cell.m_labSaveTitle setFrame:CGRectMake(170, 60, 61, 21)];
				[cell.m_labSaveValue setFrame:CGRectMake(235, 60, 70, 21)];
				cell.m_labSaveValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msavePrice floatValue]];
				cell.m_labSaveValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			}else {
				[cell.m_labPriceTitle setFrame:CGRectMake(177, 40, 42, 21)];
				[cell.m_labPriceValue setFrame:CGRectMake(215, 40, 70, 21)];
				cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
				cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				
				cell.m_labSaveTitle.hidden = YES;
				cell.m_labSaveValue.hidden = YES;
			}
			
			cell.m_labTag.hidden = YES;
			cell.m_imgBack.layer.borderWidth = 1;
			cell.m_imgBack.layer.borderColor = [[UIColor lightGrayColor] CGColor];
			if (_savePriceTag == YES) {
				//有优惠
				[cell.m_imgBack setFrame:CGRectMake(7, 15, 55, 52)];
				[cell.m_image setFrame:CGRectMake(8, 16, 53, 50)];
			}
			
			[HJImageUtility queueLoadImageFromUrl:_productData.mimage imageView:(HJManagedImageV*)cell.m_image];
			
			[cell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			tableCell = cell;
		}else {
			NSString* cellMessageIndentifier = @"SCNCashCenterMessageTableCellId";
			SCNCashCenterMessageTableCell* messageCell = nil;
			
			messageCell = (SCNCashCenterMessageTableCell*)[tableView dequeueReusableCellWithIdentifier:cellMessageIndentifier];
			
			if (!messageCell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterMessageTableCell class]]) {
						messageCell = (SCNCashCenterMessageTableCell*)object;
						break;
					}
				}
			}	
			messageCell.m_txtViewMessage.placeholder = @"填写留言";
			messageCell.m_txtViewMessage.delegate = self;
			messageCell.m_txtViewMessage.font = [UIFont systemFontOfSize:13];  
			[messageCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			self.m_messageCell = messageCell;
			tableCell = messageCell;
		}	
		
	}
	else if (section == RemarkInfoSection) {
		if (self.m_CashType != ECashTypeSeckill)
        {
			NSString* cellMessageIndentifier = @"SCNCashCenterMessageTableCellId";
			SCNCashCenterMessageTableCell* messageCell = nil;
			
			messageCell = (SCNCashCenterMessageTableCell*)[tableView dequeueReusableCellWithIdentifier:cellMessageIndentifier];
			
			if (!messageCell) {
				NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
				
				for (NSObject *object in objects) {
					if ([object isKindOfClass:[SCNCashCenterMessageTableCell class]]) {
						messageCell = (SCNCashCenterMessageTableCell*)object;
						break;
					}
				}
			}	
			messageCell.m_txtViewMessage.placeholder = @"填写留言";
			messageCell.m_txtViewMessage.delegate = self;
			messageCell.m_txtViewMessage.font = [UIFont systemFontOfSize:13];  
			[messageCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
			self.m_messageCell = messageCell;
			tableCell = messageCell;
		}
		//else {
//			tableCell = nil;
//		}

		
	}
	return tableCell;
}

-(void)dealwithColorSizeText:(cashcenterProductData*)_productData label:(UILabel*)label
{
	if (_productData.mcolor && [_productData.mcolor length] && _productData.msize && [_productData.msize length])
	{
		label.text = [NSString stringWithFormat:@"(颜色:%@,尺码:%@)",_productData.mcolor,_productData.msize];
	}
	else if(_productData.mcolor && [_productData.mcolor length])
	{
		label.text = [NSString stringWithFormat:@"(颜色:%@)",_productData.mcolor];
	}
	else if(_productData.msize && [_productData.msize length])
	{
		label.text = [NSString stringWithFormat:@"(尺码:%@)",_productData.msize];
	}
	else
	{
		label.text = @"";
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	if (self.m_CashType != ECashTypeSeckill)
    {
		return 6;
	}else{
		return 5;
	}
}

-(void)selectCouponBtn:(id)sender
{
	if (self.isKeyboardPopup)
	{
		[self KeyboardNeedHide:m_curTxt];
		return;
	}
	m_couponInputView = [[SCNCashCenterCouponInputView alloc] initWithFrame:CGRectMake(43, 125, 235, 171)];
	m_couponInputView.m_delegate = self;
	m_couponInputView.tag = 520;
	if (m_cashCenterData.mCoupon) {
		m_couponInputView.m_txtCoupon.text = m_cashCenterData.mCoupon;
	}
	[self.view addSubview:m_couponInputView];
}

-(void)CouponCancelBtn:(id)sender{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认取消使用此优惠券吗？" message:nil
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alert show];    
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1){
		self.m_cashCenterData.mCoupon = nil;
		self.submitOrderData.couponNum = nil;
		[self subShoppingCartChangeData:YK_COUPON_CANCEL];
	}else {
		
	}
	
}

//-(void)clickMessageMoreBtn:(id)sender{
//	
//	m_messagePopView = [[SCNCashCenterMessagePopView alloc]initWithFrame:CGRectMake(0, 325, 320, 60)];
//	m_messagePopView.m_delegate = self;
//	[self.view addSubview:m_messagePopView];
//}

-(void)clickInvoiceMoreBtn:(id)sender{
	NSDictionary *_dic = @{@"111": @"文学用品",
						 @"222": @"体育用品",
						 @"333": @"餐饮发票",
						 @"444": @"交通工具",
						 @"555": @"娱乐消费",
						 @"666": @"贵重物品"};
	
	
	m_invoicePopView = [[SCNCashCenterInvoicePopView alloc]initWithFrame:CGRectMake(0, 195, 320, 190) withInvoiceTypeDic:_dic];
	m_invoicePopView.m_delegate = self;
	[self.view addSubview:m_invoicePopView];
}

#pragma mark-
#pragma mark CouponPopViewDelegate
-(void)couponPopViewDelegate:(NSString*)couponId{
	self.submitOrderData.couponNum = couponId;
	
	[self controllerReload:YK_COUPON_USE];
}


#pragma mark-
#pragma mark CouponPopMessageDelegate
-(void)couponPopMessageDelegate:(NSString *)message{
	SCNCashCenterMessageTableCell *cell=(SCNCashCenterMessageTableCell*)[self.m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
	cell.m_labMessageTxt.text = message;
}

#pragma mark-
#pragma mark CouponPopInvoiceDelegate
-(void)couponPopInvoiceDelegate:(NSString*)invoiceTxt invoiceType:(NSString*)invoiceType{
	
}

-(void)resignAllKeyboard{
	//if (self.controlArea == nil)
//	{
//		return;
//	}
//	
//	[controlArea removeFromSuperview];
//	self.controlArea = nil;
//	
//	if (m_curTxt) {
//		[m_curTxt resignFirstResponder];
//	}
//	
//	[self.m_tableView setContentOffset:CGPointMake(0,370) animated:YES];
	
}

#pragma mark-
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
	m_curTxt = (UITextField*)textView;
	//if (self.controlArea == nil)
//	{
//		controlArea = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//		controlArea.backgroundColor = [UIColor clearColor];
//		//controlArea.alpha = 0.5f;
//		[controlArea addTarget:self action:@selector(resignAllKeyboard) forControlEvents:UIControlEventTouchUpInside];
//		[self.view addSubview:controlArea];
//	}
	
	//[self.m_tableView setContentOffset:CGPointMake(0,400) animated:YES];
	
	//[self performSelector:@selector(changeTableViewFrame) withObject:nil afterDelay:0.3];
	return YES;
}

-(void)changeTableViewFrame
{
	//m_tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-216);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	
}


-(void)controllerReload:(NSString*)reloadType{
	[self subShoppingCartChangeData:reloadType];
	if ([reloadType isEqualToString:YK_ADDRESS_UPDATE]) {
		//选择地址后回来的刷新
		[self selectAddressBehavior];
		
	}
}


-(NSString*)getOrderProductListDataFrom:(NSArray*)array{
	NSMutableString *productList=[[NSMutableString alloc] initWithString:@"<list>"];
	for (shoppingcartProductData *product in array) {
			shoppingcartProductData* pP=(shoppingcartProductData*)product;
			NSString *pdata=[self getsubOrderProductData:pP];
			[productList appendString:pdata];
	}

	[productList appendString:@"</list>"];
	return productList;
}

-(void)goToAddAddress{
	UIViewController* nextController = nil;
	self.m_reloadType = YK_DEFAULT_UPDATE;
	nextController=[[SCNAddressListViewController alloc] initWithNibName:@"SCNAddressListViewController" bundle:nil];
	[(SCNAddressListViewController*)nextController setCurrentViewFromTag:cashCenterTag];
	[(SCNAddressListViewController*)nextController setDefaultSelectedAddressId:submitOrderData.addressId];
	if (nextController!=nil) {
		[self.navigationController pushViewController:nextController animated:YES];
	}
}

-(NSString*)getsubOrderProductData:(shoppingcartProductData*)p{
	
	NSMutableString *product=[[NSMutableString alloc] initWithString:@"<item"];
	[product appendString:[NSString stringWithFormat:@" code=\"%@\"",p.mproductCode]];
	[product appendString:[NSString stringWithFormat:@" name=\"%@\"",p.mname]];
	[product appendString:[NSString stringWithFormat:@" price=\"%@\"",p.msellPrice]];
	[product appendString:[NSString stringWithFormat:@" quantity=\"%@\"",p.mnumber]];
	[product appendString:[NSString stringWithFormat:@" color=\"%@\"",p.mcolor]];
	[product appendString:[NSString stringWithFormat:@" size=\"%@\"",p.msize]];

	[product appendString:@"/>"];
	return product;
}

-(void)orderSuccessBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	//订单号|姓名|电话|省|市|地址|支付方式|配送方式|配送时间|优惠活动|礼品卡|积分|留言|{商品来源页面Id|商品名称|skuid|单价|数量,商品来源页面Id|商品名称|skuid|单价|数量}|总价
    
    //订单号|姓名|电话|省|市|地址|支付方式|配送方式|配送时间|折扣券|积分|余额|礼品卡|留言|{商品来源id|商品名称|商品sku|单价|数量,商品来源id|商品名称|商品sku|单价|数量}|总价
	int nTag = 0;
	
	NSString* _curSrcPageId = nil;
	NSString* _payName = [[m_cashCenterData.mPayTypeArray objectAtIndex:0] mpayTypeName];
	NSMutableString* skuRootString = [[NSMutableString alloc] init];
	NSString* orderInfo = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|{",
						   m_orderId,
						   submitOrderData.consignee,
						   submitOrderData.phone,
						   m_cashCenterData.mAddressData.mprovince,
						   m_cashCenterData.mAddressData.mcity,
						   m_cashCenterData.mAddressData.marea,
						   _payName,
						   @"货到付款",
						   @"配送时间",
                           [YKStringUtility strOrEmpty:self.submitOrderData.couponNum],
						   @"积分",
                           @"余额",
                           @"礼品卡",
						   [YKStringUtility strOrEmpty:self.m_messageCell.m_txtViewMessage.text]
						   ];
	
	[skuRootString appendString:orderInfo];
	for (cashcenterProductData* _data in m_cashCenterData.mProductListData) 
	{
		NSString* skuString;
		
		_curSrcPageId = [NSString stringWithFormat:@"%d",[YKStatBehaviorInterface sourcePageIdWithSku:_data.mproductCode]];
		
		if (nTag == 0) 
		{
			skuString	=	[NSString stringWithFormat:@"%@|%@|%@|%@|%@", 
							 _curSrcPageId,
							 [_data.mname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
							 _data.mproductCode,
							 _data.msellPrice,
							 _data.mnumber
							 ];
		}else 
		{
			skuString	=	[NSString stringWithFormat:@",%@|%@|%@|%@|%@",
							 _curSrcPageId,
							 [_data.mname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
							 _data.mproductCode,
							 _data.msellPrice,
							 _data.mnumber
							 ];
		}
		
		nTag = 1;
		
		[skuRootString appendString:skuString];
	}
	NSString* _endFix = [NSString stringWithFormat:@"}|%@",m_payMoney];
	[skuRootString appendString:_endFix];
	
	NSLog(@"%@",skuRootString);
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_ORDERSUCCESS param:skuRootString];
#endif
}

-(void)orderFailureBehavior:(NSString*)_errorInfo{
#ifdef USE_BEHAVIOR_ENGINE
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_ORDERFAILURE param:nil];
#endif
}

-(void)orderSubmitBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_SUBMITORDER param:nil];
#endif
}

-(void)selectAddressBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	//订单号|用户名|用户id|区域
	//NSString* _param = [NSString stringWithFormat:@"%@|%@|%@|%@",];
#endif
}

//-(NSString*)pageJumpParam{
//	NSString* _param = nil;
//#ifdef USE_BEHAVIOR_ENGINE
//    
//    switch (self.m_CashType) {
//        case ECashTypeCommon:
//        {
//            _param = @"购物车";
//        }
//            break;
//        case ECashTypeSeckill:
//        {
//            _param = @"秒杀";
//        }
//            break;
//        case ECashTypeImmediately:
//        {
//            _param = @"商品详情";
//        }
//        default:
//            break;
//    }
//#endif
//	return _param;
//
//}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}
@end

