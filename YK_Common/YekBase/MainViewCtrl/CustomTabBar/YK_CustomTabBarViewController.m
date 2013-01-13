    //
//  YK_CustomTabBarViewController.m
//  Moonbasa
//
//  Created by user on 11-7-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_CustomTabBarViewController.h"

/**
 TabBar的背景色
 */
 const NSString* TABBAR_IMAGE;

/**
 TabBar选中后的遮罩色
 */
 const NSString* TABBAR_IMAGE_SELECTED;

/**
 选中TabBar后的图标背景底色
 */
 const NSString* TABBAR_ITEM_SELECTED_BACKGROUND_IMAGE; //空则不显示

/**
 TabBar的选中效果图, 可以为空，空则不显示
 */
 const NSString* TABBAR_GLOW_IMAGE; //空则不显示

/**
 TabBar的选中效果图, 可以为空，空则不显示
 */
 const NSString* TABBAR_NIPPLE_IMAGE; //空则不显示


/**
 TabBar的第一个ViewController
 */
 const NSString* YK_B2C_CLASS_PAGE_1;
/**
 TabBar的第一个ViewController的导航栏标题
 */
 const NSString* YK_B2C_CLASS_PAGE_1_TITLE;
/**
 第一个TabBar的图标
 */
 const NSString* YK_B2C_CLASS_PAGE_1_ICON;

/**
 TabBar的第二个ViewController
 */
 const NSString* YK_B2C_CLASS_PAGE_2;
/**
 TabBar的第二个ViewController的导航栏标题
 */
 const NSString* YK_B2C_CLASS_PAGE_2_TITLE;
/**
 第二个TabBar的图标
 */
 const NSString* YK_B2C_CLASS_PAGE_2_ICON;

/**
 TabBar的第三个ViewController
 */
 const NSString* YK_B2C_CLASS_PAGE_3;
/**
 TabBar的第三个ViewController的导航栏标题
 */
 const NSString* YK_B2C_CLASS_PAGE_3_TITLE;
/**
 第三个TabBar的图标
 */
 const NSString* YK_B2C_CLASS_PAGE_3_ICON;

/**
 TabBar的第四个ViewController
 */
 const NSString* YK_B2C_CLASS_PAGE_4;
/**
 TabBar的第四个ViewController的导航栏标题
 */
 const NSString* YK_B2C_CLASS_PAGE_4_TITLE;
/**
 第四个TabBar的图标
 */
 const NSString* YK_B2C_CLASS_PAGE_4_ICON;

/**
 TabBar的第五个ViewController
 */
 const NSString* YK_B2C_CLASS_PAGE_5;
/**
 TabBar的第无个ViewController的导航栏标题
 */
 const NSString* YK_B2C_CLASS_PAGE_5_TITLE;
/**
 第五个TabBar的图标
 */
 const NSString* YK_B2C_CLASS_PAGE_5_ICON;

static NSArray* s_tabBarItems = nil;
#define TABBAR_ITEM_NUMBER 5
#define TABBAR_KEY_ICON @"icon"
#define TABBAR_KEY_VIEWCTRL @"viewController"
#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface YK_CustomTabBarViewController(hidden)

-(void)initTabBarAndCtrl;

@end


@implementation YK_CustomTabBarViewController
@synthesize delegate;
@synthesize m_customTabBar;
@synthesize m_navCtrl_page_1;
@synthesize m_navCtrl_page_2;
@synthesize m_navCtrl_page_3;
@synthesize m_navCtrl_page_4;
@synthesize m_navCtrl_page_5;

@synthesize m_badgeView;


- (void)dealloc {
	[m_customTabBar release];
	[m_badgeView release];
	
	[m_navCtrl_page_1 release];
	[m_navCtrl_page_2 release];
	[m_navCtrl_page_3 release];
	[m_navCtrl_page_4 release];
	[m_navCtrl_page_5 release];
	
    [super dealloc];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		[self initTabBarAndCtrl];
	}
	return self;
}

-(void)awakeFromNib{
	[self initTabBarAndCtrl];
}

-(void)initTabBarAndCtrl{
	// Page 1
	Class l_class_page_1 = NSClassFromString(YK_B2C_CLASS_PAGE_1);
	id l_ViewCtrl_page_1 = [[l_class_page_1 alloc] initWithNibName:YK_B2C_CLASS_PAGE_1 bundle:nil];
	[l_ViewCtrl_page_1 setM_str_navTitle:YK_B2C_CLASS_PAGE_1_TITLE];
	[l_ViewCtrl_page_1 setIsMainPage:TRUE];
	m_navCtrl_page_1 = [[UINavigationController alloc] initWithRootViewController:l_ViewCtrl_page_1];
	[l_ViewCtrl_page_1 release];
	
	// Page 2
	Class l_class_page_2 = NSClassFromString(YK_B2C_CLASS_PAGE_2);
	id l_ViewCtrl_page_2 = [[l_class_page_2 alloc] initWithNibName:YK_B2C_CLASS_PAGE_2 bundle:nil];
	[l_ViewCtrl_page_2 setM_str_navTitle:YK_B2C_CLASS_PAGE_2_TITLE];
	[l_ViewCtrl_page_2 setIsMainPage:TRUE];
	m_navCtrl_page_2 = [[UINavigationController alloc] initWithRootViewController:l_ViewCtrl_page_2];
	[l_ViewCtrl_page_2 release];
	
	// Page 3
	Class l_class_page_3 = NSClassFromString(YK_B2C_CLASS_PAGE_3);
	id l_ViewCtrl_page_3 = [[l_class_page_3 alloc] initWithNibName:YK_B2C_CLASS_PAGE_3 bundle:nil];
	[l_ViewCtrl_page_3 setM_str_navTitle:YK_B2C_CLASS_PAGE_3_TITLE];
	[l_ViewCtrl_page_3 setIsMainPage:TRUE];
	m_navCtrl_page_3 = [[UINavigationController alloc] initWithRootViewController:l_ViewCtrl_page_3];
	[l_ViewCtrl_page_3 release];
	
	// Page 4
	Class l_class_page_4 = NSClassFromString(YK_B2C_CLASS_PAGE_4);
	id l_ViewCtrl_page_4 = [[l_class_page_4 alloc] initWithNibName:YK_B2C_CLASS_PAGE_4 bundle:nil];
	[l_ViewCtrl_page_4 setM_str_navTitle:YK_B2C_CLASS_PAGE_4_TITLE];
	[l_ViewCtrl_page_4 setIsMainPage:TRUE];
	m_navCtrl_page_4 = [[UINavigationController alloc] initWithRootViewController:l_ViewCtrl_page_4];
	[l_ViewCtrl_page_4 release];
	
	// Page 5
	Class l_class_page_5 = NSClassFromString(YK_B2C_CLASS_PAGE_5);
	id l_ViewCtrl_page_5 = [[l_class_page_5 alloc] initWithNibName:YK_B2C_CLASS_PAGE_5 bundle:nil];
	[l_ViewCtrl_page_5 setM_str_navTitle:YK_B2C_CLASS_PAGE_5_TITLE];
	[l_ViewCtrl_page_5 setIsMainPage:TRUE];
	m_navCtrl_page_5 = [[UINavigationController alloc] initWithRootViewController:l_ViewCtrl_page_5];
	[l_ViewCtrl_page_5 release];
	
	s_tabBarItems = [[NSArray arrayWithObjects:
					  [NSDictionary dictionaryWithObjectsAndKeys:YK_B2C_CLASS_PAGE_1_ICON, TABBAR_KEY_ICON, m_navCtrl_page_1, TABBAR_KEY_VIEWCTRL, nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:YK_B2C_CLASS_PAGE_2_ICON, TABBAR_KEY_ICON, m_navCtrl_page_2, TABBAR_KEY_VIEWCTRL, nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:YK_B2C_CLASS_PAGE_3_ICON, TABBAR_KEY_ICON, m_navCtrl_page_3, TABBAR_KEY_VIEWCTRL, nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:YK_B2C_CLASS_PAGE_4_ICON, TABBAR_KEY_ICON, m_navCtrl_page_4, TABBAR_KEY_VIEWCTRL, nil],
					  [NSDictionary dictionaryWithObjectsAndKeys:YK_B2C_CLASS_PAGE_5_ICON, TABBAR_KEY_ICON, m_navCtrl_page_5, TABBAR_KEY_VIEWCTRL, nil], nil] retain];
	
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 使用宏定义TABBAR_IMAGE作为每一个tabBarItem的背景图, bar的高度(49*2=98)
	UIImage *tabBarImage = [UIImage imageNamed:TABBAR_IMAGE];
	NSLog(@"%@, %f, %f", tabBarImage, tabBarImage.size.width, tabBarImage.size.height);
	// 创建自定义tabBar, 每一个item的大小, 设定自己为代理
	self.m_customTabBar = [[[CustomTabBar alloc] initWithItemCount:TABBAR_ITEM_NUMBER 
														  itemSize:CGSizeMake(self.view.frame.size.width/TABBAR_ITEM_NUMBER, tabBarImage.size.height) tag:0 delegate:self] autorelease];
	
	// 将自定义tabBar放置在view的底部
	m_customTabBar.frame = CGRectMake(0, self.view.frame.size.height - tabBarImage.size.height,
									  self.view.frame.size.width, tabBarImage.size.height);
	
	[self.view addSubview:m_customTabBar];
	
	// 选中第一个tab
	[m_customTabBar selectItemAtIndex:0];
	[self touchDownAtItemAtIndex:0];
	
	// 添加badge
	self.m_badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(230, -10, 60, 30)];
	m_badgeView.backgroundColor = [UIColor clearColor];
	[self setBadgeNumber:0];
	[m_customTabBar addSubview:m_badgeView];
}

-(void)loadHomeView{
	// 选中第一个tab
	[m_customTabBar selectItemAtIndex:0];
	[self touchDownAtItemAtIndex:0];
	
	// 添加badge
	self.m_badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(230, -10, 60, 30)];
	m_badgeView.backgroundColor = [UIColor clearColor];
	[self setBadgeNumber:0];
	[m_customTabBar addSubview:m_badgeView];	
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark 自定义方法
// 控制tabBar是否显示
-(void)tabBarHidden:(BOOL)hidden{
	self.m_customTabBar.hidden = hidden;
}

// 设置购物车的badgeNumber
-(void)setBadgeNumber:(int)_num
{
	m_badgeView.badgeValue = _num;
	m_badgeView.hidden = _num > 0 ? NO : YES;
	[m_badgeView setNeedsDisplay];
}

#pragma mark -
#pragma mark CustomTabBarDelegate Methods
-(UIImage*)imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex{
	// 获取tab icon
	NSDictionary *assign_data = [s_tabBarItems objectAtIndex:itemIndex];
	UIImage *tmp_image = [UIImage imageNamed:[assign_data objectForKey:TABBAR_KEY_ICON]];
	NSLog(@"=imageFor== image :%@, %f, %f ===", tmp_image, tmp_image.size.width, tmp_image.size.height);
	return tmp_image;
}

-(UIImage*)backgroundImage{
	// The tab bar's width is the same as our width
	CGFloat width = self.view.frame.size.width;
	// Get the image that will form the top of the background
	UIImage *topImage = [UIImage imageNamed:TABBAR_IMAGE];
	NSLog(@"=backgroundImage== topImage :%@, %f, %f ===", topImage, topImage.size.width, topImage.size.height);
	
	// Create a new image context
	if (UIGraphicsBeginImageContextWithOptions != NULL) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height), NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(CGSizeMake(width, topImage.size.height));
	}
	//UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height), NO, 0.0);
	
	// Create a stretchable image for the top of the background and draw it
	UIImage *stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
	
	// Draw a solid black color for the bottom of the background
	[[UIColor blackColor] set];
	CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
	
	// Generate a new image
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage*) selectedItemBackgroundImage
{
	return [UIImage imageNamed:TABBAR_ITEM_SELECTED_BACKGROUND_IMAGE];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage*) glowImage
{
	UIImage* tabBarGlow = [UIImage imageNamed:TABBAR_GLOW_IMAGE];
	
	// Create a new image using the TabBarGlow image but offset 4 pixels down
	if (UIGraphicsBeginImageContextWithOptions != NULL) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0));
	}
	
	// Draw the image
	[tabBarGlow drawAtPoint:CGPointZero];
	
	// Generate a new image
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultImage;
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage*) selectedItemImage
{
	// Use the TabBarGradient image to figure out the tab bar's height (49x2=98)
	UIImage* tabBarImage = [UIImage imageNamed:TABBAR_IMAGE];
	CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/s_tabBarItems.count, tabBarImage.size.height);
	if (UIGraphicsBeginImageContextWithOptions != NULL) {
		UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(tabBarItemSize);
	}
	
	// Create a stretchable image using the TabBarSelection image but offset 4 pixels down
	//[[[UIImage imageNamed:TABBAR_IMAGE_SELECTED] stretchableImageWithLeftCapWidth:6.0 topCapHeight:0] drawInRect:CGRectMake(0, 3.0, tabBarItemSize.width, tabBarItemSize.height-6.0)];  
	[[UIImage imageNamed:TABBAR_IMAGE_SELECTED] drawInRect:CGRectMake(0, 3.0, tabBarItemSize.width, tabBarItemSize.height-6.0)];  
	
	// Generate a new image
	UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return selectedItemImage;
}

- (UIImage*) tabBarArrowImage
{
	return [UIImage imageNamed:TABBAR_NIPPLE_IMAGE];
}

static NSUInteger selectedItemIndex=-1;
- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
	if (itemIndex == selectedItemIndex) {
		return;
	}
	selectedItemIndex = itemIndex;
	
	// Remove the current view controller's view
	UIView *currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
	[currentView removeFromSuperview];
	
	// Get the right view controller
	NSDictionary *data = [s_tabBarItems objectAtIndex:itemIndex];
	UIViewController *assign_viewController = [data objectForKey: TABBAR_KEY_VIEWCTRL];
	
	// Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
	UIImage *tabBarImage = [UIImage imageNamed:TABBAR_IMAGE];
	
	// Set the view controller's frame to account for the tab bar
	assign_viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height); //-(tabBarImage.size.height)
	
	// Se the tag so we can find it later
	assign_viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
	
	// Add the new view controller's view
	[self.view insertSubview:assign_viewController.view belowSubview:m_customTabBar];
	
	// In 0 second glow the selected tab
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
	
	[delegate onSelectedTabBar:itemIndex];
}

- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
	// Remove the glow from all tab bar items
	for (NSUInteger i = 0 ; i < s_tabBarItems.count ; i++)
	{
		[m_customTabBar removeGlowAtIndex:i];
	}
	
	// Then add it to this tab bar item
	[m_customTabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}

@end
