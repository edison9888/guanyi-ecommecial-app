//
//  YK_CustomTabBarViewController.h
//  Moonbasa
//
//  Created by user on 11-7-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"
#import "BadgeView.h"

/**
	TabBar的背景色
 */
extern const NSString* TABBAR_IMAGE;

/**
	TabBar选中后的遮罩色
 */
extern const NSString* TABBAR_IMAGE_SELECTED;

/**
	选中TabBar后的图标背景底色
 */
extern const NSString* TABBAR_ITEM_SELECTED_BACKGROUND_IMAGE; //空则不显示

/**
	TabBar的选中效果图, 可以为空，空则不显示
 */
extern const NSString* TABBAR_GLOW_IMAGE; //空则不显示

/**
	TabBar的选中效果图, 可以为空，空则不显示
 */
extern const NSString* TABBAR_NIPPLE_IMAGE; //空则不显示


/**
	TabBar的第一个ViewController
 */
extern const NSString* YK_B2C_CLASS_PAGE_1;
/**
	TabBar的第一个ViewController的导航栏标题
 */
extern const NSString* YK_B2C_CLASS_PAGE_1_TITLE;
/**
 第一个TabBar的图标
 */
extern const NSString* YK_B2C_CLASS_PAGE_1_ICON;

/**
	TabBar的第二个ViewController
 */
extern const NSString* YK_B2C_CLASS_PAGE_2;
/**
	TabBar的第二个ViewController的导航栏标题
 */
extern const NSString* YK_B2C_CLASS_PAGE_2_TITLE;
/**
	第二个TabBar的图标
 */
extern const NSString* YK_B2C_CLASS_PAGE_2_ICON;

/**
	TabBar的第三个ViewController
 */
extern const NSString* YK_B2C_CLASS_PAGE_3;
/**
	TabBar的第三个ViewController的导航栏标题
 */
extern const NSString* YK_B2C_CLASS_PAGE_3_TITLE;
/**
	第三个TabBar的图标
 */
extern const NSString* YK_B2C_CLASS_PAGE_3_ICON;

/**
	TabBar的第四个ViewController
 */
extern const NSString* YK_B2C_CLASS_PAGE_4;
/**
	TabBar的第四个ViewController的导航栏标题
 */
extern const NSString* YK_B2C_CLASS_PAGE_4_TITLE;
/**
	第四个TabBar的图标
 */
extern const NSString* YK_B2C_CLASS_PAGE_4_ICON;

/**
	TabBar的第五个ViewController
 */
extern const NSString* YK_B2C_CLASS_PAGE_5;
/**
	TabBar的第无个ViewController的导航栏标题
 */
extern const NSString* YK_B2C_CLASS_PAGE_5_TITLE;
/**
	第五个TabBar的图标
 */
extern const NSString* YK_B2C_CLASS_PAGE_5_ICON;

@protocol YK_CustomTabBarViewControllerDelegate

-(void)onSelectedTabBar:(NSUInteger)itemIndex;

@end


@interface YK_CustomTabBarViewController : UIViewController 
<CustomTabBarDelegate>{
	id<YK_CustomTabBarViewControllerDelegate> delegate;
	CustomTabBar *m_customTabBar;
	
	UINavigationController *m_navCtrl_page_1;
	UINavigationController *m_navCtrl_page_2;
	UINavigationController *m_navCtrl_page_3;
	UINavigationController *m_navCtrl_page_4;
	UINavigationController *m_navCtrl_page_5;
	
	BadgeView *m_badgeView;
}
@property (nonatomic, assign) id<YK_CustomTabBarViewControllerDelegate> delegate;
@property (nonatomic, retain) CustomTabBar *m_customTabBar;
@property (nonatomic, assign) UINavigationController *m_navCtrl_page_1;
@property (nonatomic, assign) UINavigationController *m_navCtrl_page_2;
@property (nonatomic, assign) UINavigationController *m_navCtrl_page_3;
@property (nonatomic, assign) UINavigationController *m_navCtrl_page_4;
@property (nonatomic, assign) UINavigationController *m_navCtrl_page_5;

@property (nonatomic, retain) BadgeView *m_badgeView;

-(void)tabBarHidden:(BOOL)hidden;
-(void)setBadgeNumber:(int)_num;

@end