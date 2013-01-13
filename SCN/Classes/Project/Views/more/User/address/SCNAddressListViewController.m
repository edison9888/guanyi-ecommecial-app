//
//  SCNAddressListViewController.m
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNAddressListViewController.h"
#import "SCNCashCenterViewController.h"
#import "SCNAddressTableCell.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "addressData.h"
#import "Go2PageUtility.h"
#import "YKStatBehaviorInterface.h"

@implementation SCNAddressListViewController
@synthesize m_tableView;
@synthesize m_addressList;
@synthesize defaultSelectedAddressId;
@synthesize currentViewFromTag;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(BOOL)isNeedLogin
{
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	if (currentViewFromTag == myAddressTag) {
		self.pathPath = @"/address";
		self.navigationItem.title = @"收货地址簿";
	}else {
		self.pathPath = @"/selectaddress";
		self.navigationItem.title = @"选择收货地址";
	}
	
	m_tableView.backgroundColor = [UIColor clearColor];
	[self setNormalNavigationItem];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReloadAddressList:) name:YK_ADDRESS_DELETE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSetDefaultAddress:) name:YK_DEFAULTADDRESS_CHANGE object:nil];
	
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.m_tableView setSeparatorColor:YK_CELLBORDER_COLOR];
	if (!self.isGoBack)
	{
		[self requestAddressListXmlData];
	}
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

-(void)setNormalNavigationItem{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 0,54,32)];
	[button setTitle:@"添加" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
	
	[button setBackgroundImage:[[UIImage imageNamed:@"com_btn.png"] 
								stretchableImageWithLeftCapWidth:20 
								topCapHeight:20] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"com_btn_SEL.png"] 
								stretchableImageWithLeftCapWidth:20 
								topCapHeight:20] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(addMyAddress:) forControlEvents:UIControlEventTouchUpInside];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:button.frame];
	[ricusview addSubview:button];
	
	UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:ricusview];
	[self.navigationItem  setRightBarButtonItem:item];
	
	//self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

-(void)addMyAddress:(UIButton*)_btn{
	[Go2PageUtility go2AddressModifyPage:self withAddress:nil withDelegate:self];
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
	[[NSNotificationCenter defaultCenter] removeObserver:self name:YK_ADDRESS_DELETE object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:YK_DEFAULTADDRESS_CHANGE object:nil];
}



-(void)parseAddressListXmlDataResponse:(GDataXMLDocument*)xmlDoc{
	//NSString *path = [[NSBundle mainBundle]pathForResource:@"addressListTest" ofType:@"xml"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"------%@",aStr);
//    xmlDoc =[[GDataXMLDocument alloc] initWithXMLString:aStr options:0 error:nil];
//    [aStr release];
	
	//addressList
	m_addressList = [[NSMutableArray alloc]initWithCapacity:10];
	NSString* addressPath = [NSString stringWithFormat:@"shopex/info/data_info/addressList/address"];
	NSArray* addressEleArr = [xmlDoc nodesForXPath:addressPath error:nil];
	if ([addressEleArr count]>0) {
		for (GDataXMLElement* item in addressEleArr) {
			addressData* _addressData = [[addressData alloc]init];
			_addressData.maddressId = [[item attributeForName:@"addressId"] stringValue];
			_addressData.mdefault = [[item attributeForName:@"default"] stringValue];
		
			GDataXMLNode* _consigneeNode = [item oneNodeForXPath:@"consignee" error:nil];
			_addressData.mconsignee = [_consigneeNode stringValue];
			
			GDataXMLNode* _sexNode = [item oneNodeForXPath:@"sex" error:nil];
			_addressData.msex = [_sexNode stringValue];
			
			GDataXMLNode* _addressDetailNode = [item oneNodeForXPath:@"addressdetail" error:nil];
			_addressData.maddressdetail = [_addressDetailNode stringValue];
			
			GDataXMLNode* _provinceNode = [item oneNodeForXPath:@"province" error:nil];
			GDataXMLElement* _provinceEle = [item oneElementForName:@"province"];
			_addressData.mprovinceId = [[_provinceEle attributeForName:@"provinceId"] stringValue];
			_addressData.mprovince = [_provinceNode stringValue];
			
			GDataXMLNode* _cityNode = [item oneNodeForXPath:@"city" error:nil];
			GDataXMLElement* _cityEle = [item oneElementForName:@"city"];
			_addressData.mcityId = [[_cityEle attributeForName:@"cityId"]stringValue];
			_addressData.mcity = [_cityNode stringValue];
			
			GDataXMLNode* _areaNode = [item oneNodeForXPath:@"area" error:nil];
			GDataXMLElement* _areaEle = [item oneElementForName:@"area"];
			_addressData.mareaId = [[_areaEle attributeForName:@"areaId"]stringValue];
			_addressData.marea = [_areaNode stringValue];
			
			GDataXMLNode* _phoneNode = [item oneNodeForXPath:@"phone" error:nil];
			_addressData.mphone = [_phoneNode stringValue];
			
			[m_addressList addObject:_addressData];
		}
		
	}
	
	[m_tableView reloadData];

}

-(void)requestAddressListXmlData{
    if (m_isRequesting) {
        return;
    }
	m_isRequesting = YES;
    [self startLoading];
    //[m_tableView setHidden:YES];
    //NSString* method = [YKStringUtility strOrEmpty:@"getAddressList"];
	
    NSDictionary* extraParam= @{@"act": YK_METHOD_GET_ADDRESSLIST};
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestAddressListXmlDataResponse:)];
    
}
-(void)onRequestAddressListXmlDataResponse:(GDataXMLDocument*)xmlDoc{
    [self stopLoading];
    m_isRequesting =NO;
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        NSLog(@"===========");
		[self parseAddressListXmlDataResponse:xmlDoc];
		
		if ([m_addressList count] > 0) {
            [self hideNotecontent];
		}else{
            [self showNotecontent:@"您还没有添加收货地址"];
        }
        
    [m_tableView reloadData];
	}
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	float height = 80.0f;
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (currentViewFromTag == cashCenterTag) {
		for (UIViewController *controller in self.navigationController.viewControllers) {
			if ([controller isKindOfClass:[SCNCashCenterViewController class]]) {
				addressData *data =[m_addressList objectAtIndex:[indexPath indexAtPosition:0]];
				[self behaviorSelectAddress:data];
				SCNCashCenterViewController *con=(SCNCashCenterViewController*)controller;
				NSString *address=[NSString stringWithFormat:@"%@\n%@\n%@%@%@\n%@",
								   [data mconsignee],
								   [data mphone],
								   [data mprovince],
								   [data mcity],
								   [data marea],
								   [data maddressdetail]];
                //[con.submitOrderData setAddressOnly:[NSString stringWithFormat:@"%@",[data maddressdetail]]];
				//[con.submitOrderData setAddressed:address];
				//con.submitOrderData.addressId=[data maddressId];
				[con.submitOrderData setTempAddressOnly:[NSString stringWithFormat:@"%@",[data maddressdetail]]];
				[con.submitOrderData setTempAddressed:address];
				con.submitOrderData.tempAddressId=[data maddressId];
				[con controllerReload:YK_ADDRESS_UPDATE]; //这点细看
				[self goBack];
				break;
			}
		}
		
		return;
		
	}
	addressData* _address = [m_addressList objectAtIndex:indexPath.section];
	[Go2PageUtility go2AddressModifyPage:self withAddress:_address withDelegate:self];
	[self.m_tableView deselectRowAtIndexPath:indexPath animated:NO];
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	addressData* _address = [m_addressList objectAtIndex:indexPath.section];
	[Go2PageUtility go2AddressModifyPage:self withAddress:_address withDelegate:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	tableView.sectionHeaderHeight = 4.0f;
    return 4.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	tableView.sectionFooterHeight = 4.0f;
    return 4.0f;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	NSInteger nAddrCount = [m_addressList count];
	return nAddrCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell* cell = nil;
	int section = indexPath.section;
	
	NSString* cellIndentifier = @"SCNAddressListTableCellId";
	
	SCNAddressListTableCell* addressCell = nil;
	
	addressCell = (SCNAddressListTableCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
	
	if (!addressCell)
	{
		NSArray *objects=[[NSBundle mainBundle] loadNibNamed:@"SCNAddressTableCell" owner:self options:nil];
		
		for (NSObject *object in objects) {
			if ([object isKindOfClass:[SCNAddressListTableCell class]]) {
				addressCell = (SCNAddressListTableCell*)object;
				
				UIView * _view_bgcellview = [YKButtonUtility initBgCornerViewWithHeight:76 cornerRadius:5];
				[addressCell.contentView insertSubview:_view_bgcellview atIndex:0];
				
				break;
			}
		}
	}
	addressData* _address = [m_addressList objectAtIndex:section];
	addressCell.m_labName.text = [_address mconsignee];
	addressCell.m_labAddress.text = [_address maddressdetail];
	addressCell.m_labArea.text = [NSString stringWithFormat:@"%@%@%@",[_address mprovince],[_address mcity],[_address marea]]; 
	addressCell.m_labMobile.text = [_address mphone];
	NSLog(@"%@",addressCell.m_labName.text);
	NSLog(@"%@",addressCell.m_labAddress.text);
	NSLog(@"%@",addressCell.m_labArea.text);
	NSLog(@"%@",addressCell.m_labMobile.text);
	
	if (currentViewFromTag == myAddressTag) {
		//我的地址薄页面
		
		if ([_address.maddressId isEqualToString:defaultSelectedAddressId] || [_address.mdefault isEqualToString:@"1"]) {
			addressCell.m_imageDefaultArrow.hidden = NO;
			addressCell.m_imageDefaultBox.hidden = NO;
			addressCell.m_labDefault.hidden = NO;
		}else{
			addressCell.m_imageDefaultArrow.hidden = YES;
			addressCell.m_imageDefaultBox.hidden = YES;
			addressCell.m_labDefault.hidden = YES;
		}
		addressCell.m_imageArrow.hidden = NO;
		[addressCell.m_imageArrow setFrame:CGRectMake(285, 36, 9, 16)];
		[addressCell.m_imageArrow setBackgroundColor:[UIColor clearColor]];
		addressCell.m_imageArrow.image = [UIImage imageNamed:@"com_arrow.png"];
	}else if (currentViewFromTag == cashCenterTag) {
		//从结算中心导航过来的
		addressCell.m_imageDefaultArrow.hidden = YES;
		addressCell.m_imageDefaultBox.hidden = YES;
		addressCell.m_labDefault.hidden = YES;
		
		if ([_address.maddressId isEqualToString:defaultSelectedAddressId]) {
			addressCell.m_imageArrow.hidden = NO;
		}else {
			addressCell.m_imageArrow.hidden = YES;
		}
	}
	//if (currentViewFromTag == myAddressTag) {
//		[addressCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//	}
	[addressCell setBackgroundColor:[UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1.0f]];

	cell = addressCell;

	return cell;
}


-(void) addressEditFinish:(addressData*) addressData{
	[self requestAddressListXmlData];
}

-(void)onReloadAddressList:(NSNotification*)_notification{
	[self requestAddressListXmlData];
	//[self parseAddressListXmlDataResponse:nil];
}

-(void)onSetDefaultAddress:(NSNotification*)_notification{
	NSString* _addressId = [_notification object];
	
	NSLog(@"%@",_addressId);
	
	//[self parseAddressListXmlDataResponse:nil];
	self.defaultSelectedAddressId = _addressId;
	[self requestAddressListXmlData];
	[m_tableView reloadData];
	
}

//#pragma mark Behavior
//-(void)BehaviorPageJump{
//#ifdef USE_BEHAVIOR_ENGINE
//#endif
//}

-(NSString*)pageJumpParam{
	NSString* _param = nil;
#ifdef USE_BEHAVIOR_ENGINE
	return _param;
#else
	return _param;
#endif
}

-(void)behaviorSelectAddress:(addressData*)_addressData{
#ifdef USE_BEHAVIOR_ENGINE
	//订单号|用户名|用户id|区域
	NSString* _userName = [[YKUserInfoUtility shareData] m_userDataInfo].musername;
	NSString* _userId = [[YKUserInfoUtility shareData] m_userDataInfo].mweblogid;
	NSString* _param = [NSString stringWithFormat:@"%@|%@|%@%@%@",_userName,_userId,_addressData.mprovince,_addressData.mcity,_addressData.marea];
	
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_SELECTADDRESS param:_param];
#endif
}

@end
