//
//  SCNCashCenterTableCell.h
//  SCN
//
//  Created by huangwei on 11-9-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyTextView.h"

@interface SCNCashCenterOrderInfoTableCell : UITableViewCell {
	UILabel* m_labTotalAmount;
	UILabel* m_labCarrige;
	UILabel* m_labPreferentAmount;
	UILabel* m_labPreferentAmountTxt;
	UILabel* m_labMobileSave;
	UILabel* m_labMobileSaveTxt;
	UIImageView* m_imgSepar;
	
}
@property(nonatomic,strong)IBOutlet UILabel* m_labTotalAmount;
@property(nonatomic,strong)IBOutlet UILabel* m_labCarrige;
@property(nonatomic,strong)IBOutlet UILabel* m_labPreferentAmount;
@property(nonatomic,strong)IBOutlet UILabel* m_labPreferentAmountTxt;
@property(nonatomic,strong)IBOutlet UILabel* m_labMobileSave;
@property(nonatomic,strong)IBOutlet UILabel* m_labMobileSaveTxt;
@property(nonatomic,strong)IBOutlet UIImageView* m_imgSepar;

@end

@interface SCNCashCenterOrderInfoDownTableCell : UITableViewCell
{
	UILabel* m_labPayAmount;
	UILabel* m_labProductCount;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labPayAmount;
@property(nonatomic,strong)IBOutlet UILabel* m_labProductCount;

@end

@interface SCNCashCenterNoReceiveInfoTableCell : UITableViewCell
{
	UILabel* m_labAddAddress;
	UIButton* m_btnAddAddress;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labAddAddress;
@property(nonatomic,strong)IBOutlet UIButton* m_btnAddAddress;

@end


@interface SCNCashCenterReceiveInfoTableCell : UITableViewCell {
	UILabel* m_labAddress;
	UILabel* m_labName;
	UILabel* m_labMobile;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labAddress;
@property(nonatomic,strong)IBOutlet UILabel* m_labName;
@property(nonatomic,strong)IBOutlet UILabel* m_labMobile;
@end

@interface SCNCashCenterPayShippingUpTableCell : UITableViewCell {
	UILabel* m_labPayMethod;
	UIImageView* m_imgTag;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labPayMethod;
@property(nonatomic,strong)IBOutlet UIImageView* m_imgTag;
@end

@interface SCNCashCenterPayShippingDownTableCell : UITableViewCell {
	UILabel* m_labUseCoupon;
	UILabel* m_labUseResult;
	UIButton* m_btnCouponSelect;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labUseCoupon;
@property(nonatomic,strong)IBOutlet UIButton* m_btnCouponSelect;
@property(nonatomic,strong)IBOutlet UILabel* m_labUseResult;
@end

@interface SCNCashCenterProductListTableCell : UITableViewCell {
	
}

@end

@interface SCNCashCenterAskInvoiceTableCell : UITableViewCell
{
	UILabel* m_labAskInvoiceTxt;
	UIButton* m_btnAskInvoiceMore;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labAskInvoiceTxt;
@property(nonatomic,strong)IBOutlet UIButton* m_btnAskInvoiceMore;

@end

@interface SCNCashCenterMessageTableCell : UITableViewCell
{
	UILabel* m_labMessageTxt;
	SyTextView* m_txtViewMessage;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labMessageTxt;
@property(nonatomic,strong)IBOutlet SyTextView* m_txtViewMessage;

@end
		   
@interface SCNCashCenterCouponPopTableCell : UITableViewCell
{
	UILabel* m_labCoupon;
	UIButton* m_btnCouponSelect;
	UIButton* m_btnCouponCancel;
	UIButton* m_btnTouch;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labCoupon;
@property(nonatomic,strong)IBOutlet UIButton* m_btnCouponSelect;
@property(nonatomic,strong)IBOutlet UIButton* m_btnCouponCancel;
@property(nonatomic,strong)IBOutlet UIButton* m_btnTouch;

@end

@interface SCNCashCenterSuccessTableCell : UITableViewCell
{
	UILabel* m_labOrderId;
	UILabel* m_labOrderPrice;
	UILabel* m_labPayMethod;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labOrderId;
@property(nonatomic,strong)IBOutlet UILabel* m_labOrderPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_labPayMethod;
@end

@interface SCNCashCenterTableCell : UITableViewCell
{
	UIImageView* m_image;
	UIImageView* m_imgBack;
	UILabel* m_labName;
	UILabel* m_labStyle;
	UILabel* m_labNumber;
	
	UILabel* m_labPriceTitle;
	UILabel* m_labPriceValue;
	UILabel* m_labSaveTitle;
	UILabel* m_labSaveValue;
	
	UITextField* m_txtNumber;
	UIImageView* m_imgArrow;
	
	UILabel* m_labTag;
	
}
@property(nonatomic,strong)IBOutlet UIImageView* m_imgBack;
@property(nonatomic,strong)IBOutlet UIImageView* m_image;
@property(nonatomic,strong)IBOutlet UILabel* m_labName;
@property(nonatomic,strong)IBOutlet UILabel* m_labStyle;
@property(nonatomic,strong)IBOutlet UILabel* m_labNumber;

@property(nonatomic,strong)IBOutlet UILabel* m_labPriceTitle;
@property(nonatomic,strong)IBOutlet UILabel* m_labPriceValue;
@property(nonatomic,strong)IBOutlet UILabel* m_labSaveTitle;
@property(nonatomic,strong)IBOutlet UILabel* m_labSaveValue;

@property(nonatomic,strong)IBOutlet UITextField* m_txtNumber;
@property(nonatomic,strong)IBOutlet UIImageView* m_imgArrow;

@property(nonatomic,strong)IBOutlet UILabel* m_labTag;

@end



