//
//  YKAnimationHelper.m
//  YKAnimationLibrary
//
//  Created by guwei.zhou on 11-9-22.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKAnimationHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation YKAnimationHelper
@synthesize m_view;
@synthesize m_delegate;
@synthesize m_isRemoveOnCompletion;

-(id)initWithView:(UIView*)aView delegate:(id)viewController removeOnCompletion:(BOOL)yesOrno{
    self = [super init];
    if (self) {
        self.m_view = aView;
        self.m_isRemoveOnCompletion = yesOrno;
        self.m_delegate = viewController;
    }
    
    return self;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //回调
    if ( m_isRemoveOnCompletion ) {
        [m_view removeFromSuperview];
    }else{
        [m_delegate YKAnimationDidStop:m_view];
    }
    
    //动画播放完成之后，helper对象的使命结束
}

-(void)dealloc{
    #ifndef __OPTIMIZE__
    NSLog( @"[SYS]%@ dealloced", [self class] );
    #endif
}

@end
