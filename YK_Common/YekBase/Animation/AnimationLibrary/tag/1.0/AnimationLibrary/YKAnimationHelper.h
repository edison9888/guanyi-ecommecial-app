//
//  YKAnimationHelper.h
//  YKAnimationLibrary
//
//  Created by guwei.zhou on 11-9-22.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKAnimationDelegate <NSObject>

-(void)YKAnimationDidStop:(UIView*)aView;

@end

/**
 动画类的代理对象
 */
@interface YKAnimationHelper : NSObject{
    UIView*                 m_view;
    BOOL                    m_isRemoveOnCompletion;
    id<YKAnimationDelegate> __unsafe_unretained m_delegate;
}
-(id)initWithView:(UIView*)aView delegate:(id)viewController removeOnCompletion:(BOOL)yesOrno;
@property (nonatomic,strong) UIView*                 m_view;
@property (nonatomic,assign) BOOL                    m_isRemoveOnCompletion;
@property (nonatomic,unsafe_unretained) id<YKAnimationDelegate> m_delegate;
@end
