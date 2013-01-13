    //
//  YKBaseViewController.m
//  YK
//
//  Created by blackApple-1 on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YK_BaseViewController.h"
#import "YK_ButtonUtility.h"
#import "YK_BaseConfig.h"
#import "MBProgressHUD.h"

@implementation YK_BaseViewController

#pragma mark UI
- (void)layOutUI{
    /*
     优先级说明：如果用户未调用prepareTitleString设置title，使用titleString返回的字符
     */
    if ( mTitleString == nil  ) {
        mTitleString = [self titleString];
    }
    
    [self setTitle:mTitleString];
}

- (void)prepareTitle:(NSString*)title{
    [mTitleString autorelease];
    mTitleString = [title retain];
}

- (void)startAsyncWebData{
     [self startUILoading];
}

- (void)onResponseWebData:(NSObject*)obj{
    [self stopUILoading];
}

- (NSString*)titleString{
    return (mTitleString == nil)?nil:mTitleString;
}

#pragma mark buttonAction
- (void)buttonAction_goBACK
{
    int navigationViewControllersCount = [[[self navigationController] viewControllers] count];
    
    if ( navigationViewControllersCount == 1 ) {
        [[self navigationController] dismissModalViewControllerAnimated:YES];
    }else if ( navigationViewControllersCount > 1 ){
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (YK_BaseViewController*)logicParentViewController{
    int locateIndex = [[[self navigationController] viewControllers] indexOfObject:self]-1;
    
    if ( locateIndex >= 0 ) {
        return [[[self navigationController] viewControllers] objectAtIndex:locateIndex];
    }else{
        return nil;
    }
}

- (void)setGoBackButton
{
    if ( [[[self navigationController] viewControllers] count] > 1 ) {
        NSString *l_str_backTitle = @"返回";//[[self logicParentViewController] title];    //获取前一个UIViewController的实例
        
        /*if (l_str_backTitle == nil) {
            l_str_backTitle = @"返回";
        }*/
        
        UIView *l_button = [YK_ButtonUtility customButtonViewWithImageName:YK_NAVIGATION_BUTTON_BACK_IMAGE
                                                      highlightedImageName:YK_NAVIGATION_BUTTON_BACK_SEL_IMAGE
                                                                     title:l_str_backTitle
                                                                      font:[UIFont boldSystemFontOfSize:DEFAULT_FONTSIZE]
                                                                    target:self
                                                                    action:@selector(buttonAction_goBACK)];
        
        UIButton* button = (UIButton*)[l_button viewWithTag:BUTTON_TAG];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 3.f, 0, 0)];
        
        UIBarButtonItem *l_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:l_button];
        self.navigationItem.leftBarButtonItem = l_barButtonItem;
        [l_barButtonItem release];
    }
}

- (void)setGoBackButtonInModel{
    NSString *l_str_backTitle = @"返回";//[[self logicParentViewController] title];    //获取前一个UIViewController的实例
    /*if (l_str_backTitle == nil) {
        l_str_backTitle = @"返回";
    }*/
    
    UIView *l_button = [YK_ButtonUtility customButtonViewWithImageName:YK_NAVIGATION_BUTTON_BACK_IMAGE
                                                  highlightedImageName:YK_NAVIGATION_BUTTON_BACK_SEL_IMAGE
                                                                 title:l_str_backTitle
                                                                  font:[UIFont boldSystemFontOfSize:DEFAULT_FONTSIZE]
                                                                target:self
                                                                action:@selector(buttonAction_goBACK)];
    
    UIButton* button = (UIButton*)[l_button viewWithTag:BUTTON_TAG];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 3.f, 0, 0)];
        
    UIBarButtonItem *l_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:l_button];
    self.navigationItem.leftBarButtonItem = l_barButtonItem;
    [l_barButtonItem release];
}

- (void)setLeftButton:(NSString*)buttonTitle action:(SEL)action{
    UIView *_button = [YK_ButtonUtility customButtonViewWithImageName:YK_NAVIGATION_BUTTON_RIGHT_IMAGE
                                                 highlightedImageName:YK_NAVIGATION_BUTTON_RIGHT_SEL_IMAGE
                                                                title:buttonTitle
                                                                 font:[UIFont boldSystemFontOfSize:DEFAULT_FONTSIZE]
                                                               target:self
                                                               action:action];
        	
	UIBarButtonItem *l_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
	self.navigationItem.leftBarButtonItem = l_barButtonItem;
	[l_barButtonItem release];
}

- (void)disableGoBackButton{
     [[self navigationItem] setHidesBackButton:YES];
}

- (void)setLeftImageButton:(NSString*)imageName action:(SEL)action{
    UIView *_button = [YK_ButtonUtility customButtonViewWithBackImageName:YK_NAVIGATION_BUTTON_RIGHT_IMAGE frontImageName:imageName highlightedBackImageName:YK_NAVIGATION_BUTTON_RIGHT_SEL_IMAGE frontHighlightedImageName:[NSString stringWithFormat:@"%@_SEL.png", [imageName stringByDeletingPathExtension]] target:self action:action];
	
	UIBarButtonItem *l_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
	self.navigationItem.leftBarButtonItem = l_barButtonItem;
	[l_barButtonItem release];
}

- (void)setRightImageButton:(NSString*)imageName action:(SEL)action{
    UIView *_button = [YK_ButtonUtility customButtonViewWithBackImageName:YK_NAVIGATION_BUTTON_RIGHT_IMAGE frontImageName:imageName highlightedBackImageName:YK_NAVIGATION_BUTTON_RIGHT_SEL_IMAGE frontHighlightedImageName:[NSString stringWithFormat:@"%@_SEL.png", [imageName stringByDeletingPathExtension]] target:self action:action];
	
	UIBarButtonItem *r_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
	self.navigationItem.rightBarButtonItem = r_barButtonItem;
	[r_barButtonItem release];
}

- (void)setRightButton:(NSString*)buttonTitle action:(SEL)action{
    
    UIView *_button = [YK_ButtonUtility customButtonViewWithImageName:YK_NAVIGATION_BUTTON_RIGHT_IMAGE
                                                  highlightedImageName:YK_NAVIGATION_BUTTON_RIGHT_SEL_IMAGE
                                                                 title:buttonTitle
                                                                  font:[UIFont boldSystemFontOfSize:DEFAULT_FONTSIZE]
                                                                target:self
                                                                action:action];
	
	UIBarButtonItem *r_barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
	self.navigationItem.rightBarButtonItem = r_barButtonItem;
	[r_barButtonItem release];
}

#pragma mark UI Signal

-(void)startUILoading{
    NSLog( @"[SYS]%@ startUILoading", [self class] );
    [MBProgressHUD showHUDAddedTo:[self view] animated:YES withText:@"加载中..."];
}

-(void)stopUILoading{
    NSLog( @"[SYS]%@ stopUILoading", [self class] );
    [MBProgressHUD hideHUDForView:[self view] animated:NO];
}

#pragma mark lifecycle

-(void)viewWillAppear:(BOOL)animated{
    NSLog( @"[SYS]%@ viewWillAppear", [self class] );
    //每一次viewWillAppear时执行
    //注册键盘相应观察者
    //[self registerForKeyboardNotifications];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog( @"[SYS]%@ viewDidLoad", [self class] );
    [self layOutUI];    //执行默认的layout过程
    mPickerLock = YES; //解决乱弹问题
    mOriginalFrameIsSet = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog( @"[SYS]%@ didReceiveMemoryWarning", [self class] );
}

- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog( @"[SYS]%@ viewDidUnload", [self class] );
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog( @"[SYS]%@ viewWillDisappear", [self class] );
    //[self unregisterForKeyboardNotifications];
}


- (void)dealloc {
	NSLog( @"[SYS]%@ dealloecd.", [self class]);
    [mTitleString release];
    [super dealloc];
}

#pragma mark keyBoard相关

// 软键盘出现时把页面上移
- (void)registerForKeyboardNotifications
{
     NSLog( @"[SYS]%@ registerForKeyboardNotifications", [self class] );
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
    NSLog( @"[SYS]%@ unregisterForKeyboardNotifications", [self class] );
        
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    mPickerLock = YES;
    NSLog( @"[SYS]keyboardWillShow resize view" );
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PICKERVIEW_DURATION];
    if (!mOriginalFrameIsSet) {
        mOriginalFrame = self.view.frame;
        mOriginalFrameIsSet = YES;
    }
    mKeyBoardFrame = self.view.frame;
    self.view.frame = CGRectMake( 0, 0, 320, 220);
    [UIView commitAnimations];
}


- (void)keyboardWasHidden:(NSNotification*)aNotification {
    
    if ( mKeyBoardLock == YES ) {
        return;
    }
    
    NSLog( @"[SYS]keyboardWasHidden" );
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PICKERVIEW_DURATION];
    self.view.frame = mOriginalFrame;
    [UIView commitAnimations];
    
    mPickerLock = NO; //pickerView可以调整frame
}

- (void)keyboardForceHidden:(NSNotification*)aNotification
{
    if ( mKeyBoardLock == YES ) {
        return;
    }
    
    NSLog( @"[SYS]keyboardWasHidden" );
    
    self.view.frame = mOriginalFrame;
    
    mPickerLock = NO; //pickerView可以调整frame
}

- (void)pickerViewWillShow:(UIView *)pickerView{
    mKeyBoardLock = YES;
    NSLog( @"[SYS]pickerViewWillShow resize view" );
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PICKERVIEW_DURATION];
    if (!mOriginalFrameIsSet) {
        mOriginalFrame = self.view.frame;
        mOriginalFrameIsSet = YES;
    }
    mPickerFrame   = self.view.frame;
    self.view.frame = CGRectMake( 0, 0, 320, 176);
    [UIView commitAnimations];
}

- (void)pickerViewWasHidden:(UIView*)pickerView{
    if ( mPickerLock == YES ) {
        return;
    }
    NSLog( @"[SYS]pickerViewWasHidden" );
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:PICKERVIEW_DURATION];
    self.view.frame = mOriginalFrame;
    [UIView commitAnimations];
    
    mKeyBoardLock = NO; //keyBoard可以调整frame
}

- (void)pickerViewWasForceHidden:(UIView *)pickerView {
    NSLog( @"[SYS]pickerViewWasHidden" );
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:PICKERVIEW_DURATION];
    self.view.frame = mOriginalFrame;
    //[UIView commitAnimations];
    
    mKeyBoardLock = NO; //keyBoard可以调整frame
}

@end
