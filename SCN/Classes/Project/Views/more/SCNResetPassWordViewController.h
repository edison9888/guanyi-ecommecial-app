//
//  SCNResetPassWordViewController.h
//  SCN
//
//  Created by chenjie on 11-10-12.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  找回密码
#import <UIKit/UIKit.h>
#import "YKUserInfoUtility.h"
#import "BaseViewController.h"

@interface SCNResetPassWordViewController : BaseViewController<YKUserInfoUtilityDelegate,UIAlertViewDelegate> {
    
    IBOutlet UIButton      *m_button_ensure;
    
    UITextField            *m_textfield_newPassword;
    UITextField            *m_textfield_RenewPassword;

}
@property (nonatomic, strong)IBOutlet  UITextField* m_textfield_newPassword;
@property (nonatomic, strong)IBOutlet  UITextField* m_textfield_RenewPassword;

-(IBAction)onActionResetbuttonpress:(id)sender;
-(BOOL)checkUserInput;
@end
