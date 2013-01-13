//
//  SCNSecKillListTableCell.m
//  SCN
//
//  Created by xie xu on 11-10-17.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNSecKillListTableCell.h"

@implementation SCNSecKillListTableCell
@synthesize m_imageView_left;
@synthesize m_label_product_secKillPrice_left;
@synthesize m_label_product_price_left;
@synthesize m_label_product_discount_left;
@synthesize m_label_product_name_left;
@synthesize m_label_product_time_left;
@synthesize m_imageView_right;
@synthesize m_label_product_secKillPrice_right;
@synthesize m_label_product_price_right;
@synthesize m_label_product_discount_right;
@synthesize m_label_product_name_right;
@synthesize m_label_product_time_right;
@synthesize m_button_product_left;
@synthesize m_button_product_right;
@synthesize m_label_product_status_left;
@synthesize m_label_product_status_right;
@synthesize m_imageView_status_left;
@synthesize m_imageView_status_right;
@synthesize m_label_secKillPrice_status_left;
@synthesize m_label_secKillPrice_status_right;

@end

//秒杀详情顶部图片
@implementation SCN_SecKillDetail_tabelCell_One

@synthesize m_titleLable,m_sellPriceLable,m_nowPriceLable,m_remainCountLable;
@synthesize m_topScrollV,m_pageController;

-(void)dealloc{
    m_titleLable = nil;
    m_sellPriceLable = nil;
    m_nowPriceLable = nil;
    m_remainCountLable = nil ;
    
    m_topScrollV = nil; 
    m_pageController = nil;
}
@end

//关于秒杀商品的描述
@implementation SCN_SecKillDetail_tabelCell_Two
@synthesize m_statr_EndLable,m_timeLable;
@synthesize m_secKil;
@synthesize m_secDescLable;
-(void)dealloc{
    m_statr_EndLable = nil;
    m_timeLable = nil;
    
    m_secKil = nil;
    m_secDescLable = nil;
}
@end

//更多商品信息
@implementation SCN_SecKillDetail_tabelCell_More
@synthesize m_descLable,m_backImageV;
-(void)dealloc{
    m_descLable = nil;
    m_backImageV = nil;
}
@end
//尺寸选择
@implementation SCN_SecKillDetail_tabelCell_Size
@synthesize m_leftButton,m_rightButton,m_siwtchSizeButton;
@synthesize m_sizeScrollView;
-(void)dealloc{
    m_leftButton = nil;
    m_rightButton = nil;
    m_siwtchSizeButton = nil;
    m_sizeScrollView = nil;
}
@end




