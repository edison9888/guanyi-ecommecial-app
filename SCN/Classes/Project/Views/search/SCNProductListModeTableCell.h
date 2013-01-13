//
//  SCNProductListModeTableCell.h
//  SCN
//
//  Created by xie xu on 11-10-10.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCustomMiddleLineLable.h"
@interface SCNProductListModeTableCell : UITableViewCell{
    UILabel *m_label_product_name;//商品名
    YKCustomMiddleLineLable *m_label_product_marketPrice;//市场价
    UILabel *m_label_product_sellPrice;//销售价
    UIImageView *m_imageView_product;//商品图片视图
    UILabel *m_label_product_type1;//商品标签1
    UILabel *m_label_product_type2;//商品标签2
    UILabel *m_label_product_type3;//商品标签3
}
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_name;
@property(nonatomic,strong)IBOutlet YKCustomMiddleLineLable *m_label_product_marketPrice;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_sellPrice;
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_product;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_type1;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_type2;
@property(nonatomic,strong)IBOutlet UILabel *m_label_product_type3;
@end
