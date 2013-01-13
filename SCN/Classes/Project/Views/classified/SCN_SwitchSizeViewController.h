//
//  SCN_SwitchSizeViewController.h
//  SCN
//
//  Created by yuanli on 11-10-13.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNCommonPickerView.h"
#import "SCNSwitchSizeData.h"

@protocol SwitchSizeDelegate<NSObject>
-(void)updateCurrentSize:(NSString *)size;
@end

@interface SCN_SwitchSizeViewController : BaseViewController 
<SCNCommonPickerViewDelegate,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>{
    UIScrollView          *m_scrllView;
    id<SwitchSizeDelegate> __unsafe_unretained m_delegate;
    
    NSString             *m_brand;
    NSString             *m_size;
    NSString             *m_sex;
    NSString             *m_scode;
    
    NSMutableArray       *m_skuArr;//详情页面传过来得所有sku
    NSMutableArray       *m_brandArr;
    NSMutableArray       *m_sexArr;
    NSMutableArray       *m_sizeArr;
    
    UILabel              *m_titleLable;          //所选尺码大小

    UIButton             *m_cancleButton;  //导航条取消按钮
    
    UIView               *m_switchView;     //中间灰色区域
    UIImageView          *m_bottomSeparate;
    UIView               *m_brandView;
    UIView               *m_sexView;
    UIView               *m_sizeView;
    
    UILabel              *m_brandLable;
    UILabel              *m_sexLable;
    UILabel              *m_sizeLable;
    
    UIButton             *m_brandButton;        //点击弹出brandPicker
    UIButton             *m_sexButton;          //点击弹出sexPicker
    UIButton             *m_sizeButton;         //点击弹出sizePicker
    UIButton             *m_switchSizeButton;   //转换尺码
}
@property (nonatomic, strong) IBOutlet  UIScrollView          *m_scrllView;
@property (nonatomic, unsafe_unretained) id<SwitchSizeDelegate> m_delegate;

@property (nonatomic, strong) NSMutableArray       *m_skuArr;
@property (nonatomic, strong) NSMutableArray       *m_brandArr;
@property (nonatomic, strong) NSMutableArray       *m_sexArr;
@property (nonatomic, strong) NSMutableArray       *m_sizeArr;

@property (nonatomic, strong) NSString             *m_brand;
@property (nonatomic, strong) NSString             *m_size;
@property (nonatomic, strong) NSString             *m_sex;
@property (nonatomic, strong) NSString             *m_scode;

@property (nonatomic, strong) IBOutlet  UILabel              *m_titleLable;

@property (nonatomic, strong) IBOutlet UIView               *m_switchView;
@property (nonatomic, strong) IBOutlet UIImageView          *m_bottomSeparate;
@property (nonatomic, strong) IBOutlet UIView               *m_brandView;
@property (nonatomic, strong) IBOutlet UIView               *m_sexView;
@property (nonatomic, strong) IBOutlet UIView               *m_sizeView;

@property (nonatomic, strong) IBOutlet  UILabel              *m_brandLable;
@property (nonatomic, strong) IBOutlet  UILabel              *m_sexLable;
@property (nonatomic, strong) IBOutlet  UILabel              *m_sizeLable;

@property (nonatomic, strong) IBOutlet UIButton             *m_brandButton;
@property (nonatomic, strong) IBOutlet UIButton             *m_sexButton;
@property (nonatomic, strong) IBOutlet UIButton             *m_sizeButton;
@property (nonatomic, strong) IBOutlet UIButton             *m_switchSizeButton;

@property (nonatomic, strong) IBOutlet UIButton             *m_cancleButton;
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
              withSex:(NSString *)sex 
            withBrand:(NSString *)brand
           withSkuArr:(NSMutableArray *)skuArr;

-(IBAction)onAction_cancle:(id)sender;

-(IBAction)onAction_ButtonPressed:(id)sender;

-(void)setDefaultSex;
-(void)setDefaultSize;

-(void)request_getsizeCoverListXmlData;
-(void)sizeSwitch:(NSString *)scode;
-(BOOL)isNeutral:(NSString *)sex;
-(void)getSizeArr:(NSMutableArray *)sexArr;
-(void)setDefaultBrandAndSex;
@end
