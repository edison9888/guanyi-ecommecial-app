//
//  SCNAddressEditViewController.h
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YK_B2C_AddressData.h"
#import "YK_ProvinceData.h"
#import "addressData.h"
#import "YKHttpAPIHelper.h"

@protocol YK_SCN_AddressEditDelegate<NSObject>
-(void) addressEditFinish:(addressData*)addressData;
@end

@interface SCNAddressEditFunView : UIView
{
	UIButton* m_btnDefault;
	UIButton* m_btnDelete;
}

@property(nonatomic,strong)IBOutlet UIButton* m_btnDefault;
@property(nonatomic,strong)IBOutlet UIButton* m_btnDelete;

-(id)initWithFrame:(CGRect)frame;
@end


@interface SCNAddressEditViewController : BaseViewController<UITextFieldDelegate , UIAlertViewDelegate, YKCityPickerDelegate, YKCityPickerDataSource> {	
	SCNAddressEditFunView* footerView;
	UIButton* m_button_delete;
	
	UIView* setDefaultView;
	UIButton* m_button_default;

	YKCityPickerView* m_cityPickerView;
	addressData*  m_address;
	id<YK_SCN_AddressEditDelegate>	__unsafe_unretained delegate;
	
	BOOL m_isAddMode;
	YK_SystemAddressData* m_currentProvinceObj;		//当前选择的省份
	YK_SystemAddressData* m_currentCityObj;			//当前选择的市
	YK_SystemAddressData* m_currentAreaObj;			//当前选择的县
    
	UITextField* m_activeTextField;
	BOOL m_isRequestSended;
	BOOL firstEnter;
	UITableView *m_tableView;
    BOOL isRequesting;
	
	NSArray* m_provinceArray;
	BOOL isModified;
}

@property (nonatomic,strong) IBOutlet UITableView *m_tableView;
@property (nonatomic, strong) IBOutlet SCNAddressEditFunView *footerView;
@property (nonatomic,strong) IBOutlet UIView* setDefaultView;
@property (nonatomic,strong) IBOutlet UIButton* m_button_default;
@property (nonatomic,strong) IBOutlet UIButton* m_button_delete;
@property (nonatomic,strong) IBOutlet YKCityPickerView* m_cityPickerView;
@property (nonatomic,copy) addressData*  m_address;
@property (nonatomic,assign) BOOL m_isAddMode;
@property (nonatomic,unsafe_unretained) id<YK_SCN_AddressEditDelegate> delegate;
@property (nonatomic,strong) YK_SystemAddressData* m_currentProvinceObj;
@property (nonatomic,strong) YK_SystemAddressData* m_currentCityObj;
@property (nonatomic,strong) YK_SystemAddressData* m_currentAreaObj;

@property (nonatomic,strong) NSArray* m_provinceArray;
@property (nonatomic,assign) BOOL isModified;


-(IBAction)DeleAddress:(id)sender;
-(IBAction)setDefaultAddress:(id)sender;
/**
 pickerView显示控制函数
 */
-(IBAction)resignPickerView;
-(IBAction)activePickerView;

-(id)initWithNibName:(NSString *)nibNameOrNil withAddress:(addressData*)addr bundle:(NSBundle *)nibBundleOrNil;

-(void)setViewTitle;
-(void)onSaveAddress;

-(void)onSaveAddressFinished:(GDataXMLDocument*)xmlDoc;
-(void)parseSaveAddress:(GDataXMLDocument*)xmlDoc;

-(void)buttonAction_setDefault:(UIButton*)sender;
-(void)buttonAction_delete:(UIButton*)sender;

-(void)requestSetDefaultAddress;
-(void)onRequestSetDefaultAddressResponse:(GDataXMLDocument*)xmlDoc;
-(void)parseSetDefaultAddress:(GDataXMLDocument*)xmlDoc;

-(void)requestDeleteAddress;
-(void)onRequestDeleteAddressResponse:(GDataXMLDocument*)xmlDoc;
-(void)parseDeleteAddress:(GDataXMLDocument*)xmlDoc;

@end
