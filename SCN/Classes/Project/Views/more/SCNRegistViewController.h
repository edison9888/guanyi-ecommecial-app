//
//  SCNRegistViewController.h
//  SCN
//
//  Created by chenjie on 11-9-27.
//  Copyright 2011年 yek.me. All rights reserved.
//
//  密码重置控制器

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ASIFormDataRequest.h"
#import "YKUserInfoUtility.h"
#import "SCNMoreViewController.h"
#import "SCNAppDelegate.h"

@class SCNViewController;

@interface SCNRegistViewController : BaseViewController <YKUserInfoUtilityDelegate,UIAlertViewDelegate>{

    SEL                     m_SEL_action;
    id                      m_object;
    
}
@property (nonatomic, strong) id                     m_object;
@property (nonatomic, unsafe_unretained) id          m_delegate;

@property (nonatomic, strong)IBOutlet UIButton *m_button_regist;

@property (nonatomic, strong)IBOutlet UITextField *m_textField_name;
@property (nonatomic, strong)IBOutlet UITextField *m_textField_passwd;
@property (nonatomic, strong)IBOutlet UITextField *m_textField_rePasswd;
@property (nonatomic, unsafe_unretained) BaseViewController  *m_quondamController;
@property (nonatomic, strong) BaseViewController  *m_nextController;

-(IBAction)onRegisterButtonPressed:(id)sender;

//-(IBAction)onResignAllResponder:(id)sender;

-(IBAction)loginButtonPressed:(id)sender;

-(BOOL)checkUserInput;

- (id)initWithNibName:(NSString *)nibNameOrNil quondamViewCtr:(BaseViewController*)quondamViewCtr 
          nextViewCtr:(BaseViewController*)nextViewCtr 
               bundle:(NSBundle *)nibBundleOrNil;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
               target:(id)target 
               action:(SEL)action
           withobject:(id)object;

@end
