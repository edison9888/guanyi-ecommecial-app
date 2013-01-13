//
//  SCNRejiggerPasswordViewController.m
//  SCN
//
//  Created by chenjie on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "YKStatBehaviorInterface.h"
#import "SCNRejiggerPasswordViewController.h"
#import "Go2PageUtility.h"

#define VIEWTAG_BGVIEW       100

@implementation SCNRejiggerPasswordViewController

@synthesize m_textfield_oldPassword;
@synthesize m_textfield_newPassword;
@synthesize m_textfield_RenewPassword;
@synthesize m_button_ensure;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"修改密码dealloc调用");
}
#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_textfield_oldPassword = nil;
    self.m_textfield_newPassword = nil;
    self.m_textfield_RenewPassword = nil;
    self.m_button_ensure = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [m_textfield_oldPassword becomeFirstResponder];
    
}
- (void)viewDidLoad
{
    
	self.pathPath = @"/other";
    [super viewDidLoad];
    
    self.title = @"重置密码";
    
    UIView * _view_bgview = (UIView *) [self.view viewWithTag:VIEWTAG_BGVIEW];
    _view_bgview.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    UIImage * _buttonregist_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [m_button_ensure setBackgroundImage:[_buttonregist_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonregist_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [m_button_ensure setBackgroundImage:[_buttonregist_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
    
    [m_button_ensure addTarget:self action:@selector(OnActionRejiggerSucceedPressed:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_textfield_oldPassword resignFirstResponder];
    [m_textfield_newPassword resignFirstResponder];
    [m_textfield_RenewPassword resignFirstResponder];
}

- (void)OnActionRejiggerSucceedPressed:(id)sender
{
    if ([self checkUserInput]) {
        [K_YKUserInfoUtility onrequestchangePassword:m_textfield_oldPassword.text password:m_textfield_newPassword.text m_delegate_ChangePassword:self];
        [self startLoading];
    }
}

-(BOOL)checkUserInput
{
    NSString * user_oldpassword = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textfield_oldPassword.text];
    NSString * user_newpassword = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textfield_newPassword.text];
    NSString * user_renewpassword = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textfield_RenewPassword.text];
    
    NSString * errorMsg = nil;
    
    if ([user_oldpassword length] < 1) {
        errorMsg = @"请输入原密码.";
    }
    else if ([user_newpassword length] < 1){
        errorMsg = @"请输入新密码.";
    }
    else if ([user_newpassword length] < 6 || [user_newpassword length] > 20){
        errorMsg = @"请您输入6~20位的密码长度.";
    }
    else if ([user_renewpassword length] < 1){
        errorMsg = @"请输入确认密码.";
    }
    else if (![user_newpassword isEqualToString:user_renewpassword]){
        errorMsg = @"两次输入的密码不一致.";
    
    }
    if (errorMsg != nil) {
        UIAlertView* alert =[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE 
                                                          message:errorMsg 
                                                         delegate:nil 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil];
        [alert show];
        return NO;
    }

    return YES;
}
-(void)CallbackChangePassword:(BOOL)success errMsg:(NSString*)msg{
    [self stopLoading];
    if (success) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE 
                                                          message:@"密码修改成功." 
                                                         delegate:self 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil];
        [alert show];

    }
    NSLog(@"回调修改密码页面成功");
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if ([alertView.message isEqualToString:@"密码修改成功."]) {
        [self goBack];
    }
    
    
}

@end
