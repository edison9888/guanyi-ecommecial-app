//
//  SCNLoginViewController.h
//  SCN
//
//  Created by chenjie on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNMoreViewController.h"
#import "YKUserInfoUtility.h"
#import "SCNViewController.h"

@interface SCNLoginViewController : BaseViewController <UIAlertViewDelegate,YKUserInfoUtilityDelegate,UITextFieldDelegate> {
    
    SEL                     m_SEL_action;
    NSNumber                *m_connect_login;
    
}
@property (nonatomic, strong) id                     m_object;
@property (nonatomic, unsafe_unretained) id          m_delegate;
@property (nonatomic, strong) UIButton               *m_button_getbackpassword;
@property (nonatomic, strong) UIButton               *m_button_gobackmore;
@property (nonatomic, strong)IBOutlet UIButton       *m_button_login;
@property (nonatomic, strong)IBOutlet UIButton       *m_button_regist;
@property (nonatomic, strong)IBOutlet UITextField    *m_textField_userName;
@property (nonatomic, strong)IBOutlet UITextField    *m_textField_password;
@property (nonatomic, unsafe_unretained)BaseViewController      *m_quondamController;
@property (nonatomic, strong)BaseViewController      *m_nextController;
//取消所有第一响应
-(IBAction)resignAllFirstResponder:(id)sender;

//点击登陆按钮
-(IBAction)loginButtonPressed:(id)sender;

//点击注册按钮
-(IBAction)registButtonPressed:(id)sender;

//点击找回密码按钮
-(IBAction)onActionGetbackPassword:(id)sender;

//检测用户输入
-(BOOL)checkUserInput;

//注册界面初始化
- (id)initWithNibName:(NSString *)nibNameOrNil 
       quondamViewCtr:(BaseViewController*)quondamViewCtr 
          nextViewCtr:(BaseViewController*)nextViewCtr 
               bundle:(NSBundle *)nibBundleOrNil;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
               target:(id)target 
               action:(SEL)action
           withobject:(id)object;
//取消登陆模态视图
-(void)goback:(id)sender;

#pragma mark Behavior
//-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;

@end
