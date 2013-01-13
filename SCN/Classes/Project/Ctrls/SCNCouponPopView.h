//
//  SCNCouponPopView.h
//  SCN
//
//  Created by huangwei on 11-9-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKNotificationConfig.h"

#define PUSH_TIPS_HOR_PERCENT 0.1     //按百分比调整小尺度 
#define PUSH_TIPS_VER_PERCENT 0.8     //按百分比调整大尺度
#define PUSH_TIPS_HEIGHT 20           //固定pushTips的高度
#define PUSH_TIPS_BORDER_RADIUS 8.0f  //边框圆角度数
#define PUSH_TIPS_BORDER_WIDTH 1.3f   //边框大小
#define PUSH_TIPS_POS_DIZZER 0.25      //上下悬框位置矫正
#define DEFAULT_SHOW_TIME 3.0f        //显示消息的默认时间


@interface SCNCouponPopView : UIView{
	UITableView* m_couponTableView;
	UITextField* m_couponField;
	UIButton* m_btnConfirm;
	
	UILabel* m_labTitle;
	
	UIWindow*  m_appWindow;
	
	NotificationPoint  m_pos;
	NSMutableDictionary* m_couponDic;
}

@property(nonatomic,retain)UITableView* m_couponTableView;
@property(nonatomic,retain)UITextField* m_couponField;
@property(nonatomic,retain)UIButton* m_btnConfirm;
@property(nonatomic,retain)UILabel* m_labTitle;
@property(nonatomic,retain)UIWindow*  m_appWindow;
@property (nonatomic,assign) NotificationPoint m_pos;
@property(nonatomic,retain)NSMutableDictionary* m_couponDic;

-(id)initWithView:(UIView*)aView pos:(NotificationPoint)position;

-(void)show:(BOOL)animation;
-(void)showOnView:(UIView*)aView animation:(BOOL)yesOrNo;

@end
