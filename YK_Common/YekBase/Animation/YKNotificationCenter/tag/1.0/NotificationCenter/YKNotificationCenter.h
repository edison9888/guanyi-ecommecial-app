//
//  YKTipsCenter.h
//  MKHF
//
//  Created by guwei.zhou on 11-9-21.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKNotificationView.h"
#import "YKNotificationConfig.h"

@interface YKNotificationCenter : NSObject

+(YKNotificationView*)pushTipsViewWithMessage:(NSString*)message pos:(NotificationPoint)pos;

+(YKNotificationView*)pushTipsViewWithView:(UIView*)aView pos:(NotificationPoint)pos;

@end

extern void notification(NSString* message, NotificationPoint pos);