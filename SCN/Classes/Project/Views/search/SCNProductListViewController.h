//
//  SCNProductListViewController.h
//  SCN
//  
//  显示搜索结果
//
//  Created by x x on 12-08-03.
//  Copyright 2012年 Guanyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SCNSearchData.h"
#import "BaseViewController.h"
#import "HLayoutView.h"
#import "SCNSearchData.h"
#import "SCNHotSellView.h"
#import "GY_Collections.h"

/**
    委托用于筛选页面的参数传递
    pram: filterData 筛选数据对象SCNSearchProductFilterData
 */
@protocol SCNProductFilterDelegate <NSObject>
-(void)receiveFilterData:(NSMutableDictionary*)userFilterData;

@end

/**
    商品列表视图控制器
 */
typedef enum{
    SortToOldProduct=0,
    SortToNewProduct,
    PriceUp,
    PriceDrop,
    SellCountUp,
    SellCountDrop,
}sorttype;
typedef enum{ //枚举器，表示了三种类型
	ArrowUp = 0,
	ArrowDown,
} ButtonArrowState;

@interface SCNProductListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAccelerometerDelegate,SCNProductFilterDelegate>{
  
    BOOL _isNewSortUp;                                  //是否是商品由旧到新
    BOOL _isPriceSortUp;                                //是否是价格由低到高
	BOOL _isSellSortUp;                                 //是否是销量由少到多
    BOOL _isListMode;                                   //是否是列表模式
                          
    int m_int_lastMode;                                 //记录上一次模式(用于优化)
    int m_int_sorttype;                                 //排序类型
    int m_int_lastSortBtn;                              //记录上一个排序按钮
    
    //请求相关
    BOOL _isRequestSuccess;                             //是否请求成功的标记位

    BOOL _isRequesting;                                 //是否请求中
    NSUInteger m_int_lastPage;                                 //记录上一页
    NSUInteger m_int_currPage;                                 //当前页数
    NSUInteger m_int_currPageSize;                             //每页商品数


    //重力加速计相关
    UIAccelerationValue	m_myAccelerometer[3];           //坐标
    CFTimeInterval		m_lastTime;
}
@property(nonatomic,strong)IBOutlet UIButton *m_button_newProduct;          //新品按钮
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_newSort;       //新品箭头图片
@property(nonatomic,strong)IBOutlet UIButton *m_button_price;               //价格
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_priceSort;     //价格箭头图片
@property(nonatomic,strong)IBOutlet UIButton *m_button_saleCount;           //销量
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_sellSort;      //销量箭头图片

@property(nonatomic,strong)IBOutlet UITableView *m_tableView_productList;   //商品列表
@property(nonatomic,strong)NSMutableArray *m_array_productList;             //接收商品数据的数组
@property(nonatomic,strong)NSMutableDictionary *m_dict_filterData;          //接收筛选信息的字典
@property(nonatomic,strong)NSMutableDictionary *m_dict_userFilterData;      //接收商品筛选页面返回数据字典
@property(nonatomic,strong)NSMutableString *m_string_filterContent;         //提交的筛选数据
@property(nonatomic,strong)NSString *m_string_keyword;                      //记录关键字    
@property(nonatomic,strong)NSString *m_string_categoryId;                   //记录分类ID

@property(nonatomic,strong)NSString *m_string_type;                         //首页传过来的类型
@property(nonatomic,strong)NSString *m_string_typeId;                       //首页传过来的类型ID
@property(nonatomic,strong)NSString *m_string_typeName;                     //首页传过来的类型名称
@property(nonatomic,strong)NSString *m_string_brandId;                      //品牌Id


@property(nonatomic,strong)IBOutlet UILabel *m_label_pageSchedule;          //显示浏览进度

//没有结果页面
@property(nonatomic,strong)IBOutlet UIView *m_view_noResult;                //无搜索结果View
@property(nonatomic,strong)IBOutlet UILabel *m_label_hotSellTitle;          //热卖通知栏信息


@property(nonatomic,assign)BOOL _isSearch;                                  //是否由搜索页面过来


@property(nonatomic,strong)SCNSearchProductListData *m_data_listAttributeData;  //记录商品列表的属性
@property(nonatomic,unsafe_unretained)NSNumber *m_number_requestID;         //标记上一次请求ID

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString *)keyword categoryId:(NSString*)categoryid isSearch:(BOOL)isSearch brandID:(NSString*)brandid typeId:(NSString*)typeId type:(NSString*)type;

-(void)rightNavigationItemCreate;                       //创建浏览模式按钮
-(void)onActionModeButtonPressed:(id)sender;            //模式按钮事件处理
-(void)onActionFilterButtonPressed:(id)sender;          //筛选按钮事件处理
-(IBAction)onActionSortTypeButtonPressed:(id)sender;    //排序按钮事件处理
-(void)resetDataSource;                                 //初始化视图状态
-(BOOL)isActivityList;
-(void)requestProductList:(int)currentpage;             //请求商品列表数据
-(void)startViewAnimation:(UIImageView*)imgView degreesToRadians:(int)degree;//开启一个图片旋转动画
-(void)dealAllView:(BOOL)isEnter;						//重新处理视图
-(void)resetAllView;									//重新布局视图
-(void)adjustNaviBtn;

-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;
@end

