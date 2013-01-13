//
//  SCNCashCenterSubviews.h
//  SCN
//
//  Created by huangwei on 11-10-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNCommonPickerView.h"
#import "SyTextView.h"

@protocol CouponPopViewDelegate<NSObject>
-(void)couponPopViewDelegate:(NSString*)couponId;
@end

@protocol CouponPopMessageDelegate<NSObject>
-(void)couponPopMessageDelegate:(NSString*)message;
@end

@protocol CouponPopInvoiceDelegate<NSObject>
-(void)couponPopInvoiceDelegate:(NSString*)invoiceTxt invoiceType:(NSString*)invoiceType;
@end

@interface SCNCashCenterCouponInputView : UIControl<UITextFieldDelegate>
{
	UITextField* m_txtCoupon;
	UIButton* m_btnCouponOk;
	UIButton* m_btnCouponCancel;
	UIButton* m_btnHeadView;
	UILabel* m_labTitle;
	
	UIView* m_showView;
	
	NSString* m_couponTxt;
	
	id<CouponPopViewDelegate> __unsafe_unretained m_delegate;
	
	CGSize m_keyboardSize;
}

@property(nonatomic,strong)IBOutlet UITextField* m_txtCoupon;
@property(nonatomic,strong)IBOutlet UIButton* m_btnCouponOk;
@property(nonatomic,strong)IBOutlet UIButton* m_btnCouponCancel;
@property(nonatomic,strong)IBOutlet UIButton* m_btnHeadView;
@property(nonatomic,strong)IBOutlet UILabel* m_labTitle;
@property(nonatomic)UIView* m_showView;
@property(nonatomic,strong)NSString* m_couponTxt;
@property(nonatomic,assign)CGSize m_keyboardSize;
@property(nonatomic,unsafe_unretained)id<CouponPopViewDelegate> m_delegate;

-(id)initWithFrame:(CGRect)frame;
-(void)createShowView;
-(void)riseUpShowView;
@end



@interface SCNCashCenterCouponPopView : UIControl<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
	UITableView* m_tableCoupon;
	UILabel* m_labCoupon;
	UITextField* m_txtCoupon;
	UIButton* m_btnCouponOk;
	NSMutableDictionary* m_couponDic;
	
	UIView* m_showView;
	
	NSString* m_couponId;
	int	m_selIndex;
	
	id<CouponPopViewDelegate> __unsafe_unretained m_delegate;
	
	CGSize m_keyboardSize;
}

@property(nonatomic,strong)IBOutlet UITableView* m_tableCoupon;
@property(nonatomic,strong)IBOutlet UITextField* m_txtCoupon;
@property(nonatomic,strong)IBOutlet UIButton* m_btnCouponOk;
@property(nonatomic,strong)IBOutlet UILabel* m_labCoupon;
@property(nonatomic,strong)NSMutableDictionary* m_couponDic;
@property(nonatomic)UIView* m_showView;
@property(nonatomic,strong)NSString* m_couponId;
@property(nonatomic,assign)CGSize m_keyboardSize;
@property(nonatomic,unsafe_unretained)id<CouponPopViewDelegate> m_delegate;
@property(nonatomic,assign)int m_selIndex;

-(id)initWithFrame:(CGRect)frame withCouponDic:(NSMutableDictionary*)couponDic;
-(void)createShowView;
-(void)riseUpShowView;
@end

@interface SCNCashCenterMessagePopView : UIControl<UITextFieldDelegate,UITextViewDelegate>
{
	UITextField* m_txtMessage;
	
	UIView* m_showView;
	
	id<CouponPopMessageDelegate> __unsafe_unretained m_delegate;
	
	CGSize m_keyboardSize;
}

@property(nonatomic,strong)UITextField* m_txtMessage;
@property(nonatomic)UIView* m_showView;
@property(nonatomic,unsafe_unretained)id<CouponPopMessageDelegate> m_delegate;
@property(nonatomic,assign)CGSize m_keyboardSize;

-(id)initWithFrame:(CGRect)frame;
-(void)createShowView;
-(void)riseUpShowView;
@end

@interface SCNCashCenterInvoicePopView : UIControl<UITextFieldDelegate,SCNCommonPickerViewDelegate>
{
	UITextField* m_txtInvoice;
	
	UIView* m_showView;
	
	UILabel* m_labInvoiceTitle;
	UILabel* m_labInvoiceHead;
	UILabel* m_labInvoiceType;
	UIButton* m_btnInvoiceType;
	
	CGSize m_keyboardSize;
	
	id<CouponPopInvoiceDelegate> __unsafe_unretained m_delegate;
	
	NSDictionary* m_tmpDic;
}

@property(nonatomic,strong)UITextField* m_txtInvoice;
@property(nonatomic,strong)UILabel* m_labInvoiceTitle;
@property(nonatomic,strong)UILabel* m_labInvoiceHead;
@property(nonatomic,strong)UILabel* m_labInvoiceType;
@property(nonatomic,strong)UIButton* m_btnInvoiceType;
@property(nonatomic)UIView* m_showView;
@property(nonatomic,assign)CGSize m_keyboardSize;
@property(nonatomic,unsafe_unretained)id<CouponPopInvoiceDelegate> m_delegate;
@property(nonatomic,strong)NSDictionary* m_tmpDic;

-(id)initWithFrame:(CGRect)frame withInvoiceTypeDic:(NSDictionary*)_invoiceTypeDic;
-(void)createShowView;
-(void)riseUpShowView;
@end


