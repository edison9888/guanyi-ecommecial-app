//
//  SCN_productDetailViewController.h
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//	商品详情界面
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YKCheckBox.h"
#import "YKCustomMiddleLineLable.h"
#import "TextBlock.h"
#import "SCN_productDetail_tabelCell.h"
#import "SCNProductDetailData.h"
#import "SCN_SwitchSizeViewController.h"
@interface SCN_productDetailViewController : BaseViewController
<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SwitchSizeDelegate,UIAlertViewDelegate> {
    
    UITableView     *m_tableview;
    NSArray         *m_heightOfRow;     //tableView行高      
    UITextField     *m_countTextField;  //选择数量
    UILabel         *m_disCountLable;   //库存数
    int             m_totalCount;       //总数
    int             m_IndexTopSV;       //顶部图片当前页码
    HLayoutView     *m_colorScrollView;
    HLayoutView     *m_sizeScrollView;
    
    NSString        *m_productCode;     //商品id，和sku必须有一个
    NSString        *m_sku;             //商品唯一标识
    NSString        *m_productColor;    //所选的颜色
    NSString        *m_productSize;     //所选的尺寸
    NSString        *m_imageUrl;        //保存到浏览记录中的图片地址
    
    SCNProductDetailData *m_productDetailDatas;
    SCN_productDetail_tabelCell_Buy *m_buy_cell;
    //颜色，尺寸旁边的两个小箭头
    UIButton        *m_colorLeftBT;
    UIButton        *m_colorRightBT;
    UIButton        *m_sizeLeftBT;
    UIButton        *m_sizeRightBT;
}
@property (nonatomic, strong) SCN_productDetail_tabelCell_Buy *m_buy_cell;

@property (nonatomic, strong) UIButton        *m_colorLeftBT;
@property (nonatomic, strong) UIButton        *m_colorRightBT;
@property (nonatomic, strong) UIButton        *m_sizeLeftBT;
@property (nonatomic, strong) UIButton        *m_sizeRightBT;

@property (nonatomic, assign) int             m_totalCount;
@property (nonatomic, assign) int             m_IndexTopSV;
@property (nonatomic, strong) SCNProductDetailData *m_productDetailDatas;
@property (nonatomic, strong) HLayoutView     *m_colorScrollView;
@property (nonatomic, strong) HLayoutView     *m_sizeScrollView;

@property (nonatomic, strong) NSString        *m_productCode;
@property (nonatomic, strong) NSString        *m_sku;
@property (nonatomic, strong) NSString        *m_productColor;
@property (nonatomic, strong) NSString        *m_productSize;
@property (nonatomic, strong) NSString        *m_imageUrl;


@property (nonatomic, strong) UITextField     *m_countTextField;
@property (nonatomic, strong) UILabel         *m_disCountLable;
@property (nonatomic, strong) UITableView	  *m_tableview;
@property (nonatomic, strong)NSArray          *m_heightOfRow;

-(id)initWithNibName:(NSString *)nibNameOrNil 
              bundle:(NSBundle *)nibBundleOrNil 
     withProductCode:(NSString *)productCode 
       withwithImage:(NSString*)imgUrl;

-(void)layout_TopPcitureView:(TopView *)topView;
-(void)layout_ColorScrollView:(HLayoutView *)colorScrollview;
-(void)layout_SizeScrollView:(HLayoutView *)sizeScrollview;
-(void)fixScrollowView:(UIScrollView *)scrollView;      //调整scrollView位置
-(void)fixHJManagedImageVAlpha:(UIScrollView *)scrollView index:(int)index;//调整透明度
-(void)ifHidenForAllertScroll:(UIScrollView *)Scrollview;
-(void)layout_secondTableViewCell:(UITableViewCell *)cell;//动态排布第二个单元格
-(void)request_getProductInfoXmlData;//获得商品详情信息
-(void)request_addFavoriteInfoXmlData;//加入收藏夹
-(void)go2PayPriceCenterView;         //立即购买
-(void)addShopingCar;                 //添加到购物车
-(void)removeImageFromCustomButton:(id)sender;
-(void)updateDisCount:(id)sender;
-(void)onAction_checkSize:(id)sender;
-(BOOL)judgmentDatas:(id)sender;               //判断选择是否选择尺寸,数量

-(void)immediateCashWithShoppingcart;//立即结算（购物车中所有商品）
-(void)immediateCashWithoutShoppingcart;//立即购买(不包括购物车中的商品)
-(void)go2PayPriceCenterView;//直接购买，不通过购物车,直接去结算中心
-(void)immediateCash;
-(BOOL)hideKeyBorod;//判断键盘是否隐藏,和进行下一步操作
#pragma mark behavior
-(void)addShoppingcartBehavior;
-(void)immediateBuyBehavior;
-(void)addFavoriteBehavior;
-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;

-(void)refreshNowProduct;//用于把当前正在浏览的数据存入公共数据类中
@end


//自定义 颜色 尺码 按钮..............................
@interface CustomButton :UIButton{
//颜色选项
NSString *colorRgb;         //没有图片时rgb色值                  
NSString *colorImagUrl;     //颜色图片url
NSString *colorProductCode; //不同的颜色对应的商品id
NSString *colorName;        //颜色的名字
NSString *colorCheck;
//尺寸选项
NSString *sizeSku;          //尺码类型
NSString *sizeStocks;       //当前尺寸对应的库存
BOOL   isCheck;             //是否点击过
}
@property (nonatomic, assign) BOOL   isCheck;
@property (nonatomic, strong) NSString *colorRgb;
@property (nonatomic, strong) NSString *colorImagUrl;
@property (nonatomic, strong) NSString *colorProductCode;
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic, strong) NSString *colorCheck;

@property (nonatomic, strong) NSString *sizeSku;
@property (nonatomic, strong) NSString *sizeStocks;

@end
 