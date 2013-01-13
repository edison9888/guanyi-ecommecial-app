//
//  SCNAddressEditViewController.m
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNAddressEditViewController.h"
#import "YK_ButtonUtility.h"
#import "SCNAddressTableCell.h"
#import "YKStringHelper.h"
#import "StatusUtility.h"
#import "SCNStatusUtility.h"

@interface SCNAddressEditViewController(PrivateMethods)
-(void)onTextChange:(NSNotification*) notification;
-(void)buttonAction_lacal;
-(void)onRequestDeleAddressViewXmlDataResponse:(ASIHTTPRequest*)request;
-(void)changeTableViewFrame;
-(void)onSaveAddressFinished:(GDataXMLDocument*)xmlDoc;
@end

@implementation SCNAddressEditFunView
@synthesize m_btnDefault;
@synthesize m_btnDelete;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		self.m_btnDefault = [YKButtonUtility initSimpleButton:CGRectMake(30, 10, 258, 35)
												   title:@"设为默认地址"
											 normalImage:@"com_button_normal.png"
											 highlighted:@"com_button_select.png"];
		[self addSubview:m_btnDefault];
		
		self.m_btnDelete = [YKButtonUtility initSimpleButton:CGRectMake(30, 60, 258, 35)
												   title:@"删除"
											 normalImage:@"com_button_normal.png"
											 highlighted:@"com_button_select.png"];
		[self addSubview:m_btnDelete];
	}
	return self;
}

-(void)dealloc{
	m_btnDefault = nil;
	m_btnDelete = nil;
}

@end


@implementation SCNAddressEditViewController
@synthesize m_button_delete;
@synthesize m_cityPickerView;
@synthesize m_isAddMode;
@synthesize	delegate;
@synthesize m_address;
@synthesize m_currentProvinceObj;
@synthesize m_currentCityObj;
@synthesize m_currentAreaObj;
@synthesize footerView;
@synthesize setDefaultView;
@synthesize m_button_default;
@synthesize m_tableView;
@synthesize m_provinceArray;
@synthesize isModified;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString*)nibNameOrNil withAddress:(addressData*)addr bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		m_isAddMode = !addr;
		
		if (m_isAddMode)
		{
			m_address = [[addressData alloc] init];
		}
		else 
		{
			self.m_address = addr;
		}
		
		firstEnter = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:YES];
	//[m_tableView setBackgroundColor:[UIColor clearColor]];
	[m_tableView setSeparatorColor:[UIColor clearColor]];
	[m_tableView reloadData];
	
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.pathPath = @"/address";
	[m_cityPickerView setDelegate:self];
	[m_cityPickerView setDataSource:self];
	
	footerView = [[SCNAddressEditFunView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
	[footerView.m_btnDefault addTarget:self action:@selector(buttonAction_setDefault:) forControlEvents:UIControlEventTouchUpInside];
	[footerView.m_btnDelete addTarget:self action:@selector(buttonAction_delete:) forControlEvents:UIControlEventTouchUpInside];
	
	[self setViewTitle];
	firstEnter = NO;
	
}

-(void)setViewTitle{
	if (m_isAddMode ) {
		self.title=@"新增地址";
		UIView *btnView =[YK_ButtonUtility customButtonViewWithImageName:@"com_btn.png" 
                                                    highlightedImageName:@"com_btn_SEL.png" 
                                                                   title:@"保存地址" 
                                                                    font:[UIFont boldSystemFontOfSize:14] 
                                                                  target:self action:@selector(buttonAction_lacal)];
		self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btnView];
		
		m_button_delete.hidden = YES;
		
	}
	else {
		self.title=@"编辑地址";
		UIView *btnView =[YK_ButtonUtility customButtonViewWithImageName:@"com_btn.png" 
                                                    highlightedImageName:@"com_btn_SEL.png" 
                                                                   title:@"修改" 
                                                                    font:[UIFont boldSystemFontOfSize:14] 
                                                                  target:self action:@selector(buttonAction_lacal)];
		self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btnView];
		
		m_button_delete.hidden = NO;
	}
	
}

//保存地址
-(void)buttonAction_lacal
{
	if (self.isLoading) {
		return;
	}
	[self onSaveAddress];
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
	self.m_tableView = nil;
    self.m_cityPickerView = nil;
	self.m_currentProvinceObj = nil;
	self.m_currentCityObj = nil;
	self.m_currentAreaObj = nil;
}


- (void)dealloc {
	m_tableView = nil;
	m_cityPickerView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray* keyArray=@[@"收货人:",
					   @"手机:",
					   @"地区:",
					   @"详细地址:"];
	
	{		
		NSString* editIdentifier=@"SCN_address_edit";
		
		MorelacalEditTableCell_Edit* cell = (MorelacalEditTableCell_Edit*)[tableView dequeueReusableCellWithIdentifier:editIdentifier];
		
		if (cell == nil) {
			cell=[[[NSBundle mainBundle] loadNibNamed:@"SCNAddressTableCell" owner:self options:nil] objectAtIndex:3];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			UIView *_view_bgcellview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 48)];
			//设置View的背景颜色
			[_view_bgcellview setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
			//设置圆角半径
			if (indexPath.row == 0 || indexPath.row == 3) {
				[_view_bgcellview.layer setCornerRadius:5.0];
			}else {
				[_view_bgcellview.layer setCornerRadius:0];
			}

			//设置边框宽度
			[_view_bgcellview.layer setBorderWidth:1];
			//设置边框颜色
			[_view_bgcellview.layer setBorderColor:YK_CELLBORDER_COLOR.CGColor];
			[cell.contentView insertSubview:_view_bgcellview atIndex:0];
			
			
		}
		
		cell.m_TextField_value.tag = indexPath.row;
		cell.m_TextField_value.returnKeyType = UIReturnKeyNext;
		cell.m_TextField_value.keyboardType = UIKeyboardTypeDefault;
		cell.m_TextField_value.enabled = YES;
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextChange:) name:UITextFieldTextDidChangeNotification object:cell.m_TextField_value];
		
		if (indexPath.row <= 3) {
			cell.m_TextField_value.delegate = self;
			if (indexPath.row == 1) {
				cell.m_TextField_value.keyboardType = UIKeyboardTypeNumberPad;
                //KBCustomTextField* l_kbTf = (KBCustomTextField*)cell.m_TextField_value;
                //l_kbTf.kbDelegate = self;
			}
			if (indexPath.row == 2) {
				cell.m_TextField_value.enabled = NO;
			}
			if (indexPath.row == 3){
				cell.m_TextField_value.returnKeyType = UIReturnKeyDone;
				
			}
		}
		
		NSString* provinceString = strOrEmpty([m_address mprovince]);
		NSString* cityString = strOrEmpty([m_address mcity]); 
		NSString* isPeCString = [NSString stringWithFormat:@"%@市", provinceString];
		
		if( [isPeCString isEqualToString:cityString]){
			provinceString = @"";
		}
		
		
		NSArray* valueArray;
		if ([provinceString isEqualToString: cityString]) {
			valueArray=@[strOrEmpty([m_address mconsignee]),
						strOrEmpty([m_address mphone]),
						strOrEmpty([NSString stringWithFormat:@"%@%@", provinceString,strOrEmpty([m_address marea]) ]),
						strOrEmpty([m_address maddressdetail])];
		}
		else {
			valueArray=@[strOrEmpty([m_address mconsignee]),
						strOrEmpty([m_address mphone]),
						strOrEmpty([NSString stringWithFormat:@"%@%@%@", provinceString, cityString,strOrEmpty([m_address marea]) ]),
						strOrEmpty([m_address maddressdetail])];
		}
		
		cell.m_TextField_value.text=[valueArray objectAtIndex:indexPath.row];
		
		cell.m_lable_key.text=[keyArray objectAtIndex:indexPath.row];
		
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	if ( m_isAddMode == NO ) {
		return footerView;
	}
	
	return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	[self.view endEditing:YES];
	if(indexPath.row==2){
		[self activePickerView];
	}
	else{
		[self resignPickerView];
		m_tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
		
		//[ m_tableView setContentOffset:CGPointMake(0,0) animated:YES];
		
	}
}

-(IBAction)resignPickerView{
	//[m_tableView setContentOffset:CGPointMake(0, 0)];
	m_tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
	m_cityPickerView.hidden=YES;
}
-(IBAction)activePickerView{
	if ([m_activeTextField respondsToSelector:@selector(resignFirstResponder)])
	{
		[m_activeTextField resignFirstResponder];
	}	
	//所在地区设置，弹出picker;
	//[m_tableView setContentOffset:CGPointMake(0, 80) animated:YES];
	m_tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-216);
	m_cityPickerView.hidden=NO;
}

#pragma mark UITextField method
-(void) onTextChange:(NSNotification*) notification{
	UITextField* textField=(UITextField*) [notification object];
	
	assert(textField!=nil);
	int tag = textField.tag;
	switch (tag) {
		case 0:
			//			@"收货人",
			m_address.mconsignee = textField.text;
			break;
		case 1:
			//			@"手机号码",
			m_address.mphone = textField.text;
			break;
		case 2:
			//			@"所在地区",
			//TODO:
			break;
		case 3:
			//			@"详细地址",
			m_address.maddressdetail = textField.text;
			break;
		default:
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 45;
}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
	m_cityPickerView.hidden=YES;
	
	m_activeTextField = textField;
	
	[self performSelector:@selector(changeTableViewFrame) withObject:nil afterDelay:0.3];
	return YES;
}

-(void)changeTableViewFrame
{
	m_tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-216);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
	
	//[m_activeTextField resignFirstResponder];
	if (textField == m_activeTextField)
	{
		m_activeTextField = nil;
	}
	if ([textField respondsToSelector:@selector(resignFirstResponder)])
	{
		[textField resignFirstResponder];
	}
	
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	//[m_tableView setContentOffset:CGPointMake(0, 0)];
	if ([textField respondsToSelector:@selector(resignFirstResponder)])
	{
		[textField resignFirstResponder];
	}
	
	
	if ( textField.tag == 0 ) {
		MorelacalEditTableCell_Edit* editCell = (MorelacalEditTableCell_Edit *)[m_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		
		[editCell.m_TextField_value becomeFirstResponder];
	}
	if ( textField.tag == 3 ) {
		[self onSaveAddress];
	}
	return YES;
}

-(IBAction)setDefaultAddress:(id)sender
{
	
}

//删除地址
-(IBAction)DeleAddress:(id)sender{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定删除吗？" message:nil
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alert show];    
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==1){
		[self requestDeleteAddress];
	}else {
		
	}

}
-(void) onSaveAddress{
	
	if ([m_activeTextField respondsToSelector:@selector(resignFirstResponder)])
	{
		[m_activeTextField resignFirstResponder];
	}
	
	
	[self resignPickerView];
	
	if (([m_address mconsignee]==nil) || ([[m_address mconsignee] length] == 0) 
		|| ([stripWhiteSpace([m_address mconsignee]) length] == 0)) {
		
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"请您填写收货人姓名." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
		return;
	}
	
	if( ([m_address mphone] == nil) || ([[m_address mphone] length] == 0)
	   || ([stripWhiteSpace([m_address mphone]) length] == 0)){
		
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"请您填写收货人的手机号码." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
		return;
		
	}
	
	if(![YKStringUtility isMobileNum:[m_address mphone]]){
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"您输入的手机号码有误." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
		return;
	}
	
	if(([m_address maddressdetail] == nil) || ([[m_address maddressdetail] length] == 0)
	   || ([stripWhiteSpace([m_address maddressdetail]) length] == 0)){
		UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"" message:@"请您填写收货人详细地址." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertView show];
		return;
	}
	
	//NSString* method =  [YKStringUtility strOrEmpty:@"setAddress"];
	NSString* addressDetail = strOrEmpty([NSString stringWithFormat:@"%@", m_address.maddressdetail]);	
	NSString* addressId = strOrEmpty([NSString stringWithFormat:@"%@",m_address.maddressId]);
	NSString* areaId = strOrEmpty([NSString stringWithFormat:@"%@",m_address.mareaId]);
	NSString* cityId = strOrEmpty([NSString stringWithFormat:@"%@",m_address.mcityId]);
	NSString* provinceId = strOrEmpty([NSString stringWithFormat:@"%@",m_address.mprovinceId]);
	NSString* consignee = strOrEmpty([NSString stringWithFormat:@"%@",m_address.mconsignee]);
	NSString* phone = strOrEmpty([NSString stringWithFormat:@"%@",m_address.mphone]);
	
	if (m_isAddMode) {
		addressId = @"";
	}
	NSDictionary* extraParam = @{@"act": YK_METHOD_SET_ADDRESS,
								@"addressDetail": addressDetail,
								@"addressId": addressId,
								@"areaId": areaId,
								@"cityId": cityId,
								@"provinceId": provinceId,
								@"consignee": consignee,
								@"phone": phone};
	
	NSLog(@"_extraParam__%@,",extraParam);
	
	[self startLoading];
	
	[YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onSaveAddressFinished:)];
}



/*
 保存地址完成
 */
-(void) onSaveAddressFinished:(GDataXMLDocument*)xmlDoc{
	[self stopLoading];
	
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		[self parseSaveAddress:xmlDoc];
	}
	
}

-(void)parseSaveAddress:(GDataXMLDocument*)xmlDoc{
	/*
	 <?xml version=”1.0” encoding=”utf-8”?>
	 <shopex>
	 <result>success</result>
	 <msg/>
	 <info>
	 <data_info>
	 <weblogid>123123</weblogid>
	 <stime>13131113</stime>
	 <addressId>13622</addressId>
	 </data_info>
	 </info>
	 </shopex>
	 */
	
	GDataXMLElement* datainfonode = [SCNStatusUtility paserDataInfoNode:xmlDoc];
	GDataXMLElement* addressIdEle = [datainfonode oneElementForName:@"addressId"];
	
	NSString* _addressId = [addressIdEle stringValue];
	
	if (m_isAddMode) {
		m_address.maddressId = _addressId;
	}
	
	NSString* _promptStr = nil;
	if (m_isAddMode) {
		_promptStr = @"添加地址成功!";
	}else {
		_promptStr = @"修改地址成功!";
	}
	
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:_promptStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	
	if(delegate!=nil)
	{
		[delegate addressEditFinish:m_address];
	}
	
	[self goBack];
}

#pragma mark -
#pragma mark 
- (void)keyboardShow:(KBCustomTextField *)sender{
	if (sender.tag == 2){
        [sender modifyKeyView:@"NumberPad-Empty" display:@"-" represent:@"-" interaction:@"String"];
    }else{
        [sender modifyKeyView:@"NumberPad-Empty" display:@"" represent:@"" interaction:@"String"];
    }
}

// [Yonsm] Handle keyboard hide
- (void)keyboardHide:(KBCustomTextField *)sender{
    [sender delCustomButton:@"NumberPad-Empty"];
}

#pragma mark YKCityPicker method
-(NSArray *) provinceArray
{
	if (!m_provinceArray) 
	{
		self.m_provinceArray = [StatusUtility SystemAddressDataWithParentId:nil];
	}
	return m_provinceArray;
}

-(NSArray *) cityArrayByProvince:(id)province{
	return [StatusUtility SystemAddressDataWithParentId:province];
}

-(NSArray *) areaArrayByCity:(id)city{
	return [StatusUtility SystemAddressDataWithParentId:city];
}

-(id) findByCityName:(NSString*) name array:(NSArray*) array{
	id ret=nil;
	for(int i=0;i<[array count];++i){
		YK_SystemAddressData* city=(YK_SystemAddressData*)[array objectAtIndex:i];
		if([city.mname isEqualToString:name ]){
			ret=city;
			break;
		}
	}
	
	return ret;
}

-(id) defaultProvince{
	id ret=nil;
	if([m_address mprovince]!=nil){
		NSArray* array=[self provinceArray];
		ret=[self findByCityName:[m_address mprovince] array:array];
	}
	return ret;
}
-(id) defaultCity{
	id ret=nil;
	id defaultProvince_=[self defaultProvince];
	if([m_address mcity]!=nil && defaultProvince_!=nil){
		NSArray* array=[self cityArrayByProvince:defaultProvince_];
		ret=[self findByCityName:[m_address mcity] array:array];
	}
	return ret;
}
-(id) defaultArea{
	id ret=nil;
	id mdefaultCity=[self defaultCity];
	if([m_address marea]!=nil && mdefaultCity!=nil){
		NSArray* array=[self areaArrayByCity:mdefaultCity];
		ret=[self findByCityName:[m_address marea] array:array ];
	}
	return ret;
}

#pragma mark YKPickerView Delegate

-(void) cityPicker:(YKCityPickerView *)pv changeProvince:(id)p city:(id)c area:(id)a{
	if (firstEnter){
		isModified = NO;
		return;
	}
	isModified = YES;
	@autoreleasepool {
	
	/**
	 设置当前选中的省市区
	 */
		self.m_currentProvinceObj=p;
		self.m_currentCityObj=c;
		self.m_currentAreaObj=a;
		
		/**
		 省市区名称
		 */
		NSString* provinceString = [p description];
		NSString* cityString = [c description];
		NSString* areaString = [a description];
		
		
		/**
		 省市区Id
		 */
		NSString* provinceId	=	[ p mid];
		NSString* cityId		=	[ c mid];
		NSString* areaId		=	[ a mid];
		
		
		/**
		 给当前地址复制
		 */
		m_address.mprovince = provinceString;
		m_address.mcity = cityString;
		m_address.marea = areaString;
		m_address.mprovinceId = provinceId;
		m_address.mcityId = cityId;
		m_address.mareaId = areaId;
		    
		//id mdefaultCity=[self defaultCity];
		//NSArray* array=[self areaArrayByCity:mdefaultCity];
		//YK_SystemAddressData *l_SAData = [self findByCityName:[m_address marea] array:array];
		[m_tableView reloadData];
	}
}

-(void)updateSystemAddressData:(YK_SystemAddressData*)_systemAddr{
	
}

-(void)buttonAction_setDefault:(UIButton*)sender{
	[self requestSetDefaultAddress];
}

-(void)buttonAction_delete:(UIButton*)sender{
	NSString* temp = @"确认要删除吗?";
	//成功
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:temp delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
	[alertView show];
}

-(void)requestSetDefaultAddress{
	[self startLoading];
	//NSString* method = [YKStringUtility strOrEmpty:@"setDefaultAddress"];

	NSString* _addressId = self.m_address.maddressId;
	NSLog(@"%@",_addressId);
	
	NSDictionary* extraParam = @{@"act": YK_METHOD_SET_DEFAULTADDRESS,
								@"addressId": _addressId};
	NSLog(@"%@",extraParam);
    
	[YKHttpAPIHelper startLoad:SCN_URL 
				   extraParams:extraParam
						object:self 
					  onAction:@selector(onRequestSetDefaultAddressResponse:)];
	//[self onRequestSetDefaultAddressResponse:nil];
}

-(void)onRequestSetDefaultAddressResponse:(GDataXMLDocument*)xmlDoc{
	[self stopLoading];
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		[self parseSetDefaultAddress:xmlDoc];
	}
}

-(void)parseSetDefaultAddress:(GDataXMLDocument*)xmlDoc{

	GDataXMLElement* datainfoNode = [SCNStatusUtility paserDataInfoNode:xmlDoc];;
	
	GDataXMLNode* addressNode = [datainfoNode oneNodeForXPath:@"addressId" error:nil];
	NSString* _defaultAddressId	= [addressNode stringValue];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:YK_DEFAULTADDRESS_CHANGE object:_defaultAddressId];
	
	NSString* temp = @"默认地址设置成功!";
	//成功
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:temp delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	
	[self goBack];
}


-(void)requestDeleteAddress{
	[self startLoading];
	//NSString* method = [YKStringUtility strOrEmpty:@"delAddress"];
	
	NSString* _addressId = self.m_address.maddressId;
	NSLog(@"%@",_addressId);
	
	NSDictionary* extraParam = @{@"act": YK_METHOD_DEL_ADDRESS,
								@"addressId": _addressId};
	NSLog(@"%@",extraParam);
    
	[YKHttpAPIHelper startLoad:SCN_URL 
				   extraParams:extraParam
						object:self 
					  onAction:@selector(onRequestDeleteAddressResponse:)];
}

-(void)onRequestDeleteAddressResponse:(GDataXMLDocument*)xmlDoc{
	[self stopLoading];
	if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
		[self parseDeleteAddress:xmlDoc];
	}
	
}

-(void)parseDeleteAddress:(GDataXMLDocument*)xmlDoc{
	[SCNStatusUtility paserDataInfoNode:xmlDoc];
	[[NSNotificationCenter defaultCenter] postNotificationName:YK_ADDRESS_DELETE object:self];
	
	NSString* temp = @"删除地址成功!";
	//成功
	UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:temp delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	
	[self goBack];
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}

@end
