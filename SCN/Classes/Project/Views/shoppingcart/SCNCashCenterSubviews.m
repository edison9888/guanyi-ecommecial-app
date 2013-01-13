//
//  SCNCashCenterSubviews.m
//  SCN
//
//  Created by huangwei on 11-10-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCashCenterSubviews.h"
#import "SCNCashCenterTableCell.h"
#import "SCNCashCenterViewController.h"
#import "SCNStatusUtility.h"

@implementation SCNCashCenterCouponInputView
@synthesize m_txtCoupon;
@synthesize m_btnCouponOk;
@synthesize m_btnCouponCancel;
@synthesize m_btnHeadView;
@synthesize m_labTitle;
@synthesize m_showView;
@synthesize m_couponTxt;
@synthesize m_keyboardSize;
@synthesize m_delegate;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
		m_showView = [[UIView alloc] initWithFrame:frame];
		m_showView.backgroundColor = [UIColor lightGrayColor];
		
		[self addTarget:self action:@selector(clickfreeSpace:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_showView];
		[self createShowView];
    }
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
    return self;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif{
    NSDictionary *info = [notif userInfo];
    
	NSValue *keyboardBoundsValue = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    self.m_keyboardSize = [keyboardBoundsValue CGRectValue].size;
	
	[self riseUpShowView];
}

- (void)riseUpShowView
{
	CGRect rect = m_showView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(AnimateDidRiseUp)];
	NSLog(@"%@",[NSString stringWithFormat:@"%f",m_showView.frame.origin.y]);
	CGFloat ry = [[UIScreen mainScreen] applicationFrame].size.height - [SCNStatusUtility getNavigationBarHeight] - self.m_keyboardSize.height;
	rect.origin.y = ry - rect.size.height;
	m_showView.frame = rect;
	[UIView commitAnimations];
}

-(void)AnimateDidRiseUp{
	
}

- (void)clickfreeSpace:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[self removeFromSuperview];
	[UIView commitAnimations];
}

-(void)createShowView{
	[m_showView setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
	m_showView.layer.cornerRadius=6;
	m_showView.layer.masksToBounds=YES;
	
	self.m_btnHeadView = [YKButtonUtility initSimpleButtonWithCapWidth:CGRectMake(0, 0, 235, 35)
														 title:@"使用优惠券"
												   normalImage:@"shoppingcart_orderAlertWindowBg.png"
														   highlighted:@"shoppingcart_orderAlertWindowBg.png" 
															  capWidth:3];
	m_btnHeadView.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	[m_showView addSubview:m_btnHeadView];
	
	m_txtCoupon = [[UITextField alloc]initWithFrame:CGRectMake(10, 47, 217, 30)];
	m_txtCoupon.placeholder	= @"请输入您的优惠券号码";
	m_txtCoupon.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	m_txtCoupon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[m_txtCoupon setTextColor:[UIColor colorWithRed:0.518 green:0.067 blue:0.067 alpha:1]];
	[m_txtCoupon setBackgroundColor:[UIColor whiteColor]];
	m_txtCoupon.textAlignment = UITextAlignmentLeft;
	[m_txtCoupon setFont:[UIFont systemFontOfSize:14.0f]];
	m_txtCoupon.delegate = self;
	[m_txtCoupon setBorderStyle:UITextBorderStyleRoundedRect];
	m_txtCoupon.backgroundColor = [UIColor clearColor];
	[m_showView addSubview:m_txtCoupon];
	
	self.m_btnCouponCancel = [YKButtonUtility initSimpleButton:CGRectMake(10, 127, 75, 30)
											   title:@"取消"
										 normalImage:@"com_button_normal.png"
										 highlighted:@"com_button_select.png"];
	m_btnCouponCancel.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	[m_btnCouponCancel addTarget:self action:@selector(clickCouponCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
	[m_showView addSubview:m_btnCouponCancel];
	
	self.m_btnCouponOk = [YKButtonUtility initSimpleButton:CGRectMake(152, 127, 75, 30)
													title:@"确定"
											  normalImage:@"com_button_normal.png"
											  highlighted:@"com_button_select.png"];
	m_btnCouponOk.titleLabel.font = [UIFont boldSystemFontOfSize:16];
	[m_btnCouponOk addTarget:self action:@selector(clickCouponOkBtn:) forControlEvents:UIControlEventTouchUpInside];
	[m_showView addSubview:m_btnCouponOk];
}

-(void)clickCouponCancelBtn:(id)sender{
	
	[self removeFromSuperview];
}

-(void)clickCouponOkBtn:(id)sender{
	[self removeFromSuperview];
	if (m_delegate) {
		if (m_txtCoupon.text && [m_txtCoupon.text length]>0) {
			self.m_couponTxt = m_txtCoupon.text;
			[m_delegate couponPopViewDelegate:self.m_couponTxt];
		}else {
			[self removeFromSuperview];
		}
	}
}

@end


#pragma mark-
#pragma mark SCNCashCenterCouponPopView
@implementation SCNCashCenterCouponPopView
@synthesize m_tableCoupon;
@synthesize m_labCoupon;
@synthesize m_txtCoupon;
@synthesize m_btnCouponOk;
@synthesize m_couponDic;
@synthesize m_showView;
@synthesize m_couponId;
@synthesize m_keyboardSize;
@synthesize m_delegate;
@synthesize m_selIndex;

- (id)initWithFrame:(CGRect)frame withCouponDic:(NSMutableDictionary*)couponDic{
    
	self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
		self.m_couponDic = couponDic;
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		m_showView = [[UIView alloc] initWithFrame:frame];
		m_showView.backgroundColor = [UIColor lightGrayColor];

		[self addTarget:self action:@selector(clickfreeSpace:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_showView];
		[self createShowView];
    }
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return self;
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif{
    NSDictionary *info = [notif userInfo];
    
	NSValue *keyboardBoundsValue = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    self.m_keyboardSize = [keyboardBoundsValue CGRectValue].size;
	
	[self riseUpShowView];
}

- (void)riseUpShowView
{
	CGRect rect = m_showView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(AnimateDidRiseUp)];
	rect.origin.y = m_showView.frame.origin.y - self.m_keyboardSize.height + [SCNStatusUtility getTabBarHeight];
	m_showView.frame = rect;
	[UIView commitAnimations];
}

-(void)AnimateDidRiseUp{
	
}

- (void)clickfreeSpace:(id)sender
{
	[self removeFromSuperview];
}

-(void)createShowView{
	m_tableCoupon = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 110) style:UITableViewStyleGrouped];
	m_tableCoupon.backgroundColor = [UIColor clearColor];
	[m_showView addSubview:m_tableCoupon];
	m_tableCoupon.delegate = self;
	m_tableCoupon.dataSource = self;
	
	m_labCoupon = [[UILabel alloc]initWithFrame:CGRectMake(15, 105, 320, 30)];
	m_labCoupon.text = @"或者请直接输入优惠券激活码";
	m_labCoupon.font = [UIFont systemFontOfSize:15.0f];
	m_labCoupon.backgroundColor = [UIColor clearColor];
	[m_showView addSubview:m_labCoupon];
	
	m_txtCoupon = [[UITextField alloc]initWithFrame:CGRectMake(15, 140, 280, 35)];
	m_txtCoupon.placeholder	= @"输入优惠券号码";
	[m_txtCoupon setTextColor:[UIColor colorWithRed:0.518 green:0.067 blue:0.067 alpha:1]];
	[m_txtCoupon setBackgroundColor:[UIColor whiteColor]];
	m_txtCoupon.textAlignment = UITextAlignmentLeft;
	[m_txtCoupon setFont:[UIFont systemFontOfSize:15.0f]];
	m_txtCoupon.delegate = self;
	[m_showView addSubview:m_txtCoupon];
	
	self.m_btnCouponOk = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[m_btnCouponOk setTitle:@"确定" forState:UIControlStateNormal];
	[m_btnCouponOk setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[m_btnCouponOk setFrame:CGRectMake(120, 185, 80, 30)];
	[m_btnCouponOk addTarget:self action:@selector(clickCouponOkBtn:) forControlEvents:UIControlEventTouchUpInside];
	[m_showView addSubview:m_btnCouponOk];
}

#pragma mark-
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark-
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [[m_couponDic allKeys]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell* tableCell = nil;
	NSString* cellIndentifier = @"CouponPopTableCellId";
	int row = indexPath.row;
	
	SCNCashCenterCouponPopTableCell* couponCell = nil;
	couponCell = (SCNCashCenterCouponPopTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
	
	if (!couponCell) {
		NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
		
		for (NSObject *object in objects) {
			if ([object isKindOfClass:[SCNCashCenterCouponPopTableCell class]]) {
				couponCell = (SCNCashCenterCouponPopTableCell*)object;
				break;
			}
		} 
		couponCell.m_labCoupon.text = [NSString stringWithString:[[self.m_couponDic allValues] objectAtIndex:row]];
		couponCell.m_btnCouponSelect.tag = indexPath.row;
		[ couponCell.m_btnCouponSelect addTarget:self action:@selector(selectCouponBtn:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	tableCell = couponCell;
	
	return tableCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(void)clickCouponOkBtn:(id)sender{
	[self removeFromSuperview];
	if (m_delegate) {
		self.m_couponId = [[m_couponDic allKeys] objectAtIndex:m_selIndex];
		[m_delegate couponPopViewDelegate:self.m_couponId];
	}
}

-(void)selectCouponBtn:(id)sender
{
	UIButton* btn = (UIButton*)sender;
	m_selIndex = btn.tag;
}
// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField{
	self.m_couponId = textField.text;
}

@end


#pragma mark-
#pragma mark SCNCashCenterMessagePopView
@implementation SCNCashCenterMessagePopView
@synthesize m_showView;
@synthesize m_txtMessage;
@synthesize m_delegate;
@synthesize m_keyboardSize;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		m_showView = [[UIView alloc] initWithFrame:frame];
		m_showView.backgroundColor = [UIColor lightGrayColor];
		
		[self addTarget:self action:@selector(clickfreeSpace:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_showView];
		[self createShowView];
    }
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notif{
    NSDictionary *info = [notif userInfo];
    

	NSValue *keyboardBoundsValue = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    self.m_keyboardSize = [keyboardBoundsValue CGRectValue].size;
	
	[self riseUpShowView];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)createShowView{
	m_txtMessage = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
	m_txtMessage.placeholder	= @"请填写留言";
	[m_txtMessage setTextColor:[UIColor colorWithRed:0.518 green:0.067 blue:0.067 alpha:1]];
	[m_txtMessage setBackgroundColor:[UIColor whiteColor]];
	m_txtMessage.textAlignment = UITextAlignmentLeft;
	[m_txtMessage setFont:[UIFont systemFontOfSize:15.0f]];
	m_txtMessage.delegate = self;
	[m_showView addSubview:m_txtMessage];
}

- (void)clickfreeSpace:(id)sender
{
	[self removeFromSuperview];
}

- (void)riseUpShowView
{
	CGRect rect = m_showView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDidStopSelector:@selector(AnimateDidRiseUp)];
	rect.origin.y = m_showView.frame.origin.y - self.m_keyboardSize.height + [SCNStatusUtility getTabBarHeight];
	m_showView.frame = rect;
	[UIView commitAnimations];
}

-(void)AnimateDidRiseUp{
	
}

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField{
	[m_delegate couponPopMessageDelegate:m_txtMessage.text];
}

@end

#pragma mark-
#pragma mark SCNCashCenterInvoicePopView
@implementation SCNCashCenterInvoicePopView

@synthesize m_txtInvoice;
@synthesize m_showView;
@synthesize m_labInvoiceHead;
@synthesize m_labInvoiceType;
@synthesize m_btnInvoiceType;
@synthesize m_labInvoiceTitle;
@synthesize m_keyboardSize;
@synthesize m_delegate;
@synthesize m_tmpDic;

-(id)initWithFrame:(CGRect)frame withInvoiceTypeDic:(NSDictionary*)_invoiceTypeDic{
	self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
		self.m_tmpDic = _invoiceTypeDic;
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		m_showView = [[UIView alloc] initWithFrame:frame];
		m_showView.backgroundColor = [UIColor lightGrayColor];
		
		[self addTarget:self action:@selector(clickfreeSpace:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:m_showView];
		[self createShowView];
    }
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notif{
    NSDictionary *info = [notif userInfo];
    

	NSValue *keyboardBoundsValue = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    self.m_keyboardSize = [keyboardBoundsValue CGRectValue].size;
	
	[self riseUpShowView];
}

- (void)riseUpShowView
{
	CGRect rect = m_showView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDidStopSelector:@selector(AnimateDidRiseUp)];
	rect.origin.y = m_showView.frame.origin.y - self.m_keyboardSize.height + [SCNStatusUtility getTabBarHeight];
	m_showView.frame = rect;
	[UIView commitAnimations];
}

-(void)AnimateDidRiseUp{
	
}


-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

-(void)createShowView{
	m_labInvoiceTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 320, 30)];
	m_labInvoiceTitle.text = @"填写发票内容";
	m_labInvoiceTitle.font = [UIFont systemFontOfSize:15.0f];
	m_labInvoiceTitle.backgroundColor = [UIColor clearColor];
	[m_showView addSubview:m_labInvoiceTitle];
	
	m_labInvoiceHead = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 320, 30)];
	m_labInvoiceHead.text = @"发票抬头";
	m_labInvoiceHead.font = [UIFont systemFontOfSize:15.0f];
	m_labInvoiceHead.backgroundColor = [UIColor clearColor];
	[m_showView addSubview:m_labInvoiceHead];
	
	m_txtInvoice = [[UITextField alloc]initWithFrame:CGRectMake(15, 75, 280, 35)];
	m_txtInvoice.placeholder	= @"请输入发票抬头...";
	[m_txtInvoice setTextColor:[UIColor colorWithRed:0.518 green:0.067 blue:0.067 alpha:1]];
	[m_txtInvoice setBackgroundColor:[UIColor whiteColor]];
	m_txtInvoice.textAlignment = UITextAlignmentLeft;
	[m_txtInvoice setFont:[UIFont systemFontOfSize:15.0f]];
	m_txtInvoice.delegate = self;
	[m_showView addSubview:m_txtInvoice];
	
	m_labInvoiceType = [[UILabel alloc]initWithFrame:CGRectMake(15, 115, 320, 30)];
	m_labInvoiceType.text = @"发票类型";
	m_labInvoiceType.font = [UIFont systemFontOfSize:15.0f];
	m_labInvoiceType.backgroundColor = [UIColor clearColor];
	[m_showView addSubview:m_labInvoiceType];
	
	self.m_btnInvoiceType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[m_btnInvoiceType setTitle:@"" forState:UIControlStateNormal];
	[m_btnInvoiceType setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[m_btnInvoiceType setFrame:CGRectMake(15, 150, 280, 35)];
	[m_btnInvoiceType addTarget:self action:@selector(clickInvoicePopBtn:) forControlEvents:UIControlEventTouchUpInside];
	[m_showView addSubview:m_btnInvoiceType];
}

-(void)clickInvoicePopBtn:(id)sender{
	SCNCommonPickerView* _pickerView = [[SCNCommonPickerView alloc]initWithFrame:CGRectMake(0, 150, 320, 270)];
	[self addSubview:_pickerView];
	_pickerView.m_delegate = self;
	
}

- (void)clickfreeSpace:(id)sender
{
	[self removeFromSuperview];
}

#pragma mark-
#pragma mark SCNCommonPickerViewDelegate
-(NSInteger)numberOfCellsForPickerView:(SCNCommonPickerView*)aPickerView{
	return 6;
}

-(NSArray*)titleForPickerView:(SCNCommonPickerView*)aPickerView{
	//m_tmpArr = [NSArray arrayWithObjects:@"10元优惠券",@"20元优惠券",@"30元优惠券",@"40元优惠券",@"50元优惠券",@"60元优惠券",nil];//test data
//	return m_tmpArr;
	
	NSArray* _allValue = [m_tmpDic allValues];
	return _allValue;
}

-(void)scnCommonPickerView:(SCNCommonPickerView*)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	NSArray* _allValue = [m_tmpDic allValues];
	NSArray* _allKey = [m_tmpDic allKeys];
	NSString* _curValue = [_allValue objectAtIndex:row];
	NSString* _curKey = [_allKey objectAtIndex:row];
	if (m_delegate) {
		[m_delegate couponPopInvoiceDelegate:_curValue invoiceType:_curKey];
	}
}

@end


