//
//  YKUserInfoUtility.m
//  SCN
//
//  Created by chenjie on 11-10-10.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "YKUserInfoUtility.h"
#import "YKStringUtility.h"
#import "YK_DateUtility.h"
#import "SCNConfig.h"
#import "YKHttpAPIHelper.h"
#import "SCNDataInterface.h"
#import "SCNStatusUtility.h"
#import "YKStatBehaviorInterface.h"

@implementation YKUserDataInfo

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"musername", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mweblogid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"muserstatus", @"@\"BOOL\""),
				   DECLARE_PROPERTY(@"mpassword", @"@\"NSString\"")
				   )

-(void)save{
	for (YKUserDataInfo *_i in [[self class] allObjects]) {
		[_i deleteObject]; 
	}
	NSLog(@"%@", self);
	[super save];
}

-(BOOL)isUserLogin
{
	if (self.mweblogid && [self.mweblogid length] > 0 && self.muserstatus)
	{
		return YES;
	}
	return NO;
}

@end

static YKUserInfoUtility* s_YKUserInfoUtility = nil;


@interface YKUserInfoUtility(hidden)
-(void)NotifyLogin;
-(void)NotifyLogout;

//请求自动登陆
-(void)requestAutoLogin:(NSString*)username password:(NSString*)password;
@end


@implementation YKUserInfoUtility



+(YKUserInfoUtility*)shareData
{
	@synchronized(self)
	{
		if (s_YKUserInfoUtility==nil)
		{
			s_YKUserInfoUtility = [[[self class] alloc] init];
            
		}
	}
	return s_YKUserInfoUtility;
}

-(id)init
{
	if (self == [super init])
	{
		NSArray* datainfoArray = [YKUserDataInfo allObjects];
		if (datainfoArray && [datainfoArray count])
		{
            _m_userDataInfo = [datainfoArray objectAtIndex:0];
		}
		else
		{
			_m_userDataInfo = [[YKUserDataInfo alloc] init];
		}
	}
	return self;
}


#pragma mark -
#pragma mark 用户注册接口
-(void)OnrequestRigsterUser:(NSString*)username password:(NSString*)password 
                                     m_delegate_Register:(id<YKUserInfoUtilityDelegate>)delegate; {
    
    self.m_tempData = [@{ @"YK_UESR_NAME" : username, @"YK_USER_PASSWORD" : password } mutableCopy];
    
    self.m_delegate_Register = delegate;
    
	NSString* v_method   =  [YKStringUtility strOrEmpty:MMUSE_METHOD_REGISTER];
	NSString* v_username = [YKStringUtility strOrEmpty:username];
	NSString* v_password = [YKStringUtility strOrEmpty:password];
	NSString* v_device_token = [YKStringUtility strOrEmpty:[SCNStatusUtility getDeviceToken]];
	
    NSDictionary* extraParam = @{@"method": v_method,
								@"username": v_username,
								@"password": v_password,
								@"device_token": v_device_token,
                                };
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(OnrResponseRigsterUser:)];
}
-(void)OnrResponseRigsterUser:(id)json_obj
{
	BOOL _isSuccess = [SCNStatusUtility isRequestSuccessJSON:json_obj];
	
	if (_isSuccess)
	{
		[self paserUserDataInfo:json_obj];
		[self doRegisterBehavior];
	}
	
    if ([self.m_delegate_Register respondsToSelector:@selector(CallbackRegister:errMsg:) ]) {
         
        [self.m_delegate_Register CallbackRegister:_isSuccess errMsg:nil] ;
    }
    
	//数据清理
	self.m_delegate_Register = nil;
	
	[self NotifyLogin];
}


#pragma mark -
#pragma mark 用户登陆接口
-(void)OnrequestLoginUser:(NSString*)username password:(NSString*)password 
                                      m_delegate_login:(id<YKUserInfoUtilityDelegate>)delegate;
{
    self.m_tempData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  username, @"YK_UESR_NAME",
                  password, @"YK_USER_PASSWORD",
                  nil];
    
    self.m_delegate_login = delegate;
	NSString* v_method =  [YKStringUtility strOrEmpty:MMUSE_METHOD_LOGIN];
	NSString* v_username = [YKStringUtility strOrEmpty:username];
	NSString* v_password = [YKStringUtility strOrEmpty:password];
	NSString* v_device_token = [YKStringUtility strOrEmpty:[SCNStatusUtility getDeviceToken]];
	
    NSDictionary* extraParam = @{@"method": v_method,
								@"username": v_username,
								@"password": v_password,
								@"device_token": v_device_token};	
	

    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parseLoginUserJSON:)];
    
}

//解析登陆回传数据
-(void)parseLoginUserJSON:(id)json_obj{
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccessJSON:json_obj] ;
    
    if (_isSuccess) {
		[self paserUserDataInfo:json_obj];
		[self doLoginBehavior];
    }
    if ([self.m_delegate_login respondsToSelector:@selector(CallbackLogin:errMsg:) ]) {
        
        [self.m_delegate_login CallbackLogin:_isSuccess errMsg:nil];
    }

    self.m_delegate_login = nil;
    [self NotifyLogin];
}

#pragma mark -
#pragma mark 用户注销接口
-(void)onrequestLogoutUser:(id<YKUserInfoUtilityDelegate>)delegate{
    
    self.m_delegate_Logout =delegate;

    NSString* v_method =  [YKStringUtility strOrEmpty:MMUSE_METHOD_LOGOUT];
    
    NSDictionary* extraParam = @{@"method": v_method};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parseLogoutUser:)];
}
//解析回传注销数据
-(void)parseLogoutUser:(id)json_obj{
    
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj];
    
	if (_isSuccess)
	{        
        YKUserDataInfo* datainfo = [[self class] shareData].m_userDataInfo;
		
		[self doLogoutBehavior:datainfo];
        
		NSString* weblogid = [json_obj objectForKey:@"weblogid"];
		if (weblogid)
		{
			datainfo.mweblogid = weblogid;
		}
        datainfo.muserstatus = NO;
        [datainfo save];
    }
	
	if ([self.m_delegate_Logout respondsToSelector:@selector(CallbackLogout:errMsg:) ]) {
        [self.m_delegate_Logout CallbackLogout:_isSuccess errMsg:nil] ;
    }
	
	self.m_delegate_Logout = nil;
    
    //发出通知
	[self NotifyLogout];
}
#pragma mark -
#pragma mark 修改密码接口
-(void)onrequestchangePassword:(NSString*)oldPassword password:(NSString*)newPassword 
     m_delegate_ChangePassword:(id<YKUserInfoUtilityDelegate>)delegate
{
    self.m_delegate_ChangePassword = delegate;
	self.m_tempData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
					   newPassword, @"YK_USER_PASSWORD",
					   nil];
	
	NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_MODIFYPASSWORD];
	NSString* v_oldpassword = [YKStringUtility strOrEmpty:oldPassword];
	NSString* v_newpassword = [YKStringUtility strOrEmpty:newPassword];
	
    NSDictionary* extraParam = @{@"act": v_method,
								@"oldPassword": v_oldpassword,
								@"newPassword": v_newpassword};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parsechangePassworduser:)];

}
//解析回传修改密码数据
-(void)parsechangePassworduser:(id)json_obj
{
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj];
	
	if (_isSuccess)
	{
		NSString* password = [self.m_tempData objectForKey:@"YK_USER_PASSWORD"];
		if (password)
		{
			 YKUserDataInfo* datainfo = [[self class] shareData].m_userDataInfo;
			datainfo.mpassword = password;
			[datainfo save];
		}
	}
    
    if ([self.m_delegate_ChangePassword respondsToSelector:@selector(CallbackChangePassword:errMsg:) ])
    {
		[self.m_delegate_ChangePassword CallbackChangePassword:_isSuccess errMsg:nil];
	}
	
	self.m_delegate_ChangePassword = nil;
    
}

#pragma mark -
#pragma mark 获取校验码
-(void)onrequestGetCheckcode:(NSString*)username m_delegate_GetCheckcode:(id<YKUserInfoUtilityDelegate>)delegate
{
    self.m_delegate_GetCheckcode = delegate;
	NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_REQUESTSECURITYCODE];
	NSString* v_data = [YKStringUtility strOrEmpty:username];
	
    NSDictionary* extraParam = @{@"act": v_method,
								@"data": v_data};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parsegetcheckoutUser:)];

}
//解析回传验证码数据
-(void)parsegetcheckoutUser:(id)json_obj
{
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj];
    if ([self.m_delegate_GetCheckcode respondsToSelector:@selector(CallbackGetCheckcode:errMsg:) ])
    {
		[self.m_delegate_GetCheckcode CallbackGetCheckcode:_isSuccess errMsg:nil];
    }
	
	self.m_delegate_GetCheckcode = nil;
}

#pragma mark -
#pragma mark 验证验证码
-(void)onrequesCheckcodeUser:(NSString*)verificationcode 
        m_delegate_Checkcode:(id<YKUserInfoUtilityDelegate>)delegate
{
    self.m_delegate_Checkcode = delegate;
	NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_VERIFYSECURITYCODE];
	NSString* v_securityCode = [YKStringUtility strOrEmpty:verificationcode];
	
    NSDictionary* extraParam = @{@"act": v_method,
								@"securityCode": v_securityCode};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parseCheckcodeUser:)];
}
-(void)parseCheckcodeUser:(id)json_obj{
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj]; 
    
    YKUserDataInfo *datainfo = [[self class] shareData].m_userDataInfo;
    
    if (_isSuccess) {
        
        NSMutableDictionary* _datainfo = [json_obj objectForKey:@"data"];
        if (!_datainfo)
        {
            return;
        }
        
        datainfo.mresecuritycode = [[_datainfo objectForKey:@"resecuritycode"] stringValue];

    }
    if ([self.m_delegate_Checkcode respondsToSelector:@selector(CallbackCheckcode:errMsg:) ])
    {
        [self.m_delegate_Checkcode CallbackCheckcode:_isSuccess errMsg:nil ];
    }

    //将用户验证码储存
    self.m_tempData = [@{@"YK_KEY_USER_securitycode": datainfo.mresecuritycode} mutableCopy];
    
    self.m_delegate_Checkcode = nil;
       
}
#pragma mark -
#pragma mark 重置密码
-(void)onrequestResetPasswordUser:(NSString*)newpassword 
         m_delegate_ResetPassword:(id<YKUserInfoUtilityDelegate>)delegate
{
    self.m_delegate_ResetPassword = delegate;
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_RESETPASSWORD];
	NSString* v_newpassword = [YKStringUtility strOrEmpty:newpassword];
    NSString* v_vcodeid = [YKStringUtility strOrEmpty:[self.m_tempData objectForKey:@"YK_KEY_USER_securitycode"]];
    
    NSLog(@"v_vcodeid:>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",v_vcodeid);
    NSDictionary* extraParam = @{@"act": v_method,
                                @"securitycode": v_vcodeid,
                                @"newPassword": v_newpassword};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parsePasswordUser:)];

    
    
}
-(void)parsePasswordUser:(id)json_obj{
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj];
    
    if ([self.m_delegate_ResetPassword respondsToSelector:@selector(CallbackResetPassword:errMsg:) ])
    {
        [self.m_delegate_ResetPassword CallbackResetPassword:_isSuccess errMsg:nil ];
    }
    
	self.m_delegate_ResetPassword = nil;
}
#pragma mark -
#pragma mark 获取weblogid
-(void)onrequesgetWeblogidUser:(id<YKUserInfoUtilityDelegate>)delegate;
{
    self.m_delegate_getWeblogid = delegate;
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_WEBLOGID];
	
    NSDictionary* extraParam = @{@"act": v_method};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parseGetweblogid:)];

}
-(void)parseGetweblogid:(id)json_obj
{
    BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj];
    
    if (_isSuccess) 
	{
        NSString* path_weblogid = [NSString stringWithFormat:@"//shopex/info/data_info/weblogid"];
		NSString* weblogidnode = [[json_obj objectForKey:@"path_weblogid"] stringValue];
		if (weblogidnode)
		{
			YKUserDataInfo* _userInfo = [[self class] shareData].m_userDataInfo;
			_userInfo.mweblogid = weblogidnode;
			[_userInfo save];
		}
    }

    if ([self.m_delegate_getWeblogid respondsToSelector:@selector(CallbackgetWeblogid:errMsg:) ])
    {
		[self.m_delegate_getWeblogid CallbackgetWeblogid:_isSuccess errMsg:nil];
    }
	
	self.m_delegate_getWeblogid = nil;
}
#pragma mark -
#pragma mark 用户信息相关

-(void)paserUserDataInfo:(id)json_obj
{
	if (!json_obj ||  ![json_obj objectForKey:@"data"] )
	{
		return;
	}
	NSMutableDictionary* user_info = [json_obj objectForKey:@"data"];
    
    if (!user_info )
	{
		return;
	}
    
	YKUserDataInfo* _userInfo = [[self class] shareData].m_userDataInfo;
    
    NSString* weblogid  = [json_obj objectForKey:@"weblogid"];
    
	if (weblogid)
	{
        _userInfo.mweblogid = weblogid;
	}
	
	NSString* password = [self.m_tempData objectForKey:@"YK_USER_PASSWORD"];
	if (password)
	{
		_userInfo.mpassword = password;
	}
	
    //这里要转换掉
	[_userInfo parseFromDictionary:user_info];
	_userInfo.muserstatus = YES;
	[_userInfo save];
}

+(BOOL)isUserLogin{
    
    YKUserDataInfo* datainfo = [[self class] shareData].m_userDataInfo;
	if (datainfo)
	{
		return [datainfo isUserLogin];
	}
	return NO;
}

+(NSString*)getWebLogid
{
	return [[self class] shareData].m_userDataInfo.mweblogid;
}

-(void)NotifyLogin
{
	// 发出登录通知
    if ([[self class] isUserLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YK_LOGIN_SUCCESS object:nil userInfo:nil];
    }
	
}

-(void)NotifyLogout
{
	// 发出登录通知
    if (![[self class] isUserLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YK_LOGIN_OUT object:nil userInfo:nil];
    }
}


#pragma mark -
#pragma mark 自动登录

+(BOOL)JudgeNeedAndAutoLogin
{
	//---自动登录
	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
	if ([userdata isUserLogin])
	{
		userdata.muserstatus = NO;
		[userdata save];
		[[self class] autoLogin];
		return YES;
	}
	return NO;
}

+(void)autoLogin
{
	YKUserDataInfo* datainfo = [[self class] shareData].m_userDataInfo;
	[[[self class] shareData] requestAutoLogin:datainfo.musername password:datainfo.mpassword];
}

+(void)autoLoginBackLogout
{
	[[self class] shareData].m_autoLogin_logout = YES;
	[[self class] autoLogin];
}

-(void)requestAutoLogin:(NSString*)username password:(NSString*)password
{
	if (!username || !password || [username length] == 0 || [password length] == 0)
	{
		return;
	}
	

	NSString* v_username = [YKStringUtility strOrEmpty:username];
	NSString* v_password = [YKStringUtility strOrEmpty:password];
	
    NSDictionary* extraParam = @{@"method": MMUSE_METHOD_LOGIN,
								@"username": v_username,
								@"password": v_password};	
	
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(parseAutoLogin:)];
}

//解析自动登陆回传数据
-(void)parseAutoLogin:(id)json_obj{
	
	SCNRequestResultData* _data = [[SCNRequestResultData alloc] init];
	_data.mNoShowTip = YES;
	_data.mNoShowSystemTip = YES;
	
	BOOL _isSuccess = [SCNStatusUtility isRequestSuccess:json_obj requestData:_data];
    if (_isSuccess)
	{
		[self paserUserDataInfo:json_obj];
		[self NotifyLogin];
    }
	else if(self.m_autoLogin_logout)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:YK_LOGIN_OUT object:nil userInfo:nil];
	}
	self.m_autoLogin_logout = NO;
	
}

-(void)doLoginBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@|%@",self.m_userDataInfo.musername,self.m_userDataInfo.mweblogid];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_LOGIN param:_param];
#endif
}

-(void)doRegisterBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@|%@",self.m_userDataInfo.musername,self.m_userDataInfo.mweblogid];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_REGISTER param:_param];
#endif
}

-(void)doLogoutBehavior:(YKUserDataInfo*)_userdata{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@|%@",_userdata.musername,_userdata.mweblogid];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_USERLOGOUT param:_param];
#endif	
}
 
@end