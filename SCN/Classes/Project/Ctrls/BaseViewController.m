    //
//  BaseViewController.m
//  SCN
//
//  Created by yekapple on 11-9-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "BaseViewController.h"
#import "SCNStatusUtility.h"
#import "YKStatBehaviorInterface.h"
#import "SCNAppDelegate.h"
#define YK_GOBACK_DELAYTIME 0.4
#import "UIDevice+Resolutions.h"


@implementation UINavigationBar (UINavigationBarImage)
- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:YK_COMMONIMG_NAVI];
	assert(image!=nil);
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

//- (void)layoutSubviews 
//{
////	[super layoutSubviews];
//	CGRect barFrame = self.frame;
//	barFrame.size.height = 80;
//	self.frame = barFrame;
//}

@end
/*
    分类：更改UISearchBar的前景色为黑色
 */
@implementation UISearchBar (searchBarBackColor)
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setTintColor:[UIColor blackColor]];
}
@end


@implementation BaseViewController
@synthesize isHiddenBackButton;
@synthesize backButtonTitle;
@synthesize isKeyboardPopup;

@synthesize loadingViewRetainCount;
@synthesize m_loadingView;
@synthesize pathPath;
@synthesize m_label_Nocontent;
@synthesize isGoBack;
@synthesize isLoading;


//loadview 在ios6有问题 暂时撤销

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	loadingViewRetainCount = 0;
	
//	if (!backButtonTitle && !isHiddenBackButton)
//	{
//		self.backButtonTitle = @"返回";
//	}
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self BehaviorPageJump];
	[self dealWithNeedLogin];
}

-(void)dealWithNeedLogin
{
	if ([self isNeedLogin])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyNoLogin:) name:YK_NO_LOGIN object:nil];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.isGoBack = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:YK_NO_LOGIN object:nil];
}

-(void)BehaviorPageJump
{
#ifdef USE_BEHAVIOR_ENGINE
	[YKStatBehaviorInterface logEvent_PageJumpWithAimPath:self.pathPath paramObject:self];
#endif
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 初始化
	m_loadingView = [[MBProgressHUD alloc] initWithView:self.view];
	m_loadingView.hidden = YES;
	m_loadingView.labelText = @"加载中...";
	m_loadingView.center = CGPointMake(320.0f/2.0f, 480.0f/2.0f - 54.0f);
    
    [self.view addSubview:m_loadingView];
    // no content view
    UILabel * lable_tempnote = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
    lable_tempnote.center = CGPointMake(320/2, [SCNStatusUtility getShowViewHeight]/2);
    self.m_label_Nocontent = lable_tempnote;
    self.m_label_Nocontent.hidden = YES;
    self.m_label_Nocontent.textAlignment = UITextAlignmentCenter;
    self.m_label_Nocontent.font = [UIFont systemFontOfSize:18];
    self.m_label_Nocontent.textColor = [UIColor blackColor];
//    self.m_label_Nocontent.shadowOffset = CGSizeMake(-1, 1);
//    self.m_label_Nocontent.shadowColor = [UIColor blackColor];
    [self.view addSubview:m_label_Nocontent];
    
	//custom navigationBar
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.frame = CGRectMake(0,0, navBar.frame.size.width, [SCNStatusUtility getNavigationBarHeight]);
	
	if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
	{    
		// set globablly for all UINavBars
		//UIBarMetricsDefault
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:YK_COMMONIMG_NAVI] forBarMetrics:0];
		// ...
	}
	
	//导航栏按钮
	[self dealBackButton];
	
}
//显示无商品内容
-(void)showNotecontent:(NSString *)note
{
    self.m_label_Nocontent.text = note;
    [self.m_label_Nocontent setHidden:NO];
    
}
//隐藏无商品内容
-(void)hideNotecontent
{
    [self.m_label_Nocontent setHidden:YES];

}


-(void)handleNavBack:(id)sender{
    NSLog(@"BaseViewController handleNavBack button click");
    [self goBack];
}


//导航栏按钮
- (void)dealBackButton
{
	self.navigationItem.hidesBackButton = YES;
	
	UIButton* backButton = [self createBackButton];
	backButton.tag = 10;
	
	// Add an action for going back
	[backButton addTarget:self action:@selector(handleNavBack:) forControlEvents:UIControlEventTouchUpInside];
	
	UIView* cusview = [[UIView alloc] initWithFrame:backButton.frame];
	[cusview addSubview:backButton];
	
	NSString* backtext = self.navigationController.navigationBar.topItem.title;
	if (!backtext)
	{
		if ([self.navigationController.viewControllers count] >	1)
			backtext = @" 返回";
	}
	else
	{
		if ([self.navigationController.viewControllers count] == 1)
		{
			backtext = @"";
		}
	}

	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cusview];
	
	// Just like the standard back button, use the title of the previous item as the default back text

	[self setBackText:backtext];
}


-(void)setBackButtonStyle:(UIButton*)backButton
{
	// Create stretchable images for the normal and highlighted states
	UIImage* buttonImage = [[UIImage imageNamed:@"com_backBtn.png"]  stretchableImageWithLeftCapWidth:20.0 topCapHeight:0.0];
	UIImage* buttonHighlightImage = [[UIImage imageNamed:@"com_backBtn_SEL.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:0.0];
	
	// Set the title to use the same font and shadow as the standard back button
	backButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	backButton.titleLabel.textColor = [UIColor whiteColor];
	backButton.titleLabel.shadowOffset = CGSizeMake(0,-1);
	backButton.titleLabel.shadowColor = [UIColor darkGrayColor];
	
	// Set the break mode to truncate at the end like the standard back button
	backButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	// Inset the title on the left and right
	backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12.0, 0, 6.0);
	CGRect btnrect = backButton.frame;
	backButton.frame = CGRectMake(btnrect.origin.x, btnrect.origin.y, 0, buttonImage.size.height);
	
	// Set the stretchable images as the background for the button
	[backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[backButton setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
	[backButton setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
}

-(UIButton*)createBackButton
{
	// Create a custom button
	UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self setBackButtonStyle:backButton];
	return backButton;
}

- (void)setBackText:(NSString *)text
{
	//
	UIView* cusview = self.navigationItem.leftBarButtonItem.customView;
	UIButton* backButton = (UIButton*)[cusview viewWithTag:10];
	[self setBackText:text withButton:backButton];
	CGRect cusrect = cusview.frame;
	cusview.frame = CGRectMake(cusrect.origin.x, cusrect.origin.y, backButton.frame.size.width, backButton.frame.size.height);
}

- (void)setBackText:(NSString *)text withButton:(UIButton*)backButton
{
	self.backButtonTitle = text;	

	
	if (!backButtonTitle ||  [backButtonTitle length] == 0)
	{
		backButton.hidden = YES;
	}
	else
	{
		backButton.hidden = NO;
	}
	
	// Measure the width of the text
	CGSize textSize = [text sizeWithFont:backButton.titleLabel.font];
	// Change the button's frame. The width is either the width of the new text or the max width
	CGFloat btnwidth = MAX(MIN((textSize.width + 18), 120), 48);
	
	CGRect backButtonRect = backButton.frame;
	backButton.frame = CGRectMake(backButtonRect.origin.x, backButtonRect.origin.y, btnwidth, backButton.frame.size.height);
	
	// Set the text on the button
	[backButton setTitle:text forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark navigationItem


-(void)MBProgressHUD:(UIButton *)button
{
	[self goBack];
}


-(void)goBack
{
	NSArray* vcarr = [self.navigationController viewControllers];
	if (vcarr.count > 1)
	{
		BaseViewController* pvc = [vcarr objectAtIndex:vcarr.count - 2];
		if ([pvc respondsToSelector:@selector(isGoBack)])
		{
			pvc.isGoBack = YES;
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)isGoBack
{
	BOOL tmp = isGoBack;
	isGoBack = NO;
	return tmp;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.m_loadingView = nil;
    self.m_label_Nocontent = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	backButtonTitle = nil;
	// Loading view
    
    //提示被dealloc的页面
    NSString *className = NSStringFromClass([self class]);
    NSLog(@" Dealloc 被调用 %@",className);
    
    
}

#pragma mark -
#pragma mark Loading View
-(void)startLoading{
	[m_loadingView setHidden:NO];
	self.loadingViewRetainCount = self.loadingViewRetainCount + 1;
	[self.view bringSubviewToFront:m_loadingView];
	[m_loadingView show:YES];
}

-(void)stopLoading{
	self.loadingViewRetainCount = self.loadingViewRetainCount - 1;
	if (self.loadingViewRetainCount <=0 )
	{
		self.loadingViewRetainCount = 0;
		[m_loadingView setHidden:YES];
		[m_loadingView hide:YES];
	}	
}

-(BOOL)isLoading
{
	return (self.loadingViewRetainCount > 0);
}

-(void)reFreshVc
{
	
}

-(void)delayGoBack
{
	[self performSelector:@selector(goBack) withObject:nil afterDelay:YK_GOBACK_DELAYTIME];
}


-(void)GoBackToNoNeedViewController
{
	BaseViewController* noNeedvc = nil;
	for(BaseViewController* vc in self.navigationController.viewControllers)
	{
		
		if ([vc respondsToSelector:@selector(isNeedLogin)])
		{
			if([vc isNeedLogin])
				break;
		}
		noNeedvc = vc;
	}
	if (noNeedvc && noNeedvc != self.navigationController.visibleViewController)
	{
		[self.navigationController popToViewController:noNeedvc animated:YES];
	}
}

- (void)NotifyNoLogin:(NSNotification *)notify
{
	[self GoBackToNoNeedViewController];
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return self.navigationItem.title;
#else
	return nil;
#endif
}

-(BOOL)isNeedLogin
{
	return NO;
}

@end
