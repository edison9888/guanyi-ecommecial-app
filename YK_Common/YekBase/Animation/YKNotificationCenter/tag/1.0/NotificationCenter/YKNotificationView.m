//
//  YKPushTipsView.m
//  MKHF
//
//  Created by guwei.zhou on 11-9-21.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YKNotificationView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YKNotificationView
@synthesize  m_kcaFromType;
@synthesize  m_kcaToType;
@synthesize  m_tipsTime;
@synthesize  m_kcaAnimationType;
@synthesize  m_pos;
@synthesize  m_appWindow;

-(void)initUIElements:(NotificationPoint)position delay:(float)seconds{
    
    /**
     附加window策略
     1.使用最顶层的keyWindow
     2.如果keywindow为nil,UI操作失败
     */
    self.m_appWindow = [UIApplication sharedApplication].keyWindow;
    
    if ( m_appWindow == nil ) {
        return;
    }
    
    /**
     如果屏幕带statusbar,m_appWindow.frame.size高度减去statusBar高度 
    */    
    int statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGSize contentViewSize = CGSizeMake(m_appWindow.frame.size.width, m_appWindow.frame.size.height-statusBarHeight );
    
    self.backgroundColor = [UIColor lightTextColor];
    self.m_tipsTime = seconds;
    self.m_pos = position;
    
    /**
     屏幕layout适配
     */
    if ( self.m_pos == TOP ) {
        int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
        self.m_kcaAnimationType = kCATransitionPush;
        self.m_kcaFromType = kCATransitionFromBottom;
        self.m_kcaToType = kCATransitionFromTop;
        self.frame = CGRectMake( 0, statusBarHeight, contentViewSize.width, tipsHeight );
    }else if( self.m_pos == BOTTOM ){
        int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
        self.m_kcaAnimationType = kCATransitionPush;
        self.m_kcaFromType = kCATransitionFromTop;
        self.m_kcaToType = kCATransitionFromBottom;
        self.frame = CGRectMake( 0, contentViewSize.height - tipsHeight + statusBarHeight, contentViewSize.width, tipsHeight );
    }else if( self.m_pos == RIGHT ){
        self.m_kcaAnimationType = kCATransitionPush;
        self.m_kcaFromType = kCATransitionFromRight;
        self.m_kcaToType = kCATransitionFromLeft;
        int tipsWidth = contentViewSize.width * PUSH_TIPS_HOR_PERCENT;
        int tipsHeight = contentViewSize.height * PUSH_TIPS_VER_PERCENT;
        self.frame = CGRectMake( contentViewSize.width - tipsWidth, ( contentViewSize.height - tipsHeight )/2, tipsWidth, tipsHeight );
    }else if( self.m_pos == LEFT ){
        self.m_kcaAnimationType = kCATransitionPush;
        self.m_kcaFromType = kCATransitionFromLeft;
        self.m_kcaToType = kCATransitionFromRight;
        int tipsWidth = contentViewSize.width * PUSH_TIPS_HOR_PERCENT;
        int tipsHeight = contentViewSize.height * PUSH_TIPS_VER_PERCENT;
        self.frame = CGRectMake( 0, ( contentViewSize.height - tipsHeight )/2, tipsWidth, tipsHeight );
    }else if( self.m_pos == MIDDLE_UP_MOVE ){
        self.m_kcaAnimationType = kCATransitionMoveIn;
        self.m_kcaFromType = kCATransitionFromRight;
        self.m_kcaToType = kCATransitionFromRight;
        int tipsWidth = contentViewSize.width * PUSH_TIPS_VER_PERCENT;
        int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
        self.frame = CGRectMake( ( contentViewSize.width - tipsWidth )/2, ( contentViewSize.height - tipsHeight )/2 - contentViewSize.height*PUSH_TIPS_POS_DIZZER, tipsWidth, tipsHeight );
    }else if( self.m_pos == MIDDLE_DOWN_MOVE ){
        self.m_kcaAnimationType = kCATransitionMoveIn;
        self.m_kcaFromType = kCATransitionFromLeft;
        self.m_kcaToType = kCATransitionFromLeft;
        int tipsWidth = contentViewSize.width * PUSH_TIPS_VER_PERCENT;
        int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
        self.frame = CGRectMake( ( contentViewSize.width - tipsWidth )/2, ( contentViewSize.height - tipsHeight )/2 + contentViewSize.height*PUSH_TIPS_POS_DIZZER, tipsWidth, tipsHeight );
    }else if( self.m_pos == MIDDLE_UP_REVEAL ){
        self.m_kcaAnimationType = kCATransitionReveal;
        self.m_kcaFromType = kCATransitionReveal;
        self.m_kcaToType = kCATransitionReveal;
        int tipsWidth = contentViewSize.width * PUSH_TIPS_VER_PERCENT;
        int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
        self.frame = CGRectMake( ( contentViewSize.width - tipsWidth )/2, ( contentViewSize.height - tipsHeight )/2 - contentViewSize.height*PUSH_TIPS_POS_DIZZER, tipsWidth, tipsHeight );
    }else if( self.m_pos == MIDDLE_DOWN_REVEAL ){
        self.m_kcaAnimationType = kCATransitionReveal;
        self.m_kcaFromType = kCATransitionReveal;
        self.m_kcaToType = kCATransitionReveal;
        int tipsWidth = contentViewSize.width * PUSH_TIPS_VER_PERCENT;
        int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
        self.frame = CGRectMake( ( contentViewSize.width - tipsWidth )/2, ( contentViewSize.height - tipsHeight )/2 + contentViewSize.height*PUSH_TIPS_POS_DIZZER, tipsWidth, tipsHeight );
    }
    
    self.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1.0f].CGColor;
    self.layer.borderWidth = PUSH_TIPS_BORDER_WIDTH;
    self.layer.cornerRadius = PUSH_TIPS_BORDER_RADIUS;
}


-(id)initWithMessage:(NSString*)message pos:(NotificationPoint)position delay:(float)seconds{

    self = [super init];

    if (self) {
        
        [self initUIElements:position delay:seconds];
                
        UILabel* tipsContent = [[UILabel alloc] initWithFrame:self.bounds];
        tipsContent.textAlignment = UITextAlignmentCenter;
        tipsContent.backgroundColor = [UIColor clearColor];
        tipsContent.font = [UIFont systemFontOfSize:18];
        tipsContent.textColor = [UIColor darkGrayColor];
        
        tipsContent.numberOfLines = [message length];
        
        tipsContent.text = message;
        [self addSubview:tipsContent];
    }
    
    return self;
}

-(id)initWithView:(UIView*)aView pos:(NotificationPoint)position delay:(float)seconds{
    self = [super init];
    
    if (self) {
        
        [self initUIElements:position delay:seconds];
        
        [self addSubview:aView];
    }
    
    return self;
}

//动画显示view效果
-(void)doAnimationForShow{
    CATransition *transition = [CATransition animation];
	transition.duration = 0.6f;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	transition.type = kCATransitionPush;
	transition.subtype = m_kcaFromType;
	transition.fillMode = kCAFillModeForwards;
	transition.removedOnCompletion = NO;
	[self.layer addAnimation:transition forKey:nil];
}

-(void)show:(BOOL)animation{
   
    if ( animation ) {
        [self doAnimationForShow];
    }
        
    [m_appWindow addSubview:self];
    
    [NSTimer scheduledTimerWithTimeInterval:m_tipsTime target:self selector:@selector(onShowMessageFinish:) userInfo:nil repeats:NO];
}

-(void)showOnView:(UIView*)aView animation:(BOOL)yesOrNo{
    
    if (yesOrNo) {
        [self doAnimationForShow];
    }
    
    [aView addSubview:self];
    
    [NSTimer scheduledTimerWithTimeInterval:m_tipsTime target:self selector:@selector(onShowMessageFinish:) userInfo:nil repeats:NO];
}

//动画隐藏view效果
-(void)doAnimationForDismiss{
    CATransition *transition = [CATransition animation];
	transition.duration = 0.6f;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	transition.type = kCATransitionPush;
	transition.subtype = m_kcaToType;
    transition.delegate = self;
	transition.fillMode = kCAFillModeBackwards;
	transition.removedOnCompletion = YES;
	[self.layer addAnimation:transition forKey:nil]; 
}

-(void)onShowMessageFinish:(NSTimer*)showTimer{
    
    [showTimer invalidate];
    
    [self doAnimationForDismiss];
    
    [self setHidden:YES];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self removeFromSuperview];
}

-(void)dealloc{
    #ifndef __OPTIMIZE__
    NSLog( @"[SYS]%@ dealloced", [self class] );
    #endif
}

@end
