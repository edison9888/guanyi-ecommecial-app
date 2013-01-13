//
//  SCNShoppingcartTableCell.h
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"YKCustomMiddleLineLable.h"

@interface SCNShoppingcartTableCell : UITableViewCell {

	UIImageView* m_image;		//预览图
	UILabel* m_name;			//名称
	UILabel* m_size;			//尺码
	UILabel* m_color;			//颜色
	UILabel* m_number;			//数量
	UILabel* m_unitPrice;		//单价
	UILabel* m_preferential;	//优惠小计
	
	UITextField *m_txtNumber;
	
	UIButton* m_btnMoreFun;		//更多功能按钮
}
@property(nonatomic,strong)IBOutlet UIImageView* m_image;
@property(nonatomic,strong)IBOutlet UILabel* m_name;
@property(nonatomic,strong)IBOutlet UILabel* m_size;
@property(nonatomic,strong)IBOutlet UILabel* m_color;
@property(nonatomic,strong)IBOutlet UILabel* m_number;
@property(nonatomic,strong)IBOutlet UILabel* m_unitPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_preferential;
@property(nonatomic,strong)IBOutlet UIButton* m_btnMoreFun;
@property(nonatomic,strong)IBOutlet UITextField *m_txtNumber;

@end

@interface SCNShoppingcartTableHeadCell : UITableViewCell
{
	UILabel* m_originalPrice;			//原始价格
	UILabel* m_preferentailPrice;		//优惠价格
	UILabel* m_totalPrice;				//商品总价
	UILabel* m_productNumber;			//商品数量
}
@property(nonatomic,strong)IBOutlet UILabel* m_originalPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_preferentailPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_totalPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_productNumber;
	
@end

@interface SCNShoppingcartNameValueTableCell : UITableViewCell
{
	UILabel* m_labName;
	YKCustomMiddleLineLable* m_labValue;
	UIImageView* m_imgSepar;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labName;
@property(nonatomic,strong)IBOutlet YKCustomMiddleLineLable* m_labValue;
@property(nonatomic,strong)IBOutlet UIImageView* m_imgSepar;

@end


