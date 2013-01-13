//
//  SCNShoppingcartViewController.m
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNShoppingcartViewController.h"
#import "SCNCashCenterViewController.h"
#import "SCNShoppingcartTableCell.h"
#import "SCNCashCenterTableCell.h"
#import "Go2PageUtility.h"
#import "ShoppingCartData.h"
#import "OffShoppingCartData.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "YKButtonUtility.h"
#import "SCNProductTagLabel.h"
#import "YKStatBehaviorInterface.h"

@implementation SCNShoppingcartHeadView
@synthesize m_backImage;
@synthesize m_originalPrice;
@synthesize m_preferentailPrice;
@synthesize m_totalPrice;
@synthesize m_productNumber;
@synthesize m_btnAccount;
@synthesize m_labTitle;

@end


@implementation SCNShoppingcartAccountBtnView
@synthesize m_btnAccount;
@synthesize m_labAccount;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.m_btnAccount = [YKButtonUtility initSimpleButton:CGRectMake(30, 13, 258, 35)
												   title:@"结    算"
											 normalImage:@"com_button_normal.png"
											 highlighted:@"com_button_select.png"];
		m_btnAccount.titleLabel.font = [UIFont boldSystemFontOfSize:16];
		[self addSubview:m_btnAccount];
	}
	return self;
}

-(void)dealloc{
	m_btnAccount = nil;
	m_labAccount = nil;
}

@end

@implementation SCNShoppingcartListHeadView
@synthesize m_labTitle;


@end



@implementation SCNShoppingcartViewController
@synthesize m_tableView;
@synthesize m_footerView;
@synthesize m_headView;
//@synthesize m_operateDic;
@synthesize m_shoppingcartData;
@synthesize isEdit;
@synthesize isDeledate;
@synthesize m_shoppingcartHeadView;
@synthesize controlArea;
@synthesize m_curTxt;
@synthesize noProductView;
@synthesize isDeleting;
@synthesize m_skuRootString;
@synthesize m_willDeleteItem;
@synthesize isTxtFieldEmpty;
@synthesize isNumberExceed;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.navigationItem.title = @"购物车";
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.pathPath = @"/shoppingcart";
	[self setNormalNavigationItem];
	
	m_footerView = [[SCNShoppingcartAccountBtnView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
	[m_footerView.m_btnAccount addTarget:self action:@selector(go2PayPriceCenterView) forControlEvents:UIControlEventTouchUpInside];
	
	//self.m_operateDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//						 @"修改购买数量",YK_KEY_NUMBER_MODIFY,
//						 @"修改尺寸",YK_KEY_SIZE_MODIFY,
//						 @"移入收藏夹",YK_KEY_MOVETO_FAVORITE,
//						 @"删除",YK_KEY_PRODUCT_DELETE,
//					nil];
}

#pragma mark update headdata
-(void)refreshHeadViewData{
	m_shoppingcartHeadView.m_originalPrice.text = [NSString stringWithFormat:@"￥%@", m_shoppingcartData.mpriceInfoData.moriTotalPrice];
	m_shoppingcartHeadView.m_preferentailPrice.text = [NSString stringWithFormat:@"￥%@", m_shoppingcartData.mpriceInfoData.msavePrice];
	m_shoppingcartHeadView.m_totalPrice.text = [NSString stringWithFormat:@"￥%@", m_shoppingcartData.mpriceInfoData.msellPrice];
	m_shoppingcartHeadView.m_productNumber.text = [NSString stringWithFormat:@"%@件", m_shoppingcartData.mpriceInfoData.mnumber];
}

#pragma mark -
#pragma mark 导航栏

-(void)setNormalNavigationItem
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 0,52,32)];
	[button setTitle:@"编辑" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
	
	[button setBackgroundImage:[[UIImage imageNamed:@"com_btn.png"] 
								stretchableImageWithLeftCapWidth:20 
								topCapHeight:20] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"com_btn_SEL.png"] 
								stretchableImageWithLeftCapWidth:20 
								topCapHeight:20] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(startEditOrFinishEdit:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = 20;
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:button.frame];
	[ricusview addSubview:button];
	
	UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:ricusview];
	[self.navigationItem  setRightBarButtonItem:item];
	
	//self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFielChange:) name:UITextFieldTextDidChangeNotification object:nil];

	// 若是登陆页跳转回，则直接进入结算中心
    if ([YKUserInfoUtility isUserLogin] && isLoginBack) 
	{
        [self performSelector:@selector(go2PayPriceCenterView) withObject:self afterDelay:0.8];
    }else
	{
		NSString* _data = [SCNStatusUtility getShoppingcartDataAndOffShoppingcartData];
		//NSString* _data = @"512-12416-1|512-12417-1|13414-68279-2|9023-59586-4";
		if ([_data length]>0) {
			[self requestGetCartXmlData:_data];
		}
        else {
			self.noProductView.hidden=NO;
		}
    }
    self.m_shoppingcartData = nil;
	//[self parseShoppingcartXmlDataResponse:nil];
	[self.m_tableView setSeparatorColor:YK_CELLBORDER_COLOR];

	[self.m_tableView reloadData];
	isTxtFieldEmpty = NO;
	isNumberExceed = NO;
    isLoginBack = NO;
	
}



-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark getShoppingData
-(void)getShoppingCartData{
	NSLog(@"%@",[SCNStatusUtility getShoppingcartData]);
}

#pragma mark getShoppingType
-(NSString*)getShoppingType{
//	int nTag = 0;
//	
//	NSMutableString* skuRootString = [[NSMutableString alloc] init];
//	for (shoppingcartProductData* _data in m_shoppingcartData.sellingproducts) {
//		NSString* skuString;
//		
//		if (nTag == 0) {
//			skuString	=	[NSString stringWithFormat:@"%@", _data.mpstatus];
//		}else {
//			skuString	=	[NSString stringWithFormat:@"|%@", _data.mpstatus];
//		}
//		
//		nTag = 1;
//		
//		[skuRootString appendString:skuString];
//	}
//	return [skuRootString autorelease];
	return @"0";
}

-(void)go2PayPriceCenterView{
//    NSString* _shoppingType = [self getShoppingType];
//	NSLog(@"%@",_shoppingType);
	
	NSString* _productData = [SCNStatusUtility getShoppingcartData];
	
	SCNCashCenterViewController* cashCenter = [[SCNCashCenterViewController alloc] initWithNibName:@"SCNCashCenterViewController" bundle:nil];
	//[Go2PageUtility go2CashCenterViewController:self cashCenterViewCtrl:cashCenter withProducts:m_shoppingcartData.sellingproducts shoppingType:_shoppingType];
	[Go2PageUtility go2CashCenterByShoppingType:self cashCenterViewCtrl:cashCenter withProductData:_productData withCashType:ECashTypeCommon];
}

#pragma mark data request&response
-(void)requestGetCartXmlData:(NSString*)_data{
	self.noProductView.hidden=YES;
	[self startLoading];
	
	NSDictionary* extraParam = @{@"act": YK_METHOD_GET_SHOPPINGCART,
								@"data": _data};
    
	[YKHttpAPIHelper startLoad:SCN_URL 
				   extraParams:extraParam
						object:self 
					  onAction:@selector(onRequestGetCartXmlData:)];
}

-(void)onRequestGetCartXmlData:(GDataXMLDocument*)xmlDoc{
	[self stopLoading];
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		[self parseShoppingcartXmlDataResponse:xmlDoc];
		if (isDeleting) {
			[self confirmDeleteItem];
		}else {
			[self reloadSaveProductList:m_shoppingcartData.sellingproducts];
			[self reloadSaveOffProductList:m_shoppingcartData.offsellingproducts];
		}
	}else {
		self.noProductView.hidden=NO;
	}

	if ([m_shoppingcartData.m_prompt length]>0) {
		//提示
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
														  message:m_shoppingcartData.m_prompt 
														 delegate:nil 
												cancelButtonTitle:@"确定" 
												otherButtonTitles:nil];
		[alertView show];
	}
	[m_tableView reloadData];
	
	NSLog(@"%@",xmlDoc);
	
}

-(void)parseShoppingcartXmlDataResponse:(GDataXMLDocument*)xmlDoc{
	m_shoppingcartData = [[SCNShoppingcartData alloc]init];
	
//	NSString *path = [[NSBundle mainBundle]pathForResource:@"shoppingcart" ofType:@"xml"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"------%@",aStr);
//    xmlDoc =[[GDataXMLDocument alloc] initWithXMLString:aStr options:0 error:nil];
//    [aStr release];
	
	GDataXMLElement* datainfoNode = [SCNStatusUtility paserDataInfoNode:xmlDoc];
	
	NSString* promptPath = [NSString stringWithFormat:@"prompt"];
	GDataXMLNode* promptNode = [datainfoNode oneNodeForXPath:promptPath error:nil];
	m_shoppingcartData.m_prompt = [promptNode stringValue];
	
	NSString* priceInfoPath = [NSString stringWithFormat:@"priceInfo"];
	GDataXMLNode* priceInfoNode = [datainfoNode oneNodeForXPath:priceInfoPath error:nil];
	
	shoppingcartPriceInfoData* _priceInfo = [[shoppingcartPriceInfoData alloc]init];
	
	NSString* pricePath = [NSString stringWithFormat:@"oriTotalPrice"];
	NSString* savePricePath = [NSString stringWithFormat:@"savePrice"];
	NSString* sellPricePath = [NSString stringWithFormat:@"sellPrice"];
	NSString* numberPath = [NSString stringWithFormat:@"number"];
	
	GDataXMLNode* priceItem = [priceInfoNode oneNodeForXPath:pricePath error:nil];
	NSString* strPrice = [priceItem stringValue];
	_priceInfo.moriTotalPrice = strPrice;
	
	GDataXMLNode* savePriceItem = [priceInfoNode oneNodeForXPath:savePricePath error:nil];
	NSString* strSavePrice = [savePriceItem stringValue];
	_priceInfo.msavePrice = strSavePrice;
	
	GDataXMLNode* sellPriceItem = [priceInfoNode oneNodeForXPath:sellPricePath error:nil];
	NSString* strSellPrice = [sellPriceItem stringValue];
	_priceInfo.msellPrice = strSellPrice;
	
	GDataXMLNode* numberItem = [priceInfoNode oneNodeForXPath:numberPath error:nil];
	NSString* strNumber = [numberItem stringValue];
	_priceInfo.mnumber = strNumber;
	
	m_shoppingcartData.mpriceInfoData = _priceInfo;
	
	NSMutableArray* _productArr = [[NSMutableArray alloc]initWithCapacity:10];
	NSMutableArray* _offsellArr = [[NSMutableArray alloc]initWithCapacity:10];
	
	NSString* productListPath = [NSString stringWithFormat:@"productList"];
	GDataXMLNode* productListNode = [datainfoNode oneNodeForXPath:productListPath error:nil];
	
	NSString* itemPath = [NSString stringWithFormat:@"item"];
	NSArray* productNodeArr = [productListNode nodesForXPath:itemPath error:nil];
	
	if ([productNodeArr count]>0) {
		for (GDataXMLElement* item in productNodeArr) {
			shoppingcartProductData* cartProductData = [[shoppingcartProductData alloc]init];
			[cartProductData parseFromGDataXMLElement:item];
			NSString* mpstatus = cartProductData.mpstatus;
			NSLog(@"---mpstatus---=%@",mpstatus);
			if (![mpstatus isEqualToString:PRODUCT_NORMAL_VALUE] ) 
            {
				[_offsellArr addObject:cartProductData];
			}
            else
            {
				[_productArr addObject:cartProductData];
			}
			
		}
	}
	
	m_shoppingcartData.sellingproducts = _productArr;
	m_shoppingcartData.offsellingproducts = _offsellArr;
	
	//reload to shoppingcart database
	[self reloadSaveProductList:m_shoppingcartData.sellingproducts];
	[self reloadSaveOffProductList:m_shoppingcartData.offsellingproducts];
	//NSLog(@"%@",[SCNStatusUtility getShoppingcartDataAndOffShoppingcartData]);
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //self.m_operateDic = nil;
}



#pragma mark-
#pragma mark UITableViewDelegates Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	float height = 0;
	int row = indexPath.row;
	
	if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count]>0) {
		height = 32;
	}else if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count] == 0 && [m_shoppingcartData.offsellingproducts count] > 0) {
		shoppingcartProductData* _productData = [m_shoppingcartData.offsellingproducts objectAtIndex:row];
		if (_productData && [_productData.msavePrice floatValue] > 0.0){
			height = 83;
		}else {
			height = 63;
		}
	}else if (indexPath.section == 1) {
		//可售商品
		if ([m_shoppingcartData.sellingproducts count] > 0) {
			shoppingcartProductData* _productData = [m_shoppingcartData.sellingproducts objectAtIndex:row];
			if (_productData && [_productData.msavePrice floatValue] > 0.0){
				height = 83;
			}else {
				height = 63;
			}
		}
	}else if (indexPath.section == 2) {
		//不可售商品
		if ([m_shoppingcartData.offsellingproducts count] > 0) {
			shoppingcartProductData* _productData = [m_shoppingcartData.offsellingproducts objectAtIndex:row];
			if (_productData && [_productData.msavePrice floatValue] > 0.0){
				height = 83;
			}else {
				height = 63;
			}
		}
	}
	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	float height = 0;
	if (section == 0 && [m_shoppingcartData.sellingproducts count] == 0 && [m_shoppingcartData.offsellingproducts count]>0) {
		height = 40;
	}else if (section == 1 ) {
		if ([m_shoppingcartData.sellingproducts count] > 0) {
			height = 40;
		}
	}else if (section == 2) {
		if ([m_shoppingcartData.offsellingproducts count] > 0) {
			height = 40;
		}
	}

	return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	float height = 0;
	
	if (section == 0) {
		if ([m_shoppingcartData.sellingproducts count]>0) {
			height = 60;
		}
	}

	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	UIView *_v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	_v.backgroundColor = [UIColor clearColor];
	
	
	UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	[backImageView setBackgroundColor:[UIColor colorWithRed:(float)(68/255.0f) green:(float)(68/255.0f) blue:(float)(68/255.0f) alpha:1.0f]];
	[_v addSubview:backImageView];
	
	if (section == 0 && [m_shoppingcartData.sellingproducts count]==0 && [m_shoppingcartData.offsellingproducts count]>0) {
		UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
		labTitle.text = [NSString stringWithFormat:@"%@",@"无法成功购买的商品"];
		labTitle.backgroundColor = [UIColor clearColor];
		labTitle.textColor = [UIColor whiteColor];
		labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		[_v addSubview:labTitle];
		
		return _v;
	}else if (section == 1 && [m_shoppingcartData.sellingproducts count]>0) {
		
		UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
		labTitle.text = [NSString stringWithFormat:@"%@",@"商品明细"];
		labTitle.backgroundColor = [UIColor clearColor];
		labTitle.textColor = [UIColor whiteColor];
		labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		[_v addSubview:labTitle];
	
		return _v;
	}else if (section == 2 && [m_shoppingcartData.offsellingproducts count]>0) {
		UILabel* labTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 200, 23)];
		labTitle.text = [NSString stringWithFormat:@"%@",@"无法成功购买的商品"];
		labTitle.backgroundColor = [UIColor clearColor];
		labTitle.textColor = [UIColor whiteColor];
		labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
		[_v addSubview:labTitle];
		
		return _v;
	}
	return nil;
	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView* nView = nil;
	if (section == 0 && [m_shoppingcartData.sellingproducts count]>0) {
		nView = m_footerView;
	}
	return nView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int nSection = indexPath.section;
	if (nSection == 0 && m_shoppingcartData.offsellingproducts && [m_shoppingcartData.offsellingproducts count]==0) {
		return;
	}
	
	shoppingcartProductData* shoppingcartProduct = nil;
	if (nSection == 0 && m_shoppingcartData.offsellingproducts && [m_shoppingcartData.offsellingproducts count]>0) {
		shoppingcartProduct = [self.m_shoppingcartData.offsellingproducts objectAtIndex:indexPath.row];
	}else if( nSection == 2 && m_shoppingcartData.sellingproducts && [m_shoppingcartData.offsellingproducts count]>0){
		shoppingcartProduct = [self.m_shoppingcartData.offsellingproducts objectAtIndex:indexPath.row];
	}else if (nSection == 1 && [self.m_shoppingcartData.sellingproducts count]>0) {
        shoppingcartProduct = [self.m_shoppingcartData.sellingproducts objectAtIndex:indexPath.row];
    }
	NSLog(@"商品名%@",shoppingcartProduct.mname);
	[Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:shoppingcartProduct.mproductCode withPstatus:shoppingcartProduct.mpstatus withImage:nil];
}

-(void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{	
	isDeledate=NO;
	UIButton *bt=(UIButton*)([self.navigationItem.rightBarButtonItem.customView viewWithTag:20]);
	[bt setTitle:@"完成" forState:UIControlStateNormal];
	isEdit=YES;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	//if (isDeledate) {
	//		NSString *data=[SCNStatusUtility getShoppingcartDataAndOffShoppingcartData];
	//		
	//		[self requestGetCartXmlData:data];
	//	}
	
	UIButton *bt=(UIButton*)([self.navigationItem.rightBarButtonItem.customView viewWithTag:20]);
	[bt setTitle:@"编辑" forState:UIControlStateNormal];
	isEdit=NO;
}

#pragma mark-
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{	
	int nCount = 0;
	if (!m_shoppingcartData) {
		return 0;
	}
	else if(section == 0 && [m_shoppingcartData.sellingproducts count]>0){
		if ([m_shoppingcartData.mpriceInfoData.msavePrice isEqualToString:@"0"]) {
			nCount = 2;
		}else {
			nCount = 4;
		}
	}else if (section == 0 && [m_shoppingcartData.sellingproducts count]==0 && [m_shoppingcartData.offsellingproducts count]>0) {
		nCount = [m_shoppingcartData.offsellingproducts count];
	}else if (section == 1 && [m_shoppingcartData.sellingproducts count]>0) {
		nCount = [m_shoppingcartData.sellingproducts count];
	}else if (section == 2 && [m_shoppingcartData.offsellingproducts count]>0) {
		nCount = [m_shoppingcartData.offsellingproducts count];
	}
	return nCount;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	int nRow = 0;
	if (!m_shoppingcartData) {
		m_tableView.hidden=YES;
        //noProductView.hidden=NO;
        self.navigationItem.rightBarButtonItem.customView.hidden=YES;
		m_headView.hidden=YES;
		m_footerView.hidden=YES;
		return nRow;
	}else {
		if ([m_shoppingcartData.sellingproducts count] > 0 && [m_shoppingcartData.offsellingproducts count] > 0	) {
			m_tableView.hidden = NO;
			noProductView.hidden = YES;
			self.navigationItem.rightBarButtonItem.customView.hidden = NO;
			m_footerView.hidden = NO;
			m_headView.hidden = NO;
			nRow = 3;
		}else if ([m_shoppingcartData.sellingproducts count] == 0 && [m_shoppingcartData.offsellingproducts count] == 0	) {
			m_tableView.hidden = YES;
			noProductView.hidden = NO;
			self.navigationItem.rightBarButtonItem.customView.hidden = YES;
			m_footerView.hidden = YES;
			m_headView.hidden = YES;
			nRow = 0;
		}else if ([m_shoppingcartData.sellingproducts count] > 0) {
			m_tableView.hidden = NO;
			noProductView.hidden = YES;
			self.navigationItem.rightBarButtonItem.customView.hidden = NO;
			m_footerView.hidden = NO;
			m_headView.hidden = NO;
			nRow = 2;
		}else if ([m_shoppingcartData.offsellingproducts count] > 0) {
			m_tableView.hidden = NO;
			noProductView.hidden = YES;
			self.navigationItem.rightBarButtonItem.customView.hidden = NO;
			m_footerView.hidden = YES;
			m_headView.hidden = NO;
			nRow = 1;
		}
	}
	return nRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	int row = indexPath.row;
	
	UITableViewCell* tableCell = nil;
	
	NSString* cellIndentifier;
	
	if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count] >0) {
		SCNShoppingcartNameValueTableCell* nameValueCell = nil;
		cellIndentifier = @"SCNShoppingcartNameValueTableCellId";
		
		nameValueCell = (SCNShoppingcartNameValueTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
		
		if (!nameValueCell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNShoppingcartTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNShoppingcartNameValueTableCell class]]) {
					nameValueCell = (SCNShoppingcartNameValueTableCell*)object;
					
					break;
				}
			}
		}
		if (![m_shoppingcartData.mpriceInfoData.msavePrice isEqualToString:@"0"]) {
			if (indexPath.row == 0) {
				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"原始总价:"];
                
                nameValueCell.m_labValue.textColor = [UIColor grayColor];
                nameValueCell.m_labValue.enabled_middleLine = YES;
                nameValueCell.m_labValue.text = [SCNStatusUtility getPriceString:self.m_shoppingcartData.mpriceInfoData.moriTotalPrice];
                
                
				//nameValueCell.m_imgSepar.image = [UIImage imageNamed:@"com_separate.png"];
			}else if (indexPath.row == 1) {
				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"优惠金额:"];
				
				nameValueCell.m_labValue.enabled_middleLine = NO;
				nameValueCell.m_labValue.text = [NSString stringWithFormat:@"¥%.02f",[self.m_shoppingcartData.mpriceInfoData.msavePrice floatValue]];
				nameValueCell.m_labValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				//nameValueCell.m_imgSepar.image = [UIImage imageNamed:@"com_separate.png"];
			}else if (indexPath.row == 2) {
				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"商品总价:"];
				
				nameValueCell.m_labValue.enabled_middleLine = NO;
				nameValueCell.m_labValue.text = [NSString stringWithFormat:@"¥%.02f",[self.m_shoppingcartData.mpriceInfoData.msellPrice floatValue]];
				nameValueCell.m_labValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				//nameValueCell.m_imgSepar.image = [UIImage imageNamed:@"com_separate.png"];
			}else if (indexPath.row == 3) {
				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"商品数量:"];
				
				nameValueCell.m_labValue.enabled_middleLine = NO;
				nameValueCell.m_labValue.textColor = [UIColor blackColor];
				nameValueCell.m_labValue.text = [NSString stringWithFormat:@"%@件",self.m_shoppingcartData.mpriceInfoData.mnumber];
			}
			
//			if (indexPath.row != 3) {
//				[nameValueCell.m_imgSepar setFrame:CGRectMake(0, 31, 300, 1)];
//			}
		}else {
			//if (indexPath.row == 0) {
//				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"原始总价:"];
//                
//                nameValueCell.m_labValue.textColor = [UIColor grayColor];
//                nameValueCell.m_labValue.enabled_middleLine = YES;
//                nameValueCell.m_labValue.text = [SCNStatusUtility getPriceString:self.m_shoppingcartData.mpriceInfoData.moriTotalPrice];
//                
//				nameValueCell.m_imgSepar.image = [UIImage imageNamed:@"com_separate.png"];
//			}else 
			if (indexPath.row == 0) {
				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"商品总价:"];
				
				nameValueCell.m_labValue.enabled_middleLine = NO;
				nameValueCell.m_labValue.text = [NSString stringWithFormat:@"¥%.02f",[self.m_shoppingcartData.mpriceInfoData.msellPrice floatValue]];
				nameValueCell.m_labValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
				//nameValueCell.m_imgSepar.image = [UIImage imageNamed:@"com_separate.png"];
			}else if (indexPath.row == 1) {
				nameValueCell.m_labName.text = [NSString stringWithFormat:@"%@",@"商品数量:"];
				
				nameValueCell.m_labValue.enabled_middleLine = NO;
				nameValueCell.m_labValue.textColor = [UIColor blackColor];
				nameValueCell.m_labValue.text = [NSString stringWithFormat:@"%@件",self.m_shoppingcartData.mpriceInfoData.mnumber];
			}
			
			if (indexPath.row != 1) {
				//[nameValueCell.m_imgSepar setFrame:CGRectMake(0, 31, 300, 1)];
			}
		}

		
		[nameValueCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		nameValueCell.selectionStyle = UITableViewCellSelectionStyleNone;
		nameValueCell.accessoryType = UITableViewCellAccessoryNone;
	
		nameValueCell.layer.borderColor = [UIColor colorWithRed:(float)(149/255.0f) green:(float)(149/255.0f) blue:(float)(149/255.0f) alpha:1.0f].CGColor;
		
		tableCell = nameValueCell;
	}else if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count]==0 && [m_shoppingcartData.offsellingproducts count]>0) {
		cellIndentifier = @"SCNCashCenterTableCellId";
		SCNCashCenterTableCell* cell = nil;
		
		cell = (SCNCashCenterTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
		
		if (!cell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNCashCenterTableCell class]]) {
					cell = (SCNCashCenterTableCell*)object;
					break;
				}
			}
		}
		
		shoppingcartProductData* _productData = [m_shoppingcartData.offsellingproducts objectAtIndex:row];
		
		cell.m_labName.text = _productData.mname;
		
		[self dealwithColorSizeText:_productData label:cell.m_labStyle];		
		
		cell.m_labStyle.textColor = [UIColor colorWithRed:(float)(55/255.0f) green:(float)(55/255.0f) blue:(float)(55/255.0f) alpha:1.0f];
		cell.m_labNumber.text = _productData.mnumber;
		cell.m_txtNumber.text = _productData.mnumber;
		cell.m_image.image = [UIImage imageNamed:@"com_loading53x50.png"];
		
		if ([_productData.msavePrice floatValue] > 0.0) {
			[cell.m_labPriceTitle setFrame:CGRectMake(68, 60, 42, 21)];
			[cell.m_labPriceValue setFrame:CGRectMake(110, 60, 70, 21)];
			cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
			cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			
			cell.m_labSaveTitle.hidden = NO;
			cell.m_labSaveValue.hidden = NO;
			[cell.m_labSaveTitle setFrame:CGRectMake(170, 60, 61, 21)];
			[cell.m_labSaveValue setFrame:CGRectMake(235, 60, 70, 21)];
			cell.m_labSaveValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msavePrice floatValue]];
			cell.m_labSaveValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
		}else {
			[cell.m_labPriceTitle setFrame:CGRectMake(177, 40, 42, 21)];
			[cell.m_labPriceValue setFrame:CGRectMake(215, 40, 70, 21)];
			cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
			cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			
			cell.m_labSaveTitle.hidden = YES;
			cell.m_labSaveValue.hidden = YES;
		}
		cell.m_labTag.hidden = NO;
		[cell.m_labTag setFrame:CGRectMake(190, 25, 80, 14)];
		cell.m_labTag.text = [_productData mpstatusDes];
		
		cell.m_txtNumber.delegate=self;
		cell.m_txtNumber.enabled= isEdit;
		cell.m_txtNumber.hidden = !isEdit;
		if (isEdit) {
			[cell.m_txtNumber setBorderStyle:UITextBorderStyleLine];
			cell.m_txtNumber.text = cell.m_labNumber.text;
			cell.m_labNumber.hidden = YES;
		}else {
			[cell.m_txtNumber setBorderStyle:UITextBorderStyleNone];
			cell.m_labNumber.text = cell.m_txtNumber.text;
			cell.m_labNumber.hidden = NO;
		}
		
		//cell.m_imgBack = (UIImageView *)[cell viewWithTag:44];
		cell.m_imgBack.layer.borderWidth = 1;
		cell.m_imgBack.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		
		[HJImageUtility queueLoadImageFromUrl:_productData.mimage imageView:(HJManagedImageV*)cell.m_image];
		
		cell.m_txtNumber.tag=1000+indexPath.row;
		//cell.m_txtNumber.userInteractionEnabled = NO;
		[cell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		tableCell = cell;
		
	}else if (indexPath.section == 1) {
		cellIndentifier = @"SCNCashCenterTableCellId";
		SCNCashCenterTableCell* cell = nil;
		
		cell = (SCNCashCenterTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
		
		if (!cell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNCashCenterTableCell class]]) {
					cell = (SCNCashCenterTableCell*)object;
					break;
				}
			}
		}
		
		shoppingcartProductData* _productData = [m_shoppingcartData.sellingproducts objectAtIndex:row];
		
		NSString* clearName = [_productData.mname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		cell.m_labName.text = clearName;
		[self dealwithColorSizeText:_productData label:cell.m_labStyle];
		cell.m_labStyle.textColor = [UIColor colorWithRed:(float)(55/255.0f) green:(float)(55/255.0f) blue:(float)(55/255.0f) alpha:1.0f];
		cell.m_labNumber.text = _productData.mnumber;
		cell.m_txtNumber.text = _productData.mnumber;
		cell.m_image.image = [UIImage imageNamed:@"com_loading53x50.png"];
		
		if ([_productData.msavePrice floatValue] > 0.0) {
			[cell.m_labPriceTitle setFrame:CGRectMake(68, 60, 42, 21)];
			[cell.m_labPriceValue setFrame:CGRectMake(110, 60, 70, 21)];
			cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
			cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			
			cell.m_labSaveTitle.hidden = NO;
			cell.m_labSaveValue.hidden = NO;
			[cell.m_labSaveTitle setFrame:CGRectMake(170, 60, 61, 21)];
			[cell.m_labSaveValue setFrame:CGRectMake(235, 60, 70, 21)];
			cell.m_labSaveValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msavePrice floatValue]];
			cell.m_labSaveValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
		}else {
			[cell.m_labPriceTitle setFrame:CGRectMake(177, 40, 42, 21)];
			[cell.m_labPriceValue setFrame:CGRectMake(215, 40, 70, 21)];
			cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
			cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			
			cell.m_labSaveTitle.hidden = YES;
			cell.m_labSaveValue.hidden = YES;
		}

		cell.m_labTag.hidden = YES;
		
		cell.m_txtNumber.delegate=self;
		cell.m_txtNumber.enabled= isEdit;
		cell.m_txtNumber.hidden = !isEdit;
		if (isEdit) {
			[cell.m_txtNumber setBorderStyle:UITextBorderStyleLine];
			cell.m_txtNumber.text = cell.m_labNumber.text;
			cell.m_labNumber.hidden = YES;
		}else {
			[cell.m_txtNumber setBorderStyle:UITextBorderStyleNone];
			cell.m_labNumber.text = cell.m_txtNumber.text;
			cell.m_labNumber.hidden = NO;
		}

		cell.m_imgBack.layer.borderWidth = 1;
		cell.m_imgBack.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		
		[HJImageUtility queueLoadImageFromUrl:_productData.mimage imageView:(HJManagedImageV*)cell.m_image];
		
		cell.m_txtNumber.tag=indexPath.row;
		[cell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		tableCell = cell;
	}else if (indexPath.section == 2) {//缺货商品列表
		cellIndentifier = @"SCNCashCenterTableCellId";
		SCNCashCenterTableCell* cell = nil;
		
		cell = (SCNCashCenterTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
		
		if (!cell) {
			NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNCashCenterTableCell" owner:self options:nil];
			
			for (NSObject *object in objects) {
				if ([object isKindOfClass:[SCNCashCenterTableCell class]]) {
					cell = (SCNCashCenterTableCell*)object;
					break;
				}
			}
		}
		
		shoppingcartProductData* _productData = [m_shoppingcartData.offsellingproducts objectAtIndex:row];
		
		cell.m_labName.text = _productData.mname;
		[self dealwithColorSizeText:_productData label:cell.m_labStyle];
		cell.m_labStyle.textColor = [UIColor colorWithRed:(float)(55/255.0f) green:(float)(55/255.0f) blue:(float)(55/255.0f) alpha:1.0f];
		cell.m_labNumber.text = _productData.mnumber;
		cell.m_txtNumber.text = _productData.mnumber;
		
		if ([_productData.msavePrice floatValue] > 0.0) {
			[cell.m_labPriceTitle setFrame:CGRectMake(68, 60, 42, 21)];
			[cell.m_labPriceValue setFrame:CGRectMake(110, 60, 70, 21)];
			cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
			cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			
			cell.m_labSaveTitle.hidden = NO;
			cell.m_labSaveValue.hidden = NO;
			[cell.m_labSaveTitle setFrame:CGRectMake(170, 60, 61, 21)];
			[cell.m_labSaveValue setFrame:CGRectMake(235, 60, 70, 21)];
			cell.m_labSaveValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msavePrice floatValue]];
			cell.m_labSaveValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
		}else {
			[cell.m_labPriceTitle setFrame:CGRectMake(177, 40, 42, 21)];
			[cell.m_labPriceValue setFrame:CGRectMake(215, 40, 70, 21)];
			cell.m_labPriceValue.text = [NSString stringWithFormat:@"¥%.02f",[_productData.msellPrice floatValue]];
			cell.m_labPriceValue.textColor = [UIColor colorWithRed:(float)(180/255.0f) green:(float)(0/255.0f) blue:(float)(7/255.0f) alpha:1.0f];
			
			cell.m_labSaveTitle.hidden = YES;
			cell.m_labSaveValue.hidden = YES;
		}
		cell.m_labTag.hidden = NO;
		[cell.m_labTag setFrame:CGRectMake(190, 25, 80, 14)];
		cell.m_labTag.text = [_productData mpstatusDes];
		
		cell.m_txtNumber.delegate=self;
		cell.m_txtNumber.enabled= isEdit;
		cell.m_txtNumber.hidden = !isEdit;
		if (isEdit) {
			[cell.m_txtNumber setBorderStyle:UITextBorderStyleLine];
			cell.m_txtNumber.text = cell.m_labNumber.text;
			cell.m_labNumber.hidden = YES;
		}else {
			[cell.m_txtNumber setBorderStyle:UITextBorderStyleNone];
			cell.m_labNumber.text = cell.m_txtNumber.text;
			cell.m_labNumber.hidden = NO;
		}
		
		//cell.m_imgBack = (UIImageView *)[cell viewWithTag:44];
		cell.m_imgBack.layer.borderWidth = 1;
		cell.m_imgBack.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		
		[HJImageUtility queueLoadImageFromUrl:_productData.mimage imageView:(HJManagedImageV*)cell.m_image];
		
		cell.m_txtNumber.tag=1000+indexPath.row;
		//[cell.layer setBorderColor:[UIColor colorWithRed:(float)(149/255.0f) green:(float)(149/255.0f) blue:(float)(149/255.0f) alpha:1.0f]];
		[cell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];
		tableCell = cell;
	}
	
	return tableCell;
}

-(void)dealwithColorSizeText:(shoppingcartProductData*)_productData label:(UILabel*)label
{
	if (_productData.mcolor && [_productData.mcolor length] && _productData.msize && [_productData.msize length])
	{
		label.text = [NSString stringWithFormat:@"(颜色:%@,尺码:%@)",_productData.mcolor,_productData.msize];
	}
	else if(_productData.mcolor && [_productData.mcolor length])
	{
		label.text = [NSString stringWithFormat:@"(颜色:%@)",_productData.mcolor];
	}
	else if(_productData.msize && [_productData.msize length])
	{
		label.text = [NSString stringWithFormat:@"(尺码:%@)",_productData.msize];
	}
	else
	{
		label.text = @"";
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count]>0) {
		return NO;
	}else if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count]==0 && [m_shoppingcartData.offsellingproducts count]>0) {
		return YES;
	}else {
		return YES;
	}

}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(editingStyle==UITableViewCellEditingStyleDelete)
	{
		isDeledate=YES;
		
		if (indexPath.section == 0 && [m_shoppingcartData.sellingproducts count]==0 && [m_shoppingcartData.offsellingproducts count]>0) {
			OffShoppingCartData* _offshoppingcartdata = [m_shoppingcartData.offsellingproducts objectAtIndex:indexPath.row];
			[self removeShoppingcartBehavior:_offshoppingcartdata];//移除购物车行为统计
			[self preDeleteItem:_offshoppingcartdata indexPath:indexPath];
		}else if (indexPath.section == 1) {
			ShoppingCartData* _shoppingcartdata = [m_shoppingcartData.sellingproducts objectAtIndex:indexPath.row];
			[self removeShoppingcartBehavior:_shoppingcartdata];//移除购物车行为统计
			[self preDeleteItem:_shoppingcartdata indexPath:indexPath];
		}else if (indexPath.section == 2) {
			OffShoppingCartData* _offshoppingcartdata = [m_shoppingcartData.offsellingproducts objectAtIndex:indexPath.row];
			[self removeShoppingcartBehavior:_offshoppingcartdata];
			[self preDeleteItem:_offshoppingcartdata indexPath:indexPath];
		}
	}
}

#pragma mark Delete shoppingcartProductData
-(void)preDeleteItem:(CartData*)_item indexPath:(NSIndexPath *)_indexPath{
	
	NSMutableArray* shoppingCart = [SCNStatusUtility loadShoppingcartAndOffShoppingcart];
	
	if( shoppingCart ==nil ){
		NSLog( @"[NOTE]deleted //assert(shoppingCart!=nil);" );
		return;
	}
	
	NSLog( @"shopcartItem count %d", [shoppingCart count] );
	
	self.m_willDeleteItem = _item;
	
	m_skuRootString = [[NSMutableString alloc]init];
	for (CartData* _data in shoppingCart) {
		if (![_data.msku isEqualToString:_item.msku]) {
			//构造要提交到查看购物车的数据
			[self genPreDeleteShoppingCartData:_data];
		}
	}

	
	if ([shoppingCart count]>1)
	{
		isDeleting = TRUE;
		[self requestGetCartXmlData:m_skuRootString];
	}
	else 
	{
		[self directDeleteInLocal:_item indexPath:_indexPath];
	}
}

-(void)removeShoppingcartBehavior:(CartData*)_cartData{
#ifdef USE_BEHAVIOR_ENGINE
	//商品来源页面id|数量|商品名称|sku
	NSString* _curSrcPageId = [NSString stringWithFormat:@"%d",[YKStatBehaviorInterface currentSourcePageId]];
	NSString* _param = [NSString stringWithFormat:@"%@|%@|%@|%@",_curSrcPageId,
						_cartData.mnumber,
						_cartData.mname,
						_cartData.mproductCode];
	
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_REMOVESHOPPINGCART param:_param];
#endif
}

-(void)confirmDeleteItem{
	isDeleting = FALSE;
	[self stopLoading];
	
	int _delTag = 0;
	//已经在服务端的数据库中删除，接下来删除本地数据库中的
	for (ShoppingCartData* _item in [ShoppingCartData allObjects]) {
		if ([self.m_willDeleteItem.msku isEqualToString:_item.msku]) {
			_delTag = 1;
			break;
		}
	}
	
	if (_delTag != 1) {
		for (OffShoppingCartData* _item in [OffShoppingCartData allObjects]) {
			if ([self.m_willDeleteItem.msku isEqualToString:_item.msku]) {
				_delTag = 2;
				break;
			}
		}
	}
	//delTag = 2  >>>>>>>说明要删除不可购买表中的商品
	//delTag = 1  >>>>>>>说明要删除可购买表中的商品
	if (_delTag == 1) {
		[self reloadSaveProductList:self.m_shoppingcartData.sellingproducts];
	}else if (_delTag == 2) {
		[self reloadSaveOffProductList:m_shoppingcartData.offsellingproducts];
	}
	
	//如果没有item存在于购物车中，停止编辑
	if( [[ShoppingCartData allObjects] count] == 0 && [[OffShoppingCartData allObjects] count] == 0 ){
		self.navigationItem.leftBarButtonItem.customView.hidden = YES;
		isEdit=NO;
	}
	
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
													  message:@"已成功删除！" 
													 delegate:nil 
											cancelButtonTitle:@"确定" 
											otherButtonTitles:nil];
	[alertView show];
}

-(void)directDeleteInLocal:(CartData*)_cartData indexPath:(NSIndexPath *)_indexPath{
	
	int _delTag = 0;
	//已经在服务端的数据库中删除，接下来删除本地数据库中的
	for (ShoppingCartData* _item in [ShoppingCartData allObjects]) {
		if ([_cartData.msku isEqualToString:_item.msku]) {
			_delTag = 1;
			break;
		}
	}
	
	if (_delTag != 1) {
		for (OffShoppingCartData* _item in [OffShoppingCartData allObjects]) {
			if ([_cartData.msku isEqualToString:_item.msku]) {
				_delTag = 2;
				break;
			}
		}
	}
	//delTag = 2  >>>>>>>说明要删除不可购买表中的商品
	//delTag = 1  >>>>>>>说明要删除可购买表中的商品
	if (_delTag == 1) {
		[SCNStatusUtility deleteOffShoppingcartData:_cartData];
		[m_shoppingcartData.sellingproducts removeObjectAtIndex:_indexPath.row];
		[self reloadSaveProductList:m_shoppingcartData.sellingproducts];
	}else if (_delTag == 2) {
		[SCNStatusUtility deleteShoppingcartData:_cartData];
		[m_shoppingcartData.offsellingproducts removeObjectAtIndex:_indexPath.row];
		[self reloadSaveOffProductList:m_shoppingcartData.offsellingproducts];
	}
	[m_tableView reloadData];
	
	//如果没有item存在于购物车中，停止编辑
	if( [[ShoppingCartData allObjects] count] == 0 && [[OffShoppingCartData allObjects] count] == 0 ){
		self.navigationItem.leftBarButtonItem.customView.hidden = YES;
		isEdit=NO;
	}
	
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
													  message:@"已成功删除！" 
													 delegate:nil 
											cancelButtonTitle:@"确定" 
											otherButtonTitles:nil];
	[alertView show];
}

-(void)genPreDeleteShoppingCartData:(CartData*)_cartData{
	NSString* skuString;
	
	if ([m_skuRootString length]==0) {
		skuString = [NSString stringWithFormat:@"%@-%@-%d",_cartData.mproductCode,_cartData.msku,_cartData.mnumber];
	}else {
		skuString =	[NSString stringWithFormat:@"|%@-%@-%d",_cartData.mproductCode,_cartData.msku,_cartData.mnumber];	
	}
	
	[m_skuRootString appendString:skuString];
	
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	int nCount = textField.tag;
	
	m_curTxt = textField;
	if (self.controlArea == nil)
	{
		controlArea = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		controlArea.backgroundColor = [UIColor clearColor];
		//controlArea.alpha = 0.5f;
		[controlArea addTarget:self action:@selector(resignAllKeyboard) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:controlArea];
	}
	
	if (nCount >= 1000) {
		nCount-=1000;
		
		if ([[ShoppingCartData allObjects]count] != 0) {
			nCount+=[[ShoppingCartData allObjects]count]+1;
		}
	}
	
	//CGRect rect = m_showView.frame;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	self.m_tableView.contentOffset = CGPointMake(0.0f, nCount*63.0f+80.f);
	[UIView commitAnimations];
	
	
	return YES;
}

#pragma mark modify textField
-(void)resignAllKeyboard{
	if (self.controlArea == nil)
	{
		return;
	}
	
	[controlArea removeFromSuperview];
	self.controlArea = nil;
	
	if (m_curTxt) {
		[m_curTxt resignFirstResponder];
	}
	
	[self.m_tableView setContentOffset:CGPointMake(0,0) animated:YES];
	
}

-(void)textFielChange:(NSNotification*)notification
{
	UITextField *textField = (UITextField *)[notification object];
	
	if (isEdit) {
		shoppingcartProductData* pData;
		if (textField.tag<1000) {
			pData = [self.m_shoppingcartData.sellingproducts objectAtIndex:textField.tag];
            
		}else {
			pData = [self.m_shoppingcartData.offsellingproducts objectAtIndex:textField.tag-1000];
		}

		if ([textField.text length] == 0 || [textField.text isEqualToString:@""]) {
			isTxtFieldEmpty = YES;
		}else {
			isTxtFieldEmpty = NO;
		}
		
		if ([textField.text intValue] > 100) {
			isNumberExceed = YES;
		}else {
			isNumberExceed = NO;
		}


		pData.mnumber = textField.text;
		[self reloadSaveProductList:self.m_shoppingcartData.sellingproducts];
		[self reloadSaveOffProductList:m_shoppingcartData.offsellingproducts];
		
	}
	
}

-(void)startEditOrFinishEdit:(UIButton*)item
{
	isEdit=!isEdit;
	
	if (isEdit) {
		[self.m_tableView setEditing:YES animated:YES];
		[item setTitle:@"完成" forState:UIControlStateNormal];
	}else {
		if (isTxtFieldEmpty) {
			isEdit=!isEdit;
			[self popNumberZeroAlert];
			return;
		}else if (isNumberExceed) {
			isEdit=!isEdit;
			[self popNumberExceedAlert];
			return;
		}else {
			
			CGRect rect=self.m_tableView.frame;
			self.m_tableView.frame=rect;
			[self.m_tableView setEditing:NO animated:YES];
			[item setTitle:@"编辑" forState:UIControlStateNormal];
			
			[self resignAllKeyboard];
			
			NSString *data = [SCNStatusUtility getShoppingcartDataAndOffShoppingcartData];
			NSLog(@"%@",data);
			[self requestGetCartXmlData:data];
		}	
		
	}	
	[m_tableView reloadData];
	
}

#pragma mark reloadProductList
-(void)reloadSaveProductList:(NSArray*)list
{
	NSMutableArray *l_array_shoppingCartData = [NSMutableArray array];
	for (shoppingcartProductData* _data in list) {
		ShoppingCartData* cartData = [[ShoppingCartData alloc]init];
		cartData.msku = _data.msku;
		cartData.mproductCode = _data.mproductCode;
		cartData.mnumber = [_data.mnumber intValue];
		
		[l_array_shoppingCartData addObject:cartData];
	}
	[SCNStatusUtility clearShoppingcart];
	for (ShoppingCartData* _product in l_array_shoppingCartData) {
		[SCNStatusUtility saveShoppingcart:_product];
	}
	
}

-(void)reloadSaveOffProductList:(NSArray*)list{
    NSMutableArray *l_array_shoppingCartData = [NSMutableArray array];
	for (shoppingcartProductData *product in list) {
		OffShoppingCartData *cartData=[self fromProductToOffShoppingCartData:product];
        for (OffShoppingCartData *_scData in [OffShoppingCartData allObjects]) {
            if ([cartData.msku isEqualToString:_scData.msku]) {
                [_scData deleteObject];
            }
        }
        [l_array_shoppingCartData addObject:cartData];
	}
    [SCNStatusUtility clearOffShoppingcart];
    for (OffShoppingCartData *_data in l_array_shoppingCartData) {
        [SCNStatusUtility saveOffShoppingcart:_data];
    }
    
}

#pragma mark from shoppingcartProductData to OffShoppingCartData
-(OffShoppingCartData*)fromProductToOffShoppingCartData:(shoppingcartProductData*)_product{
	OffShoppingCartData *data=[[OffShoppingCartData alloc] init];
	data.mnumber=[_product.mnumber intValue];
	data.mproductCode=_product.mproductCode;
	data.msku=_product.msku;
	return data;
}


-(void)clickFunctionBtn:(id)sender{
	//NSArray *l_array_function = [self.m_operateDic allValues];
//	UIActionSheet *menu = [[UIActionSheet alloc]
//                           initWithTitle:nil
//                           delegate:self
//                           cancelButtonTitle:nil
//                           destructiveButtonTitle:nil
//                           otherButtonTitles:nil];
//	
//	for (NSString *l_str_function in l_array_function) {
//		[menu addButtonWithTitle:l_str_function];
//	}
//	menu.cancelButtonIndex = [menu addButtonWithTitle:@"取消"];
//    [menu showInView:self.view];
}

#pragma mark gotoCashCenter
-(IBAction)goPayPriceCenter:(id)sender
{
	if ([YKUserInfoUtility isUserLogin]) {
//		NSString* _shoppingType = [self getShoppingType];
//		NSLog(@"%@",_shoppingType);
		SCNCashCenterViewController* cashCenter = [[SCNCashCenterViewController alloc] initWithNibName:@"SCNCashCenterViewController" bundle:nil];
		//[Go2PageUtility go2CashCenterViewController:self cashCenterViewCtrl:cashCenter withProducts:m_shoppingcartData.sellingproducts shoppingType:_shoppingType];
		NSString* _productData = [SCNStatusUtility getShoppingcartData];
		[Go2PageUtility go2CashCenterByShoppingType:self cashCenterViewCtrl:cashCenter withProductData:_productData withCashType:ECashTypeCommon];
	}
    else {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"您当前没有登录,请您先登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		alert.delegate=self;
		[alert show];
		isLoginBack = YES;
	}
}

#pragma mark UIAlertView delegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
//	NSString* _shoppingType = [self getShoppingType];
//	NSLog(@"%@",_shoppingType);
	SCNCashCenterViewController* cashCenter = [[SCNCashCenterViewController alloc] initWithNibName:@"SCNCashCenterViewController" bundle:nil];
	//[Go2PageUtility go2CashCenterViewController:self cashCenterViewCtrl:cashCenter withProducts:m_shoppingcartData.sellingproducts shoppingType:_shoppingType];
	NSString* _productData = [SCNStatusUtility getShoppingcartData];
	[Go2PageUtility go2CashCenterByShoppingType:self cashCenterViewCtrl:cashCenter withProductData:_productData withCashType:ECashTypeCommon];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
//	NSString* numStr = textField.text;
//	NSLog(@"%@",numStr);
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//	NSString* numStr = textField.text;
//	NSLog(@"%@",numStr);

	if ([textField.text intValue] ==0 || [textField.text isEqualToString:@""]){
		textField.text = @"1";
		[self popNumberZeroAlert];
	}
	
	if ([textField.text intValue]>100) {
		textField.text = @"100";
		
		[self popNumberExceedAlert];
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if (([string isEqualToString:@"0"] && (range.location == 0)) || ([string isEqualToString:@""] && (range.location == -1)) ) {
		return NO;
	}
	
	return YES;
}

-(void)popNumberExceedAlert{
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
													  message:@"每样单品最多购买100件!" 
													 delegate:nil 
											cancelButtonTitle:@"确定" 
											otherButtonTitles:nil];
	[alertView show];
}

-(void)popNumberZeroAlert{
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" 
													  message:@"编辑数量不可为空!" 
													 delegate:nil 
											cancelButtonTitle:@"确定" 
											otherButtonTitles:nil];
	[alertView show];
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}

@end
