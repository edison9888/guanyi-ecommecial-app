//
//  SCNRePasswordViewController.h
//  SCN
//
//  Created by chenjie on 11-10-9.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  验证验证码控制器
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YKUserInfoUtility.h"

@interface SCNRePasswordViewController : BaseViewController <YKUserInfoUtilityDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    
    NSString*    m_str_username;
    UITextField* m_textField_checkout;      //用户验证码
    
    UIButton*    m_button_checkout;         //重获验证码按钮
    UIButton*    m_button_next;             //下一步按钮
    
    NSTimer*     m_timer_checkoutNum;       //重获验证码时间
    int time;
    
}
@property (nonatomic, strong) NSString* m_str_username;
@property (nonatomic, strong) IBOutlet UITextField* m_textField_checkout;
@property (nonatomic, strong) IBOutlet UIButton* m_button_checkout;
@property (nonatomic, strong) IBOutlet UIButton* m_button_next;

//取消第一响应
//- (IBAction)onActionClearKeyBoard:(id)sender;
//进入修改密码界面
- (IBAction)onActionRejiggerPasswordView:(id)sender;
//改变重获验证码时间
-(void)changecheckoutNum;
//重新获取验证码
-(IBAction)onActionGetcheckoutbuttonpress:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil username : (NSString *)username;
- (BOOL)checkUserInput;

-(void)StarNstimer:(int)times;
@end
