//
//  YKAnimationCenter.m
//  YKAnimationLibrary
//
//  Created by guwei.zhou on 11-9-22.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKAnimationCenter.h"
#import "YKAnimationHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation YKAnimationCenter

+(void)transition:(UIView*)aView animationType:(YK_ANIMATION_TYPE)type direction:(YK_ANIMATION_DIRECTION)direction removedOnCompletion:(BOOL)yesOrno fillMode:(NSString*)aFillMode delegate:(YKAnimationHelper*)animationHelper{
    
    [[self class] transition:aView animationType:type direction:direction removedOnCompletion:yesOrno fillMode:aFillMode delegate:animationHelper duration:DEFAULT_DELAY];
}
+(void)transition:(UIView *)aView animationType:(YK_ANIMATION_TYPE)type direction:(YK_ANIMATION_DIRECTION)direction removedOnCompletion:(BOOL)yesOrno fillMode:(NSString *)aFillMode delegate:(YKAnimationHelper *)animationHelper duration:(CFTimeInterval)duration
{
    CATransition *transition = [CATransition animation];
	transition.duration = duration;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	transition.fillMode = aFillMode;
    
	transition.removedOnCompletion = yesOrno;
    
    switch (direction) {
        case UPDOWN:
            transition.subtype = kCATransitionFromBottom;
            break;
        case DOWNUP:
            transition.subtype = kCATransitionFromTop;
            break;
        case LEFTRIGHT:
            transition.subtype = kCATransitionFromLeft;
            break;
        case RIGHTLEFT:
            transition.subtype = kCATransitionFromRight;
            break;
        default:
            transition.subtype = kCATransition;
            break;
    }
    
    switch (type) {
        case REVEAL:
            transition.type = kCATransitionReveal;
            break;
        case MOVEIN:
            transition.type = kCATransitionMoveIn;
            break;
        case PUSH:
            transition.type = kCATransitionPush;
            break;
        case FADE:
            transition.type = kCATransitionFade;
        default:
            break;
    }
    
    /**
     viewController传空值可以不产生回调事件
     */
    if ( animationHelper != nil ) {
        transition.delegate = animationHelper;
    }
    
    [aView.layer addAnimation:transition forKey:[[aView class] description]];
}
+(void)AnimationPush:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction{
    [YKAnimationCenter transition:aView animationType:PUSH direction:direction removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil];
}

+(void)AnimationPush:(UIView *)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration
{
    [YKAnimationCenter transition:aView animationType:PUSH direction:direction removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil duration:duration];
}

+(void)AnimationPop:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction{
    [aView setHidden:YES];
     YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:PUSH direction:direction removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:animationHelper];
}

+(void)AnimationPop:(UIView *)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration
{
    [aView setHidden:YES];
    YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:PUSH direction:direction removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:animationHelper duration:duration];
}
+(void)AnimationMoveIn:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction{
    [YKAnimationCenter transition:aView animationType:MOVEIN direction:direction removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil];
}
+(void)AnimationMoveIn:(UIView *)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration
{
    [YKAnimationCenter transition:aView animationType:MOVEIN direction:direction removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil duration:duration];
}
+(void)AnimationMoveOut:(UIView*)aView direction:(YK_ANIMATION_DIRECTION)direction{
    [aView setHidden:YES];    
     YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:MOVEIN direction:direction removedOnCompletion:YES fillMode:kCAFillModeBackwards delegate:animationHelper];
}
+(void)AnimationMoveOut:(UIView *)aView direction:(YK_ANIMATION_DIRECTION)direction duration:(CFTimeInterval)duration
{
    [aView setHidden:YES];    
    YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:MOVEIN direction:direction removedOnCompletion:YES fillMode:kCAFillModeBackwards delegate:animationHelper duration:duration];
}
+(void)AnimationRevealIn:(UIView*)aView{
    [YKAnimationCenter transition:aView animationType:REVEAL direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil];
}
+(void)AnimationRevealIn:(UIView *)aView duration:(CFTimeInterval)duration
{
    [YKAnimationCenter transition:aView animationType:REVEAL direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil duration:duration];
}
+(void)AnimationRevealOut:(UIView*)aView{
    [aView setHidden:YES];    
    YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:REVEAL direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:animationHelper];
}
+(void)AnimationRevealOut:(UIView *)aView duration:(CFTimeInterval)duration
{
    [aView setHidden:YES];    
    YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:REVEAL direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:animationHelper duration:duration];
}
+(void)AnimationFadeIn:(UIView*)aView{
    [YKAnimationCenter transition:aView animationType:FADE direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil];
}
+(void)AnimationFadeIn:(UIView *)aView duration:(CFTimeInterval)duration
{
    [YKAnimationCenter transition:aView animationType:FADE direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:nil duration:duration];
}
+(void)AnimationFadeOut:(UIView*)aView{
    [aView setHidden:YES];    
     YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:FADE direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:animationHelper];
}
+(void)AnimationFadeOut:(UIView *)aView duration:(CFTimeInterval)duration
{
    [aView setHidden:YES];    
    YKAnimationHelper* animationHelper = [[YKAnimationHelper alloc] initWithView:aView delegate:nil removeOnCompletion:YES];
    [YKAnimationCenter transition:aView animationType:FADE direction:NONE removedOnCompletion:YES fillMode:kCAFillModeForwards delegate:animationHelper duration:duration];
}
@end
