//
//  UserStatistic.m
//  scn
//
//  Created by fan wt on 11-8-4.
//  Copyright 2011 yek.com All rights reserved.
//

#import "UserStatistic.h"

#import "SCNDataInterface.h"
#import "YKStringUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "DataWorld.h"


@implementation UserStatistic
@synthesize musername;
@synthesize muserid;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"musername", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"muserid", @"@\"NSString\"")
				   )

-(BOOL)existsInDB{
	SQLitePersistentObject* _userStatistic = [UserStatistic 
										  findFirstByCriteria:[NSString stringWithFormat:@"WHERE muserid='%@'", self.muserid]];
	if (_userStatistic) {
		return YES;
	}else {
		return NO;
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<UserStatistic.%d> musername:%@, muserid:%@", 
			[self pk], musername, muserid];
}

-(void)save{
	if (![self existsInDB]) {
		[super save];
	}else {
		NSLog(@"%@ 已存在。", self);
	}
}

-(void)dealloc{
	[musername release];
	[muserid release];
	[super dealloc];
}

#pragma mark -
#pragma mark 提交请求
-(void)postClientinfo{
	/**
	 appkey 软件身份key 12087020
	 udid 客户端设备ID 123qwerqwtf423246dfdh4434rhoo
	 os 操作系统名称 android:1434124125151515
	 osversion 操作系统版本 4.1
	 appversion APP 版本 1.0
	 userid 用户ID 12312
	 username 用户名 Jacky
	 devicename 终端名称 HTC Desire
	 sourceid 推广id x_yek_001
	 wantype 网络连接类型 Wifi、3G
	 carrier 运营商类型 中国移动
	 Ver 通讯协议版本 1.0
	 */
	NSString* url = @"http://scn.250y.com:8181/scn/clientinfo.ashx";
	
	NSString* productcode = [YKStringUtility strOrEmpty:[SCNDataInterface commonParam:YK_KEY_PRODUCTCODE]];
	NSString* udid = [SCNDataInterface commonParam:YK_KEY_UDID];
	NSString* macid = [YKStringUtility strOrEmpty:[SCNDataInterface commonParam:YK_KEY_MACID]];
	NSString* osname = [SCNDataInterface commonParam:YK_KEY_PLATFORM_N];
	NSString* osversion = [SCNDataInterface commonParam:YK_KEY_MODEL];
	NSString* appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString* username = [YKStringUtility strOrEmpty:musername];
	NSString* devicename = [SCNDataInterface commonParam:YK_KEY_MODEL];
	NSString* sourceid = [SCNDataInterface commonParam:YK_KEY_SOURCEID];
	NSString* sourcesubid = [YKStringUtility strOrEmpty:[SCNDataInterface commonParam:YK_KEY_SOURCESUBID]];
	NSString* wantype = [SCNDataInterface commonParam:YK_KEY_WANTYPE];
	NSString* carrier = [SCNDataInterface commonParam:YK_KEY_CARRIER];
	NSString* ver = [YKStringUtility strOrEmpty:[SCNDataInterface commonParam:YK_KEY_VER]];
	NSString* time = @"";
	NSString* sign = [YKStringUtility strOrEmpty:[YKStringUtility YKMD5:[NSString stringWithFormat:@"%@%@%@%@%@%@", productcode, udid, osname,sourceid,sourcesubid,time, nil]]]; 
	
	NSDictionary* extraParam = [NSDictionary dictionaryWithObjectsAndKeys:
								udid, YK_KEY_UDID,
								osname, YK_KEY_OSNAME,
								macid,YK_KEY_MACID,
								osversion, YK_KEY_OSVERSION,
								appversion, YK_KEY_APPVERSION,
								username, YK_KEY_USER_NAME,
								devicename, YK_KEY_DEVICENAME,
								sourceid, YK_KEY_SOURCEID,
								sourcesubid,YK_KEY_SOURCESUBID,
								wantype, YK_KEY_WANTYPE,
								carrier, YK_KEY_CARRIER,
								ver, YK_KEY_VER,
								time,YK_KEY_TIME,
								sign,YK_KEY_SIGN,
								nil];
    [YKHttpAPIHelper startLoad:url extraParams:extraParam object:self onAction:@selector(onPostClientinfoResponse:)];
}

- (void)onPostClientinfoResponse:(GDataXMLDocument*)xmlDoc{
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		BOOL nBack = [UserFeedback isRequestSuccess:xmlDoc];
			
		[self deleteObject];
	}
}

@end

@implementation UserFeedback
@synthesize mresult;
@synthesize msessionid;
@synthesize mdesc;

DECLARE_PROPERTIES(
					DECLARE_PROPERTY(@"mresult", @"@\"NSString\""),
					DECLARE_PROPERTY(@"msessionid", @"@\"NSString\""),
				    DECLARE_PROPERTY(@"mdesc", @"@\"NSString\"")
)


-(void)dealloc{
	[mresult release];
	[msessionid release];
	[mdesc release];
	[super dealloc];
}

+(BOOL)isRequestSuccess:(GDataXMLDocument*)xmlDoc
{
	GDataXMLElement* _rootEle = [xmlDoc rootElement];
	UserFeedback* _data = [[UserFeedback alloc] init];
	_data.mresult=[[_rootEle oneElementForName:@"result"] stringValue];
	_data.msessionid = [[_rootEle oneElementForName:@"sessionid"] stringValue];
	_data.mdesc = [[_rootEle oneElementForName:@"desc"]stringValue];
	
	if (_data.msessionid) {
		[SCNDataInterface setCommonParam:YK_KEY_SESSIONID value:_data.msessionid];
	}
	[_data save];
	[_data release];
	return YES;
}

@end
