//
//  SCNRejiggerPasswordViewController.h
//  SCN
//
//  Created by chenjie on 11-10-9.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//   修改密码控制器
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YKUserInfoUtility.h"

@interface SCNRejiggerPasswordViewController : BaseViewController <YKUserInfoUtilityDelegate,UIAlertViewDelegate> {
    
    UITextField* m_textfield_oldPassword;
    UITextField* m_textfield_newPassword;
    UITextField* m_textfield_RenewPassword;
    
    UIButton   *m_button_ensure;
}
@property (nonatomic, strong)IBOutlet  UIButton*  m_button_ensure;
@property (nonatomic, strong)IBOutlet  UITextField* m_textfield_oldPassword;
@property (nonatomic, strong)IBOutlet  UITextField* m_textfield_newPassword;
@property (nonatomic, strong)IBOutlet  UITextField* m_textfield_RenewPassword;
//- (IBAction)OnActionClearKeyBoard;
//确定修改密码
- (IBAction)OnActionRejiggerSucceedPressed:(id)sender;

//检测用户输入
-(BOOL)checkUserInput;



@end
