//
//  SCNChangePasswordViewController.m
//  SCN
//
//  Created by chenjie on 11-10-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCNChangePasswordViewController.h"
#import "Go2PageUtility.h"

#define VIEWTAG_BGVIEW       100

@implementation SCNChangePasswordViewController

@synthesize m_textField_name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidUnload
{
    
    [super viewDidUnload];
    m_textField_name = nil;
    m_button_ensure = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    NSLog(@"重置密码dealloc调用");
}
#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_textField_name becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad
{
    self.title = @"找回密码";
	self.pathPath = @"/other";
    [super viewDidLoad];
    
    UIView * _view_bgview = (UIView *) [self.view viewWithTag:VIEWTAG_BGVIEW];
    _view_bgview.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    UIImage * _buttonregist_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [m_button_ensure setBackgroundImage:[_buttonregist_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonregist_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [m_button_ensure setBackgroundImage:[_buttonregist_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}
//- (IBAction)onActionClearKeyBoard:(id)sender
//{
//    [m_textField_name resignFirstResponder];
//
//}
- (IBAction)onActionRePassWord:(id)sender
{
    
    if ([self checkUserInput]) {
        [self startLoading];
        [K_YKUserInfoUtility onrequestGetCheckcode:m_textField_name.text m_delegate_GetCheckcode:self];    
    }
    
}
-(void)CallbackGetCheckcode:(BOOL)success errMsg:(NSString*)msg
{
    [self stopLoading];
    if (success) {
        [Go2PageUtility go2RePasswordController:self username:m_textField_name.text];
    }
    
    NSLog(@"=============%@",msg);
    
}
- (BOOL)checkUserInput{
    NSString* str_Username = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_textField_name.text];
    NSString* str_errorMsg = nil;
    if ([str_Username length]<1) {
		str_errorMsg =@"请您输入邮箱或手机号码.";
		
	}
	else if (!([YKStringUtility isEmail:str_Username]||
               [YKStringUtility isMobileNum:str_Username])) {
		str_errorMsg =@"您的账号输入有误，请输入合法的邮箱或手机号码.";
		
	}
    if (str_errorMsg != nil){
        UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
                                                          message:str_errorMsg 
                                                         delegate:nil 
                                                cancelButtonTitle:@"确定" 
                                                otherButtonTitles:nil];
        [alertView show];
        return NO;
    }

    return YES;
}

@end
