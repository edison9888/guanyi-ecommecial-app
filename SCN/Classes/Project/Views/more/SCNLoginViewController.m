//
//  SCNLoginViewController.m
//  SCN
//
//  Created by chenjie on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "YKHttpAPIHelper.h"
#import "SCNLoginViewController.h"
#import "SCNAppDelegate.h"
#import "Go2PageUtility.h"
#import "SCNMySCNController.h"
#import "SCNChangePasswordViewController.h"
#import "YKUserInfoUtility.h"
#import "SCNMoreViewController.h"
#import "YKStatBehaviorInterface.h"
#import "SCNDataInterface.h"
#import "SCNViewController.h"

#define VIEWTAG_BGVIEW       100

@implementation SCNLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
               target:(id)target 
               action:(SEL)action
           withobject:(id)object {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.m_delegate =target;
        m_SEL_action = action;
        self.m_object = object;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil quondamViewCtr:(BaseViewController*)quondamViewCtr 
                                                  nextViewCtr:(BaseViewController*)nextViewCtr 
                                                       bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];    
    if (self) 
    {
        self.m_quondamController = quondamViewCtr;
        self.m_nextController = nextViewCtr;
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_button_login = nil;
    self.m_button_regist = nil;
    self.m_textField_userName = nil;
    self.m_textField_password = nil;
	self.m_button_gobackmore = nil;
    self.m_button_getbackpassword = nil;
}
-(void)dealloc {
    NSLog(@"登陆界面的dealloc被调用");
     ///////////////////
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    self.m_textField_userName.text = @"";
    self.m_textField_password.text = @"";
    
    
    [self setup_test_login_field_text];

    
    //读数据库,取用户名;
}
#pragma mark - View lifecycle

-(void)setup_test_login_field_text
{
    self.m_textField_userName.text = @"gakaki@gmail.com";
    self.m_textField_password.text = @"z5896321";
}

- (void)viewDidLoad
{    [super viewDidLoad];
	
    
       
	self.pathPath = @"/login";
    
	self.m_button_gobackmore= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 48, 42)
                                                          title:@" 返回"
                                                    normalImage:@"com_backBtn.png"
                                                    highlighted:@"com_backBtn_SEL.png"];
	
	//customview
	UIView* leftcusview = [[UIView alloc] initWithFrame:self.m_button_gobackmore.frame];
	[leftcusview addSubview:self.m_button_gobackmore];
	
    UIBarButtonItem * _barbuttonItem_left = [[UIBarButtonItem alloc]initWithCustomView:leftcusview];
	
    [self.m_button_gobackmore addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem = _barbuttonItem_left;
	
    self.m_button_getbackpassword= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 80, 42)
                                                               title:@"找回密码"
                                                         normalImage:@"com_btn.png"
                                                         highlighted:@"com_btn_SEL.png"];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:self.m_button_getbackpassword.frame];
	[ricusview addSubview:self.m_button_getbackpassword];
    
    UIBarButtonItem * _barbuttonItem_right = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	
    [self.m_button_getbackpassword addTarget:self action:@selector(onActionGetbackPassword:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_right;
    
    UIView * _view_bgview = (UIView *) [self.view viewWithTag:VIEWTAG_BGVIEW];
    _view_bgview.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    self.title = @"用户登录";
    
    UIImage * _buttonregist_normal = [UIImage imageNamed:@"com_blackbtn.png"];
    [self.m_button_login setBackgroundImage:[_buttonregist_normal stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    
    UIImage * _buttonregist_select = [UIImage imageNamed:@"com_blackbtn_SEL.png"] ;
    [self.m_button_login setBackgroundImage:[_buttonregist_select stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    UIImage * _buttonlogin_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [self.m_button_regist setBackgroundImage:[_buttonlogin_normal stretchableImageWithLeftCapWidth:10 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonlogin_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [self.m_button_regist setBackgroundImage:[_buttonlogin_select stretchableImageWithLeftCapWidth:10 topCapHeight:14] forState:UIControlStateHighlighted];
    
}


//#pragma mark
//#pragma mark 取消输入框第一响应
-(IBAction)resignAllFirstResponder:(id)sender 
{
    [self.m_textField_userName resignFirstResponder];
    [self.m_textField_password resignFirstResponder];
}

#pragma mark
#pragma mark 登陆按钮
-(IBAction)loginButtonPressed:(id)sender 
{
	
//#ifdef TEST_FOR_CUSTOMER	//给客户版本
//    
//    [self startLoading];
//    [K_YKUserInfoUtility OnrequestLoginUser:m_textField_userName.text password:m_textField_password.text m_delegate_login:self];
//
//	
//#else    
    if ([self checkUserInput]) {
        [self startLoading];
        [K_YKUserInfoUtility OnrequestLoginUser:self.m_textField_userName.text password:self.m_textField_password.text m_delegate_login:self];
    }
//#endif
   
}
#pragma mark
#pragma mark 回调登录界面
-(void)CallbackLogin:(BOOL)success errMsg:(NSString*)msg{
    NSLog(@"回调登录界面成功");
    [self stopLoading];
    
    if (success) {
        
        SCNAppDelegate* delegate = (SCNAppDelegate*)([UIApplication sharedApplication].delegate);
        
        if (self.m_nextController != nil) {

            [delegate.viewController dismissModalViewControllerAnimated:YES];
            
            [self.m_quondamController.navigationController pushViewController:self.m_nextController animated:YES];
            
        }else{
            if ([self.m_delegate respondsToSelector:m_SEL_action]) {
                [self.m_delegate performSelector:m_SEL_action withObject:self.m_object];
            }
            
            [delegate.viewController dismissModalViewControllerAnimated:YES];

        }
        //[super BehaviorPageJump]; 
    }
       
		
} 

#pragma mark
#pragma mark 注册账号
-(IBAction)registButtonPressed:(id)sender 
{
    if (self.m_nextController == nil) {
        [Go2PageUtility showRegisterViewControlelr:self Target:self.m_delegate action:m_SEL_action withObject:self.m_object];
    }else{
        [Go2PageUtility go2RegisterController:self.m_quondamController viewCtrl:self nextViewCtr:self.m_nextController];
    }
    
}

#pragma mark
#pragma mark 找回密码
-(IBAction)onActionGetbackPassword:(id)sender 
{
    [Go2PageUtility go2ChangePasswordController:self];
}

#pragma mark
#pragma mark 判断文本输入内容
-(BOOL)checkUserInput{
	NSString* str_Username = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:self.m_textField_userName.text];
	NSString* str_Passwd = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:self.m_textField_password.text];;
	NSString* str_errorMsg = nil;
    
	if ([str_Username length]<1) {
		str_errorMsg =@"请您输入用户名.";
		
	}
    if (str_errorMsg != nil){
        UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE
                                                          message:str_errorMsg 
                                                         delegate:nil 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil];
        [alertView show];
        return NO;
    }

	int int_passWdLength = [str_Passwd length];
    
	if (int_passWdLength<1) {
		str_errorMsg =@"请您输入密码.";
		
	}	
    if (str_errorMsg != nil){
        UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE 
                                                          message:str_errorMsg 
                                                         delegate:nil 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    	return YES;
}

-(void)goback:(id)sender{
    
    
    SCNAppDelegate* delegate = (SCNAppDelegate*)([UIApplication sharedApplication].delegate);
    [delegate.viewController dismissModalViewControllerAnimated:YES];

}

//-(void)BehaviorPageJump{
//#ifdef USE_BEHAVIOR_ENGINE
//#endif
//}

-(NSString*)pageJumpParam{
	NSString* _param = nil;
#ifdef USE_BEHAVIOR_ENGINE
	//NSString* _param = [NSString stringWithFormat:@"%@|%@",[[[YKUserInfoUtility shareData]m_userDataInfo] mweblogid],[[[YKUserInfoUtility shareData] m_userDataInfo] musername]];
//	return _param;
	return _param;
#else
	return _param;
#endif
}

@end
