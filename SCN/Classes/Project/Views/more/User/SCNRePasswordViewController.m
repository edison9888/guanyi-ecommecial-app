//
//  SCNRePasswordViewController.m
//  SCN
//
//  Created by chenjie on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCNRePasswordViewController.h"
#import "Go2PageUtility.h"
#import "SCNResetPassWordViewController.h"
#import "YKStringUtility.h"

#define VIEWTAG_BGVIEW       100
#define LABLETAG_PHONE       101

@implementation SCNRePasswordViewController

@synthesize m_textField_checkout;
@synthesize m_button_checkout;
@synthesize m_button_next;
@synthesize m_str_username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil username : (NSString *)username
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_str_username = username;
        // Custom initialization
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_textField_checkout = nil;
    self.m_button_checkout = nil;
    self.m_button_next = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    NSLog(@"验证校验码dealloc调用");
    if ([m_timer_checkoutNum isValid] && m_timer_checkoutNum) {
        [m_timer_checkoutNum invalidate];
         m_timer_checkoutNum = nil;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self StarNstimer:time];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_textField_checkout resignFirstResponder];
    [self changecheckoutNum];
    if ([m_timer_checkoutNum isValid] && m_timer_checkoutNum) {
        [m_timer_checkoutNum invalidate];
        m_timer_checkoutNum = nil;
    }
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"验证码";
    self.pathPath = @"/other";
    UIView * _view_bgview = (UIView *) [self.view viewWithTag:VIEWTAG_BGVIEW];
    _view_bgview.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    UILabel * _label_phone = (UILabel *)[self.view viewWithTag:LABLETAG_PHONE];
    
    if ([YKStringUtility isPhoneNum:m_str_username]) {
        
        _label_phone.text = [NSString stringWithFormat:@"请等待并输入发送到手机:%@的短信验证码",m_str_username];
    }
    if ([YKStringUtility isEmail:m_str_username]) {
        
        _label_phone.text = [NSString stringWithFormat:@"邮件已发送到:%@,请即时查看您的邮箱",m_str_username];
    }
    UIImage * _buttonregist_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [m_button_next setBackgroundImage:[_buttonregist_normal stretchableImageWithLeftCapWidth:10 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonregist_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [m_button_next setBackgroundImage:[_buttonregist_select stretchableImageWithLeftCapWidth:10 topCapHeight:14] forState:UIControlStateHighlighted];
    
    UIImage * _buttonlogin_normal = [UIImage imageNamed:@"com_blackbtn.png"];
    [m_button_checkout setBackgroundImage:[_buttonlogin_normal stretchableImageWithLeftCapWidth:10 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonlogin_select = [UIImage imageNamed:@"com_blackbtn_SEL.png"] ;
    [m_button_checkout setBackgroundImage:[_buttonlogin_select stretchableImageWithLeftCapWidth:10 topCapHeight:14] forState:UIControlStateHighlighted];
    
    [self StarNstimer:60];

}
-(void)StarNstimer:(int)times
{
    time = times;
    if (!(m_timer_checkoutNum && [m_timer_checkoutNum isValid]))
    {
        m_timer_checkoutNum = [NSTimer scheduledTimerWithTimeInterval:1 
                                                               target:self 
                                                             selector:@selector(changecheckoutNum)
                                                             userInfo:nil 
                                                              repeats:YES];
       
    }
     m_button_checkout.enabled = NO;
}
#pragma mark
#pragma mark - 重新获取验证码时间
-(void)changecheckoutNum
{
    time--;
    NSLog(@"====================%d",time);
    NSString* title = [NSString stringWithFormat:@"重新获取验证码:(%ds)",time];
    if (m_button_checkout) {
        [m_button_checkout setTitle:title forState:UIControlStateNormal];
    }
    if (time <= 0)
    {
        if ([m_timer_checkoutNum isValid] ) {
            [m_timer_checkoutNum invalidate];
            m_timer_checkoutNum = nil;
        }
        if (m_button_checkout)
        {
            m_button_checkout.enabled = YES;
        }
    }
}

#pragma mark
#pragma mark - 进入密码重置界面
- (IBAction)onActionRejiggerPasswordView:(id)sender
{
    
    if ([self checkUserInput]) {
        [self startLoading];
        [K_YKUserInfoUtility onrequesCheckcodeUser:m_textField_checkout.text m_delegate_Checkcode:self];
    }
}
#pragma mark
#pragma mark - 重获验证码
-(IBAction)onActionGetcheckoutbuttonpress:(id)sender
{
    [self startLoading];
    [K_YKUserInfoUtility onrequestGetCheckcode:m_str_username m_delegate_GetCheckcode:self];

}
//验证码回调
-(void)CallbackGetCheckcode:(BOOL)success errMsg:(NSString*)msg
{
    [self stopLoading];
    if (success) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"您的验证码已下发,请注意查收" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        [self StarNstimer:60];    
    }
}
#pragma mark
#pragma mark - 回调校验验证码
-(void)CallbackCheckcode:(BOOL)success errMsg:(NSString*)msg
{ 
    NSLog(@"回调校验验证码界面成功");
    [self stopLoading];
    if (success) {
        [Go2PageUtility go2ResetPassWordController:self];
    }
    [m_textField_checkout resignFirstResponder];
     
}
- (BOOL)checkUserInput
{
    NSString * _str_checkout = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textField_checkout.text];
    if ([_str_checkout length] < 5) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"请输入6位正确的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}


@end
