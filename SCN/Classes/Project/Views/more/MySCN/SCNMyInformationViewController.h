//
//  SCNMyInformationViewController.h
//  SCN
//
//  Created by chenjie on 11-10-13.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISwitchCustom.h"
#import "BaseViewController.h"
#import "YKUserInfoUtility.h"
#import "YK_B2C_AddressData.h"

@class YK_SystemAddressData;

@interface SCNMyInformationViewController : BaseViewController <UIAlertViewDelegate,UISwitchCustomDelegate,UITextFieldDelegate,YKCityPickerDataSource,YKCityPickerDelegate>{
    
    
    UITextField          *m_textfield_name;           // 用户名
    UITextField          *m_textfield_address;        // 用户地址
    UITextField          *m_textfield_phone;          // 用户电话
     
    UIButton             *m_button_selectcity;        // 选择省市区按钮
    UIButton             *m_button_ensure;            // 确定修改按钮
	
    NSArray              *m_array_areaList_;          // 当前省市下的所有区
    NSArray              *m_array_cityList_;          // 当前省下的所有市
    NSArray              *m_array_provinceList_;      // 所有省
    
    YK_SystemAddressData *m_selectedProvinceName;     // 选择的省名称
    YK_SystemAddressData *m_selectedCityName;         // 选择的市名称
    YK_SystemAddressData *m_selectedAreaName;         // 选择的区名称
    YKCityPickerView     *m_pickerview_picker;        // picker选择器(省,市,区)
    
    NSString             *m_str_sex;                  // 用户性别
    UISwitchCustom       *m_sex;
    
    UIView               *m_contentBgview;            // 内容区背景视图
    UIScrollView         *m_scrollview;               
    
    BOOL                  m_isRequestsuccess;
    BOOL                  m_isRequesting;
    BOOL                  m_isSelectbutton_press;
    
    IBOutlet UIView      *m_view_isSelect;            // 盖在选择省市区按钮上的view
    
    SCNUserInformationData  *m_userinformationdata;   //装载用户临时数据信息
    
}
@property (nonatomic, strong) IBOutlet UIView* m_contentBgview;
@property (nonatomic, strong) IBOutlet UIScrollView* m_scrollview;
@property (nonatomic, strong) IBOutlet UISwitchCustom* m_sex;
@property (nonatomic, strong) IBOutlet UITextField* m_textfield_name;
@property (nonatomic, strong) IBOutlet UITextField* m_textfield_address;
@property (nonatomic, strong) IBOutlet UITextField* m_textfield_phone;
@property (nonatomic, strong) IBOutlet UIButton* m_button_selectcity;
@property (nonatomic, strong) IBOutlet YKCityPickerView* m_pickerview_picker;

@property (nonatomic, strong) UIButton* m_button_ensure;
@property (nonatomic, strong) NSArray* m_array_areaList;
@property (nonatomic, strong) NSArray* m_array_cityList;
@property (nonatomic, strong) NSArray* m_array_provinceList;
@property (nonatomic, strong) YK_SystemAddressData* m_selectedProvinceName;
@property (nonatomic, strong) YK_SystemAddressData* m_selectedCityName;
@property (nonatomic, strong) YK_SystemAddressData* m_selectedAreaName;
@property (nonatomic, strong) NSString* m_str_sex;
@property (nonatomic, strong) SCNUserInformationData* m_userinformationdata;
//清理键盘
-(IBAction)clearKeyBorad;
//选择城市地址按钮
-(IBAction)onActionselectcityButtonPress:(id)sender;
//获取个人资料请求
-(void)requestPresoninformationXmlData;

-(void)onRequestPresoninformationlDataResponse:(GDataXMLDocument*)xmlDoc;
//修改个人资料请求
-(void)requestChangePresoninformationXmlData;

-(void)onRequestChangePresoninformationlDataResponse:(GDataXMLDocument*)xmlDoc;
//修改个人资料
- (void)evaluateInformation;
//picker显示
-(void)PickerviewShow;
//picker隐藏
-(void)PickerViewDown;

-(void)moveScorllViwToTop;
//检测输入框
-(BOOL)checkUserInput;
-(NSString*)getCurrentSexText;



#pragma mark behavior
-(void)personalInfoModifyBehavior;

@end
