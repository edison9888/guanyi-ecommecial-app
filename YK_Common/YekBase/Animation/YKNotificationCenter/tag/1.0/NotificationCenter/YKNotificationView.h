//
//  YKPushTipsView.h
//  MKHF
//
//  Created by guwei.zhou on 11-9-21.
//  Copyright 2011年 yek. All rights reserved.
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

@interface YKNotificationView : UIView{
    NSString*  m_kcaFromType;
    NSString*  m_kcaToType;
    NSString*  m_kcaAnimationType;
    float      m_tipsTime;
    NotificationPoint  m_pos;
    UIWindow*  m_appWindow;
}
@property (nonatomic,strong) NSString* m_kcaFromType;
@property (nonatomic,strong) NSString* m_kcaToType;
@property (nonatomic,strong) NSString*  m_kcaAnimationType;
@property (nonatomic,assign) float     m_tipsTime;
@property (nonatomic,assign) NotificationPoint m_pos;
@property (nonatomic,strong) UIWindow*  m_appWindow;

-(id)initWithMessage:(NSString*)message pos:(NotificationPoint)position delay:(float)seconds;
-(id)initWithView:(UIView*)aView pos:(NotificationPoint)position delay:(float)seconds;

-(void)show:(BOOL)animation;
-(void)showOnView:(UIView*)aView animation:(BOOL)yesOrNo;
@end
