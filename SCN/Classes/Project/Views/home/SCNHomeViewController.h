//
//  SCNHomeViewController.h
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LayoutManagers.h"
#import "GrayPageControl.h"
#import "SCNHomeData.h"
#import "GY_Collections.h"


@interface SCNHomeViewController : BaseViewController 
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate> {
    
    
    NSTimer         *m_timerTopRun;                   //顶部定时滚动
    
    
}
@property (nonatomic, strong) SCNHomeData     *m_SCNHomeDatas;


@property (nonatomic, assign) BOOL        m_topisfromLeft;//判断顶部图片是否从左到右开始滚动
@property (nonatomic, assign) BOOL        m_hotisfromLeft;//判断热销图片是否从左到右开始滚动

@property (nonatomic, assign) int         m_topIndex;//顶部当前商品

@property (nonatomic, strong) UITableView     *m_homeTableView;//所有视图都加在表格上
@property (nonatomic, strong) HLayoutView     *m_topScrollView;//顶部滚动视图

@property (nonatomic, strong) GrayPageControl *m_GpageControl;//顶部pageControl


@property (nonatomic, strong) NSString        *m_hotSaleTitle; //热卖产品标题

@property (nonatomic, strong) GY_Collection_Home* m_home_data;  // home 页面 的 json 数据
#pragma mark -
#pragma mark 暂存属性 纯粹为了操作方便而存在的临时变量
@property (nonatomic, strong) NSMutableArray* arr_activity_brands;//顶部活动专区数据
@property (nonatomic, strong) NSMutableArray* arr_hot_goods; //热销商品数据
@property (nonatomic, strong) NSMutableArray* arr_recommend_brands; //推荐品牌

//栏目组区头数据
//栏目组每个区的数据


-(void)setNavigationTitleView;
-(UIView *)layoutTopView:(id)sender;
-(void)onActionTopViewButton:(id)sender;

-(void)topAutoRun:(id)sender;
-(void)fixScrollowView:(UIScrollView *)scrollView;

-(BOOL)isRequestSuccess;

//页面跳转行为统计
-(NSString*)pageJumpParam;
-(void)behaviorHomeUserClick:(NSString*)_topicName;




@end
