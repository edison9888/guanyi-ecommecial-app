//
//  OrderInfoStatistic.m
//  scn
//
//  Created by fan wt on 11-8-4.
//  Copyright 2011 yek.com All rights reserved.
//

#import "OrderInfoStatistic.h"

#import "SCNDataInterface.h"
#import "YKStringUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "DataWorld.h"

@implementation OrderInfoStatistic
@synthesize muserid;
@synthesize mdata;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"muserid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mdata", @"@\"NSString\"")
				   )

-(void)dealloc{
	[muserid release];
	[mdata release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark 提交请求
/**
 提交订单
 */
-(void)postOrderinfo{
	/**
	 appkey	 软件身份key	 12087020
	 udid	 客户端设备ID	 asdfagqwerqw12315hfgj23462
	 userid	 用户id	 lei.guo@yek.me
	 sourceid	 推广id	 x_yek_001
	 ver	 通讯协议版本	 1.0
	 data	 订单数据	 <order  time="20101124" total="297.0">
						 <productlist>
						 <product  name="一定要填写,如果没有尺寸和颜色的，只需要填写一个商品名称即可"   sku="商品编号" amount="数量" price="金额">
						 <product  name="衬衫|白色|XL"  sku ="21341234" amount="1" price="99.0">
						 <product  name="衬衫|白色|XXL"  sku ="21341234" amount="1" price="99.0">
						 </productlist>
						 </order>
	 os	 操作系统名称	 Iphone、android 
	 */
	NSString* url = @"http://scn.250y.com:8181/scn/orderinfo.ashx";
	
	NSString* appkey = [SCNDataInterface commonParam:YK_KEY_APP_KEY];
	NSString* udid = [SCNDataInterface commonParam:YK_KEY_UDID];
	NSString* userid = [YKStringUtility strOrEmpty:muserid];
	NSString* sourceid = [SCNDataInterface commonParam:YK_KEY_SOURCEID];
	NSString* ver = [SCNDataInterface commonParam:YK_KEY_VER];
	NSString* data = [YKStringUtility strOrEmpty:mdata];
	NSString* os = [SCNDataInterface commonParam:YK_KEY_PLATFORM_N];
	
	NSDictionary* extraParam = [NSDictionary dictionaryWithObjectsAndKeys:
								appkey, YK_KEY_APP_KEY,
								udid, YK_KEY_UDID,
								userid, YK_KEY_USER_ID,
								sourceid, YK_KEY_SOURCEID,
								ver, YK_KEY_VER,
								data, @"data",
								os, @"os",
								nil];
	[YKHttpAPIHelper startLoad:url extraParams:extraParam object:self onAction:@selector(onPostOrderinfoResponse:)];
}

- (void)onPostOrderinfoResponse:(GDataXMLDocument*)xmlDoc{
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		[self deleteObject];
	}
}

@end
