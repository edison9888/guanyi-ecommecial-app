//
//  YKShopCartAnimationView.m
//  VANCL
//
//  Created by yek on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "YKAddShopCartAnimationView.h"

@interface YKAddShopCartAnimationView (hidden)

- (void)initData;
- (void)shopCartMoveIn;
- (void)releaseSelf:(id)_sender;
- (void)moveInStop;
- (void)goodsMovePath:(UIImageView *)_goods;
- (void)goodsRotate;

@end


@implementation YKAddShopCartAnimationView
@synthesize iv_goods;
@synthesize startPoint;
@synthesize endPoint;
@synthesize isFixStartPoint;
@synthesize delegate;

+(YKAddShopCartAnimationView*)animationView{
	YKAddShopCartAnimationView* animationView = [[YKAddShopCartAnimationView alloc] init];
	animationView.endPoint = CGPointMake(105, 400);
	return animationView;
}

+(YKAddShopCartAnimationView*)animationViewWithEndPoint:(CGPoint)endPoint{
	YKAddShopCartAnimationView* animationView = [[YKAddShopCartAnimationView alloc] init];
	animationView.endPoint = endPoint;
	return animationView;
}

+(YKAddShopCartAnimationView*)animationViewWithEndPoint:(CGPoint)endPoint withAnimationImage:(UIImage*)animationImage{
	YKAddShopCartAnimationView* animationView = [[YKAddShopCartAnimationView alloc] init];
	animationView.endPoint = endPoint;
	animationView.iv_goods.image = animationImage;
	return animationView;
}

+(YKAddShopCartAnimationView*)animationViewWithStartPoint:(CGPoint)startPoint WithEndPoint:(CGPoint)endPoint withAnimationImage:(UIImage*)animationImage{
    YKAddShopCartAnimationView* animationView = [[YKAddShopCartAnimationView alloc] init];
    
    animationView.isFixStartPoint = YES;
    animationView.startPoint = startPoint;
	animationView.endPoint = endPoint;
	animationView.iv_goods.image = animationImage;
	return animationView;
}

-(void)showAnimation{
	[[UIApplication sharedApplication].keyWindow addSubview:self];
	[self shopCartMoveIn];
}

-(id)init{
	self = [super init];
	if (self) {
		[self initData];
	}
	return self;
}

-(void)initData
{	
	/*创建商品图片*/
	iv_goods = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 52, 53)];
	
	[self addSubview:iv_goods];
	
	if(!iv_goods.image)
	{
		iv_goods.image=[UIImage imageNamed:@"avatar.png"];
	}
	if(iv_goods)
	{
		[[iv_goods layer]setBorderWidth:2];
		[[iv_goods layer]setBorderColor:[UIColor darkGrayColor].CGColor];
		[[iv_goods layer] setMasksToBounds:YES];
		[[iv_goods layer] setCornerRadius:10];
	}
	self.frame=CGRectMake(120, 40, 0, 0);
	iv_goods.hidden=NO;
}

- (void)dealloc {
	NSLog( @"[SYS]%@ Deallced.", [self class] );
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{	
	[iv_goods setHidden:YES];
	
	id name = [theAnimation valueForKey:@"name"];
	
	if([name isEqual:@"shopCartPath"])
	{
	}else if ( [name isEqual:@"goodsPath"] ) {
		[self releaseSelf:self];
	}                      
	
	
	[delegate AddShopCartAnimationDidStop:self];
}

-(void)releaseSelf:(id)_sender
{
	self.hidden=YES;
	[iv_goods.layer removeAllAnimations];
	[self removeFromSuperview];
}

-(void)shopCartMoveIn
{
    if ( isFixStartPoint == NO ) {
        startPoint=iv_goods.center;
    }
	
	[self moveInStop];
}

- (void)moveInStop{
	[self goodsMovePath:iv_goods];
	[self goodsRotate];
}
/**
	移动
 */


- (void)goodsMovePath:(UIImageView *)_goods {
	// Bounces the placard back to the center
	CALayer *goodsLayer = _goods.layer;
	
	// Create a keyframe animation to follow a path back to the center
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.fillMode = kCAFillModeForwards;
	bounceAnimation.removedOnCompletion = NO;
	bounceAnimation.delegate=self;
	CGFloat animationDuration = 0.5;
	CGMutablePathRef thePath = CGPathCreateMutable();
	
	CGFloat midX = startPoint.x;
	CGFloat midY = startPoint.y;
	
	CGPathMoveToPoint(thePath, NULL, midX, midY);
	
	CGPathAddCurveToPoint(thePath, NULL, 
						  startPoint.x-100, 
						  endPoint.y-50, 
						  startPoint.x-51,
						  endPoint.y-100, 
						  endPoint.x, 
						  endPoint.y);
	bounceAnimation.repeatCount = 0;
	bounceAnimation.path = thePath;
	bounceAnimation.duration = animationDuration;
	bounceAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	CGPathRelease(thePath);
	[bounceAnimation setValue:@"goodsPath" forKey:@"name"];
	[goodsLayer addAnimation:bounceAnimation forKey:@"animatePlacardViewToCenter"];
	
	[UIView beginAnimations:@"scale" context:nil];
	[UIView setAnimationDuration:animationDuration];
	CGAffineTransform transform = CGAffineTransformMakeScale(.4, .4);
	_goods.transform = transform;
	[UIView commitAnimations];
}

/**
	旋转
 */

- (void)goodsRotate {
	CALayer *layer = iv_goods.layer;
	layer.anchorPoint=CGPointMake(0.5, 0.5);
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue =@0.0f;
	animation.toValue = @3.1f;
	animation.duration=0.5;
	animation.autoreverses=YES;
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
	animation.repeatCount=1;
	[layer addAnimation:animation forKey:nil];
}

@end
