//
//  YKUserInfoUtility.h
//  SCN
//
//  Created by chenjie on 11-10-10.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
#import "YKHttpEngine.h"
#import "SCNUserInformationData.h"

#define K_YKUserInfoUtility [YKUserInfoUtility shareData]

@interface YKUserDataInfo :  YK_BaseData

@property (nonatomic, strong) NSString* musername;   //用户名
@property (nonatomic, strong) NSString* mweblogid;  //用户ID
@property (nonatomic, assign) BOOL muserstatus;     //登陆状态
@property (nonatomic ,strong) NSString* mclass;     //用户等级 文字
@property (nonatomic ,strong) NSString* mconsume;   //消费总额：?
@property (nonatomic ,strong) NSString* mcouponNum; //优惠券数量
@property (nonatomic ,strong) NSString* mnewMessage;//新短信
@property (nonatomic ,strong) NSString* mresecuritycode;
@property (nonatomic, strong) NSString* mpassword;



-(BOOL)isUserLogin;
@end

@protocol YKUserInfoUtilityDelegate<NSObject>

@optional
//回调注册
-(void)CallbackRegister:(BOOL)success errMsg:(NSString*)msg;

//回调登陆
-(void)CallbackLogin:(BOOL)success errMsg:(NSString*)msg;

//回调注销
-(void)CallbackLogout:(BOOL)success errMsg:(NSString*)msg;

//回调修改密码
-(void)CallbackChangePassword:(BOOL)success errMsg:(NSString*)msg;

//获取验证码(提交手机号或者邮箱)
-(void)CallbackGetCheckcode:(BOOL)success errMsg:(NSString*)msg;

//验证校验码
-(void)CallbackCheckcode:(BOOL)success errMsg:(NSString*)msg;

//重置密码
-(void)CallbackResetPassword:(BOOL)success errMsg:(NSString*)msg;

//回调获取weblogid
-(void)CallbackgetWeblogid:(BOOL)success errMsg:(NSString*)msg;

@end


@interface YKUserInfoUtility : NSObject

@property (nonatomic, strong) YKUserDataInfo*	m_userDataInfo;     //用户登录数据
@property (nonatomic, strong) NSMutableDictionary* m_tempData;      //装载流程临时数据;
@property (nonatomic, assign) BOOL m_autoLogin_logout;              //自动登录失败后是否发注销通知

@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_login;                //登陆代理
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_Register;             //注册代理
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_Logout;               //注销代理
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_Password;             //修改密码

@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_ChangePassword;       //修改密码
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_GetCheckcode;         //获取验证码
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_Checkcode;            //验证校验码
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_ResetPassword;        //重置密码
@property (nonatomic, unsafe_unretained) id<YKUserInfoUtilityDelegate> m_delegate_getWeblogid;          //获取weblogid

+(YKUserInfoUtility*)shareData;

//解析user数据
-(void)paserUserDataInfo:(id)json_obj;

//请求注册
-(void)OnrequestRigsterUser:(NSString*)username password:(NSString*)password 
                           m_delegate_Register:(id<YKUserInfoUtilityDelegate>)delegate;

//请求登陆
-(void)OnrequestLoginUser:(NSString*)username password:(NSString*)password 
                           m_delegate_login:(id<YKUserInfoUtilityDelegate>)delegate;

//用户注销
-(void)onrequestLogoutUser:(id<YKUserInfoUtilityDelegate>)delegate;

 //修改密码
-(void)onrequestchangePassword:(NSString*)oldPassword password:(NSString*)newPassword 
                           m_delegate_ChangePassword:(id<YKUserInfoUtilityDelegate>)delegate;

//获取验证码(提交手机号或者邮箱)
-(void)onrequestGetCheckcode:(NSString*)username m_delegate_GetCheckcode:(id<YKUserInfoUtilityDelegate>)delegate;

//验证校验码
-(void)onrequesCheckcodeUser:(NSString*)verificationcode 
                           m_delegate_Checkcode:(id<YKUserInfoUtilityDelegate>)delegate;

//重置密码
-(void)onrequestResetPasswordUser:(NSString*)newpassword 
                           m_delegate_ResetPassword:(id<YKUserInfoUtilityDelegate>)delegate;

//获取weblogid
-(void)onrequesgetWeblogidUser:(id<YKUserInfoUtilityDelegate>)delegate;

// 用户是否登陆
+(BOOL)isUserLogin;
// 获取weblogid
+(NSString*)getWebLogid;

// 自动登录(用于服务器出问题了)
+(BOOL)JudgeNeedAndAutoLogin;//在需要的情况下会调用-(void)autoLogin

+(void)autoLogin;
+(void)autoLoginBackLogout;

//用户行为统计
-(void)doLoginBehavior;
-(void)doRegisterBehavior;
-(void)doLogoutBehavior:(YKUserDataInfo*)_userdata;
@end
