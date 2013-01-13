//
//  SCNRegistViewController.m
//  SCN
//
//  Created by chenjie on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import "SCNAppDelegate.h"
#import "SCNRegistViewController.h"
#import "YKHttpAPIHelper.h"
#import "YKStringUtility.h"
#import "SCNConfig.h"
#import "YKUserInfoUtility.h"
#import "SCNStatusUtility.h"
#import "YKUserInfoUtility.h"
#import "YKStatBehaviorInterface.h"
#import "SCNViewController.h"
@class SCNViewController;

#define VIEWTAG_BGVIEW       100
@implementation SCNRegistViewController



void alert(NSString* msg){
	UIAlertView* alert=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
}
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
               target:(id)target 
               action:(SEL)action
           withobject:(id)object{
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
    
    if (self) {
        self.m_quondamController = quondamViewCtr;
        self.m_nextController = nextViewCtr;
    }
    return self;
}

-(void)setup_test_register_field_text
{
    self.m_textField_name.text = @"gakaki";
    self.m_textField_passwd.text = @"z5896321";
    self.m_textField_rePasswd.text = self.m_textField_passwd.text;
}

-(IBAction)onRegisterButtonPressed:(id)sender
{
    
   if ([self checkUserInput]) {
        [self startLoading];
        [K_YKUserInfoUtility
         OnrequestRigsterUser:self.m_textField_name.text password:self.m_textField_passwd.text
                               m_delegate_Register:self];
   }
}

- (void)viewDidUnload
{
    _m_button_regist = nil;
    [super viewDidUnload];
    self.m_textField_name = nil;
    self.m_textField_passwd = nil;
    self.m_textField_rePasswd = nil;
    
}
-(void)dealloc{
    NSLog(@"注册页面dealloc调用");
}

//-(IBAction)onResignAllResponder:(id)sender {
//    NSLog(@"================");
//    [m_textField_name resignFirstResponder];
//    [m_textField_passwd resignFirstResponder];
//    [m_textField_rePasswd resignFirstResponder];
//   
//}
#pragma mark
#pragma mark  回调注册界面
-(void)CallbackRegister:(BOOL)success errMsg:(NSString*)msg
{
    [self stopLoading];
    NSLog(@"注册界面回调成功");
    if (success) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"恭喜您已成功注册为名鞋库会员." delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
		//[super BehaviorPageJump];
        
    }
       
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    SCNAppDelegate* delegate = (SCNAppDelegate*)([UIApplication sharedApplication].delegate);
    if (buttonIndex == 0) {
        if (self.m_nextController != nil) {
            
            [delegate.viewController dismissModalViewControllerAnimated:YES];
            
            [self.m_quondamController.navigationController pushViewController:self.m_nextController animated:YES];
        }else{
            
            if ([self.m_delegate respondsToSelector:m_SEL_action]) {
                [self.m_delegate performSelector:m_SEL_action withObject:m_object];
            }
            [delegate.viewController dismissModalViewControllerAnimated:YES];
        
        }
        
    }


}
#pragma mark
#pragma mark  点击登陆按钮
-(IBAction)loginButtonPressed:(id)sender 
{
    [self goBack];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.m_textField_name becomeFirstResponder];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户注册";
    self.pathPath = @"/register";
    UIView * _view_bgview = (UIView *) [self.view viewWithTag:VIEWTAG_BGVIEW];
    _view_bgview.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    UIImage * _buttonregist_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [_m_button_regist setBackgroundImage:[_buttonregist_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonregist_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [_m_button_regist setBackgroundImage:[_buttonregist_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
  
    [self setup_test_register_field_text];

}


#pragma mark
#pragma mark 判断输入框内容
-(BOOL)checkUserInput{
	NSString* str_Username = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:self.m_textField_name.text];
	NSString* str_Passwd = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:self.m_textField_passwd.text];;
	NSString* str_RePasswd = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:self.m_textField_rePasswd.text];
	
	if ([str_Username length]<1) {
		alert(@"请您输入邮箱或手机号码.");
		return NO;
	}
    //这里使用用户名 为邮箱或者手机号主要是为了方便用户找回他们的密码吧 估计
	else if (!([YKStringUtility isEmail:str_Username]||
               [YKStringUtility isMobileNum:str_Username])) {
		alert(@"您的账号输入有误，请输入合法的邮箱或手机号码.");
		return NO;
	}
	
	int int_passWdLength = [str_Passwd length];
	if (int_passWdLength<1) {
		alert(@"请您输入密码.");
		return NO;
	}else if (int_passWdLength<6||int_passWdLength>20) {
		alert(@"请您输入6~20位的密码长度.");
		return NO;
	}	
	if ([str_RePasswd length]<1) {
		alert(@"请您输入确认密码.");
		return NO;
	}else if (![str_Passwd isEqualToString:str_RePasswd]) {
		alert(@"您输入的两个密码不一致.");
		return NO;
	}
	
	return YES;
}

//-(void)BehaviorPageJump{
//#ifdef USE_BEHAVIOR_ENGINE
//#endif
//}

-(NSString*)pageJumpParam{
//#ifdef USE_BEHAVIOR_ENGINE
//	//NSString* _param = [NSString stringWithFormat:@"%@|%@",[[[YKUserInfoUtility shareData]m_userDataInfo] mweblogid],[[[YKUserInfoUtility shareData] m_userDataInfo] musername]];
////	return _param;
//	return nil;
//#else
//	return nil;
//#endif
	return nil;
}

@end
