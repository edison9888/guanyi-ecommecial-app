//
//  SCN_SwitchSizeViewController.m
//  SCN
//
//  Created by yuanli on 11-10-13.
//  Copyright 2011年 Yek.me. All rights reserved.
//

#import "SCN_SwitchSizeViewController.h"
#import "SCN_productDetailViewController.h"
#import "SCNCommonPickerView.h"
#import "SCNAppDelegate.h"
#import "LeveyTabBarController.h"

@implementation SCN_SwitchSizeViewController
#define Tag_brandPicker 100
#define Tag_sexPicker   200
#define Tag_sizePicker 300

#define Tag_brandView 10
#define Tag_sexView 20
#define Tag_sizeView 30

#define Tag_brandButton 11
#define Tag_sexButton 21
#define Tag_sizeButton 31

#define Tag_switchSizeButton 40
#define Tag_imageView 9


@synthesize m_brand,m_size,m_sex,m_scode;
@synthesize m_cancleButton;
@synthesize m_titleLable;
@synthesize m_brandButton,m_sexButton,m_sizeButton,m_switchSizeButton;
@synthesize m_delegate;
@synthesize m_skuArr,m_brandArr,m_sizeArr,m_sexArr;
@synthesize m_scrllView;

@synthesize m_brandView,m_sexView,m_sizeView,m_switchView;
@synthesize m_bottomSeparate;
@synthesize m_brandLable,m_sexLable,m_sizeLable;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
              withSex:(NSString *)sex 
            withBrand:(NSString *)brand
           withSkuArr:(NSMutableArray *)skuArr;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization;
        self.m_brand = brand;
        self.m_sex = sex;
        self.m_skuArr = skuArr;
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
//  self.m_brand = nil;
//	self.m_sex = nil;
//	self.m_skuArr = nil;
	
    self.m_size = nil;
    self.m_scode = nil;
    self.m_brandArr= nil;
    self.m_sizeArr = nil;
    self.m_sexArr = nil;
    
    self.m_cancleButton = nil;
    self.m_titleLable = nil;

    self.m_switchView = nil;
    self.m_bottomSeparate = nil;
    self.m_brandView = nil;
    self.m_sexView = nil;
    self.m_sizeView = nil;
    //m_brandLable,m_sexLable,m_sizeLable;
    self.m_brandLable = nil;
    self.m_sexLable = nil;
    self.m_sizeLable = nil;
    
    self.m_brandButton = nil;
    self.m_sizeButton  = nil;
    self.m_switchSizeButton = nil;
    self.m_sexButton = nil;
    self.m_scrllView = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.pathPath = @"/other";
    // Do any additional setup after loading the view from its nib.

    self.m_titleLable.text = self.m_brand ? self.m_brand :@"欢迎来到名鞋库";
    UIImage *normalImage = [DataWorld getImageWithFile:@"accountSize_button.png"];
    UIImage *SelImage = [DataWorld getImageWithFile:@"accountSize_button_SEL.png"];
    
    UIImageView *brandImageV =(UIImageView *)[self.m_brandView viewWithTag:Tag_imageView];
    [brandImageV setImage:[normalImage stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    [brandImageV setHighlightedImage:[SelImage stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    
    UIImageView *sexImageV =(UIImageView *)[self.m_sexView viewWithTag:Tag_imageView];
    [sexImageV setImage:[normalImage stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    [sexImageV setHighlightedImage:[SelImage stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    
    UIImageView *sizeImageV =(UIImageView *)[self.m_sizeView viewWithTag:Tag_imageView];
    [sizeImageV setImage:[normalImage stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    [sizeImageV setHighlightedImage:[SelImage stretchableImageWithLeftCapWidth:12 topCapHeight:12]];
    
    
    [self.m_switchSizeButton setBackgroundImage:[[DataWorld getImageWithFile:@"com_button_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateNormal];
    [self.m_switchSizeButton setBackgroundImage:[[DataWorld getImageWithFile:@"com_button_select.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:12] forState:UIControlStateHighlighted];
    
	if ([self isNeutral:self.m_sex] == NO) {
		self.m_sexView.hidden  = YES;
		self.m_sizeView.frame = self.m_sexView.frame;
        self.m_switchView.frame = CGRectMake(0, 42, 320, 140);
        self.m_bottomSeparate.frame = CGRectMake(0, 139, 320, 1);
	}
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (KDataWorld.m_switchSizeData== nil) {
        [self request_getsizeCoverListXmlData];
    }else{
    self.m_brandArr = KDataWorld.m_switchSizeData.m_brandArr;
    [self setDefaultBrandAndSex];
    }
    
}

-(void)reFreshVc
{
	[self dismissModalViewControllerAnimated:YES];
	SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
	LeveyTabBarController* viewCtrl = (LeveyTabBarController*)delegate.viewController;
	[viewCtrl refreshCurrentViewController];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(BOOL)isNeutral:(NSString *)sex
{
    if ([sex isEqualToString:@"中性鞋"]) {
        return YES;
    }
        return NO;
}
#pragma mark-
#pragma mark 请求数据
-(void)request_getsizeCoverListXmlData
{

        NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
        [extraParamsDic setObject:YK_METHOD_GET_SIZECOVERLIST forKey:@"act"];
    	[self startLoading];
        [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParamsDic 
                                                object:self 
                                              onAction:@selector(onrequestGetsizeCoverListXmlData:)];
}
-(void)onrequestGetsizeCoverListXmlData:(GDataXMLDocument*)xmlDoc
{
	[self stopLoading];
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]){
        SCNSwitchSizeData *_switchData = [[SCNSwitchSizeData alloc]init];
        KDataWorld.m_switchSizeData = _switchData;
        [SCNSwitchSizeData parserXmlDatas:xmlDoc withSwitchSizeData:KDataWorld.m_switchSizeData];
        self.m_brandArr = KDataWorld.m_switchSizeData.m_brandArr;
		[self setDefaultBrandAndSex];
    }


}
#pragma mark-
#pragma mark 设置默认品牌，性别，
-(void)setDefaultBrandAndSex
{
	if ([self.m_brandArr count]>0) 
	{
		brandAndSex_Data *brandDefault = (brandAndSex_Data *)[self.m_brandArr objectAtIndex:0];
		self.m_brandLable.text = brandDefault.mname;
		self.m_sexArr = brandDefault.datasArr;
		
		[self setDefaultSex];
		
		[self setDefaultSize];
	}
}

-(void)setDefaultSex
{
	if ([self.m_sexArr count]>0 && [self isNeutral:self.m_sex]==YES)
	{
		brandAndSex_Data *sexDefault = (brandAndSex_Data *)[self.m_sexArr objectAtIndex:0];
		self.m_sexLable.text = sexDefault.mname;
		self.m_sizeArr = sexDefault.datasArr;
	}
}

-(void)setDefaultSize
{
	[self getSizeArr:self.m_sexArr];
	
	if ([self.m_sizeArr count]>0) 
	{
		size_Data *sizeD = (size_Data *)[self.m_sizeArr objectAtIndex:0];
		self.m_scode = sizeD.mscode;
		self.m_sizeLable.text = sizeD.msize;
	}
}

-(void)getSizeArr:(NSMutableArray *)sexArr
{
    for (brandAndSex_Data *sex in sexArr) {
        NSLog(@"=%@-----%@",sex.mname,self.m_sex);
        if ([sex.mname isEqualToString:self.m_sex]) {
            self.m_sizeArr = sex.datasArr;
			
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark-
#pragma 取消
-(IBAction)onAction_cancle:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)onAction_ButtonPressed:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    switch (tag) {
        case 11://品牌
        {
            SCNCommonPickerView *PickerView = [[SCNCommonPickerView alloc]initWithFrame:CGRectMake(0, 170, 320, 284)];
            PickerView.m_showView.frame = CGRectMake(0, 170, 320, 284);
            PickerView.m_delegate = self;
            PickerView.m_pickerView.delegate = self;
            PickerView.m_pickerView.dataSource = self;
            [self.view addSubview:PickerView];
            PickerView.m_pickerView.tag = Tag_brandPicker;
        }
            break;
        case 21://性别
        {
            SCNCommonPickerView *PickerView = [[SCNCommonPickerView alloc]initWithFrame:CGRectMake(0, 170, 320, 284)];
            PickerView.m_delegate = self;
            PickerView.m_pickerView.delegate = self;
            PickerView.m_pickerView.dataSource = self;
            [self.view addSubview:PickerView];
            PickerView.m_pickerView.tag = Tag_sexPicker;
        }
            break;        
        case 31://尺寸
        {
            SCNCommonPickerView *PickerView = [[SCNCommonPickerView alloc]initWithFrame:CGRectMake(0, 170, 320, 280)];
            PickerView.m_delegate = self;
            PickerView.m_pickerView.delegate = self;
            PickerView.m_pickerView.dataSource = self;
            [self.view addSubview:PickerView];
            PickerView.m_pickerView.tag = Tag_sizePicker;
        
        }
            break;        
        case 40://换算尺码
        {
            [self sizeSwitch:self.m_scode];
        }
            break;
        default:
            break;
    }



}

-(void)sizeSwitch:(NSString *)scode
{
    if (self.m_scode == nil ||[self.m_scode isEqualToString:@"" ]) {
        UIAlertView *sizealert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"请选择尺码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [sizealert show];
        return;
    }
	for (brandAndSex_Data *brandD in self.m_brandArr) {
		if ([brandD.mname isEqualToString:self.m_brand] && [self isNeutral:self.m_sex]==NO) 
		{
			for (brandAndSex_Data *sexD in brandD.datasArr) {
				 if ([sexD.mname isEqualToString:self.m_sex]) {
					 for (size_Data *sizeD in sexD.datasArr) {
						 if ([sizeD.mscode isEqualToString:self.m_scode]) 
						 {
							 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:[NSString stringWithFormat:@"建议您选择%@码",sizeD.msize] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
							 [alert show];
							 [m_delegate updateCurrentSize:sizeD.msize];
							 return;
						 }
					 }
				 }
			}
		}
		else if ([self isNeutral:self.m_sex]==YES)
		{
			for (size_Data *sizeD in brandD.allSizeArr) {
				if ([sizeD.mscode isEqualToString:self.m_scode]) 
				{
					UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:[NSString stringWithFormat:@"建议您选择%@码",sizeD.msize] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
					[alert show];
					[m_delegate updateCurrentSize:sizeD.msize];
					return;
				}
			}
		}
	}
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"抱歉，没有找到适合您的尺码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark-
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self onAction_cancle:nil];
    }
}
#pragma mark-
#pragma mark SCNCommonPickerViewDelegate
-(NSInteger)numberOfCellsForPickerView:(SCNCommonPickerView*)aPickerView{
    return 	0;
}

-(NSArray*)titleForPickerView:(SCNCommonPickerView*)aPickerView
{
    return nil;
}
-(void)scnCommonPickerView:(SCNCommonPickerView*)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (aPickerView.m_pickerView.tag == Tag_brandPicker) {
        brandAndSex_Data *brand = (brandAndSex_Data *)[self.m_brandArr objectAtIndex:row];
        self.m_sexArr = brand.datasArr;
        if ([self isNeutral:self.m_sex] == NO) {
            [self getSizeArr:self.m_sexArr];
        }
        self.m_brandLable.text = brand.mname;
		[self setDefaultSex];
		[self setDefaultSize];
        
    }else if(aPickerView.m_pickerView.tag == Tag_sexPicker){
        brandAndSex_Data *sex = (brandAndSex_Data *)[self.m_sexArr objectAtIndex:row];
        self.m_sexLable.text = sex.mname;
        if ([self isNeutral:self.m_sex] == YES) {
            self.m_sizeArr = sex.datasArr;
        }
		[self setDefaultSize];
        
    }else if(aPickerView.m_pickerView.tag == Tag_sizePicker){
        size_Data *sizeD = (size_Data *)[self.m_sizeArr objectAtIndex:row];
        self.m_scode = sizeD.mscode;
        self.m_sizeLable.text = sizeD.msize;
    }
}
-(void)cancleView{
}

#pragma mark-
#pragma mark UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    UILabel* _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = UITextAlignmentCenter;
    [infoView addSubview:_label];
    if (pickerView.tag==Tag_brandPicker) {
        brandAndSex_Data *brand = (brandAndSex_Data *)[self.m_brandArr objectAtIndex:row];
        _label.text = brand.mname;
    }else if(pickerView.tag==Tag_sexPicker){
        brandAndSex_Data *sex = (brandAndSex_Data *)[self.m_sexArr objectAtIndex:row];
        _label.text = sex.mname;
    }else if(pickerView.tag==Tag_sizePicker){
        size_Data *sizeD = (size_Data *)[self.m_sizeArr objectAtIndex:row];
        _label.text = sizeD.msize;
    }

    
    return infoView;
}
#pragma mark-
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==Tag_brandPicker) {
    return  [self.m_brandArr count];
    }else if(pickerView.tag==Tag_sexPicker){
    return  [self.m_sexArr count];
    }else if(pickerView.tag==Tag_sizePicker){
        return  [self.m_sizeArr count];
    }
    return 0;
}
@end
