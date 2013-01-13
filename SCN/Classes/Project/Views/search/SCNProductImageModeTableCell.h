//
//  SCNProductImageModeTableCell.h
//  SCN
//
//  Created by xie xu on 11-10-11.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCustomMiddleLineLable.h"
#import "SCNProductButton.h"
#import "SCNProductTagLabel.h"

@interface SCNProductImageModeTableCell : UITableViewCell{
    //左边商品
    SCNProductButton *m_button_product_left;                    //左边商品button
    UILabel *m_label_product_name_left;                         //商品名
    YKCustomMiddleLineLable *m_label_product_marketPrice_left;  //市场价
    UILabel *m_label_product_sellPrice_left;                    //销售价
    UIImageView *m_imageView_product_left;                      //商品图片视图
    SCNProductTagLabel *m_label_product_type1_left;             //商品标签1
    SCNProductTagLabel *m_label_product_type2_left;             //商品标签2
    UIView *m_view_left;                                        //商品信息视图
    
    //右边商品
    SCNProductButton *m_button_product_right;                   //右边商品button
    UILabel *m_label_product_name_right;                        //商品名
    YKCustomMiddleLineLable *m_label_product_marketPrice_right; //市场价
    UILabel *m_label_product_sellPrice_right;                   //销售价
    UIImageView *m_imageView_product_right;                     //商品图片视图
    SCNProductTagLabel *m_label_product_type1_right;            //商品标签1
    SCNProductTagLabel *m_label_product_type2_right;            //商品标签2
    UIView *m_view_right;                                       //商品信息视图
}
@property(nonatomic,retain)IBOutlet SCNProductButton *m_button_product_left;
@property(nonatomic,retain)IBOutlet UILabel *m_label_product_name_left;
@property(nonatomic,retain)IBOutlet YKCustomMiddleLineLable *m_label_product_marketPrice_left;
@property(nonatomic,retain)IBOutlet UILabel *m_label_product_sellPrice_left;
@property(nonatomic,retain)IBOutlet UIImageView *m_imageView_product_left;
@property(nonatomic,retain)IBOutlet SCNProductTagLabel *m_label_product_type1_left;
@property(nonatomic,retain)IBOutlet SCNProductTagLabel *m_label_product_type2_left;
@property(nonatomic,retain)IBOutlet UIView *m_view_left;
@property(nonatomic,retain)IBOutlet SCNProductButton *m_button_product_right;
@property(nonatomic,retain)IBOutlet UILabel *m_label_product_name_right;
@property(nonatomic,retain)IBOutlet YKCustomMiddleLineLable *m_label_product_marketPrice_right;
@property(nonatomic,retain)IBOutlet UILabel *m_label_product_sellPrice_right;
@property(nonatomic,retain)IBOutlet UIImageView *m_imageView_product_right;
@property(nonatomic,retain)IBOutlet SCNProductTagLabel *m_label_product_type1_right;
@property(nonatomic,retain)IBOutlet SCNProductTagLabel *m_label_product_type2_right;
@property(nonatomic,retain)IBOutlet UIView *m_view_right;
@end
