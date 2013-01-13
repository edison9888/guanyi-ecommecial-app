//
//  SCNChangePasswordViewController.h
//  SCN
//
//  Created by chenjie on 11-10-9.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  获取验证码
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YKUserInfoUtility.h"

@interface SCNChangePasswordViewController : BaseViewController<YKUserInfoUtilityDelegate> {
    
    UITextField          *m_textField_name;
    IBOutlet UIButton    *m_button_ensure;
    
}
@property (nonatomic, strong) IBOutlet UITextField* m_textField_name;

//- (IBAction)onActionClearKeyBoard:(id)sender;

- (IBAction)onActionRePassWord:(id)sender;

- (BOOL)checkUserInput;
@end

