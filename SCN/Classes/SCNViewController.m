//
//  SCNViewController.m
//  SCN
//
//  Created by yekmacminiserver on 11-9-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNViewController.h"
#import "SCNStatusUtility.h"

@implementation SCNViewController
@synthesize m_badgeView;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 添加badge
	if (!self.m_badgeView)
	{
		self.m_badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(230, -10, 100, 30)];
		m_badgeView.backgroundColor = [UIColor clearColor];
		[self setBadgeNumber:0];
		[_tabBar addSubview:m_badgeView];
	}
	else
	{
		[_tabBar addSubview:m_badgeView];
	}
	
	[_tabBar bringSubviewToFront:m_badgeView];


	// 设置代理
	self.delegate = self;
	[SCNStatusUtility showShoppingcartNumber];

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
}



#pragma mark -
#pragma mark 购物车
// 设置购物车的badgeNumber
-(void)setBadgeNumber:(int)_num
{
	m_badgeView.badgeValue = _num;
	m_badgeView.hidden = _num > 0 ? NO : YES;
	[m_badgeView setNeedsDisplay];
}

#pragma mark -
#pragma mark YK_CustomTabBarViewControllerDelegate Methods
-(void)onSelectedTabBar:(NSUInteger)itemIndex{
	NSLog(@"= 选中TabBar下标: %d =", itemIndex);
	//	if (itemIndex==0) {
	//		[[_viewControllers objectAtIndex:itemIndex] popToRootViewControllerAnimated:YES];
	//	}
	//	if (itemIndex==3) {
	//		[[_viewControllers objectAtIndex:itemIndex] popToRootViewControllerAnimated:NO];
	//	}
}


-(void)viewControllerBackRoot:(NSInteger)index
{
	[[_viewControllers objectAtIndex:index] popToRootViewControllerAnimated:YES];
}

-(void)callViewControllerFresh:(NSInteger)index
{
	UIViewController* vc = [[_viewControllers objectAtIndex:index] visibleViewController];
    if ([vc respondsToSelector:@selector(reFreshVc)])
	{
		[vc performSelector:@selector(reFreshVc)];
	}
}


#pragma mark -
#pragma mark Override superclass Methods


-(void) tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	
	switch (index)
	{
		case 0://首页
		case 3://购物车
		case 4://更多
			
			[self viewControllerBackRoot:index];
			break;
		case 1:
		case 2:
			if (self.selectedIndex == index)
			{
				[self viewControllerBackRoot:index];
				break;
			}
			break;
		default:
			break;
	}
	[super tabBar:tabBar didSelectIndex:index];
	[self callViewControllerFresh:index];
	

	/*
	 UINavigationController *navCtrler = (UINavigationController *)[self.viewControllers objectAtIndex:index];
	 if([navCtrler.visibleViewController isKindOfClass:[ClassifiedViewController class]])
	 {
	 ClassifiedViewController *l_controller = (ClassifiedViewController *)navCtrler.visibleViewController;
	 [l_controller requestDataIfNeeded];
	 }
	 */
}

@end
