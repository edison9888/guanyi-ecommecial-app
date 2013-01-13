//
//  YKUserInfoUtility.m
//  SCN
//
//  Created by user on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "YKUserInfoUtility.h"
#import "YKStringUtility.h"

@implementation UserData

@synthesize mname;
@synthesize muserid;
@synthesize muserstyle;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"mname", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"muserid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"muserstyle", @"@\"NSString\"")
				   )
-(void)dealloc{
	[mname release];
	[muserid release];
	[muserstyle release];
	
	[super dealloc];
}

-(void)save{
	for (UserData* _i in [[self class] allObjects]) {
		[_i deleteObject];
	}
	NSLog(@"%@", self);
	[super save];
}
@end

static YKUserInfoUtility* s_YKUserInfoUtility = nil;

@implementation YKUserInfoUtility
+(YKUserInfoUtility*)shareData
{
	@synchronized(self)
	{
		if (s_YKUserInfoUtility==nil)
		{
			s_YKUserInfoUtility = [[self alloc] init];		
		}
	}
	return s_YKUserInfoUtility;
}
#pragma mark -
#pragma mark 登录请求
-(void)requestLoginInfoData{
	[self startLoading];
	isBusy = YES;
	/**
	 method	服务器相对应method的类名称	login
	 username	用户名	john@google.com
	 password	用户密码(密文)	6067fa88a29f566571ebf8d3506370bc
	 authtype	加密格式	md5
	 appkey	软件身份key	12087020
	 t	时间点,精确到秒	20101102164257
	 sourceid	推广id	101000@moon_iphone_1.0.0
	 weblogid	weblogid	6067fa88a29f566571ebf8d3506370bc
	 sign	数据验证签名	authtype指定的加密格式(密码+ appkey+时间点)
	 ver	通讯协议版本	1.0
	 
	 */
	NSString* method = [NSString stringWithFormat:@"%@", YK_METHOD_LOGIN];
	NSString* username = [YKStringUtility strOrEmpty:[m_textField_userName text]];
	NSString* password = [YKStringUtility YKMD5:[YKStringUtility strOrEmpty:[m_textField_userPasswd text]]];
	NSString* authtype = [NSString stringWithFormat:@"%@", YK_VALUE_AUTH_TYPE_MD5];
	NSString* appkey = [MoonbasaDataInterface commonParam:YK_KEY_APP_KEY];
	NSString* t = [YK_DateUtility NSDateToNSString:[NSDate date] withDateFormat:@"yyyyMMddHHmmss"];
	NSString* sourceid = [MoonbasaDataInterface commonParam:YK_KEY_SOURCE_ID];
	NSString* weblogid = [MoonbasaDataInterface commonParam:YK_KEY_WEBLOG_ID];
	NSString* sign = [YKStringUtility YKMD5:[NSString stringWithFormat:@"%@%@%@", sourceid, appkey, t, nil]];
	NSString* ver = [MoonbasaDataInterface commonParam:YK_KEY_VER];
	
	NSDictionary* extraParam = [NSDictionary dictionaryWithObjectsAndKeys:
								method, YK_METHOD,
								username, YK_KEY_USER_NAME,
								password, YK_KEY_PASSWORD,
								authtype, YK_KEY_AUTH_TYPE,
								appkey, YK_KEY_APP_KEY,
								t, YK_KEY_TIME,
								sourceid, YK_KEY_SOURCE_ID,
								weblogid, YK_KEY_WEBLOG_ID,
								sign, YK_KEY_SIGN,
								ver, YK_KEY_VER,
								nil];	
	
    [[KDataWorld httpEngineMoonbasa] startDefaultAsynchronousRequest:(NSString*)YK_URL_LOGIN
                                                          postParams:extraParam
                                                              object:self
                                                    onFinishedAction:@selector(onRequestLoginInfoData:)
                                                      onFailedAction:nil];
}

/**
 <home result="success" title="注册成功">
 <user name="lei.guo@yek.me" class="vip" point="123987" userid="02a653070a64d983c653015865f83ba8" />
 </home> 
 */
-(void)onRequestLoginInfoData:(ASIFormDataRequest*)_request{
    GDataXMLDocument *xmlDoc = [MoonbasaStatusUtility getXmlFromHttpRequest:_request];
    [self stopLoading];
	isBusy = NO;
	NSLog(@"== xmlDoc : %@ ==", xmlDoc);
	if (![MoonbasaStatusUtility isRequestSuccess:xmlDoc]) {
		return;
	}
	
	GDataXMLElement* rootEle = [xmlDoc rootElement];
	NSArray* array = [rootEle nodesForXPath:@"//home/user" error:nil];
	UserData* _userData = [[UserData alloc] init];
	for (GDataXMLElement* _e in array) {
		[_userData parseFromGDataXMLElement:_e];
		break;
	}
	// 保存到数据CommonParas
	[MoonbasaStatusUtility setUserWhenLogin:_userData];
	
	[_userData release];
	// 跳转页面返回
	[self.navigationController popViewControllerAnimated:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil
                                                   delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];    
    [alert release];
}


@end
