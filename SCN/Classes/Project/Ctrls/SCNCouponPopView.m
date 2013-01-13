//
//  SCNCouponPopView.m
//  SCN
//
//  Created by huangwei on 11-9-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCouponPopView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SCNCouponPopView
@synthesize m_couponTableView;
@synthesize m_couponField;
@synthesize m_btnConfirm;
@synthesize m_labTitle;
@synthesize m_couponDic;
@synthesize  m_pos;
@synthesize  m_appWindow;

-(void)initUIElements{
    
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

	int tipsWidth = contentViewSize.width * PUSH_TIPS_VER_PERCENT;
	int tipsHeight = contentViewSize.height * PUSH_TIPS_HOR_PERCENT;
	
	self.frame = CGRectMake( ( contentViewSize.width - tipsWidth )/2, ( contentViewSize.height - tipsHeight )/2 + contentViewSize.height*PUSH_TIPS_POS_DIZZER, tipsWidth, tipsHeight );

	UILabel* labTitle = [[UILabel alloc] initWithFrame:self.bounds];
	labTitle.textAlignment = UITextAlignmentCenter;
	labTitle.backgroundColor = [UIColor clearColor];
	labTitle.font = [UIFont systemFontOfSize:18];
	labTitle.textColor = [UIColor darkGrayColor];
	
	labTitle.text = @"或者请直接输入优惠券激活码";
	[self addSubview:labTitle];
	[labTitle release];
}

-(id)initWithView:(UIView*)aView{
    self = [super init];
    
    if (self) {
        
        [self initUIElements];
        
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
	transition.fillMode = kCAFillModeForwards;
	transition.removedOnCompletion = NO;
	[self.layer addAnimation:transition forKey:nil];
}

-(void)show:(BOOL)animation{
	
    if ( animation ) {
        [self doAnimationForShow];
    }
	
    [m_appWindow addSubview:self];
}

-(void)showOnView:(UIView*)aView animation:(BOOL)yesOrNo{
    
    if (yesOrNo) {
        [self doAnimationForShow];
    }
    
    [aView addSubview:self];
}

//动画隐藏view效果
-(void)doAnimationForDismiss{
    CATransition *transition = [CATransition animation];
	transition.duration = 0.6f;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
	transition.type = kCATransitionPush;
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

- (void)dealloc {
	[m_couponTableView release];
	[m_couponField release];
	[m_btnConfirm release];
	[m_labTitle release];
	[m_couponDic release];
	[m_appWindow release];
    [super dealloc];
}


@end
