//
//  SCNSecKillListTableCell.h
//  SCN
//
//  Created by xie xu on 11-10-17.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNProductButton.h"

#import "LayoutManagers.h"
#import "TextBlock.h"
#import "HJManagedImageV.h"

@interface SCNSecKillListTableCell : UITableViewCell{
    UIImageView *m_imageView_left;//左边秒杀商品图片
    UILabel *m_label_product_secKillPrice_left;//左边秒杀价
    UILabel *m_label_product_price_left;//左边原价
    UILabel *m_label_product_discount_left;//左边折扣
    UILabel *m_label_product_name_left;//左边商品名
    UILabel *m_label_product_time_left;//左边时间状态
    UILabel *m_label_product_status_left;//左边标记秒杀状态的文字
    UIImageView *m_imageView_status_left;//左边标记秒杀状态的图片
    UILabel *m_label_secKillPrice_status_left;//左边标记秒杀状态的价格
    SCNProductButton *m_button_product_left;//左边商品按钮
    
    UIImageView *m_imageView_right;//右边秒杀商品图片
    UILabel *m_label_product_secKillPrice_right;//右边秒杀价
    UILabel *m_label_product_price_right;//右边原价
    UILabel *m_label_product_discount_right;//右边折扣
    UILabel *m_label_product_name_right;//右边商品名
    UILabel *m_label_product_time_right;//右边时间状态
    UILabel *m_label_product_status_right;//右边标记秒杀状态的文字
    UIImageView *m_imageView_status_right;//右边标记秒杀状态的图片
    UILabel *m_label_secKillPrice_status_right;//右边标记秒杀状态的价格
    SCNProductButton *m_button_product_right;//右边商品按钮
    
}
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_secKillPrice_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_price_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_discount_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_name_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_time_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_status_left;
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_status_left;
@property(nonatomic,strong)IBOutlet SCNProductButton *m_button_product_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_secKillPrice_status_left;

@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_secKillPrice_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_price_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_discount_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_name_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_time_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_status_right;
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_status_right;
@property(nonatomic,strong)IBOutlet SCNProductButton *m_button_product_right;
@property(nonatomic,strong)IBOutlet UILabel *m_label_secKillPrice_status_right;
@end

//秒杀详情顶部图片
@interface SCN_SecKillDetail_tabelCell_One : UITableViewCell 
{
    UILabel             *m_titleLable;
    UILabel             *m_sellPriceLable;
    UILabel             *m_nowPriceLable;
    UILabel             *m_remainCountLable;
    
    HLayoutView         *m_topScrollV;
    UIPageControl       *m_pageController;
    
    
}
@property(nonatomic, strong)IBOutlet UILabel             *m_titleLable;
@property(nonatomic, strong)IBOutlet UILabel             *m_sellPriceLable;
@property(nonatomic, strong)IBOutlet UILabel             *m_nowPriceLable;
@property(nonatomic, strong)IBOutlet UILabel             *m_remainCountLable;

@property(nonatomic, strong)IBOutlet HLayoutView         *m_topScrollV;
@property(nonatomic, strong)IBOutlet UIPageControl       *m_pageController;
 
@end

//关于秒杀商品的描述
@interface SCN_SecKillDetail_tabelCell_Two : UITableViewCell 
{
    UILabel             *m_statr_EndLable;
    UILabel             *m_timeLable;
    
    UIButton            *m_secKil;
    TextBlock           *m_secDescLable;
    
}
@property(nonatomic, strong)IBOutlet UILabel             *m_statr_EndLable;
@property(nonatomic, strong)IBOutlet UILabel             *m_timeLable;

@property(nonatomic, strong)IBOutlet UIButton            *m_secKil;
@property(nonatomic, strong)IBOutlet TextBlock           *m_secDescLable;
 
@end

//更多商品信息
@interface SCN_SecKillDetail_tabelCell_More : UITableViewCell 
{
    UILabel     *m_descLable;//更多商品信息描述
    UIImageView *m_backImageV;
}
@property (nonatomic, strong) IBOutlet UILabel     *m_descLable;
@property (nonatomic, strong) IBOutlet UIImageView *m_backImageV;
@end

@interface SCN_SecKillDetail_tabelCell_Size : UITableViewCell 
{
    UIButton *m_leftButton;
    UIButton *m_rightButton;
    UIButton  *m_siwtchSizeButton;
    
    HLayoutView     *m_sizeScrollView;
}
@property (nonatomic, strong) IBOutlet UIButton         *m_leftButton;
@property (nonatomic, strong) IBOutlet UIButton         *m_rightButton;
@property (nonatomic, strong) IBOutlet UIButton         *m_siwtchSizeButton;

@property (nonatomic, strong) IBOutlet HLayoutView      *m_sizeScrollView;
@end
