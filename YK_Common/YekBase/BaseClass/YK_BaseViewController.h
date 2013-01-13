//
//  YKBaseViewController.h
//  YK
//
//  Created by blackApple-1 on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YK_BaseViewController : UIViewController{
    NSString* mTitleString;
    BOOL      mKeyBoardLock;
    BOOL      mPickerLock;
    CGRect    mKeyBoardFrame;
    CGRect    mPickerFrame;
    CGRect    mOriginalFrame;
    BOOL      mOriginalFrameIsSet;
}

- (void)layOutUI;
/**
	页面跳转控制
 */
- (YK_BaseViewController*)logicParentViewController;
- (void)setGoBackButton;
// 模态状态下
- (void)setGoBackButtonInModel;
- (void)disableGoBackButton;
- (void)setLeftButton:(NSString*)buttonTitle action:(SEL)action;
- (void)setLeftImageButton:(NSString*)imageName action:(SEL)action;
- (void)setRightButton:(NSString*)buttonTitle action:(SEL)action;
- (void)setRightImageButton:(NSString*)imageName action:(SEL)action;
- (void)buttonAction_goBACK;
/**
	动画播放控制
 */
- (void)startUILoading;
- (void)stopUILoading;

- (void)startAsyncWebData;
- (void)onResponseWebData:(NSObject*)obj;
/**
    准备标题
 */
- (void)prepareTitle:(NSString*)title;
- (NSString*)titleString;

/*
 KeyBoard控制
 */
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)keyboardWasHidden:(NSNotification*)aNotification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWasHidden:(NSNotification*)aNotification;
- (void)keyboardForceHidden:(NSNotification*)aNotification;

- (void)pickerViewWillShow:(UIView *)pickerView;
- (void)pickerViewWasHidden:(UIView *)pickerView;
- (void)pickerViewWasForceHidden:(UIView *)pickerView;
@end
