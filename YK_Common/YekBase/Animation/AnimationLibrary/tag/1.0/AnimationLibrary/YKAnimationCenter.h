//
//  YKAnimationCenter.h
//  YKAnimationLibrary
//
//  Created by guwei.zhou on 11-9-22.
//  Copyright 2011年 yek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKAnimationHelper.h"
#import "YKAnimationConfig.h"

#define DEFAULT_DELAY 0.6 //默认动画播放时间长度0.6秒

@interface YKAnimationCenter : NSObject
/**
 底层动画产生函数
 添加removedOnCompletion和fillMode原因，部分动画会因为这个参数导致闪烁现象
 removedOnCompletion默认值填YES
 fillMode默认值填kCAFillModeForwards
 animationHelper为nil时，函数将不会回调到当前视图控制器
 duration为动画的持续时间,默认为 DEFAULT_DELAY
 */
+(void)transition:(UIView*)aView animationType:(YK_ANIMATION_TYPE)type direction:(YK_ANIMATION_DIRECTION)direction removedOnCompletion:(BOOL)yesOrno fillMode:(NSString*)aFillMode delegate:(YKAnimationHelper*)animationHelper duration:(CFTimeInterval)duration;
+(void)transition:(UIView*)aView animationType:(YK_ANIMATION_TYPE)type direction:(YK_ANIMATION_DIRECTION)direction removedOnCompletion:(BOOL)yesOrno fillMode:(NSString*)aFillMode delegate:(YKAnimationHelper*)animationHelper;
/**
 简化封装动画函数，调用前先设置当前view hidden属性
 注意所有的dismiss函数，都会释放当前的UIView对象。其余的函数不会引起当前view的内存计数器加减
 */

/**
 push动画方式显示当前的view，支持所有方向
 */
+(void)AnimationPush:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction;
+(void)AnimationPush:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration;
/**
 pop动画方式dismiss当前view,支持所有方向(当前view内存计数减1)
 */
+(void)AnimationPop:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction;
+(void)AnimationPop:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration;
/*
MoveIn动画方式显示当前的view，支持所有方向
 */
+(void)AnimationMoveIn:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction;
+(void)AnimationMoveIn:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration;
/**
 目前AnimationMoveOut这个函数在调用时未符合期望,dismiss当前view(当前view内存计数减1)
 */
+(void)AnimationMoveOut:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction;
+(void)AnimationMoveOut:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration;
/*
 reveal动画方式显示当前的view
 */
+(void)AnimationRevealIn:(UIView*)aView;
+(void)AnimationRevealIn:(UIView*)aView duration:(CFTimeInterval)duration;
/**
 reveal动画方式dismiss当前view(当前view内存计数减1)
 */
+(void)AnimationRevealOut:(UIView*)aView;
+(void)AnimationRevealOut:(UIView*)aView duration:(CFTimeInterval)duration;
/*
 目前AnimationFadeIn这个函数在调用时未符合期望
 */
+(void)AnimationFadeIn:(UIView*)aView;
+(void)AnimationFadeIn:(UIView*)aView duration:(CFTimeInterval)duration;
/**
 fade动画方式dismiss当前view(当前view内存计数减1)
 */
+(void)AnimationFadeOut:(UIView*)aView;
+(void)AnimationFadeOut:(UIView*)aView duration:(CFTimeInterval)duration;
@end
