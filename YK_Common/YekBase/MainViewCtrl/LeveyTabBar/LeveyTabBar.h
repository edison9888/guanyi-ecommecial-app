//
//  LeveyTabBar.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView
{
	UIImageView *_backgroundView;
	id<LeveyTabBarDelegate> __unsafe_unretained _delegate;
	UIButton *__unsafe_unretained _selectedButton;
	NSMutableArray *_buttons;
}
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, unsafe_unretained) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, unsafe_unretained) UIButton *selectedButton;
@property (nonatomic, strong) NSMutableArray *buttons;


- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabInIndex:(NSInteger)index;
@end
@protocol LeveyTabBarDelegate<NSObject>
- (UIImage*) tabBarArrowImage;
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
@optional
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index; 
@end
