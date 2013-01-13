//
//  YKTipsCenter.m
//  MKHF
//
//  Created by guwei.zhou on 11-9-21.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKNotificationCenter.h"
#import <QuartzCore/QuartzCore.h>

@implementation YKNotificationCenter

+(YKNotificationView*)pushTipsViewWithMessage:(NSString*)message pos:(NotificationPoint)pos{
    YKNotificationView* tipsView = [[YKNotificationView alloc] initWithMessage:message pos:pos delay:3.0f];
    return tipsView;
}

+(YKNotificationView*)pushTipsViewWithView:(UIView*)aView pos:(NotificationPoint)pos{
    YKNotificationView* tipsView = [[YKNotificationView alloc] initWithView:aView pos:pos delay:3.0f];
    return tipsView;
}
@end

void notification(NSString* message, NotificationPoint pos){
    YKNotificationView* notificationView = [YKNotificationCenter pushTipsViewWithMessage:message pos:pos];
    [notificationView show:YES];
}