//
//  YKShopCartAnimationView.h
//  VANCL
//
//  Created by yek on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol YKAddShopCartAnimationDelegate;

@interface YKAddShopCartAnimationView : UIView {
	UIImageView *iv_goods;
	
	CGPoint startPoint;
	CGPoint endPoint;
	
	id<YKAddShopCartAnimationDelegate> __unsafe_unretained delegate;
    
    BOOL    isFixStartPoint;
}
@property(nonatomic,assign) CGPoint startPoint;
@property(nonatomic,assign) CGPoint endPoint;
@property(nonatomic,assign) BOOL    isFixStartPoint;
@property(nonatomic,strong) UIImageView *iv_goods;
@property(nonatomic,unsafe_unretained) id<YKAddShopCartAnimationDelegate> delegate;
-(void)showAnimation;
+(YKAddShopCartAnimationView*)animationView;
+(YKAddShopCartAnimationView*)animationViewWithEndPoint:(CGPoint)endPoint withAnimationImage:(UIImage*)animationImage;
+(YKAddShopCartAnimationView*)animationViewWithEndPoint:(CGPoint)endPoint;
+(YKAddShopCartAnimationView*)animationViewWithStartPoint:(CGPoint)startPoint WithEndPoint:(CGPoint)endPoint withAnimationImage:(UIImage*)animationImage;
@end

@protocol YKAddShopCartAnimationDelegate

-(void)AddShopCartAnimationDidStop:(YKAddShopCartAnimationView*)animationView;

@end


