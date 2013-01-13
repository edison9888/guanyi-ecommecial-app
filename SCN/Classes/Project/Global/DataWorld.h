//
//  DataWorld.h
//  Moonbasa
//
//  Created by user on 11-7-7.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"HJObjManager.h"
#import "HJManagedImageV.h"
#import "YK_DateUtility.h"
#import "YKStringUtility.h"
#import "YK_BaseData.h"
#import "HJImageUtility.h"
#import "SCNConfig.h"
#import "SCNHomeData.h"
#import "SCNSwitchSizeData.h"
#import "SCNBrowserData.h"

#define KDataWorld [DataWorld shareData]
@class GY_Collection_Home;

@interface DataWorld : NSObject
{
	UIWindow *__unsafe_unretained m_mainWindow;
    SCNHomeData *m_homeData;
    SCNSwitchSizeData *m_switchSizeData;
	SCNNowProductData* m_nowProductData;
	SCNNowClassifiedData* m_nowClassifiedData;
}
@property(nonatomic, strong) SCNHomeData *m_homeData;
@property(nonatomic, strong) SCNSwitchSizeData *m_switchSizeData;
@property(unsafe_unretained, nonatomic, readonly) UIWindow *mainWindow;
@property(nonatomic, strong) SCNNowProductData* m_nowProductData;
@property(nonatomic, strong) SCNNowClassifiedData* m_nowClassifiedData;
@property(nonatomic, strong) GY_Collection_Home* m_home;
+(DataWorld*)shareData;
- (void)setMainWindow:(UIWindow *)window;

// 获取程序启动次数
- (int)  getAppStartTimes;
// 设置程序启动次数
- (void) setAppStartTimes:(int)times;

//获取
-(NSString*)getSourceId;
-(NSString*)getSubSourceId;
-(void)reSetSourceId;
-(void)setSourceId:(NSString*)sourceId subSourceId:(NSString*)subSourceId;

//=================================================
// 获取资源路径
+ (NSString *)getResourcePath:(NSString*)path;
// 获取图片路径
+ (UIImage *)getImageWithFile:(NSString*)path;

//=================================================


@end


