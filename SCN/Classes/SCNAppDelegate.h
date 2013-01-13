//
//  SCNAppDelegate.h
//  SCN
//
//  Created by yekmacminiserver on 11-9-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YK_StatisticEngine.h"
#import "YKUserInfoUtility.h"
#import "SCNAppDelegate.h"



#define KAppDelegate ((SCNAppDelegate*)([UIApplication sharedApplication].delegate))

@class SCNViewController;

@interface SCNAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate,YK_StatisticEngineDelegate> {
	UIApplication					*m_application;			// 运行启动参数
	NSDictionary					*m_launchOptions;		// 运行启动参数
    UIWindow						*window;				// 主窗口
	
    SCNViewController				*viewController;
    //PUSH相关
    BOOL _isShouldRetrySubmitDeviceToken;                     //是否重试提交DeviceToken;
    NSString *m_string_deviceToken;                         //用于推送的DeviceToken
    
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet SCNViewController *viewController;
@property (nonatomic, strong) NSString *m_string_deviceToken;

-(BOOL)judgeAppTimeOut;
- (void)myapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+(void)setNavigationShadow:(UINavigationController*)navic;
- (void)createTabBar;
// 处理没有weblogid存在的情况
-(void)dealWeblogid;
-(void)startStatisticEngine;
-(void)startBehaviorEngine;
-(BOOL)registerPushNotification;

- (void)saveUserClient:(NSNotification*)_notification;
-(void)requestSubmitDeviceToken;

#pragma mark Behavior
-(void)appLaunchBehavior;
-(void)scnLaunchBehavior;
-(void)statusChangeBehavior:(int)_statusValue;
-(void)exitScnBehavior;

-(void)updateSystemTime;
-(void)onRequestGetServerTime:(GDataXMLDocument*)docXml;

@end

