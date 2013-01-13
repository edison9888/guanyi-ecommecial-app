//
//  UISwitchCustom.h
//  SCN
//
//  Created by zwh on 11-10-13.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UISwitchCustomDelegate;

@interface UISwitchCustom : UIControl 
{
    id<UISwitchCustomDelegate> __unsafe_unretained _delegate;
    BOOL _on;
	UIImageView* _onImage;
	UIImageView* _offImage;
	CGFloat		_slideWidth;
	
	BOOL	isAnimating;
}
@property (nonatomic ,unsafe_unretained) id delegate;
@property (nonatomic ,getter = isOn, readonly) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (void)setOnImage:(UIImage*)image;// 与UISwitchCustom大小一致
- (void)setOffImage:(UIImage*)image;// 与UISwitchCustom大小一致
- (void)setSlideWidth:(CGFloat)width;// 滑块宽度

@end

@protocol UISwitchCustomDelegate<NSObject>

@optional
- (void)valueChangedInView:(UISwitchCustom *)view;

@end