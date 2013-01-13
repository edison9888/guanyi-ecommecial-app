//
//  SCNStatusUtility.m
//  SCN
//
//  Created by zwh on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import "YKStatBehaviorInterface.h"
#import "SCNStatusUtility.h"
#import "CTCarrier.h"
#import "CTTelephonyNetworkInfo.h"
#import "SCNAppDelegate.h"
#import "SCNViewController.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "SCNUpdate.h"
#import "ModalAlert.h"
#import "DataWorld.h"
#import "NSString+NSString.h"

#import "NSMutableDictionary+NSMutableDictUtil.h"
#import "GY_Common_Header.h"

#import "UIDevice+Resolutions.h"

//本地时间戳与服务端时间戳差值
static NSTimeInterval localtimediff = 0.0f;

@implementation SCNStatusUtility

+(CGFloat)getNavigationBarHeight
{
	UIImage *image = [UIImage imageNamed:YK_COMMONIMG_NAVI];
	return image.size.height;
}

+(CGFloat)getTabBarHeight
{
	return 50.0;
}

+(CGFloat)getShowViewHeight
{
    float height = 480.0;
    
    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {
        height = 568;
    }
    
	return height - [SCNStatusUtility getNavigationBarHeight] - [SCNStatusUtility getTabBarHeight];
}

+(NSString *)getClientVersion
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+(NSString *)getSourceId{
	return [KDataWorld getSourceId];
}

+(NSString*)getSubSourceId{
	return [KDataWorld getSubSourceId];
}

+(CGFloat)getScreenScale
{
	CGFloat screenscale = 1.0;
	if ([UIScreen instancesRespondToSelector:@selector(scale)])
	{
		screenscale = [UIScreen mainScreen].scale;
	}
	return screenscale;
}

+(NSString *)getScreenScaleForString
{
	CGFloat screenscale = [[self class] getScreenScale];
	return [NSString stringWithFormat:@"%0.1f", screenscale];
}

+(NSString *)getPriceString:(NSString *)priceStr
{
    CGFloat fp = [priceStr floatValue];
    NSString *Price = [NSString stringWithFormat:@"¥%.2f",fp];
    return Price;
}

+(NSString *)getDeviceToken
{
	SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
	return delegate.m_string_deviceToken;
}

/*
 获取运行商名称
 */
+(NSString *)getCarrierName{
	@autoreleasepool{
        NSString* carrierName=nil;
        if (nil!=NSClassFromString(@"CTTelephonyNetworkInfo")){
            //
            CTTelephonyNetworkInfo* netInfo=[[CTTelephonyNetworkInfo alloc] init];
            if(netInfo!=nil){
                CTCarrier* carrier=netInfo.subscriberCellularProvider;
                if(carrier!=nil){
                    carrierName=[carrier.carrierName copy];
                }
            }
            
        }
        
        return carrierName ;
    }
}

+(NSString*)getNowTimeStamp;
{
	NSTimeInterval servertime = [[NSDate date] timeIntervalSince1970] + localtimediff;
	
	NSString* timeStamp = [NSString stringWithFormat:@"%d", (int)servertime];
	
	return timeStamp;
}

+(NSTimeInterval)getNowTime
{
    NSTimeInterval servertime = [[NSDate date] timeIntervalSince1970] + localtimediff;
    return servertime;
}

+(NSDate*)getNowDate
{
    return [NSDate dateWithTimeIntervalSinceNow:localtimediff];
}

+(NSDate*)getDateFromStr:(NSString*)timestr formate:(NSString*)formatestr
{
	if (timestr == nil) {
		return nil;
	}
	if (formatestr == nil) 
	{
		formatestr = @"yyyy-MM-dd HH:mm:ss";
	}
	
	NSDateFormatter* dateFormat=[[NSDateFormatter alloc] init];
	
	[dateFormat setDateFormat:formatestr];
	
	NSDate* date = [dateFormat dateFromString:timestr];
	
	return date;
}

+(NSTimeInterval)getTimeIntervalFromStr:(NSString*)timestr formate:(NSString*)formatestr
{
	NSDate* time = [[self class] getDateFromStr:timestr formate:formatestr];
	if (time)
	{
		return [time timeIntervalSince1970];
	}
	return 0;
}

+(void)setServerTimeStamp:(NSString*)timeStamp
{
	NSTimeInterval serverTime = [timeStamp doubleValue];
	NSTimeInterval localTime = [[NSDate date] timeIntervalSince1970];
	localtimediff = serverTime - localTime;
}

+(void)showShoppingcartNumber{
	int num = 0;
	@autoreleasepool {
		NSArray * allData = [ShoppingCartData allObjects];
		for (ShoppingCartData* _d in allData) {
			num += _d.mnumber;
		}
		
		SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
		SCNViewController* viewCtrl = (SCNViewController*)delegate.viewController;
		[viewCtrl setBadgeNumber:num];
	}
}

+(void)saveShoppingcart:(ShoppingCartData*)aData{
	[ ShoppingCartData saveWithSku:aData.msku withProductCode:aData.mproductCode withNumber:aData.mnumber];
	[[self class] showShoppingcartNumber];
}

+(void)saveOffShoppingcart:(OffShoppingCartData*)aData{
	[ OffShoppingCartData saveWithSku:aData.msku withProductCode:aData.mproductCode withNumber:aData.mnumber];
	
	//[[self class] showShoppingcartNumber];
}

+(void)clearShoppingcart{
	for (ShoppingCartData* _data in [ShoppingCartData allObjects]) {
		[_data deleteObject];
	}
	[[self class] showShoppingcartNumber];
}

+(void)clearOffShoppingcart{
	for (OffShoppingCartData* _data in [OffShoppingCartData allObjects]) {
		[_data deleteObject];
	}
	[[self class] showShoppingcartNumber];
}

+(NSArray*)loadShoppingcart{
	return [ShoppingCartData allObjects];
}

+(NSMutableArray*)loadShoppingcartAndOffShoppingcart{
	NSMutableArray* allArr = [[NSMutableArray alloc]init];
	for (ShoppingCartData* _item in [ShoppingCartData allObjects]) {
		[allArr addObject:_item];
	}
	
	for (OffShoppingCartData* _item in [OffShoppingCartData allObjects]) {
		[allArr addObject:_item];
	}
	return allArr;
}

+(NSString*)getShoppingcartDataAndOffShoppingcartData{
	int nTag = 0;
	NSMutableString* skuRootString = [[NSMutableString alloc]init];
	
	for (ShoppingCartData* _data in [ShoppingCartData allObjects]) {
		NSString* skuString;
		
		if (nTag == 0) {
			skuString = [NSString stringWithFormat:@"%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];
		}else {
			skuString =	[NSString stringWithFormat:@"|%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];	
		}
		
		nTag = 1;
		
		[skuRootString appendString:skuString];
	}
	
	for (OffShoppingCartData* _data in [OffShoppingCartData allObjects]) {
        NSString* skuString;
		
		if (nTag == 0) {
			skuString =	[NSString stringWithFormat:@"%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];
		}else {
			skuString =	[NSString stringWithFormat:@"|%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];
		}
        
		nTag = 1;
		
		[skuRootString appendString:skuString];
    }
	return skuRootString;
}

+(NSString*)getShoppingcartData{
	int nTag = 0;
	NSMutableString* skuRootString = [[NSMutableString alloc] init];
	for (ShoppingCartData* _data in [ShoppingCartData allObjects]) {
		NSString* skuString;
		
		if (nTag == 0) {
				skuString = [NSString stringWithFormat:@"%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];
		}else {
				skuString =	[NSString stringWithFormat:@"|%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];	
		}
		
		nTag = 1;
		
		[skuRootString appendString:skuString];
	}
	return skuRootString;
}

+(NSString*)getOffShoppingcartData{
	int nTag = 0;
	NSMutableString* skuRootString = [[NSMutableString alloc] init];
	for (OffShoppingCartData* _data in [OffShoppingCartData allObjects]) {
        NSString* skuString;
		
		if (nTag == 0) {
			skuString =	[NSString stringWithFormat:@"%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];
		}else {
			skuString =	[NSString stringWithFormat:@"|%@-%@-%d",_data.mproductCode,_data.msku,_data.mnumber];
		}
        
		nTag = 1;
		
		[skuRootString appendString:skuString];
    }
	return skuRootString;
}

+(void)deleteOffShoppingcartData:(CartData*)data{
	[data deleteObject];
}

+(void)deleteShoppingcartData:(CartData*)data{
	[data deleteObject];
}

//判断是否请求成功
+(BOOL)isRequestSuccess:(GDataXMLDocument*)xmlDoc
{
	SCNRequestResultData* _data = [[SCNRequestResultData alloc] init];
	BOOL _success = [[self class] isRequestSuccess:xmlDoc requestData:_data];
	return _success;
}


//判断是否请求成功
+(BOOL)isRequestSuccess:(GDataXMLDocument*)xmlDoc requestData:(SCNRequestResultData*)requestData
{
	//网络错误
     
	if (xmlDoc==nil) 
	{
		if (!requestData.mNoShowSystemTip)
		{
			if (![[self class] isNetworkReachable])
			{
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"暂无网络连接，请稍后再试." delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alertView show];
			}
			else
			{
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"网络异常，请稍后重试." delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alertView show];
			}
		}
        requestData.merror_info = @"网络异常";
		return NO;
	}
	
	GDataXMLElement* _rootEle = [xmlDoc rootElement];
	SCNRequestResultData* _data = requestData;
	_data.mresult=[[_rootEle oneElementForName:@"result"] stringValue];
    _data.mmsg=[[_rootEle oneElementForName:@"msg"] stringValue];
	GDataXMLElement* infonode = [_rootEle oneElementForName:@"info"];
	if (_data.merror_Code == 0)
	{
		_data.merror_Code = [[[infonode oneElementForName:@"error_code"] stringValue] integerValue];
	}
	_data.merror_info = [[infonode oneElementForName:@"error_info"] stringValue];
	
	//stime;
	GDataXMLElement* stimenode = [infonode oneElementForName:@"stime"];
	if (stimenode)
	{
		[[self class] setServerTimeStamp:[stimenode stringValue]];
	}
	
	//weblogid	
	GDataXMLElement* weblogidnode = [infonode oneElementForName:@"weblogid"];
    
	NSString* newweblogid = [weblogidnode stringValue];
	
	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
	if (newweblogid && [newweblogid length] > 0 && ![newweblogid isEqualToString:userdata.mweblogid])
	{
		//weblogid失效
		userdata.mweblogid = newweblogid;
		[userdata save];
		//--自动登录
		if (requestData.merror_Code == 0)
		{
			requestData.merror_Code = EBE_WeblogidFailOrChange;
		}
	}
	NSLog(@"== isRequestSuccess: %@ ==", ([_data isSuccess]?@"YES":@"NO"));
	
	//相关处理
	NSString* _msg = _data.mmsg;
	
	if ([_data isSuccess])
	{
		if (_data.merror_Code > 0)
		{
			[[self class] DealWithBussinessErrorCode:_data];
		}
		return YES;
	}
	else
	{
		if (_msg && [_msg length] > 0)
		{
			if (!_data.mNoShowSystemTip)
			{
				//系统级别错误
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"系统维护" message:@"系统维护中，请稍后访问。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
				[alertView show];
			}
		}
		else
		{
			//业务错误
			[[self class] DealWithBussinessErrorCode:_data];
		}
		return NO;
	}
	return YES;
}


#pragma mark
#pragma 判断是否请求成功 JSON 
//判断是否请求成功
+(BOOL)isRequestSuccessJSON:(id)json_obj
{
	SCNRequestResultData* _data = [[SCNRequestResultData alloc] init];
	BOOL _success = [[self class] isRequestSuccessJSON:json_obj requestData:_data];
	return _success;
}

//判断是否请求成功
+(BOOL)isRequestSuccessJSON:(id)json_obj requestData:(SCNRequestResultData*)requestData
{
    //网络错误
	if (json_obj==nil)
	{
		if (!requestData.mNoShowSystemTip)//是否显示错误 这里可以自定义是否显示错误
		{
			if (![[self class] isNetworkReachable])
			{

                [UIAlertView alertViewWithTitle:GY_DEFAULT_TIP_TITLE
                                        message:@"无法连接网络，请稍后再试."
                              cancelButtonTitle:@"确定"];
                
			}
			else
			{

                [UIAlertView alertViewWithTitle:GY_DEFAULT_TIP_TITLE
                                        message:@"网络异常，请稍后重试."
                              cancelButtonTitle:@"确定"];

			}
		}
        requestData.merror_info = @"网络异常";
		return NO;
	}

    if( ![json_obj isKindOfClass:[NSDictionary class]] && [json_obj isKindOfClass:[NSMutableDictionary class]] ){
         //is not NSDictionary or not NSMutableDictionary
        
        [UIAlertView alertViewWithTitle:GY_DEFAULT_TIP_TITLE
                                message:@"数据解析出错 http json_obj 数据无法解析 不为dict"
                      cancelButtonTitle:@"确定"];

        
        NSLog(@"--==数据解析出错 http json_obj 数据无法解析 不为dict==--");
        return NO;
    }
    
//    if ([json_obj is_dict_key_empty_or_null:@"data"]) {
//        
//        [UIAlertView alertViewWithTitle:GY_DEFAULT_TIP_TITLE
//                                message:@"数据解析出错 http json_obj json_obj 为 nil 空"
//                      cancelButtonTitle:@"确定"];
//        
//        
//        NSLog(@"--==数据解析出错 http json_obj json_obj 为 nil 空 ==--");
//        return NO;
//    }

    
    SCNRequestResultData* _data = requestData;
    
    NSString* _status       =  (NSString*)[json_obj objectForKey:@"status"];
    NSString* _msg          =  (NSString*)[json_obj objectForKey:@"msg"];
    NSString* _err_code     =  (NSString*)[json_obj objectForKey:@"error_code"];//可能为空哦
    NSString* _error_info   =  (NSString*)[json_obj objectForKey:@"error_info"];//可能为空哦
	NSString* _stime        =  (NSString*)[json_obj objectForKey:@"ts"];//stime; 系统时间
    NSString* newweblogid   =  (NSString*)[json_obj objectForKey:@"weblogid"];
    
    _data.mresult= _status;
    _data.mmsg=_msg;
    
	if (_data.merror_Code == 0 && _err_code != Nil && ![_err_code isKindOfClass:[NSNull class]])
	{
		_data.merror_Code = [_err_code integerValue];
	}
	_data.merror_info = _error_info;//可能为空哦
	
	if (_stime)
	{
		[[self class] setServerTimeStamp:_stime];
	}

	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
	if (newweblogid && [newweblogid length] > 0 && ![newweblogid isEqualToString:userdata.mweblogid])
	{
		//weblogid失效
		userdata.mweblogid = newweblogid;
		[userdata save];
		//--自动登录
		if (requestData.merror_Code == 0)
		{
			requestData.merror_Code = EBE_WeblogidFailOrChange;
		}
	}
	NSLog(@"== isRequestSuccess: %@ ==", ([_data isSuccess]?@"YES":@"NO"));
	
	//相关处理

	if ([_data isSuccess])
	{
		if (_data.merror_Code > 0)
		{
			[[self class] DealWithBussinessErrorCode:_data];
		}
		return YES;
	}
	else
	{
		if (_data.mmsg && [_data.mmsg length] > 0)
		{
			if (!_data.mNoShowSystemTip)
			{
				//系统级别错误
	
                [UIAlertView alertViewWithTitle:@"系统维护"
                                        message:@"统维护中，请稍后访问。"
                              cancelButtonTitle:@"确定"];
                
                
                NSLog(@"具体的系统错误是 %d, error_info is %@ , msg 是 %@",_data.merror_Code,_data.merror_info,_data.mmsg);
			}
		}
		else
		{
            
            NSLog(@"具体的业务错误是 %d, error_info is %@",_data.merror_Code,_data.merror_info);

			//业务错误
			[[self class] DealWithBussinessErrorCode:_data];
		}
		return NO;
	}
	return YES;
}

+(void)DealWithBussinessErrorCode:(SCNRequestResultData*)requestData
{
	NSString* notifyStr = nil;
	BOOL showConfirm = NO;
	switch (requestData.merror_Code)
	{
		case EBE_WeblogidFailOrChange://WEBLOGID 失败
		case EBE_HasntLogin://未登录
		{
			//deal weblogid fail
			//成功情况
			if ([requestData isSuccess])
			{
				requestData.mNoShowTip = YES;
				YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
				//之前已登录－－－
				if ([userdata isUserLogin])
				{
					userdata.muserstatus = NO;
					[userdata save];
					//先自动登录，后还是登录不成功发注销通知
					[YKUserInfoUtility autoLoginBackLogout];//YK_LOGIN_OUT
				}
			}
			else
			{
				//之前未登录－－－提示未登录，发出通知，弹出登录界面
				YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
				
				if ([userdata isUserLogin])
				{
					//之前已登录－－－提示服务端异常，请重试，自动登录并当场将状态置为未登录，发出通知(可以后退界面)
					requestData.merror_info = @"网络不太稳定哦，请稍候。";
					userdata.muserstatus = NO;
					[userdata save];
					[YKUserInfoUtility autoLogin];
					notifyStr = YK_NO_LOGIN;
				}
				else
				{
					//未登录－－－
					requestData.merror_info = @"您尚未登录,请先登录!";
					notifyStr = YK_NO_LOGIN;
					showConfirm = YES;
				}
			}
		}
			break;
		case EBE_ProductFail://商品未找到(秒杀)
		{
			notifyStr = YK_NO_PRODUCT;
		}
			break;
		default:
			break;
	}
	
	if (!requestData.mNoShowTip)
	{
		if (showConfirm)
		{
			if ([ModalAlert confirm:SCN_DEFAULTTIP_TITLE message:requestData.merror_info])
			{
				requestData.mSelectConfirm = ERequestSelectConfirm;
			}
			else
			{
				requestData.mSelectConfirm = ERequestSelectCancel;
			}
		}
		else
		{
			[ModalAlert showTip:SCN_DEFAULTTIP_TITLE message:requestData.merror_info];
		}
	}
	if (notifyStr)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:notifyStr object:nil userInfo:nil];
	}
}

+(GDataXMLElement*)paserDataInfoNode:(GDataXMLDocument*)xmlDoc
{
	NSString* _datainfo = [NSString stringWithFormat:@"//shopex/info/data_info"];
	GDataXMLElement* datainfoNode = [xmlDoc oneNodeForXPath:_datainfo error:nil];	
	return datainfoNode;
}



+(BOOL)isNetworkReachable{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
/**
 判断是否需要更新
 */
+(void)updateApp{

    [[[SCNUpdate alloc] init]requestUpdateData];

}

+(void)save2BrowserData:(productDetail_Data*)data withProductCode:(NSString *)productCode withProductBn:(NSString*)productBn withImageUrl:(NSString *)imageUrl{
    
    //让数据保存的商品数不大于50，如果大于50就删除最前面的商品数据。
    NSArray* l_annelArray = [self getAllBrowserData];
    
    if ([l_annelArray count]>=MAX_BROWSER) {
        for (int i=1; i<=[l_annelArray count]-(MAX_BROWSER-1); i++) {
            [self deleteBrowserData:(SCNBrowserData *)[l_annelArray objectAtIndex:i-1]];
        }  
        
    }
    //mname,msex,mbrand,mpstatus,mmarketPrice,msellPrice
	SCNBrowserData* _browserData = [[SCNBrowserData alloc] init];
    _browserData.mproudctCode = productCode;
    _browserData.mimageUrl  = imageUrl;
    
	_browserData.mname = data.mname;
    _browserData.msex = data.msex;
    _browserData.mbrand = data.mbrand;
    _browserData.mpstatus = data.mpstatus;
    _browserData.mmarketPrice = data.mmarketPrice;
    _browserData.msellPrice = data.msellPrice;
    _browserData.mbn = data.mbn;
    
	[_browserData save];
}

+(NSArray*)getAllBrowserData{
	return [SCNBrowserData allObjects];
}

+(void)deleteBrowserData:(SCNBrowserData*)data{
	[data deleteObject];
}

+(void)makeCall:(NSString*)telnum
{	
	if ([[self class] checkDevice:DEVICETYPE_DESC_IPHONE] && [telnum length])
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否拨打热线电话?" message:telnum
													   delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"拨打",nil];
		[alert show];
		
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"本设备不支持拨号功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
	}
	
//#ifdef USE_BEHAVIOR_ENGINE
//	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_MOBILE param:nil];
//#endif
}

+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1)
	{
		NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",alertView.message]; //number为号码字符串    
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; 
	}
}

/**
 判断设备类型
 @param name 设备描述字符串
 @returns 是否是此类设备
 */
+(BOOL)checkDevice:(NSString*)name
{
    NSString* deviceType = [UIDevice currentDevice].model;  
    NSLog(@"deviceType = %@", deviceType);  
	
    NSRange range = [deviceType rangeOfString:name];  
    return range.location != NSNotFound;  
}  


@end
