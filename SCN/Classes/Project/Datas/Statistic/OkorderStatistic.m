//
//  OkorderStatistic.m
//  scn
//
//  Created by fan wt on 11-8-4.
//  Copyright 2011 yek.com All rights reserved.
//

#import "OkorderStatistic.h"

#import "SCNDataInterface.h"
#import "YKStringUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "DataWorld.h"

@implementation OkorderStatistic
@synthesize mproductcode;
@synthesize morderid;
@synthesize msessionid;
@synthesize mordermessage;
@synthesize muserid;
@synthesize musername;
@synthesize mfullname;
@synthesize mcellphone;
@synthesize mprovince;
@synthesize mcity;
@synthesize mcounty;
@synthesize maddress;
@synthesize mamount;
@synthesize mordertime;
@synthesize mitemdata;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"mproductcode", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"morderid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"msessionid",@"@\"NSString\""),
				   DECLARE_PROPERTY(@"mordermessage",@"@\"NSString\""),
				   DECLARE_PROPERTY(@"muserid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"musername", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mfullname", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mcellphone", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mprovince", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mcity", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mcounty", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"maddress", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mamount", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mordertime", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mitemdata", @"@\"NSString\"")
				   )

-(void)dealloc{
	[mproductcode release];
	[morderid release];
	[msessionid release];
	[mordermessage release];
	[muserid release];
	[musername release];
	[mfullname release];
	[mcellphone release];
	[mprovince release];
	[mcity release];
	[mcounty release];
	[maddress release];
	[mamount release];
	[mordertime release];
	[mitemdata release];
	
	[super dealloc];
}

-(BOOL)existsInDB{
	OkorderStatistic* _okorderStatistic = (OkorderStatistic*)[OkorderStatistic 
									 findFirstByCriteria:[NSString stringWithFormat:@"WHERE morderid is null"]];
	if (_okorderStatistic) {
		return YES;
	}else {
		return NO;
	}
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<OkorderStatistic.%d> morderid:%@, muserid:%@, musername:%@, mfullname:%@, mcellphone:%@, maddress:%@, mamount:%@", 
			[self pk], morderid, muserid, musername, mfullname, mcellphone, maddress, mamount];
}

-(void)save{
	if (![self existsInDB]) {
		[super save];
	}else {
	}
}

-(OkorderStatistic*)existsInDBWithOrderId:(NSString*)orderId{
	OkorderStatistic* _orderData = (OkorderStatistic*)[OkorderStatistic findByCriteria:[NSString stringWithFormat:@"WHERE morderid is null",orderId]];
	return _orderData;
}

-(void)saveSelf{
	if ([morderid isEqualToString:@""]) {
		//在提交订单前先保存没有订单号的订单详细
		[super save];
	}else {
		//已成功提交订单，在获得订单号后，再次更新上一次的订单详细
		OkorderStatistic* _okOrder = [self existsInDBWithOrderId:morderid];
		
		if (_okOrder) {//数据库中存在
			OkorderStatistic* _order = [[OkorderStatistic alloc] init];
			_order.morderid = morderid;
			_order.mproductcode = _okOrder.mproductcode;
			_order.msessionid = _okOrder.msessionid;
			_order.mordermessage = _okOrder.mordermessage;
			_order.muserid = _okOrder.muserid;
			_order.musername = _okOrder.musername;
			_order.mfullname = _okOrder.mfullname;
			_order.mcellphone = _okOrder.mcellphone;
			_order.mprovince = _okOrder.mprovince;
			_order.mcity = _okOrder.mcity;
			_order.mcounty = _okOrder.mcounty;
			_order.maddress = _okOrder.maddress;
			_order.mamount = mamount;
			_order.mordertime = _okOrder.mordertime;
			_order.mitemdata = _okOrder.mitemdata;
			[_okOrder deleteObject];
			[_order save];
			[_order release];
		}else {
			OkorderStatistic* _order = [[OkorderStatistic alloc] init];
			_order.morderid = morderid;
			_order.mproductcode = mproductcode;
			_order.msessionid = msessionid;
			_order.mordermessage = mordermessage;
			_order.muserid = muserid;
			_order.musername = musername;
			_order.mfullname = mfullname;
			_order.mcellphone = mcellphone;
			_order.mprovince = mprovince;
			_order.mcity = mcity;
			_order.mcounty = mcounty;
			_order.maddress = maddress;
			_order.mamount = mamount;
			_order.mordertime = mordertime;
			_order.mitemdata = mitemdata;
			[_order save];
			[_order release];
		}

	}

}

/**
 上传已确认订单
 */
-(void)postOkorder{
	/**
	 appkey	 软件身份key	 12087020
	 ver	 通讯协议版本	 1.0
	 sourceid	 推广id	 x_yek_001
	 orderid	 已成功订单ID，如果存在拆单情况，请用分隔符” |$”间隔，单个订单不需要加分隔符	 23542414|$132414|$431431243413
	 serverInfo	 提交订单接口返回的数据	 2
	 userid	 用户ID	 12312
	 username	 用户名	 Jacky
	 fullname	 接收人姓名	 张三
	 cellphone	 联系电话	 1394543531
	 address	 送货地址	 上海博霞路1号303
	 price	 订单价格	 13.1
	 os	 操作系统名称，全部小写	 iphone、android
	 */
	NSString* url = @"http://scn.250y.com:8181/scn/okorder.ashx";
	
	NSString* appkey = [SCNDataInterface commonParam:YK_KEY_APP_KEY];
	NSString* ver = [SCNDataInterface commonParam:YK_KEY_VER];
	NSString* sourceid = [SCNDataInterface commonParam:YK_KEY_SOURCEID];
	
	NSString* productcode = [YKStringUtility strOrEmpty:mproductcode];
	NSString* orderid = [YKStringUtility strOrEmpty:morderid];
	NSString* sessionid = [YKStringUtility strOrEmpty:msessionid];
	NSString* ordermessage = [YKStringUtility strOrEmpty:mordermessage];
	NSString* userid = [YKStringUtility strOrEmpty:muserid];
	NSString* username = [YKStringUtility strOrEmpty:musername];
	NSString* fullname = [YKStringUtility strOrEmpty:mfullname];
	NSString* cellphone = [YKStringUtility strOrEmpty:mcellphone];
	NSString* province = [YKStringUtility strOrEmpty:mprovince];
	NSString* city = [YKStringUtility strOrEmpty:mcity];
	NSString* county = [YKStringUtility strOrEmpty:mcounty];
	NSString* address = [YKStringUtility strOrEmpty:maddress];
	NSString* amount = [YKStringUtility strOrEmpty:mamount];
	NSString* ordertime = [YKStringUtility strOrEmpty:mordertime];
	NSString* curtime = @"";
	NSString* itemdata = [YKStringUtility strOrEmpty:mitemdata];
	
	NSString* os = [SCNDataInterface commonParam:YK_KEY_PLATFORM_N];
	
	NSDictionary* extraParam = [NSDictionary dictionaryWithObjectsAndKeys:
								appkey, YK_KEY_APP_KEY,
								ver, YK_KEY_VER,
								productcode,YK_KEY_PRODUCTCODE,
								sessionid,YK_KEY_SESSIONID,
								orderid, YK_KEY_ORDERID,
								ordermessage,YK_KEY_ORDERMESSAGE,
								userid, YK_KEY_USER_ID,
								username, YK_KEY_USER_NAME,
								fullname, YK_KEY_FULLNAME,
								cellphone, YK_KEY_CELLPHONE,
								address, YK_KEY_ADDRESS,
								amount, YK_KEY_AMOUNT,
								ordertime,YK_KEY_ORDERTIME,
								province,YK_KEY_PROVINCE,
								city,YK_KEY_CITY,
								county,YK_KEY_COUNTY,
								curtime,YK_KEY_TIME,
								itemdata,YK_KEY_ITEMDATA,
								
								os, @"os",
								nil];
	
	[YKHttpAPIHelper startLoad:url extraParams:extraParam object:self onAction:@selector(onPostOkorderResponse:)];
}

-(void)onPostOkorderResponse:(GDataXMLDocument*)xmlDoc{
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		[self deleteObject];
	}
}

@end
