//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"

static LeveyTabBarController *leveyTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
	return leveyTabBarController;
}

- (void)setLeveyTabBarController:(LeveyTabBarController *)tabbar
{
    
}

@end


@implementation LeveyTabBarController
//@synthesize tabBar = _tabBar;
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize imageArray = _imageArray;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize tabBarArrowImage = _tabBarArrowImage;
@synthesize array_tabBarX = _array_tabBarX;
@synthesize tabBarHeight;
@synthesize tabBarTransOffset;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr withHeight:(float)height;
{
	self = [super init];
	if (self != nil)
	{
		tabBarHeight = height;
		self.viewControllers = vcs;
		self.imageArray = arr;
		
		_containerView = [[UIView alloc] initWithFrame:CGRectZero];
		[self createViewIfNeed];
	}
	return self;
}

- (void)loadView 
{
	[super loadView];
	
	self.view = _containerView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self createViewIfNeed];
	[self addViewToContainer];
	int curindex = self.selectedIndex;
	
	if (curindex >= 0 && curindex <= 5)
	{
		//内存警告重置
		self.selectedIndex = curindex;
	}
	else
	{
		//第一次初始化
		self.selectedIndex = 0;
	}
}

-(void)createViewIfNeed
{
	//==================
	CGRect contentrect = [[UIScreen mainScreen] applicationFrame];
	_containerView.frame = contentrect;
	
	if (!_transitionView)
	{
		_transitionView = [[UIView alloc] initWithFrame:CGRectZero];
		_transitionView.backgroundColor =  [UIColor clearColor];
		[_containerView addSubview:_transitionView];
	}
	self.tabBarTransparent = _tabBarTransparent;
	
	//tabbar
	if (!_tabBar)
	{
		_tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, contentrect.size.height - tabBarHeight, 320.0f, tabBarHeight) buttonImages:self.imageArray];
		_tabBar.delegate = self;
		[_containerView addSubview:_tabBar];
	}
	[self hidesTabBar:_tabBarHidden animated:NO];
}

-(void)addViewToContainer
{
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}


#pragma mark -
#pragma mark methods
- (LeveyTabBar *)tabBar
{
	return _tabBar;
}
- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}
- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	_tabBarTransparent = yesOrNo;
	if (yesOrNo)
	{
		_transitionView.frame = _containerView.bounds;
	}
	else
	{
		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - tabBarHeight + tabBarTransOffset);
	}

}
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
{
	_tabBarHidden = yesOrNO;
	if (yesOrNO)
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else 
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - tabBarHeight)
		{
			return;
		}
	}
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + tabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - tabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else 
	{
		if (yesOrNO)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + tabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - tabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}

- (NSUInteger)selectedIndex
{
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

-(void)doSelectedAction:(NSUInteger)index
{
	if(self.selectedIndex == index)
		return;

//	[self.selectedViewController.view setHidden:YES];
	[self.selectedViewController viewWillDisappear:YES];
	[self.selectedViewController viewDidDisappear:YES];
	self.selectedViewController = [self.viewControllers objectAtIndex:index];
	
	for (UIViewController *vc in self.viewControllers) 
	{
		vc.view.hidden = YES;
	}
	
	CGRect showrect = _transitionView.frame;
	self.selectedViewController.view.frame = showrect;
	[self.selectedViewController.view setHidden:NO];
	if ([self.selectedViewController.view isDescendantOfView:_transitionView]) 
	{
       
		[_transitionView bringSubviewToFront:self.selectedViewController.view];
	}
	else
	{
		[_transitionView addSubview:self.selectedViewController.view];
	}
	[self.selectedViewController viewWillAppear:YES];
	[self.selectedViewController viewDidAppear:YES];
}

- (void)refreshCurrentViewController
{
	self.selectedViewController.view.frame = _transitionView.frame;
	if ([self.selectedViewController.view isDescendantOfView:_transitionView]) 
	{
        [self.selectedViewController.view setHidden:NO];
		[_transitionView bringSubviewToFront:self.selectedViewController.view];
	}
	else
	{
		[_transitionView addSubview:self.selectedViewController.view];
	}
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self doSelectedAction:index];
	[_tabBar selectTabInIndex:index];
}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self doSelectedAction:index];
	NSLog(@"[BIZ]change to index:%d",index);
	[_delegate onSelectedTabBar:index];
}

- (UIImage*) tabBarArrowImage{
	return _tabBarArrowImage;
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex{
	return [[_array_tabBarX objectAtIndex:tabIndex] floatValue];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//	[viewController viewWillAppear:animated];
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//	[viewController viewDidAppear:animated];
//}

@end
