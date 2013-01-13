//
//  YKAnimationConfig.h
//  YKAnimationLibrary
//
//  Created by guwei.zhou on 11-9-22.
//  Copyright 2011年 yek. All rights reserved.
//

/**
 动画类型
 */
typedef enum ANIMATIONTYPE{
    REVEAL,
    PUSH,
    MOVEIN,
    FADE
} YK_ANIMATION_TYPE;

/**
 动画运动方向
 */
typedef enum ANIMATIONDIRECTION{
    NONE,
    UPDOWN,
    DOWNUP,
    LEFTRIGHT,
    RIGHTLEFT
} YK_ANIMATION_DIRECTION;