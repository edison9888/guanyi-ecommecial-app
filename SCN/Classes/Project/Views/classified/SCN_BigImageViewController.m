//
//  SCN_BigImageViewController.m
//  SCN
//
//  Created by yuanli on 11-10-12.
//  Copyright 2011年 Yek.me. All rights reserved.
//

#import "SCN_BigImageViewController.h"
#import "HJManagedImageV.h"
#import "HJImageUtility.h"

@implementation SCN_BigImageViewController

@synthesize m_atPagingView,m_GpageControl;
@synthesize m_imageArr;
@synthesize  m_lastPags;
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
      withimageUrlArr:(NSMutableArray *)imageUrlArr
			withIndex:(int)index
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_imageArr = imageUrlArr;
		m_firstIndex = index;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - 
#pragma mark  UIScrollViewDelegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//    scrollView.zoomScale = 1.0;
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat f = scrollView.frame.size.width;
//    NSLog(@">>>>>>>>>>%f",f);
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	UIView* imageview = [scrollView viewWithTag:101];
	if (imageview) 
	{
		return imageview;
	}
	return nil;
}

#pragma mark - 
#pragma mark ATPagingViewDelegate
- (NSInteger)numberOfPagesInPagingView:(ATPagingView *)pagingView
{
    return [self.m_imageArr count];
}

- (UIView *)viewForPageInPagingView:(ATPagingView *)pagingView atIndex:(NSInteger)index
{
    UIView *view = [pagingView dequeueReusablePage];
    if (view == nil) {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        
        UIScrollView *imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 385)];
        imageScrollView.backgroundColor = [UIColor whiteColor];
        imageScrollView.minimumZoomScale = 1.0f;
        imageScrollView.maximumZoomScale = 2.0f;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.delegate = self;
        imageScrollView.tag = 10;
        [view addSubview:imageScrollView];
        
        HJManagedImageV *hjTopPicView = [[HJManagedImageV alloc]initWithFrame:CGRectMake(0, 0, 320, 385)];
        hjTopPicView.userInteractionEnabled = YES;
        hjTopPicView.backgroundColor = [UIColor whiteColor];
        [hjTopPicView setImage:[DataWorld getImageWithFile:@"productDetail_loading_bigImg.png"]];
        hjTopPicView.tag = 101;
        [imageScrollView addSubview:hjTopPicView];

    }
	
    HJManagedImageV *hjTopPicView = (HJManagedImageV *)[[view viewWithTag:10] viewWithTag:101];
	[hjTopPicView setImage:[DataWorld getImageWithFile:@"productDetail_loading_bigImg.png"]];
    [HJImageUtility queueLoadImageFromUrl:[self.m_imageArr objectAtIndex:index] imageView:hjTopPicView];
    return view;
}
- (void)pagesDidChangeInPagingView:(ATPagingView *)pagingView
{

    int indexone = pagingView.currentPageIndex - 1;
    UIView *_v = [pagingView viewForPageAtIndex:indexone];
    UIScrollView *_imageScrollV = (UIScrollView *)[_v viewWithTag:10];
    _imageScrollV.zoomScale = 1.0;
    
    int indextwo = pagingView.currentPageIndex + 1;
    UIView *v = [pagingView viewForPageAtIndex:indextwo];
    UIScrollView *imageScrollV = (UIScrollView *)[v viewWithTag:10];
    imageScrollV.zoomScale = 1.0;
    
    self.m_GpageControl.currentPage = pagingView.currentPageIndex;
}
- (void)pagingViewDidEndMoving:(ATPagingView *)pagingView
{

}
#pragma mark - View lifecycle
-(void)onAction_goBack:(id)sender
{
    [self goBack];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品图片";
	self.pathPath = @"/bigImage";
    // Do any additional setup after loading the view from its nib.
    self.m_atPagingView = [[ATPagingView alloc]initWithFrame:CGRectMake(0, 0, 320, 385)];
    self.m_atPagingView.gapBetweenPages = 0.0f;
    self.m_atPagingView.delegate =self;
    self.m_atPagingView.currentPageIndex = 0;
    self.m_lastPags = self.m_atPagingView.currentPageIndex;
    [self.view addSubview:self.m_atPagingView];
    
    self.m_GpageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(0, 365, 320, 20)];
    self.m_GpageControl.center = CGPointMake(320/2, 375);
    [self.m_GpageControl setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.m_GpageControl.numberOfPages = [self.m_imageArr count];
    self.m_GpageControl.currentPage = m_firstIndex;
    [self.view addSubview:self.m_GpageControl];
	self.m_atPagingView.currentPageIndex = m_firstIndex;
    [self.m_atPagingView reloadData];
	
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.m_atPagingView = nil;
    self.m_GpageControl = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|商品ID
	NSString* _name = [DataWorld shareData].m_nowProductData.m_productName;
	NSString* _code = [DataWorld shareData].m_nowProductData.m_productCode;
	NSString* _param = [NSString stringWithFormat:@"%@|%@",_name,_code];
	return _param;
#else
	return nil;
#endif
}

@end
