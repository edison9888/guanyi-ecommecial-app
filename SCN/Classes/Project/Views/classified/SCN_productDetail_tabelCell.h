//
//  SCN_productDetail_tabelCell.h
//  SCN
//
//  Created by yuanli on 11-9-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutManagers.h"

#import "YKCustomMiddleLineLable.h"
#import "TextBlock.h"
#import "SCNProductTagLabel.h"

@interface TopView : UIView 
{
    
}

@end
// 显示商品图片
@interface SCN_productDetail_tabelCell_First : UITableViewCell 
{
    TopView *m_topView;
}
@property (nonatomic, strong) IBOutlet TopView *m_topView;
@end



// 商品名和价格
@interface SCN_productDetail_tabelCell_Second : UITableViewCell 
{
    UILabel         *m_nameLable;
//    UILabel         *m_styleLable;
    UILabel         *m_marketPriceLable;
    UILabel         *m_sellPriceLable;
    UILabel         *m_sellLable;
    
    SCNProductTagLabel        *m_saleOneLable;
    SCNProductTagLabel        *m_saleTwoLable;
}
@property (nonatomic, strong) IBOutlet UILabel         *m_nameLable;
//@property (nonatomic, retain) IBOutlet UILabel         *m_styleLable;
@property (nonatomic, strong) IBOutlet UILabel         *m_marketPriceLable;
@property (nonatomic, strong) IBOutlet UILabel         *m_sellPriceLable;
@property (nonatomic, strong) IBOutlet UILabel         *m_sellLable;

@property (nonatomic, strong) IBOutlet SCNProductTagLabel        *m_saleOneLable;
@property (nonatomic, strong) IBOutlet SCNProductTagLabel        *m_saleTwoLable;
@end


// 更多商品信息
@interface SCN_productDetail_tabelCell_More : UITableViewCell 
{
    UILabel     *m_descLable;
    UIImageView *m_backImageV;
}
@property (nonatomic, strong) IBOutlet UILabel     *m_descLable;
@property (nonatomic, strong) IBOutlet UIImageView *m_backImageV;
@end


// 颜色 尺码 数量
@interface SCN_productDetail_tabelCell_Color : UITableViewCell 
{
    HLayoutView *m_colorLayoutView;
    HLayoutView *m_sizeLayutView; 
    
    UIButton *m_colorFrontButton;
    UIButton *m_colorBehindButton;
    
    UIButton *m_sizeFrontButton;
    UIButton *m_sizeBehindButton;
    
    UIButton *m_addCountButton;
    UIButton *m_cutCountButton;
    
    UIButton *m_sizeSwitch;
    
    UITextField *m_countsTextField;
    UILabel     *m_disCountLable;
    
}
@property (nonatomic, strong) IBOutlet HLayoutView *m_colorLayoutView;
@property (nonatomic, strong) IBOutlet HLayoutView *m_sizeLayutView;

@property (nonatomic, strong) IBOutlet UIButton    *m_colorFrontButton;
@property (nonatomic, strong) IBOutlet UIButton    *m_colorBehindButton;

@property (nonatomic, strong) IBOutlet UIButton    *m_sizeFrontButton;
@property (nonatomic, strong) IBOutlet UIButton    *m_sizeBehindButton;

@property (nonatomic, strong) IBOutlet UIButton    *m_addCountButton;
@property (nonatomic, strong) IBOutlet UIButton    *m_cutCountButton;

@property (nonatomic, strong) IBOutlet UIButton    *m_sizeSwitch;

@property (nonatomic, strong) IBOutlet UITextField *m_countsTextField;
@property (nonatomic, strong) IBOutlet UILabel     *m_disCountLable;
@end


// 尺码
@interface SCN_productDetail_tabelCell_Size : UITableViewCell 
{
    
}
@end


// 数量
@interface SCN_productDetail_tabelCell_Count : UITableViewCell 
{
    
}
@end


// 加入购物车
@interface SCN_productDetail_tabelCell_Buy : UITableViewCell 
{
    UIButton *m_buyImmediatelyButton;
    UIButton *m_addShopCarButton;
    UIButton *m_addfavoriteButton;
}
@property (nonatomic, strong) IBOutlet UIButton *m_buyImmediatelyButton;
@property (nonatomic, strong) IBOutlet UIButton *m_addShopCarButton;
@property (nonatomic, strong) IBOutlet UIButton *m_addfavoriteButton;

@end
//自定义分享按钮
@interface share_CustomButton: UIButton 
{
    NSString *shareUrl;
}
@property (nonatomic, strong) NSString *shareUrl;
@end
// 分享
@interface SCN_productDetail_tabelCell_Share : UITableViewCell 
{
    
    share_CustomButton *m_shareSinaButton;
    share_CustomButton *m_shareTXButton;
    share_CustomButton *m_shareMailButton;
    share_CustomButton *m_shareNoteButton;
}
@property (nonatomic, strong) IBOutlet share_CustomButton *m_shareSinaButton;
@property (nonatomic, strong) IBOutlet share_CustomButton *m_shareTXButton;
@property (nonatomic, strong) IBOutlet share_CustomButton *m_shareMailButton;
@property (nonatomic, strong) IBOutlet share_CustomButton *m_shareNoteButton;
@end



