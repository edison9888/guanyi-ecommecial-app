//
//  SCNMyInformationViewController.m
//  SCN
//
//  Created by chenjie on 11-10-13.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNMyInformationViewController.h"
#import "YK_ProvinceData.h"
#import "StatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "YKStringUtility.h"
#import "SCNUserInformationData.h"
#import "SCNStatusUtility.h"
#import "YKButtonUtility.h"
#import "YK_ProvinceData.h"
#import "YKStringHelper.h"
#import "YKStatBehaviorInterface.h"

@implementation SCNMyInformationViewController

@synthesize m_contentBgview;
@synthesize m_scrollview;
@synthesize m_sex;
@synthesize m_textfield_name;
@synthesize m_textfield_address;
@synthesize m_textfield_phone;
@synthesize m_button_selectcity,m_button_ensure;
@synthesize m_array_provinceList; // 省
@synthesize m_array_cityList; // 市
@synthesize m_array_areaList; // 区
@synthesize m_selectedProvinceName; // 选择的省名称
@synthesize m_selectedCityName;     // 选择的市名称
@synthesize m_selectedAreaName;     // 选择的区名称
@synthesize m_str_sex;              //用户性别
@synthesize m_pickerview_picker;
@synthesize m_userinformationdata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(BOOL)isNeedLogin
{
	return YES;
}

- (void)viewDidUnload
{
    m_view_isSelect = nil;
    [super viewDidUnload];
    self.m_str_sex = nil;
    self.m_sex = nil;
    self.m_textfield_name = nil;
    self.m_textfield_address = nil;
    self.m_textfield_phone = nil;
    self.m_button_selectcity = nil;
    self.m_array_provinceList = nil;
    self.m_array_cityList = nil;
    self.m_array_areaList = nil;
    self.m_pickerview_picker = nil;
    self.m_scrollview = nil;
    self.m_contentBgview = nil;
    self.m_selectedProvinceName = nil;
    self.m_selectedCityName = nil;
    self.m_selectedAreaName = nil;
    self.m_userinformationdata = nil;
	self.m_button_ensure = nil;
    
    m_isRequestsuccess = NO;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{   
    NSLog(@"个人设置资料界面dealloc被调用");
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [m_view_isSelect setHidden:YES];
    if (!m_isRequestsuccess) {
        [self.m_scrollview setHidden:YES];
        [self requestPresoninformationXmlData];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = @"个人资料";
    self.pathPath = @"/personalsetting";
    [m_pickerview_picker setDelegate:self];
	[m_pickerview_picker setDataSource:self];
    
    [m_pickerview_picker setHidden:YES];
    
    m_scrollview.contentSize = CGSizeMake(320, 440);
    m_scrollview.showsVerticalScrollIndicator = NO;
	
    
    //设置View的背景颜色
    [self.m_contentBgview setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    //设置圆角半径
    [self.m_contentBgview.layer setCornerRadius:5];
    //设self.m_contentBgview边框宽度
    [self.m_contentBgview.layer setBorderWidth:1];
    //设置边框颜色
    [self.m_contentBgview.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
	
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.m_pickerview_picker];
    
	self.m_button_ensure= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 40, 42)
                                                    title:@"确定"
                                              normalImage:@"com_btn.png"
                                              highlighted:@"com_btn_SEL.png"];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:m_button_ensure.frame];
	[ricusview addSubview:m_button_ensure];
	
    UIBarButtonItem * _barbuttonItem_ensure = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	
    
    UIImage * _buttonlogin_normal = [UIImage imageNamed:@"accountSize_button_SEL.png"];
    [m_button_selectcity setBackgroundImage:[_buttonlogin_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _buttonlogin_select = [UIImage imageNamed:@"accountSize_button.png"] ;
    [m_button_selectcity setBackgroundImage:[_buttonlogin_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
    
    
    [m_button_ensure addTarget:self action:@selector(tosave) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_ensure;
	
    m_sex.delegate = self;
    [m_sex setSlideWidth:65];
    [m_sex setOnImage:[UIImage imageNamed:@"more_male.png"]];
	[m_sex setOffImage:[UIImage imageNamed:@"more_female.png"]];
	m_sex.layer.cornerRadius = 2.0;
	m_sex.layer.masksToBounds = YES;
    
}

-(NSString*)getCurrentSexText
{
	if(m_sex.on)
	{
		return @"1";
	}
	else
	{
		return @"0";
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 
#pragma mark  保存用户资料
-(void)tosave
{
    if ([self checkUserInput]) {
        [self requestChangePresoninformationXmlData];
    }
	

}
-(BOOL)checkUserInput{

    NSString * errorMsg = nil;  
    if ([m_textfield_name.text length] < 1) {
        errorMsg = @"请输入您的姓名.";
    }
    
    if ([m_textfield_address.text length] < 1) {
        errorMsg = @"您的收货地址不能为空.";
    }
    else if([m_textfield_phone.text length] < 1 ||![YKStringUtility isMobileNum:m_textfield_phone.text]) {
        errorMsg = @"您的手机号有误，请输入合法的手机号码.";
    
    
    }
    if (errorMsg != nil) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:errorMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }

    return YES;
}
#pragma mark 
#pragma mark 请求服务器获取个人资料

-(void)requestPresoninformationXmlData
{  
	if (m_isRequesting) {
        return;
    }
	[self startLoading];
    m_isRequesting = YES;
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_USERINFO];
    
    NSDictionary* extraParam = @{@"act": v_method};	
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestPresoninformationlDataResponse:)];
	[self personalInfoModifyBehavior];
}
-(void)onRequestPresoninformationlDataResponse:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    m_isRequesting = NO;
    
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        m_isRequestsuccess = YES;
        m_userinformationdata = [[SCNUserInformationData alloc]init];
        
        GDataXMLElement * data_info = [SCNStatusUtility paserDataInfoNode:xmlDoc];
        GDataXMLElement * userinfo = [data_info oneElementForName:@"user"];
        
        GDataXMLElement* nameItem = [userinfo oneElementForName:@"consignee"];
        NSString* tempname = [nameItem stringValue];
        m_userinformationdata.mconsignee = tempname;
        
        GDataXMLElement* sexItem = [userinfo oneElementForName:@"sex"];
        NSString* tempsex = [sexItem stringValue];
        m_userinformationdata.msex = tempsex;
        
        GDataXMLElement* addressdetailItem = [userinfo oneElementForName:@"addressdetail"];
        NSString* addressdetailname = [addressdetailItem stringValue];
        m_userinformationdata.maddressdetail = addressdetailname;
        
        
        GDataXMLElement* provinceItem = [userinfo oneElementForName:@"province"];
        NSString* tempprevince = [provinceItem stringValue];
        m_userinformationdata.mprovinceId = [[provinceItem attributeForName:@"provinceId"] stringValue];
        m_userinformationdata.mprovince = tempprevince;
        
        GDataXMLElement* cityItem = [userinfo oneElementForName:@"city"];
        NSString* tempcity = [cityItem stringValue];
        m_userinformationdata.mcityId = [[cityItem attributeForName:@"cityId"] stringValue];
        m_userinformationdata.mcity = tempcity;
        
        GDataXMLElement* areaItem = [userinfo oneElementForName:@"area"];
        NSString* temparea = [areaItem stringValue];
        m_userinformationdata.mareaId = [[areaItem attributeForName:@"areaId"] stringValue];
        m_userinformationdata.marea = temparea;
        
        GDataXMLElement* phoneItem = [userinfo oneElementForName:@"phone"];
        NSString* tempphone = [phoneItem stringValue];
        m_userinformationdata.mphone = tempphone;
        [self evaluateInformation];
        [m_pickerview_picker setDataSource:self];
        NSLog(@">>>>>>>>>>>>>>>>>%@",tempphone);
    }
        
}
- (void)evaluateInformation
{
    m_textfield_name.text = m_userinformationdata.mconsignee;
    m_textfield_address.text = m_userinformationdata.maddressdetail;
    m_textfield_phone.text = m_userinformationdata.mphone;
        
	NSString* _pickerAddress = [NSString stringWithFormat:@"%@ %@ %@",m_userinformationdata.mprovince,m_userinformationdata.mcity,m_userinformationdata.marea];
	[m_button_selectcity setTitle:_pickerAddress forState:UIControlStateNormal];
    
    if ([m_userinformationdata.msex isEqualToString:@"女"]) {
        [m_sex setOn:NO animated:YES];
        
        self.m_str_sex = @"女";
    }else {
        [m_sex setOn:YES animated:YES];
    
        self.m_str_sex = @"男";
    }
    NSLog(@".................%@",m_str_sex);
    [self.m_scrollview setHidden:NO];
}
#pragma mark 
#pragma mark 请求服务器修改个人资料
-(void)requestChangePresoninformationXmlData
{
    if (m_isRequesting) {
        return;
    }
	[self startLoading];
    m_isRequesting = YES;
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_MODIFYUSERINFO];
    NSString* v_consignee = [YKStringUtility strOrEmpty:m_textfield_name.text];
    NSString* v_address = [YKStringUtility strOrEmpty:m_textfield_address.text];
    NSString* v_phone = [YKStringUtility strOrEmpty:m_textfield_phone.text];
	NSString* v_areaId = [YKStringUtility strOrEmpty:self.m_selectedAreaName.mid ];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>%@",v_areaId);
	NSString* v_cityId = [YKStringUtility strOrEmpty:self.m_selectedCityName.mid ];
	NSString* v_provinceId = [YKStringUtility strOrEmpty:self.m_selectedProvinceName.mid];
    NSString* v_sex = [YKStringUtility strOrEmpty:[self getCurrentSexText]];
	
    NSDictionary* extraParam = @{@"act": v_method,
                                @"consignee": v_consignee,
                                @"address": v_address,
                                @"phone": v_phone,
								@"provinceId": v_provinceId,
								@"cityId": v_cityId,
								@"areaId": v_areaId,
								@"sex": v_sex};
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestChangePresoninformationlDataResponse:)];
}
	   
-(void)onRequestChangePresoninformationlDataResponse:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    m_isRequesting = NO;
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        m_isRequestsuccess = YES;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE message:@"修改个人资料成功." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"修改个人资料成功."]) {
        [self goBack];
    }

}
#pragma mark
#pragma mark 清理键盘
-(IBAction)clearKeyBorad{
    NSLog(@"===========");
	[m_textfield_name    resignFirstResponder];
	[m_textfield_phone   resignFirstResponder];
    [m_textfield_address resignFirstResponder];
    [m_scrollview setContentOffset:CGPointMake(0, 0)];
    [self PickerViewDown];
    [self moveScorllViwToTop];
    	
}
-(void)moveScorllViwToTop 
{
    
    // 移动视图
    [UIView beginAnimations:@"cell shift" context:nil];
    [UIView setAnimationDuration:0.3f];
    m_scrollview.frame = CGRectMake(0.0f, 0.0f, 320.0f, 380.0f);
    [m_scrollview setContentOffset:CGPointMake(0, 0)];
    [UIView commitAnimations];  
}
#pragma mark
#pragma mark 选择城市地址
-(IBAction)onActionselectcityButtonPress:(id)sender
{
    [self clearKeyBorad];
    [self PickerviewShow];
    
}

#pragma mark
#pragma mark UIPickerView显示
-(void)PickerviewShow
{
    [m_view_isSelect setHidden:NO];
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.3];
    [m_pickerview_picker setFrame:CGRectMake(0, 480-216, 320, 206)];
    [m_pickerview_picker setHidden:NO];
    [UIView commitAnimations];
    
}
-(void)PickerViewDown
{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.3];
    [m_pickerview_picker setFrame:CGRectMake(0, 480, 320, 216)];
    [UIView commitAnimations];
    [m_view_isSelect setHidden:YES];
}
#pragma mark
#pragma mark UITextField开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    m_scrollview.frame = CGRectMake(0.0f, 0.0f, 320.0f, 300.0f);
    if ([textField isEqual:m_textfield_address]) {
        CGPoint po = CGPointMake(0.0f, 90.0f);
        [m_scrollview setContentOffset:po animated:YES];
        m_scrollview.contentSize = CGSizeMake(320.0f, 380.0f);
       
    }
    else if ([textField isEqual:m_textfield_phone]) {
        CGPoint po = CGPointMake(0.0f, 120.0f);
        [m_scrollview setContentOffset:po animated:YES];
        m_scrollview.contentSize = CGSizeMake(320.0f, 300.0f);
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self PickerViewDown];


}

#pragma mark
#pragma mark UITextField结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_scrollview.contentSize = CGSizeMake(320, 480);
   
    
}
#pragma mark YKCityPicker method
-(NSArray *) provinceArray
{
	if (!m_array_provinceList) 
	{
		self.m_array_provinceList = [StatusUtility SystemAddressDataWithParentId:nil];
	}
	return m_array_provinceList;
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
	if([m_userinformationdata mprovince]!=nil){
		NSArray* array=[self provinceArray];
		ret=[self findByCityName:[m_userinformationdata mprovince] array:array];
	}
	return ret;
}
-(id) defaultCity{
	id ret=nil;
	id defaultProvince_=[self defaultProvince];
	if([m_userinformationdata mcity]!=nil && defaultProvince_!=nil){
		NSArray* array=[self cityArrayByProvince:defaultProvince_];
		ret=[self findByCityName:[m_userinformationdata mcity] array:array];
	}
	return ret;
}
-(id) defaultArea{
	id ret=nil;
	id mdefaultCity=[self defaultCity];
	if([m_userinformationdata marea]!=nil && mdefaultCity!=nil){
		NSArray* array=[self areaArrayByCity:mdefaultCity];
		ret=[self findByCityName:[m_userinformationdata marea] array:array ];
	}
	return ret;
}

#pragma mark YKPickerView Delegate

-(void) cityPicker:(YKCityPickerView *)pv changeProvince:(id)p city:(id)c area:(id)a{
	
	@autoreleasepool {
	
	/**
	 设置当前选中的省市区
	 */
		self.m_selectedProvinceName=p;
		self.m_selectedCityName=c;
		self.m_selectedAreaName=a;
		
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
		m_userinformationdata.mprovince = provinceString;
		m_userinformationdata.mcity = cityString;
		m_userinformationdata.marea = areaString;
		m_userinformationdata.mprovinceId = provinceId;
		m_userinformationdata.mcityId = cityId;
		m_userinformationdata.mareaId = areaId;
    
    
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",m_userinformationdata.mprovinceId);
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",m_userinformationdata.mcityId);
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",m_userinformationdata.mareaId);
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",provinceString);
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",cityString);
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",areaString);
    
    
    NSString* provinceStr = strOrEmpty([m_userinformationdata mprovince]);
    NSString* cityStr = strOrEmpty([m_userinformationdata mcity]); 
    NSString* isPeCStr = [NSString stringWithFormat:@"%@市", provinceString];
    
    if( [isPeCStr isEqualToString:cityStr]){
        provinceStr = @"";
    }
    
    NSArray* valueArray;
    if ([provinceStr isEqualToString: cityStr]) {
        valueArray=@[strOrEmpty([NSString stringWithFormat:@"%@%@", provinceStr,strOrEmpty([m_userinformationdata marea]) ]),
                    strOrEmpty([m_userinformationdata maddressdetail])];
    }
    else {
        valueArray=@[strOrEmpty([NSString stringWithFormat:@"%@%@%@", provinceStr, cityStr,strOrEmpty([m_userinformationdata marea]) ]),
                    strOrEmpty([m_userinformationdata maddressdetail])];
    }

    
    [m_button_selectcity setTitle:[valueArray objectAtIndex:0] forState:UIControlStateNormal];
    
	//[self.m_scrollview setNeedsLayout];
	}
}


#pragma mark Behavior
-(void)personalInfoModifyBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _userId = [[[YKUserInfoUtility shareData] m_userDataInfo]mweblogid];
	NSString* _userName = [[[YKUserInfoUtility shareData] m_userDataInfo]musername];
	NSString* _param = [NSString stringWithFormat:@"%@|%@",_userName,_userId];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_SUBMITPERSONALINFO param:_param];
#endif
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
}

@end
