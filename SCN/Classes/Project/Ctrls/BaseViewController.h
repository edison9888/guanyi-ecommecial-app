//
//  BaseViewController.h
//  SCN
//
//  Created by yekapple on 11-9-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataWorld.h"
#import "MBProgressHUD.h"
#import "YKButtonUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "JSONKit.h"

#import "NSString+NSString.h"
#import "WBNoticeView.h"
#import "SCNAppDelegate.h"

@interface BaseViewController : UIViewController<UIAlertViewDelegate>
{
	MBProgressHUD* m_loadingView;
	NSString *backButtonTitle;
	UIImageView *topImage;
	BOOL isHiddenBackButton;
	int loadingViewRetainCount;
    
    UILabel *m_label_Nocontent;
	
	BOOL isKeyboardPopup;
	NSString* pathPath;
	
	BOOL isGoBack;
}

@property (nonatomic, assign) int loadingViewRetainCount;
@property (nonatomic, assign) BOOL isHiddenBackButton;
@property (nonatomic, strong) NSString *backButtonTitle;
@property (nonatomic, assign) BOOL isKeyboardPopup;
// Loading view
@property (nonatomic, strong) MBProgressHUD* m_loadingView;
@property (nonatomic, strong) NSString* pathPath;
@property (nonatomic, assign) BOOL isGoBack;

// No note
@property (nonatomic, strong) UILabel *m_label_Nocontent;
@property (nonatomic,assign, readonly) BOOL isLoading;




- (void)dealBackButton;
-(UIButton*)createBackButton;
-(void)setBackButtonStyle:(UIButton*)backButton;
- (void)setBackText:(NSString *)text;
- (void)setBackText:(NSString *)text withButton:(UIButton*)backButton;

-(void)startLoading;
-(void)stopLoading;

-(void)goBack;

-(void)delayGoBack;



#pragma mark -
#pragma mark 可以重载的函数
// 一般是当前视图在Tabbar上重新点击时调用
-(void)reFreshVc;
-(BOOL)isNeedLogin;
-(void)dealWithNeedLogin;
-(void)NotifyNoLogin:(NSNotification *)notify;


-(void)BehaviorPageJump;

//显示无商品内容
-(void)showNotecontent:(NSString *)note;
//隐藏无商品内容
-(void)hideNotecontent;
@end
