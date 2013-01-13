//
//  YKBaseView.m
//  YK
//
//  Created by blackApple-1 on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_BaseView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YK_BaseView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)pushView:(UIView*)view withAnimation:(BOOL)animation{
	
	if (animation) {
		CATransition *transition = [CATransition animation];
		[transition setType:kCATransitionPush];
		[transition setSubtype:kCATransitionFromRight];
		[transition setDuration:BASEVIEW_TIMESPEC_TIMEINTERVAL];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[view layer] addAnimation:transition forKey:@"pushViewAnimation"];
		view.alpha = 1.0f;
	}
	
	[self addSubview:view];
}

-(void)popViewWithAnimation:(BOOL)animation{
	
	UIView* aview = [[self subviews] lastObject];
	
	if ( animation ) {
		CATransition *transition = [CATransition animation];
		[transition setType:kCATransitionPush];
		[transition setSubtype:kCATransitionFromLeft];
		[transition setDuration:BASEVIEW_TIMESPEC_TIMEINTERVAL];
		transition.delegate = self;
		transition.removedOnCompletion = YES;
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[transition setValue:aview forKey:@"thisView"];
		
		aview.alpha = 0.0f;
		
		[[aview layer] addAnimation:transition forKey:@"popViewWithAnimation"];
	}else {
		[aview removeFromSuperview];
	}
	
	return;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	UIView* aview = [anim valueForKey:@"thisView"];
	[aview removeFromSuperview];
}

- (void)dealloc {
    [super dealloc];
}


@end
