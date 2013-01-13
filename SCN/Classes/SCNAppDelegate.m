//
//  SCNAppDelegate.m
//  SCN
//
//  Created by yekmacminiserver on 11-9-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNAppDelegate.h"
#import "SCNViewController.h"
#import "DataWorld.h"
#import "BaseViewController.h"
#import "SCNHomeViewController.h"
#import "SCNClassifiedViewController.h"
#import "SCNSearchViewController.h"
#import "SCNShoppingcartViewController.h"
#import "SCNMoreViewController.h"
#import "StatusUtility.h"
#import "SCNStatusUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "YKUserInfoUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNDataInterface.h"
#import "YKStringHelper.h"
#import "YKGo2PageConfigLoader.h"
#import "YKStatBehaviorInterface.h"

@implementation SCNAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize m_string_deviceToken;
#pragma mark -
#pragma mark Application lifecycle


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
	//过期判断
	if ([self judgeAppTimeOut])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"测试版本" message:@"该测试版本已过期，请安装新包。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
		return YES;
	}
	
    
    
	[StatusUtility buildDBDataFile];
	
	
#ifdef TEST_FOR_CUSTOMER	//给客户版本
	
	m_application = application;
	m_launchOptions = launchOptions;
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"此版本为测试版本，您要继续运行吗？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否",nil];
	alertView.tag = 0;
	[alertView show];
	[alertView release];
#else    
	[self myapplication:application didFinishLaunchingWithOptions:launchOptions];
#endif
	
	//开启后台统计
	//[self startStatisticEngine];
	
	//开启行为统计
	//[YKStatBehaviorInterface logEvent_OperateWithOperateId:1001 param:@""];
//	[self startBehaviorEngine];
	
    


    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
#ifdef TEST_FOR_CUSTOMER
	if (buttonIndex == 0)
	{
		[self myapplication:m_application didFinishLaunchingWithOptions:m_launchOptions];
	}
	else
	{
		exit(0);
	}
#endif
}

// 注册通知
-(BOOL)registerPushNotification
{    // 先将数字置0    
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	// 注册push通知   
	NSLog(@"Initiating remoteNoticationssAreActive");     
	if( YES/*( (application.enabledRemoteNotificationTypes & UIRemoteNotificationTypeAlert)  
			&& (application.enabledRemoteNotificationTypes & UIRemoteNotificationTypeSound)
            && (application.enabledRemoteNotificationTypes & UIRemoteNotificationTypeBadge)
			) ) */ ) 
	{                
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)]; 
		return YES;           
	}        
	return NO;
}

-(BOOL)judgeAppTimeOut
{
	//判断当前包是否过期了
	//超期否
	if (![SCNStatusUtility checkDevice:@"Simulator"])
	{
		//真机
		NSTimeInterval nowtime = [SCNStatusUtility getNowTime];
		NSTimeInterval timeout = [SCNStatusUtility getTimeIntervalFromStr:TEST_TIMEOUT formate:nil];
		if (nowtime >= timeout && isTestSourceID())
		{
			return YES;
		}
	}
	return NO;
}

- (void)myapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
    // create database
	[UIApplication sharedApplication].statusBarHidden = YES;
	
	[KDataWorld setMainWindow:self.window];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUserClient:) name:YK_LOGIN_SUCCESS object:nil];


    
	[self createTabBar];
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
	
	//处理weblogid不存在情况
	[self dealWeblogid];
	
    //测试版本升级提示 TODO:
	[self performSelector:@selector(startVersionCheck) withObject:nil afterDelay:0.5];
	
	//注册push
	[self registerPushNotification];
}

-(void)dealWeblogid
{
#if 0
	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
	if(!userdata.mweblogid || [userdata.mweblogid length] == 0)
	{
		[[YKUserInfoUtility shareData] onrequesgetWeblogidUser:nil];
	}
#endif
}

-(void)startStatisticEngine
{
#ifdef USE_STATISTIC_ENGINE
	/**************统计订单信息和客户端信息***************/
    // App启动时，初始化统计引擎
    YK_StatisticEngine* m_statisticEngine = [YK_StatisticEngine sharedStatisticEngine];
    m_statisticEngine.m_str_url_time = [NSString stringWithFormat:@"%@%@",YK_MOBAPI_URL, @"time.php"];
    m_statisticEngine.m_str_url_clientInfo = [NSString stringWithFormat:@"%@%@",YK_MOBAPI_URL, @"client.php"];
    m_statisticEngine.m_str_url_orderInfo = [NSString stringWithFormat:@"%@%@",YK_MOBAPI_URL, @"order.php"];
    // 设置客户服务器的系统时间，这里测试时给本地时间
    [m_statisticEngine setCSDate:[NSDate date]];
    // 设置统计引擎的代理
    m_statisticEngine.delegate = self;
    // 开启统计引擎守护进程，设置提交频率，这里测试设置10秒提交一次
    [YK_StatisticEngine startStatisticDaemon:180];
    //统计装机量，三个地方需要，登录、启动、后台恢复
	YKUserDataInfo* userdata = [YKUserInfoUtility shareData].m_userDataInfo;
    [YK_StatisticEngine postClientInfoStatistic:userdata.musername userid:userdata.mweblogid];
	
    /****************************/
#endif
}

-(void)startBehaviorEngine
{
	/*************行为统计程序启动***************/
	[self appLaunchBehavior];
	/*************行为统计程序启动结束***************/
	[YKStatBehaviorInterface logEvent_PageJumpWithAimPath:@"/loading" param:@""];
	/*************行为统计APP启动开始***************/
	[self scnLaunchBehavior];
	/*************行为统计APP启动结束***************/
}

-(void)startVersionCheck
{
	[SCNStatusUtility updateApp];
}

#pragma -
#pragma mark 推送服务
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token=[[token description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken<><><><><><><><><><><><><><><>><><><><>><><>>%@",token);
    self.m_string_deviceToken=token;
    [self requestSubmitDeviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"FailToRegister error: %@",error);
#ifdef TEST_URL
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送服务注册失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
#endif
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	@autoreleasepool {		
		NSLog(@"remote notification----------------------------------------------------: %@",[userInfo description]);	
		NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];		NSString *alert = [apsInfo objectForKey:@"alert"];	
		NSLog(@"Received Push Alert: %@", alert);    	
//	NSString *sound = [apsInfo objectForKey:@"sound"];	
//	NSLog(@"Received Push Sound: %@", sound);	/////////AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);		
//	NSString *badge = [apsInfo objectForKey:@"badge"];	
//	NSLog(@"Received Push Badge: %@", badge);	
		application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];		
		if(alert!=nil)
		{
			UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"消息推送" message:alert delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];     
			[alertView show];		
		}
	}
}
#pragma mark 推送服务:请求提交设备DeviceToken
-(void)requestSubmitDeviceToken
{
	NSLog(@"请求提交设备DeviceToken<><><><><><><><><><><><><%@", self.m_string_deviceToken);
	if(!self.m_string_deviceToken || self.m_string_deviceToken.length == 0)
	{
		return;
	}
		
    /*
        act            对应接口的方法         N           submitToken
        api_version	API版本               N               1.0
        t              客户端时间戳           N          12087021
        weblogid                             N         123123
        ac             数据验证签名          N           POST提交的参数按照字母序升序组合+token，进行MD5加密
 
        device_token	设备Token	N	xxxxxxxxxxxxxxxxxxxxxxxxxx
     */ 
    
    NSDictionary* extraParam = @{@"act": YK_METHOD_SUBMIT_TOKEN,
                                @"device_token": self.m_string_deviceToken};
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestSubmitDeviceToken:)];

}
-(void)onRequestSubmitDeviceToken:(GDataXMLDocument*)xmlDoc
{
	SCNRequestResultData* _data = [[SCNRequestResultData alloc] init];
	_data.mNoShowTip = YES;
	_data.mNoShowSystemTip = YES;
    if (![SCNStatusUtility isRequestSuccess:xmlDoc requestData:_data]) {
    }else{
#ifdef TEST_URL
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交DeviceToken成功" message:self.m_string_deviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
#endif
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSLog(@"applicationWillResignActive");
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	/******************行为统计状态变化开始******************/
	[self statusChangeBehavior:1];
	/******************行为统计状态变化结束******************/
	
	[[NSNotificationCenter defaultCenter] postNotificationName:YK_RESIGN_ACTIVE object:nil];
	
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    // 版本是否需要升级
    //[SCNStatusUtility updateApp];
	
	[YK_StatisticEngine postClientInfoStatistic:[[YKUserInfoUtility shareData] m_userDataInfo].musername userid:[[YKUserInfoUtility shareData]m_userDataInfo].mweblogid];
    
    [self updateSystemTime];
}

-(void)updateSystemTime{
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:@"getServerTime" forKey:@"act"];
    [YKHttpAPIHelper startLoad:SCN_URL
				   extraParams:extraParamsDic
						object:self
					  onAction:@selector(onRequestGetServerTime:)];
}

-(void)onRequestGetServerTime:(GDataXMLDocument*)docXml
{
    SCNRequestResultData* _data = [[SCNRequestResultData alloc] init];
    _data.mNoShowTip = YES;
    _data.mNoShowSystemTip = YES;
    [SCNStatusUtility isRequestSuccess:docXml requestData:_data];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSLog(@"applicationDidBecomeActive");
	
	/******************行为统计状态变化开始******************/
	[self statusChangeBehavior:2];
	/******************行为统计状态变化结束******************/
	
	[[NSNotificationCenter defaultCenter] postNotificationName:YK_BECOME_ACTIVE object:nil];
    //如果需要重新提交DeviceToken则提交
    if (_isShouldRetrySubmitDeviceToken)
	{
        _isShouldRetrySubmitDeviceToken = NO;
        [self requestSubmitDeviceToken];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	/******************行为统计退出APP开始******************/
	[self exitScnBehavior];
	/******************行为统计退出APP结束******************/
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    KDataWorld.m_switchSizeData = nil;
}



-(void)createTabBar{
	// 5个主页
	SCNHomeViewController* _viewCtrl_1 = [[SCNHomeViewController alloc] initWithNibName:@"SCNHomeViewController" bundle:nil];
    
    // 商店地址地图信息
 
	SCNSearchViewController* _viewCtrl_2 = [[SCNSearchViewController alloc] initWithNibName:@"SCNSearchViewController" bundle:nil];
	SCNClassifiedViewController* _viewCtrl_3 = [[SCNClassifiedViewController alloc] initWithNibName:@"SCNClassifiedViewController" bundle:nil];
	SCNShoppingcartViewController* _viewCtrl_4 = [[SCNShoppingcartViewController alloc] initWithNibName:@"SCNShoppingcartViewController" bundle:nil];
	SCNMoreViewController* _viewCtrl_5 = [[SCNMoreViewController alloc] initWithNibName:@"SCNMoreViewController" bundle:nil];
	
	UINavigationController* _navCtrl_1 = [[UINavigationController alloc] initWithRootViewController:_viewCtrl_1];	
	UINavigationController* _navCtrl_2 = [[UINavigationController alloc] initWithRootViewController:_viewCtrl_2];
	UINavigationController* _navCtrl_3 = [[UINavigationController alloc] initWithRootViewController:_viewCtrl_3];
	UINavigationController* _navCtrl_4 = [[UINavigationController alloc] initWithRootViewController:_viewCtrl_4];
	UINavigationController* _navCtrl_5 = [[UINavigationController alloc] initWithRootViewController:_viewCtrl_5];
	
	[[self class] setNavigationShadow:_navCtrl_1];
	[[self class] setNavigationShadow:_navCtrl_2];
	[[self class] setNavigationShadow:_navCtrl_3];
	[[self class] setNavigationShadow:_navCtrl_4];
	[[self class] setNavigationShadow:_navCtrl_5];
	
	
	
	NSArray* _array_viewCtrl = @[_navCtrl_1, _navCtrl_2, _navCtrl_3, _navCtrl_4, _navCtrl_5];
	
	// 设置图片
	NSMutableDictionary* imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic setObject:[UIImage imageNamed:@"TabBar_1.png"] forKey:@"Default"];
	[imgDic setObject:[UIImage imageNamed:@"TabBar_1_SEL.png"] forKey:@"Seleted"];

	NSMutableDictionary* imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic2 setObject:[UIImage imageNamed:@"TabBar_2.png"] forKey:@"Default"];
	[imgDic2 setObject:[UIImage imageNamed:@"TabBar_2_SEL.png"] forKey:@"Seleted"];
	
	NSMutableDictionary* imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic3 setObject:[UIImage imageNamed:@"TabBar_3.png"] forKey:@"Default"];
	[imgDic3 setObject:[UIImage imageNamed:@"TabBar_3_SEL.png"] forKey:@"Seleted"];
	
	NSMutableDictionary* imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic4 setObject:[UIImage imageNamed:@"TabBar_4.png"] forKey:@"Default"];
	[imgDic4 setObject:[UIImage imageNamed:@"TabBar_4_SEL.png"] forKey:@"Seleted"];
	
	NSMutableDictionary* imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
	[imgDic5 setObject:[UIImage imageNamed:@"TabBar_5.png"] forKey:@"Default"];
	[imgDic5 setObject:[UIImage imageNamed:@"TabBar_5_SEL.png"] forKey:@"Seleted"];
	
	NSArray *imgArr = @[imgDic,imgDic2,imgDic3,imgDic4,imgDic5];
	
	CGFloat tabbarheight = [UIImage imageNamed:@"TabBar_1.png"].size.height;
	viewController = [[SCNViewController alloc] initWithViewControllers:_array_viewCtrl imageArray:imgArr withHeight:tabbarheight];
//	[viewController.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarBk.png"]];
//	viewController.tabBarArrowImage = [UIImage imageNamed:@"TabBarGlow.png"];
	NSMutableArray *l_array = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:(29.0f-135.0)],
							   [NSNumber numberWithFloat:(94.0f-135.0)],
							   [NSNumber numberWithFloat:(158.0f-135.0)],
							   [NSNumber numberWithFloat:(221.0f-135.0)],
							   [NSNumber numberWithFloat:(286.0f-135.0)], nil];
	viewController.array_tabBarX = l_array;
	[viewController setTabBarTransparent:YES];
}

+(void)setNavigationShadow:(UINavigationController*)navic
{
	CALayer* navLayer = navic.navigationBar.layer;
	if([navLayer respondsToSelector:@selector(setShadowColor:)])
	{
		navLayer.shadowColor = [UIColor blackColor].CGColor;
		navLayer.shadowRadius = 1;
		navLayer.shadowOpacity = 0.4;
		navLayer.shadowOffset = CGSizeMake(0, 1);
		navLayer.shouldRasterize = YES;
	}
}


- (void)saveUserClient:(NSNotification*)_notification{
	//YKUserDataInfo* datainfo = [YKUserInfoUtility shareData].m_userDataInfo;
}

/*
 *************统计订单信息和客户端信息****************
 */

#pragma mark -
#pragma mark YK_StatisticEngineDelegate Methods
/**
 获取推广ID
 */
-(NSString*)sourceid{
    return [SCNStatusUtility getSourceId];
}

/**
 获取推广子ID
 */
-(NSString*)sourcesubid{
    return [SCNStatusUtility getSubSourceId];
}

/**
 获取AppName
 */
-(NSString*)productcode
{
	return @"scn";
}

/**
 获取通信协议版本
 */
-(NSString*)ver{
    return YK_VALUE_API_VERSION;
}


/**
 程序启动行为统计
 */
-(void)appLaunchBehavior
{
#ifdef USE_BEHAVIOR_ENGINE
	[[YKGo2PageConfigLoader instance] loadGo2PageConfig];
	
	NSString* _productCode = [self productcode];//同行为统计
	NSString* _appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString* _sourceId = [SCNStatusUtility getSourceId];
	NSString* _sourceSubId = [SCNStatusUtility getSubSourceId];
	
	//NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *_appName = nil;
	//
	if (!_appName) {
		_appName = @"scn";//[bundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
	}
	
	NSString* _isRealUrl = nil;
#ifdef TEST_URL
	_isRealUrl = @"NO";
#else
	_isRealUrl = @"YES";
#endif

	//NSMutableDictionary* myDictParam = [NSDictionary dictionaryWithObjectsAndKeys:_productCode,YK_KEY_PRODUCTCODE,
//										_appversion,YK_KEY_APPVERSION,
//										_sourceSubId,YK_KEY_SOURCESUBID,
//										_appName,YK_KEY_APPNAME,
//										_isRealUrl,YK_KEY_ISREALURL,
//										_sourceId,YK_KEY_SOURCEID,
//										nil];
	
	NSMutableDictionary *myDictParam = [[NSMutableDictionary alloc]init];
    [myDictParam setObject:_productCode forKey:@"productcode"];
	[myDictParam setObject:_appversion forKey:@"appversion"];
	[myDictParam setObject:_sourceId forKey:@"sourceid"];
	[myDictParam setObject:_sourceSubId forKey:@"sourcesubid"];
	[myDictParam setObject:_appName forKey:@"appname"];
	[myDictParam setObject:_isRealUrl forKey:@"isrealurl"];
	
	NSLog(@"%@",_productCode);
	NSLog(@"%@",_appversion);
	NSLog(@"%@",_appName);
	NSLog(@"%@",_sourceId);
	NSLog(@"%@",_sourceSubId);
	NSLog(@"%@",_isRealUrl);
	
	[YKStatBehaviorInterface start:myDictParam];
#endif
}

/**
 APP启动行为统计
 */
-(void)scnLaunchBehavior
{
#ifdef USE_BEHAVIOR_ENGINE
	[YKStatBehaviorInterface logEvent_AppStartupWithRunNum:0 version:YK_KEY_APPVERSION];
#endif	
}

/**
 状态变化行为统计
 */
-(void)statusChangeBehavior:(int)_statusValue
{
#ifdef USE_BEHAVIOR_ENGINE
	[YKStatBehaviorInterface logEvent_StateChange:_statusValue];
#endif
}

/**
 退出app行为统计
 */
-(void)exitScnBehavior
{
#ifdef USE_BEHAVIOR_ENGINE
	[YKStatBehaviorInterface logEvent_AppExit:1];
#endif
}
@end
