//
//  SCNCashCenterSuccessViewController.m
//  SCN
//
//  Created by huangwei on 11-10-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNCashCenterSuccessViewController.h"
#import "SCNCashCenterTableCell.h"
#import "Go2PageUtility.h"
#import "SCNViewController.h"

#define IMAGEVIEWTAG_PHONEIMG     411
#define BUTTONTAG_PHONEBUTTON     412

#pragma mark-
#pragma mark SCNCashCenterSuccessHeadView
@implementation SCNCashCenterSuccessHeadView
@synthesize m_labHeadTitle;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self){
		m_labHeadTitle = [[UILabel alloc] initWithFrame:CGRectMake(22, 110, 280, 13)];
		[m_labHeadTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
		[m_labHeadTitle setTextColor:[UIColor blackColor]];
		[self addSubview:m_labHeadTitle];
	}
	return self;
}

@end


#pragma mark-
#pragma mark SCNCashCenterSuccessBtnsView
@implementation SCNCashCenterSuccessBtnsView
@synthesize m_btnContinue;
@synthesize m_btnViewOrder;
@synthesize m_btnMobile;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		////////////////////////////////////////////继续购物按钮///////////////////////////////////////////////////////////////
		self.m_btnContinue = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.m_btnContinue setTitle:@"继续购物" forState:UIControlStateNormal];
		[self.m_btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self.m_btnContinue setFrame:CGRectMake(30, 60, 118, 35)];
		[self.m_btnContinue.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		
		UIImage* _btn_normal = [UIImage imageNamed:@"com_blackbtn.png"];
		[self.m_btnContinue setBackgroundImage:[_btn_normal stretchableImageWithLeftCapWidth:10 topCapHeight:0] forState:UIControlStateNormal];
		
		UIImage* _btn_select = [UIImage imageNamed:@"com_blackbtn_SEL.png"];
		[self.m_btnContinue setBackgroundImage:[_btn_select stretchableImageWithLeftCapWidth:10 topCapHeight:0]forState:UIControlStateHighlighted];
		
		[self addSubview:self.m_btnContinue];
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		////////////////////////////////////////////查看订单////////////////////////////////////////////////////////////////////
		self.m_btnViewOrder = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.m_btnViewOrder setTitle:@"查看订单" forState:UIControlStateNormal];
		[self.m_btnViewOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self.m_btnViewOrder setFrame:CGRectMake(172, 60, 118, 35)];
		[self.m_btnViewOrder.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		
		[self.m_btnViewOrder setBackgroundImage:[_btn_normal stretchableImageWithLeftCapWidth:8 topCapHeight:0] forState:UIControlStateNormal];
		
		[self.m_btnViewOrder setBackgroundImage:[_btn_select stretchableImageWithLeftCapWidth:8 topCapHeight:0]forState:UIControlStateHighlighted];
		
		[self addSubview:self.m_btnViewOrder];
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		////////////////////////////////////////////拨打电话////////////////////////////////////////////////////////////////////
		UIImageView* _imageview_phone = [[UIImageView alloc ] initWithFrame:CGRectMake(75, 120, 22, 21)];
		_imageview_phone.image = [UIImage imageNamed:@"com_phone.png"];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		
		[button setTitle:@"400-800-2222" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setFrame:CGRectMake(30, 115, 260, 35)];
		[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
		
		UIImage * _button_normal = [UIImage imageNamed:@"com_button_normal.png"];
		[button setBackgroundImage:[_button_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
		
		UIImage * _button_select = [UIImage imageNamed:@"com_button_select.png"] ;
		[button setBackgroundImage:[_button_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
		[button addTarget:self action:@selector(pressPhone:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:button];
		[self addSubview:_imageview_phone];
		
		///////
	}
	return self;
}

-(void)pressPhone:(id)sender{
	[SCNStatusUtility makeCall:YK_400PHONE_NUMBER];
}


@end

#pragma mark-
#pragma mark SCNCashCenterSuccessViewController
@implementation SCNCashCenterSuccessViewController
@synthesize m_tableView;
@synthesize m_footerView;
@synthesize m_headerView;
@synthesize m_orderId;
@synthesize m_payMoney;
@synthesize m_payType;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil withOrderId:(NSString*)_orderId withPayMoney:(NSString*)_payMoney withPayType:(NSString*)_payType bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_orderId = _orderId;
		self.m_payMoney = _payMoney;
		self.m_payType = _payType;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"订单提交成功";
	self.pathPath = @"/ordersuccess";
	self.navigationItem.leftBarButtonItem = nil;
	
	self.m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStylePlain];
    self.m_tableView.backgroundColor = [UIColor clearColor];
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.view addSubview:self.m_tableView];
	self.m_tableView.tableHeaderView = m_headerView;
	m_footerView = [[SCNCashCenterSuccessBtnsView alloc] initWithFrame:CGRectMake(0, 0, 320, 204)];
	self.m_tableView.tableFooterView = m_footerView;
	
	[ self.m_footerView.m_btnContinue addTarget:self action:@selector(continueBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
	[ self.m_footerView.m_btnViewOrder addTarget:self action:@selector(viewOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
//	[self.m_tableView setSeparatorColor:[UIColor clearColor]];
//	[self.m_tableView setBackgroundColor:[UIColor clearColor]];
//	[m_tableView reloadData];
	
}

-(void)viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	float height = 73;
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//int row = indexPath.row;
	
	UITableViewCell* cell = nil;
	NSString* orderIdentifier = @"CashCenterSuccessTableCellId";
	SCNCashCenterSuccessTableCell* orderCell = nil;
	
	orderCell = (SCNCashCenterSuccessTableCell*)[tableView dequeueReusableCellWithIdentifier:orderIdentifier];
	
	if (!orderCell) {
		NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
		
		for (NSObject *object in objects) {
			if ([object isKindOfClass:[SCNCashCenterSuccessTableCell class]]) {
				orderCell = (SCNCashCenterSuccessTableCell*)object;
				
				UIView *_view_bgcellview=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 73)];
				//设置View的背景颜色
				[_view_bgcellview setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
				//设置圆角半径
				[_view_bgcellview.layer setCornerRadius:5.0];

				//设置边框宽度
				[_view_bgcellview.layer setBorderWidth:1];
				//设置边框颜色
				[_view_bgcellview.layer setBorderColor:YK_CELLBORDER_COLOR.CGColor];
				[orderCell.contentView insertSubview:_view_bgcellview atIndex:0];
				break;
			}
		}
	}
	
	orderCell.m_labOrderId.text = self.m_orderId;
	orderCell.m_labOrderPrice.text = [SCNStatusUtility getPriceString:self.m_payMoney]; //[NSString stringWithFormat:@"¥%@",self.m_payMoney];//self.m_payMoney;
	orderCell.m_labPayMethod.text = self.m_payType;
	orderCell.m_labOrderId.textColor = [UIColor colorWithRed:(float)(73/255.0f) green:(float)(73/255.0f) blue:(float)(73/255.0f) alpha:1.0f];
	orderCell.m_labOrderPrice.textColor = [UIColor colorWithRed:(float)(73/255.0f) green:(float)(73/255.0f) blue:(float)(73/255.0f) alpha:1.0f];
	orderCell.m_labPayMethod.textColor = [UIColor colorWithRed:(float)(73/255.0f) green:(float)(73/255.0f) blue:(float)(73/255.0f) alpha:1.0f];

	//[orderCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
	
	cell = orderCell;
	
	return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//	float height = 60;
//	return height;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//	float height = 204;
//	return height;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//	return m_headerView;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//	return m_footerView;
//}

-(void)continueBuyBtn:(id)sender{
	[self.navigationController popToRootViewControllerAnimated:NO];
	[Go2PageUtility go2ViewControllerByIndex:0];
}

-(void)viewOrderBtn:(id)sender{
	[Go2PageUtility go2OrderDetailViewController:self orderId:self.m_orderId];
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}


@end
