//
//  SCNSecKillDetailViewController.h
//  SCN
//
//  Created by yuanli on 11-10-18.
//  Copyright 2011年 Yek.me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LayoutManagers.h"
#import "SCNSecKillListTableCell.h"
#import "SCNProductDetailData.h"
#import "SCN_SwitchSizeViewController.h"

typedef enum
{
	ESeckillDetailUnStart = -1,
	ESeckillDetailRunning,
	ESeckillDetailEnd,
}ESeckillDetailTimeState;

@interface SCNSecKillDetailViewController : BaseViewController
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SwitchSizeDelegate>{
    UITableView     *m_tableView;
    
    SCNProductDetailData *m_secKillDatas;           //秒杀数据类
    HLayoutView     *m_topScrollView;               //顶部图片
    HLayoutView     *m_sizeScrollView;              //尺寸
    UIPageControl   *m_pageController;              
    NSTimer         *m_updateTime;
    
    NSString        *m_prodctCode;                  //商品id
    NSString        *m_productSku;                  //所选的尺寸
    NSString        *m_stock;                       //
    
    UIButton        *m_leftButton;                  //m_sizeScrollView左边箭头
    UIButton        *m_rightButton;                 //m_sizeScrollView右边箭头
    
    UIButton        *m_secKilButton;                //秒杀按钮
    
    UILabel         *m_secTitleLable;               //秒杀图片上面的文字
    UILabel         *m_sellPriceLable;
    UILabel         *m_nowPriceLable;
    UILabel         *m_remainCountLable;
    UILabel         *m_start_endLable;
    UILabel         *m_timeLable;
	
    int				m_runningState;
}
@property (nonatomic, strong) UILabel         *m_secTitleLable;
@property (nonatomic, strong) UILabel         *m_sellPriceLable;
@property (nonatomic, strong) UILabel         *m_nowPriceLable;
@property (nonatomic, strong) UILabel         *m_remainCountLable;
@property (nonatomic, strong) UILabel         *m_start_endLable;
@property (nonatomic, strong) UILabel         *m_timeLable;

@property (nonatomic, strong) UIButton        *m_secKilButton;
@property (nonatomic, strong) UIButton        *m_leftButton;
@property (nonatomic, strong) UIButton        *m_rightButton;


@property (nonatomic, strong) SCNProductDetailData *m_secKillDatas;
@property (nonatomic, strong) HLayoutView     *m_topScrollView;
@property (nonatomic, strong) HLayoutView     *m_sizeScrollView;
@property (nonatomic, strong) UIPageControl   *m_pageController;
@property (nonatomic, strong) NSString        *m_prodctCode;
@property (nonatomic, strong) NSString        *m_productSku;
@property (nonatomic, strong) NSString        *m_stock;

@property (nonatomic, strong) UITableView *m_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
      withProductCode:(NSString *)productCode;
-(void)requestGetSecKillProductInfoXmlData;
-(BOOL)isProductSellOut;
-(BOOL)isSeckillTimeing;//秒杀的时间进行中，但商品可能卖完了
-(BOOL)isSeckilling;//判断是否秒杀进行中

-(void)layout_TopScrollView:(SCN_SecKillDetail_tabelCell_One *)first_cell;
-(void)layout_SizeScrollView:(HLayoutView *)sizeScrollview;
-(void)removeImageFromCustomButton:(id)sender;
-(void)UpdateProductInfo:(id)sender;
-(void)fixScrollowView:(UIScrollView *)scrollView;
-(void)ifHidenForAllertScroll:(UIScrollView *)Scrollview;
-(void)NotifyNoProduct:(NSNotification *)notify;
-(void)onAction_checkSize:(id)sender;
#pragma mark Behavior
-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;
-(void)doSeckillBehavior;
@end 
