//
//  SCNHomeViewController.m
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNHomeViewController.h"
#import "YKHttpEngine.h"
#import "SCNHotSellView.h"
#import "YKStatBehaviorInterface.h"

#import "SCNStatusUtility.h"
#import "YKStringUtility.h"
#import "YKHttpAPIHelper.h"
#import "Go2PageUtility.h"
#import "DataWorld.h"
#import "SCNSecKillDetailViewController.h"

@implementation SCNHomeViewController


#define Tag_m_topScrollView 100
#define Tag_m_nearHotSaleScrollView 200
#define TopScrollVieWidth 320
#define NearHotSaleScrollView 306
#define Autotimer 4.0


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"名鞋库";
	[self setNavigationTitleView];
    self.pathPath = @"/home";
    self.m_homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStylePlain];
    self.m_homeTableView.delegate = self;
    self.m_homeTableView.dataSource = self;
    self.m_homeTableView.backgroundColor = [UIColor clearColor];
    self.m_homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.m_homeTableView];
    
    self.m_topIndex = 0;
    self.m_topisfromLeft = YES;
    
    self.m_topScrollView   = [[HLayoutView alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
    self.m_topScrollView.tag = Tag_m_topScrollView;
    self.m_topScrollView.delegate = self; 
    [self.m_topScrollView setToNavi];
    
    
    self.m_GpageControl = [[GrayPageControl alloc]init];    
    
}

#pragma mark -
#pragma mark 导航栏标题
-(void)setNavigationTitleView
{
	UIImageView* l_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_LOGO.png"]];
	l_imageView.backgroundColor = [UIColor clearColor];
	l_imageView.frame = CGRectMake(0, 0, l_imageView.frame.size.width, l_imageView.frame.size.height);
	self.navigationItem.titleView = l_imageView;
	self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
}
#pragma mark -
#pragma mark 导航栏按钮
-(void)setNormalNavigationItem
{
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (![m_timerTopRun isValid] && m_timerTopRun == nil) {
        m_timerTopRun = [NSTimer scheduledTimerWithTimeInterval:Autotimer target:self selector:@selector(topAutoRun:) userInfo:nil repeats:YES];
    }

    if (![self isRequestSuccess]) 
	{
        [self requestGetHomeJSON];
    }
    
}


#pragma mark-
#pragma mark 请求解析数据
//http://appapai.loc/api.php?method=home.view.index
-(void)requestGetHomeJSON
{
    [self startLoading];
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:MMUSE_METHOD_GET_HOMEINFO forKey:@"method"];
    [YKHttpAPIHelper startLoadJSON:MMUSE_URL
				   extraParams:extraParamsDic
						object:self
					  onAction:@selector(onrequestGetHomeJSONData:)];
}
- (void)onrequestGetHomeJSONData:(id)json_obj
{
    [self stopLoading];
    
    if (![SCNStatusUtility isRequestSuccessJSON:json_obj]) 
    {
       NSLog(@"json 解析错误"); 
       return;
    }
    
    self.m_home_data = [[GY_Collection_Home alloc]initWithJSON:json_obj];
    [DataWorld shareData].m_home = self.m_home_data;
    
    self.arr_activity_brands = self.m_home_data.arr_activity_brands;
    self.arr_hot_goods       = self.m_home_data.arr_hot_goods;
    self.arr_recommend_brands = self.m_home_data.arr_recommend_brands;
    //第一区活动促销品牌 顶部滚动视图数据解析 搞活动的牌子们
    //第二区热销商品数据解析
    //解析其他区头标题，图片 第二区热销商品数据解析 品牌推荐
  
    [self.m_homeTableView reloadData];

}

#pragma mark
#pragma mark uitableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.m_home_data != nil) {
        return 3;// 活动 0  热销15 1 品牌推荐 3
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section >= 2)// 品牌推荐
    {
        return  [self.m_home_data.arr_recommend_brands  count];
    }
    else
    {
        return 1;//热销15

    }
    return 0;//活动
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    NSString *TopCellIdentifier = @"TopCellIdentifier";//活动
	NSString *ProductCellIdentifier = @"ProductCellIdentifier";//热销15
	NSString *ItemCellIdentifier = @"ItemCellIdentifier";// 品牌推荐
	
	UITableViewCell *cell = nil;
	
	if (section == 0)//幻灯片
	{
		cell =[tableView dequeueReusableCellWithIdentifier:TopCellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopCellIdentifier];
			[cell addSubview:[self layoutTopView:nil]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
	}
	else if(section == 1) //热销top15
	{
		cell =[tableView dequeueReusableCellWithIdentifier:ProductCellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProductCellIdentifier];
            SCNHotSellView *hotView = [[SCNHotSellView alloc] initWithFrame: CGRectMake(0, 0, 320, 89) parentVC:self];
            [cell addSubview:hotView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	}
	else //品牌推荐
	{
		cell =[tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier];
		if (cell == nil)
		{
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SCNHomeTableViewCell" owner:self options:nil];
			cell=[nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;

		}
        
        NSMutableDictionary *dict = self.arr_recommend_brands[row];
        HJManagedImageV *imagesV = (HJManagedImageV *)[cell.contentView viewWithTag:30];
        imagesV.image = [DataWorld getImageWithFile:@"home_loading_small.png"];
        
        [HJImageUtility queueLoadImageFromUrl:dict[@"brand_logo"] imageView:imagesV];
        
        UILabel *name = (UILabel *)[cell viewWithTag:31];
        name.text = dict[@"brand_name"];
        
        [YKButtonUtility setCommonCellBg:cell];
        cell.backgroundColor = [UIColor redColor];
	}

    
    return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section >=1 && self.m_home_data != nil) {
        return 27.0f;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section >=1 && self.m_home_data != nil) {
        UIView *_v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
        _v.backgroundColor = [UIColor clearColor];
        
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
        [backImageView setImage:[DataWorld getImageWithFile:@"com_sectionBackground.png"]];
        [_v addSubview:backImageView];
        

        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(27, 0, 290, 27)];
        titleLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor  = [UIColor whiteColor];
        
        [_v addSubview:titleLable];
        if (section ==1) 
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 3, 20, 20)];
            [imageView setImage:[DataWorld getImageWithFile:@"home_nearHotSale.png"]];
            [_v addSubview:imageView];
            
            titleLable.text = self.m_home_data.str_hot_goods_title;
        }
        else if(section>1)
        {
//            NSMutableArray* activity_brands = self.m_home_data.arr_activity_brands;
//            NSMutableDictionary* dict =activity_brands[(section -2)];
//
//            HJManagedImageV *imageView = [[HJManagedImageV alloc]initWithFrame:CGRectMake(4, 3, 20, 20)];
//            imageView.backgroundColor = [UIColor clearColor];
//            [imageView setImage:[DataWorld getImageWithFile:@"home_hotClassfiled.png"]];
//            [_v addSubview:imageView];
//            [HJImageUtility queueLoadImageFromUrl:dict[@"brand_image"] imageView:imageView];
//            titleLable.text = dict[@"brand_name"];
            //这里暂时只显示品牌推荐4个字了
            titleLable.text = self.m_home_data.str_recommend_brands_title;
        }

        return _v;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    switch (section) {
        case 0:
            return 144.0f;
            break;
        case 1:
            return 89.0f;
            break;
        default:
            break;
    }
    return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section=indexPath.section;
    
    NSMutableArray* activity_brands = self.arr_activity_brands;
    
    if ([activity_brands count]>0) {
        if (section>=2) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSMutableDictionary* dict = activity_brands[row];
             
            [Go2PageUtility go2WhichViewController:self 
                                          withType:@"activity"
                                   withProductCode:dict[@"brand_id"]
                                      withPStatues:0
                                     withImagesUrl:dict[@"brand_image"] 
                                         withTitle:dict[@"brand_name"]
                                     withTypeValue:@"2"];
        }
    }
}
#pragma mark-
#pragma mark scrollviewAutoRun
-(void)topAutoRun:(id)sender
{
    NSMutableArray* activity_brands = self.m_home_data.arr_activity_brands;
    
    if ([activity_brands count]>1) 
    {
        if (self.m_topIndex >= [activity_brands count] -1)
        {
            self.m_topIndex = 0;
            [self.m_topScrollView setContentOffset:CGPointMake(320*self.m_topIndex, 0)];
        }
        else
        {
            self.m_topIndex ++;
            [self.m_topScrollView setContentOffset:CGPointMake(320*self.m_topIndex, 0) animated:YES];
        }
//        if (self.m_topisfromLeft == YES) 
//        {
//            self.m_topIndex++;
//            if (self.m_topIndex >= [self.m_SCNHomeDatas.m_activityDatasArr count] -1) {
//                self.m_topisfromLeft = NO;
//                self.m_topIndex = [self.m_SCNHomeDatas.m_activityDatasArr count] - 1;
//            }
//            [self.m_topScrollView setContentOffset:CGPointMake(320*self.m_topIndex, 0) animated:YES];
//        }
//        else 
//        {
//            self.m_topIndex--;
//            if (self.m_topIndex <= 0) {
//                self.m_topisfromLeft = YES;
//                self.m_topIndex = 0;
//            }
//            [self.m_topScrollView setContentOffset:CGPointMake(320*self.m_topIndex, 0) animated:YES];
//        }

    }
    self.m_GpageControl.currentPage = self.m_topIndex;
}

#pragma mark-
#pragma mark scrollviewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([m_timerTopRun isValid] && scrollView.tag == Tag_m_topScrollView) 
    {
        [m_timerTopRun invalidate];
        m_timerTopRun = nil;
    }

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
		[self fixScrollowView:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixScrollowView:scrollView];
}

-(void)fixScrollowView:(UIScrollView *)scrollView
{
    if (scrollView.tag == Tag_m_topScrollView) {
        if (![m_timerTopRun isValid] && m_timerTopRun == nil) {
            m_timerTopRun = [NSTimer scheduledTimerWithTimeInterval:Autotimer target:self selector:@selector(topAutoRun:) userInfo:nil repeats:YES];
        }
        CGFloat x = scrollView.contentOffset.x;
		self.m_topIndex =  x/320;
        [self.m_GpageControl setCurrentPage:self.m_topIndex];
    } 
}

#pragma mark -
#pragma mark layoutTopView
-(UIView *)layoutTopView:(id)sender
{
    NSMutableArray* activity_brands = self.m_home_data.arr_activity_brands;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
    for (int i=0; i<[ activity_brands count]; i++) 
    {
        NSMutableDictionary* dict = activity_brands[i];
        
        HJManagedImageV *hjTopPicView = [[HJManagedImageV alloc]initWithFrame:CGRectMake(0, 0, 320, 144)];
        hjTopPicView.userInteractionEnabled = YES;
        hjTopPicView.backgroundColor = [UIColor whiteColor];
        [hjTopPicView setImage:[DataWorld getImageWithFile:@"home_loading.png"]];
        
        CustomHomeVCButton *TopViewButton = [CustomHomeVCButton buttonWithType:UIButtonTypeCustom];
        TopViewButton.backgroundColor = [UIColor clearColor];
        TopViewButton.frame = CGRectMake(0, 0, 320, 144);
        [TopViewButton addTarget:self action:@selector(onActionTopViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [hjTopPicView addSubview:TopViewButton];
        
       TopViewButton.m_type        = @"activity";
       TopViewButton.m_typename    = dict[@"brand_name"];
       TopViewButton.m_productCode = dict[@"brand_id"];
       TopViewButton.m_image       = dict[@"brand_image"];
       TopViewButton.m_pstatus     = 0;
        
        [ self.m_topScrollView addSubview:hjTopPicView];
        [HJImageUtility queueLoadImageFromUrl:TopViewButton.m_image imageView:hjTopPicView];
    }
    UIView *alphaview = [[UIView alloc]initWithFrame:CGRectMake(0, 133, 320, 11)];
    [alphaview setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    alphaview.userInteractionEnabled = NO;
    [self.m_GpageControl setBackgroundColor:[UIColor clearColor]];
    self.m_GpageControl.numberOfPages = [self.arr_activity_brands count];
    self.m_GpageControl.currentPage = self.m_topIndex;
    [topView addSubview:self.m_topScrollView];
    [topView addSubview:alphaview];
    [topView addSubview:self.m_GpageControl];

    self.m_GpageControl.center = alphaview.center;
    return  topView;
}

-(void)onActionTopViewButton:(id)sender
{
    CustomHomeVCButton *button = (CustomHomeVCButton *)sender;
	[self behaviorHomeUserClick:button.m_typename];
    [Go2PageUtility go2WhichViewController:self 
                                  withType:button.m_type 
                           withProductCode:button.m_productCode 
                              withPStatues:button.m_pstatus 
                             withImagesUrl:button.m_image 
                                 withTitle:button.m_typename 
                             withTypeValue:@"1"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	if ([m_timerTopRun isValid])
	{
		[m_timerTopRun invalidate];
        m_timerTopRun = nil;
	}	
}

- (void)viewDidUnload {
    [super viewDidUnload];

    self.m_homeTableView = nil;
    self.m_GpageControl = nil;
    self.m_topScrollView = nil;
}

-(BOOL)isRequestSuccess
{
	return self.m_SCNHomeDatas != nil;
}



-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|商品ID
	NSString* _param = @"图文";
	return _param;
#else
	return nil;
#endif
}

-(void)behaviorHomeUserClick:(NSString*)_topicName{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@|首页推荐区",_topicName];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_USERCLICK param:_param];
#endif
	
}
@end

