//
//  SCNBrandClassifiedViewController.h
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//  品牌浏览界面
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNBrandClassfiledData.h"
#import "GY_Models.h"
#import "GY_Collections.h"


@interface GY_Brands_Controller : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
	
    UIView              *m_backView;          /**为了view翻转时下面不会显示(上个页面的视图)
                                                本页面的所有视图加到此视图(self.backView)上
                                                setAnimationTransition时用self.backView
                                             */
	UITableView         *m_tableview;
	NSString            *m_FatherId;        // 请求的商品类型
    
    NSArray             *m_brandA_ZArr;        // 所有品牌搜索索引
    NSMutableArray      *m_brandsArr;          // 分类列表品牌数据
    
    BOOL                m_isText;
    
    SCNBrandClassfiledData *m_brandClassDatas;        //品牌浏览数据类
/*---------------------------------------图片形式浏览视图---------------------------------------*/    
    UIView              *m_pictureStyleView;
    UITableView         *m_p_tableView;
    
    UIButton    *m_p_outdoorsSports;  //    
    UIButton    *m_p_femaleShoes;
    UIButton    *m_p_maleShoes;
    
    NSMutableArray *m_hotSellProductArr;//热门商品
    NSMutableArray *m_allSellProductArr;//全部商品
    
    int             m_currentIndex;     //排列单元格时开始索引
    int             m_finishFor;        //排列单元格时结束索引
    
    NSString        *m_titleForSection; //不同区的头标题
}
@property (nonatomic, strong) SCNBrandClassfiledData *m_brandClassDatas;

@property (nonatomic, assign) BOOL                 m_isText;


@property (nonatomic, strong) NSString             *m_FatherId;
@property (nonatomic, strong) UIView               *m_backView;
@property (nonatomic, strong) UITableView *m_tableview;

@property (nonatomic, strong) GY_Collection_Brands  *m_collection_brands;

/*---------------------------------------图片形式浏览视图---------------------------------------*/

@property (nonatomic, strong) IBOutlet  UIView               *m_pictureStyleView;
@property (nonatomic, strong) IBOutlet  UITableView          *m_p_tableView;

@property (nonatomic, strong) IBOutlet  UIButton             *m_p_outdoorsSports;
@property (nonatomic, strong) IBOutlet  UIButton             *m_p_femaleShoes;
@property (nonatomic, strong) IBOutlet  UIButton             *m_p_maleShoes;

@property (nonatomic, strong) IBOutlet  UIButton             *m_top_p_outdoorsSports;
@property (nonatomic, strong) IBOutlet  UIButton             *m_top_p_femaleShoes;
@property (nonatomic, strong) IBOutlet  UIButton             *m_top_p_maleShoes;

@property (nonatomic, assign) int             m_currentIndex;
@property (nonatomic, assign) int             m_finishFor;
@property (nonatomic, strong) NSString        *m_titleForSection;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFatherId:(NSString*)fatherId;
-(void)setNormalNavigationItem:(BOOL)isText;
-(void)changeViewController:(id)sender;

-(IBAction)onActionChangeStyleShoes:(id)sender;
-(void)layoutCellSubViews:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;//布局单元格中的内容
-(NSUInteger)get_brand_icon_tableview_row_in_section_count:(NSMutableArray*)data;
@end


@interface Brand_pictureButton : UIButton 
{
    NSString *m_brandId;
    NSString *m_brandName;
}
@property (nonatomic, strong) NSString *m_brandId;
@property (nonatomic, strong) NSString *m_brandName;
@end