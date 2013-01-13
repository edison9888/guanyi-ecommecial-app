//
//  SCN_productDetailViewController.m
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCN_productDetailViewController.h"
#import "SCN_productDetail_tabelCell.h"
#import "SCNMoreProductInfoViewController.h"
#import "SCN_BigImageViewController.h"
#import "SCNCashCenterViewController.h"
#import "SCNViewController.h"
#import "ShoppingCartData.h"
#import "YKStatBehaviorInterface.h"
#import "YKAddShopCartAnimationView.h"

#import "Go2PageUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"

#import "TextBlock.h"
#import "SCNProductTagLabel.h"

//自定义 颜色 尺码 按钮...................
@implementation CustomButton
@synthesize colorRgb,colorImagUrl,colorProductCode,colorName,sizeSku,isCheck,sizeStocks,colorCheck;

-(void)dealloc{
colorRgb = nil;
colorImagUrl = nil;
colorName = nil;
colorProductCode = nil;
colorCheck = nil;

sizeSku = nil;
sizeStocks = nil;
}
@end
//..................................... 
#define Tag_topScrollView      10

#define Tag_colorScrollView    41
#define Tag_sizeScrollView     43
#define Tag_sizeSwitchButton   44
#define Tag_cutCountButton     45
#define Tag_addCountButton     46
#define Tag_countField         40



#define Tag_buy                51
#define Tag_addshopingCar      52
#define Tag_addfavorite        53

#define Tag_share_tx   61
#define Tag_share_sina 62
#define Tag_share_mail 63
#define Tag_share_note 64

@implementation SCN_productDetailViewController

@synthesize m_buy_cell;
@synthesize m_tableview;
@synthesize m_heightOfRow;
@synthesize m_countTextField,m_disCountLable;
@synthesize m_productCode,m_sku,m_productColor,m_productSize,m_imageUrl;
@synthesize m_colorScrollView,m_sizeScrollView;
@synthesize m_productDetailDatas;
@synthesize m_totalCount,m_IndexTopSV;
@synthesize m_colorLeftBT,m_colorRightBT,m_sizeLeftBT,m_sizeRightBT;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
      withProductCode:(NSString *)productCode 
        withwithImage:(NSString*)imgUrl{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
            self.m_productCode = productCode != nil ? productCode:@"";
            self.m_imageUrl = imgUrl;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
	self.pathPath = @"/detail";
    m_heightOfRow = [[NSArray alloc] initWithObjects:@"160.0f",@"115.0f",@"50.0f",@"164.0f",@"109.0f", nil];
    self.m_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStylePlain];
    self.m_tableview.backgroundColor = [UIColor clearColor];
    self.m_tableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    [self.view addSubview:self.m_tableview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.m_productDetailDatas == nil)
	{
        [self request_getProductInfoXmlData];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self hideKeyBorod];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark －
#pragma mark 请求数据
-(void)request_getProductInfoXmlData
{
    [self startLoading];
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:YK_METHOD_GET_PRODUCTINFO forKey:@"act"];
    [extraParamsDic setObject:self.m_productCode forKey:@"productCode"];
    [YKHttpAPIHelper startLoad:SCN_URL 
                   extraParams:extraParamsDic 
                        object:self 
                      onAction:@selector(onrequest_getProductInfoXmlData:)];
}
-(void)onrequest_getProductInfoXmlData:(GDataXMLDocument*)xmlDoc
{
	[self stopLoading];
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) 
	{
        self.m_productDetailDatas = nil;
		self.m_productDetailDatas = [SCNProductDetailData parserXmlDatas:xmlDoc IsSkill:NO];
        self.m_totalCount = [self.m_productDetailDatas.m_total intValue];
        if (self.m_productDetailDatas.m_smallImagesArr.count >0 && self.m_imageUrl == nil) {
            self.m_imageUrl = [self.m_productDetailDatas.m_smallImagesArr objectAtIndex:0];
        }
		[SCNStatusUtility save2BrowserData:self.m_productDetailDatas.m_product_data withProductCode:self.m_productCode withProductBn:self.m_productDetailDatas.m_product_data.mbn withImageUrl:self.m_imageUrl];
		[self refreshNowProduct]; 
		[self.m_tableview reloadData];
		[super BehaviorPageJump];
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.m_buy_cell = nil;
    self.m_tableview = nil;
	self.m_countTextField = nil;
	self.m_disCountLable = nil;
    self.m_heightOfRow = nil;
	self.m_sizeScrollView = nil;
    self.m_colorScrollView = nil;

    self.m_colorLeftBT = nil;
    self.m_colorRightBT = nil;
    self.m_sizeLeftBT = nil;
    self.m_sizeRightBT = nil;
    
}


#pragma mark －
#pragma mark 商品详情上面图片
-(void)layout_TopPcitureView:(TopView *)topView
{
    HLayoutView *topScrollView = (HLayoutView  *)[topView viewWithTag:Tag_topScrollView];
	
	for (UIView * vi in topScrollView.subviews)
	{
		[vi removeFromSuperview];
	}
	
    topScrollView.delegate = self;
    topScrollView.clipsToBounds = NO;
    topScrollView.spacing = 14;
    [topScrollView setToNavi];
    topScrollView.pagingEnabled = NO;
    for (int i=0; i<[self.m_productDetailDatas.m_smallImagesArr count]; i++) {
        HJManagedImageV *hjTopPicView = [[HJManagedImageV alloc]initWithFrame:CGRectMake(0, 0, 145, 138)];
        [hjTopPicView setImage:[DataWorld getImageWithFile:@"com_loading145x143.png"]];
        hjTopPicView.userInteractionEnabled = YES;
        hjTopPicView.backgroundColor = [UIColor whiteColor];
        //hjTopPicView.alpha = 0.5;
        if ( [hjTopPicView.layer respondsToSelector:@selector(setShadowOffset:)] ) {//设置阴影效果
            [hjTopPicView.layer setShadowOffset:CGSizeMake(2, 2)];
            [hjTopPicView.layer setShadowRadius:2];
            [hjTopPicView.layer setShadowOpacity:0.8]; 
            [hjTopPicView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
        }
		hjTopPicView.layer.borderWidth = 1;
		hjTopPicView.layer.borderColor =  YK_IMAGEBORDER_COLOR.CGColor;
		
        UIButton *TopViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        TopViewButton.tag = i;
        TopViewButton.backgroundColor = [UIColor clearColor];
        TopViewButton.frame = CGRectMake(0, 0, 145, 138);
        [TopViewButton addTarget:self 
                          action:@selector(onAction_go2BigImageViewController:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [hjTopPicView addSubview:TopViewButton];
        
        [topScrollView addSubview:hjTopPicView];
        [HJImageUtility queueLoadImageFromUrl:[self.m_productDetailDatas.m_smallImagesArr objectAtIndex:i] imageView:hjTopPicView];
    }
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 138)];
    [topScrollView addSubview:view];
    if ([self.m_productDetailDatas.m_smallImagesArr count] >=3) {
        [topScrollView setContentOffset:CGPointMake((145+14)*1, 0) animated:NO];
        self.m_IndexTopSV = 1;
    }
}
-(void)onAction_go2BigImageViewController:(UIView*)sender
{
    if ([self hideKeyBorod]) {
        return;
    }
	int index = sender.tag;
    [Go2PageUtility go2BigImageViewController:self withImageUrlArr:self.m_productDetailDatas.m_bigImagesArr withIndex:index];
}
#pragma mark －
#pragma mark 排列第二个单元格
-(void)layout_secondTableViewCell:(UITableViewCell *)cell
{
    CGFloat cellY = 0;
    productDetail_Data *_productData = self.m_productDetailDatas.m_product_data;
    
    TextBlock *nameLable = [[TextBlock alloc]initWithFrame:CGRectMake(10, 5, 300, 21)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    nameLable.textColor = [UIColor blackColor];
    [cell addSubview:nameLable];
    [nameLable setText:_productData.mname];
    
    CGFloat sellLableY = nameLable.frame.origin.y +nameLable.frame.size.height + 5;
    UILabel *sellLable = [[UILabel alloc]initWithFrame:CGRectMake(10, sellLableY, 60, 21)];
    sellLable.backgroundColor = [UIColor clearColor];
    sellLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    sellLable.textColor = [UIColor colorWithRed:180.0f/255.0f green:0.0f/255.0f blue:7.0f/255 alpha:1.0f];
    [cell addSubview:sellLable];
    sellLable.text = @"销售价:";
    
    UIFont *sFont = [UIFont fontWithName:@"Helvetica-Bold" size:22.0f];
    UILabel *sellPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(sellLable.frame.origin.x + sellLable.frame.size.width +4, sellLableY-6, 136, 30)];
    sellPriceLable.backgroundColor = [UIColor clearColor];
    sellPriceLable.font = sFont;
    sellPriceLable.textColor = [UIColor colorWithRed:180.0f/255.0f green:0.0f/255.0f blue:7.0f/255 alpha:1.0f];
    [cell addSubview:sellPriceLable];
    NSString * priceStr  = [SCNStatusUtility getPriceString:_productData.msellPrice];
    CGSize labelsize = [priceStr sizeWithFont:sFont constrainedToSize:sellPriceLable.frame.size lineBreakMode:UILineBreakModeWordWrap];
    CGFloat x = sellLable.frame.origin.x + sellLable.frame.size.width +5 ;
    sellPriceLable.frame = CGRectMake(x, sellPriceLable.frame.origin.y, labelsize.width, sellPriceLable.frame.size.height);
    sellPriceLable.text = priceStr;
    
    CGFloat marketX = sellPriceLable.frame.origin.x +sellPriceLable.frame.size.width +8;
    CGFloat marketY = sellLableY;
    CGRect mPLableRect = CGRectMake(marketX, marketY, 220, 21);
    UIFont *mfont = [UIFont fontWithName:@"Helvetica" size:16.0f];
    NSString * marketPriceStr = [NSString stringWithFormat:@"市场价:%@",[SCNStatusUtility getPriceString:_productData.mmarketPrice]];
    CGSize markLableSize = [marketPriceStr sizeWithFont:mfont constrainedToSize:mPLableRect.size lineBreakMode:UILineBreakModeWordWrap];
    YKCustomMiddleLineLable *marketPriceLable = [[YKCustomMiddleLineLable alloc]initWithFrame:CGRectMake(marketX, marketY, markLableSize.width +20, mPLableRect.size.height)];
    marketPriceLable.enabled_middleLine = YES;
    marketPriceLable.backgroundColor = [UIColor clearColor];
    marketPriceLable.font = mfont;
    marketPriceLable.textColor = [UIColor grayColor];
    [marketPriceLable setText:marketPriceStr];
    
    [cell addSubview:marketPriceLable];
    cellY = CGRectGetMaxY(marketPriceLable.frame);
    NSString *strOne = @"";
    NSString *strTwo = @"";
    CGFloat saleMarkY = marketPriceLable.frame.origin.y +marketPriceLable.frame.size.height +5;
    if ([self.m_productDetailDatas.m_tagsArr count]>=2) {
        strOne = ((tags_Data *)[self.m_productDetailDatas.m_tagsArr objectAtIndex:0]).minfo;
        strTwo = ((tags_Data *)[self.m_productDetailDatas.m_tagsArr objectAtIndex:1]).minfo;

        if (strOne != nil && ![strOne isEqualToString:@""] && strTwo != nil && ![strTwo isEqualToString:@""]) {
            //SCNProductTagLabel *saleOneLable = [[SCNProductTagLabel alloc]initWithFrame:CGRectMake(264, saleMarkY, 45, 15)];
            SCNProductTagLabel *saleOneLable = [[SCNProductTagLabel alloc]initWithFrame:CGRectMake(10, saleMarkY, 45, 15)];
            saleOneLable.isleft = YES;
            saleOneLable.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:17.0f/255.0f blue:17.0f/255 alpha:1.0f];
            saleOneLable.textColor = [UIColor whiteColor];
            saleOneLable.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            [cell addSubview:saleOneLable];
            saleOneLable.text = [NSString stringWithFormat:@" %@ ",strOne];
            
//            CGRect  frame = CGRectMake(saleOneLable.frame.origin.x-saleOneLable.frame.size.width-8,
//                                       saleOneLable.frame.origin.y, 
//                                       saleOneLable.frame.size.width, 
//                                       saleOneLable.frame.size.height);
              CGRect  frame = CGRectMake(saleOneLable.frame.origin.x+saleOneLable.frame.size.width+8,
                                                   saleOneLable.frame.origin.y, 
                                                   saleOneLable.frame.size.width, 
                                                saleOneLable.frame.size.height);
            SCNProductTagLabel *saleTwoLable = [[SCNProductTagLabel alloc]initWithFrame:frame];
            saleTwoLable.isleft = YES;
            saleTwoLable.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:17.0f/255.0f blue:17.0f/255 alpha:1.0f];
            saleTwoLable.textColor = [UIColor whiteColor];
            saleTwoLable.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            [cell addSubview:saleTwoLable];
            saleTwoLable.text = [NSString stringWithFormat:@" %@ ",strTwo];
            cellY = CGRectGetMaxY(saleTwoLable.frame);
        }
        
    }
    else if([self.m_productDetailDatas.m_tagsArr count]<=1 && [self.m_productDetailDatas.m_tagsArr count]>0)
    {
        strOne = ((tags_Data *)[self.m_productDetailDatas.m_tagsArr objectAtIndex:0]).minfo;

        if (strOne != nil && ![strOne isEqualToString:@""]){
            //SCNProductTagLabel *saleOneLable = [[SCNProductTagLabel alloc]initWithFrame:CGRectMake(264, saleMarkY, 45, 15)];
            SCNProductTagLabel *saleOneLable = [[SCNProductTagLabel alloc]initWithFrame:CGRectMake(10, saleMarkY, 45, 15)];
            saleOneLable.isleft = YES;
            saleOneLable.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:17.0f/255.0f blue:17.0f/255 alpha:1.0f];
            saleOneLable.textColor = [UIColor whiteColor];
            saleOneLable.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
            [cell addSubview:saleOneLable];
            saleOneLable.text = [NSString stringWithFormat:@" %@ ",strOne];
            cellY = CGRectGetMaxY(saleOneLable.frame);
        }
    }

    cell.frame = CGRectMake(0, 0, 320, cellY + 5);
    
}
#pragma mark －
#pragma mark 排列 选择颜色
-(void)layout_ColorScrollView:(HLayoutView *)colorScrollview
{
    self.m_colorScrollView = colorScrollview;
	for (UIView * vi in self.m_colorScrollView.subviews)
	{
		[vi removeFromSuperview];
	}
    self.m_colorScrollView.tag = Tag_colorScrollView;
    self.m_colorScrollView.delegate = self;
	self.m_colorScrollView.spacing = 6;
    [self.m_colorScrollView setToNavi];
	self.m_colorScrollView.pagingEnabled = NO;
	NSArray* colorArr = self.m_productDetailDatas.m_colorArr;
    for (int i=0; i<[colorArr count]; i++) 
	{
        colors_Data *_colorData = (colors_Data *)[self.m_productDetailDatas.m_colorArr objectAtIndex:i];
        HJManagedImageV *hjColorPicView = [[HJManagedImageV alloc]initWithFrame:CGRectMake(0, 0, 43, 43)];

        [hjColorPicView.layer setCornerRadius:3];
        hjColorPicView.layer.borderWidth = 1;
        hjColorPicView.layer.borderColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f].CGColor;
        hjColorPicView.userInteractionEnabled = YES;
        hjColorPicView.clipsToBounds = YES;
        CustomButton *checkColorButton = [CustomButton buttonWithType:UIButtonTypeCustom];
        checkColorButton.isCheck = NO;
        checkColorButton.colorProductCode = _colorData.mproductCode;
        if ([_colorData.mcheck intValue]==1) {
            UIImageView *image = [[UIImageView alloc]initWithImage:[DataWorld getImageWithFile:@"shoppingcart_defaultAddress_selectArrow.png"]];
            image.frame = CGRectMake(26, 28, 15, 14);
            [hjColorPicView addSubview:image];
            self.m_productColor = checkColorButton.colorProductCode;
        }
        checkColorButton.showsTouchWhenHighlighted = YES;
        checkColorButton.backgroundColor = [UIColor clearColor];
        checkColorButton.frame = CGRectMake(0, 0, 43, 43);
        [checkColorButton addTarget:self 
                          action:@selector(onAction_checkColor:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [hjColorPicView addSubview:checkColorButton];
        
        [self.m_colorScrollView addSubview:hjColorPicView];
        [HJImageUtility queueLoadImageFromUrl:_colorData.mimage
                                    imageView:hjColorPicView];
    }

}
-(void)onAction_checkColor:(id)sender
{   
    if ([self hideKeyBorod]) 
    {
        return;
    }
    CustomButton *colorBt = (CustomButton *)sender;
    if ([self.m_productCode isEqualToString:colorBt.colorProductCode]) {
        return;
    }
    self.m_imageUrl = nil;
    self.m_productDetailDatas = nil;
    self.m_productCode = colorBt.colorProductCode;
    [self viewWillAppear:YES];
    [self.m_tableview  reloadData];    
    NSLog(@"选择颜色");
}

#pragma mark －
#pragma mark 排列 选择尺寸
-(void)layout_SizeScrollView:(HLayoutView *)sizeScrollview
{
    self.m_sizeScrollView = sizeScrollview;
	for (UIView * vi in self.m_sizeScrollView.subviews)
	{
		[vi removeFromSuperview];
	}
    self.m_sizeScrollView.tag =Tag_sizeScrollView;
    self.m_sizeScrollView.delegate = self;
    self.m_sizeScrollView.spacing = 6;
    [self.m_sizeScrollView setToNavi];
    self.m_sizeScrollView.pagingEnabled = NO;
    for (int i=0; i<[self.m_productDetailDatas.m_sizeArr count]; i++) {
        sizes_Data *_sizeData = (sizes_Data *)[self.m_productDetailDatas.m_sizeArr objectAtIndex:i];
        CustomButton *checkSizeButton = [CustomButton buttonWithType:UIButtonTypeCustom];
        checkSizeButton.frame = CGRectMake(0, 0, 43, 43);
        checkSizeButton.backgroundColor = [UIColor clearColor];
        [checkSizeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkSizeButton.isCheck = NO;
        checkSizeButton.sizeSku = _sizeData.msku;
        checkSizeButton.sizeStocks = _sizeData.mstock;
        [checkSizeButton setTitle:_sizeData.msize forState:UIControlStateNormal];
        [checkSizeButton setBackgroundImage:[DataWorld getImageWithFile:@"seckillDetail_sizeBg.png"] forState:UIControlStateNormal];
        [checkSizeButton addTarget:self 
                          action:@selector(onAction_checkSize:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self.m_sizeScrollView addSubview:checkSizeButton];
        
    }
}
-(void)onAction_checkSize:(id)sender
{
    if ([self hideKeyBorod]) {
        return;
    }
    CustomButton *checkButton = (CustomButton *)sender;
    if (checkButton.isCheck == NO) {
        [self removeImageFromCustomButton:self.m_sizeScrollView];
        [checkButton setBackgroundImage:[DataWorld getImageWithFile:@"seckillDetail_sizeBg_SEL.png"] forState:UIControlStateNormal];
        checkButton.isCheck = YES;
        self.m_sku = checkButton.sizeSku;
		self.m_productSize = checkButton.titleLabel.text;
    }else{
        return;
//       [checkButton setBackgroundImage:[DataWorld getImageWithFile:@"seckillDetail_sizeBg.png"] forState:UIControlStateNormal];
//        checkButton.isCheck = NO;
//        self.m_sku = @"";
//		self.m_productSize = @"";
    }
    [self updateDisCount:sender];
    [self judgmentDatas:self.m_buy_cell];
}

-(void)removeImageFromCustomButton:(id)sender
{
    for (CustomButton *sizeBt in [self.m_sizeScrollView subviews]) {
        if (sizeBt.isCheck == YES) {
            [sizeBt setBackgroundImage:[DataWorld getImageWithFile:@"seckillDetail_sizeBg.png"] forState:UIControlStateNormal];
            sizeBt.isCheck = NO;
        }
    }

}
#pragma mark-
#pragma mark 更新库存
-(void)updateDisCount:(id)sender;
{
    CustomButton *checkButton = (CustomButton *)sender;
    NSString *disCount = [checkButton.sizeStocks intValue] !=0?checkButton.sizeStocks:[NSString stringWithFormat:@"缺货"];
    self.m_totalCount = [checkButton.sizeStocks intValue] !=0 ? [checkButton.sizeStocks intValue] :0;
    self.m_disCountLable.text = disCount;
    if ([self.m_countTextField.text intValue]> self.m_totalCount) {
        self.m_countTextField.text = [NSString stringWithFormat:@"%d",self.m_totalCount];
    }
}
#pragma mark-
#pragma mark 尺码转换
-(void)onActionSwitchSize:(id)sender
{
    if ([self hideKeyBorod]) {
        return;
    }
    SCN_SwitchSizeViewController *sizeSwitch = [[SCN_SwitchSizeViewController alloc]initWithNibName:@"SCN_SwitchSizeViewController" 
                                                                                             bundle:nil 
                                                                                            withSex:self.m_productDetailDatas.m_product_data.msex 
                                                                                          withBrand:self.m_productDetailDatas.m_product_data.mbrand 
                                                                                         withSkuArr:self.m_productDetailDatas.m_sizeArr];
    sizeSwitch.m_delegate = self;
    [self presentModalViewController:sizeSwitch animated:YES];
}
#pragma mark －
#pragma mark SwitchSizeDelegate
-(void)updateCurrentSize:(NSString *)size
{
    if ([self.m_productSize isEqualToString:size]) {
        return;
    }else{
        for (CustomButton *sizeBt in [self.m_sizeScrollView subviews] ) {
            if ([sizeBt.titleLabel.text isEqualToString:size]) {
                [self onAction_checkSize:sizeBt];
            }
        }
    }
}
#pragma mark-
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [self.m_tableview setContentOffset:CGPointMake(0, 246) animated:YES];
    self.m_tableview.frame = CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]+[SCNStatusUtility getTabBarHeight]-216);
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.m_countTextField.text intValue] ==0 || [self.m_countTextField.text isEqualToString:@""]) 
    {
        self.m_countTextField.text = @"1";
    }
	else if([self.m_countTextField.text intValue] > self.m_totalCount)
    {
        self.m_countTextField.text = [NSString stringWithFormat:@"%d",self.m_totalCount];
    }    
	else if([self.m_countTextField.text intValue] >100)
    {
        self.m_countTextField.text = @"100";
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];

    self.m_tableview.frame = CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]);
    [UIView commitAnimations];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.m_countTextField.text intValue] ==0 || [self.m_countTextField.text isEqualToString:@""]) {
        self.m_countTextField.text = @"1";
    }
    else if([self.m_countTextField.text intValue] >100)
    {
        self.m_countTextField.text = @"100";
    }else if([self.m_countTextField.text intValue] > self.m_totalCount)
    {
        self.m_countTextField.text = [NSString stringWithFormat:@"%d",self.m_totalCount];
    }
	[self hideKeyBorod];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.m_tableview.frame = CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]);
    [UIView commitAnimations];
    return YES;
}
-(BOOL)hideKeyBorod
{
	if ([self.m_countTextField isFirstResponder]) 
    {
		[self.m_countTextField resignFirstResponder];
        return YES;
	}
    return NO;
}
#pragma mark -
#pragma mark 购买数量
-(void)onActionCount_add_cut:(id)sender
{
    int tag = ((UIButton *)sender).tag;
    int sellCount = [self.m_countTextField.text intValue];
    if (tag==Tag_addCountButton && sellCount <100 && sellCount < self.m_totalCount) 
    {
        sellCount ++;
    }
    else if (tag==Tag_cutCountButton && sellCount >1) 
    {
        sellCount--;
    }
    self.m_countTextField.text = [NSString stringWithFormat:@"%d",sellCount];
}
#pragma mark-
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.tag==Tag_topScrollView) {
//        CGFloat x = scrollView.contentOffset.x;
//        NSLog(@">>>>>>++++++===%f",x);
//        [self fixScrollowView:(UIScrollView *)scrollView];
//    }
//     [self fixScrollowView:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate)
	{
        [self ifHidenForAllertScroll:scrollView];
		[self fixScrollowView:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self ifHidenForAllertScroll:scrollView];
    [self fixScrollowView:scrollView];
}

-(void)fixScrollowView:(UIScrollView *)scrollView
{
    if (scrollView.tag==Tag_topScrollView) {
        NSLog(@">>>----==%f",scrollView.decelerationRate);
        self.m_IndexTopSV = scrollView.contentOffset.x/(145+14);
        CGFloat x = scrollView.contentOffset.x;
        self.m_IndexTopSV =  x/(145+14);
        CGFloat ishalf = x-self.m_IndexTopSV*(145+14)-72;
        if (ishalf>0) 
        {
            self.m_IndexTopSV++;
        }
        [self fixHJManagedImageVAlpha:scrollView index:self.m_IndexTopSV];
        [scrollView setContentOffset:CGPointMake((145+14)*self.m_IndexTopSV, 0) animated:YES];
    }else if (scrollView.tag == Tag_sizeScrollView) 
    {
        CGFloat x = scrollView.contentOffset.x;
        int m =  x/49;
        CGFloat ishalf = x-m*49-24;
        if (ishalf>0) 
        {
            m++;
        }
        [self.m_sizeScrollView setContentOffset:CGPointMake(49*m, 0) animated:YES];
    }
    else if (scrollView.tag == Tag_colorScrollView) 
    {
        CGFloat x = scrollView.contentOffset.x;
        int m =  x/49;
        CGFloat ishalf = x-m*49-24;
        if (ishalf>0) 
        {
            m++;
        }
        [self.m_colorScrollView setContentOffset:CGPointMake(49*m, 0) animated:YES];
    }


    
}
-(void)fixHJManagedImageVAlpha:(UIScrollView *)scrollView index:(int)index
{
    return;
    for (HJManagedImageV * HJV in scrollView.subviews) {
        CGFloat x = HJV.frame.origin.x;
        if (index == x/(145+14)) {
            NSLog(@"当前试图");
            HJV.alpha = 1.0f;
        }
        else
        {
            HJV.alpha = 0.5f;
        }
        NSLog(@">>>>%f",x);
    }
}
-(void)ifHidenForAllertScroll:(UIScrollView *)Scrollview
{
    if(Scrollview.tag==Tag_sizeScrollView)
    {
        if (self.m_sizeScrollView.contentOffset.x <=0) 
        {
            self.m_sizeLeftBT.hidden = YES;
            self.m_sizeRightBT.hidden = NO;
        }
        else if((self.m_sizeScrollView.contentSize.width - self.m_sizeScrollView.contentOffset.x)<=self.m_sizeScrollView.frame.size.width)
        {
            self.m_sizeRightBT.hidden = YES;
            self.m_sizeLeftBT.hidden =  NO;
        }
        else
        {
            self.m_sizeLeftBT.hidden = NO;
            self.m_sizeRightBT.hidden =  NO;
        }
        
    } 
    else if(Scrollview.tag==Tag_colorScrollView)
    {
        if (self.m_sizeScrollView.contentOffset.x <=0) 
        {
            self.m_colorLeftBT.hidden = YES;
            self.m_colorRightBT.hidden = NO;
        }
        else if((self.m_sizeScrollView.contentSize.width - self.m_sizeScrollView.contentOffset.x)<=self.m_sizeScrollView.frame.size.width)
        {
            self.m_colorRightBT.hidden = YES;
            self.m_colorLeftBT.hidden =  NO;
        }
        else
        {
            self.m_colorLeftBT.hidden = NO;
            self.m_colorRightBT.hidden =  NO;
        }
        
    }
}

#pragma mark －
#pragma mark UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.m_productDetailDatas != nil)
	{
		self.m_tableview.hidden = NO;
		return [m_heightOfRow count];
	}
	self.m_tableview.hidden = YES;
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int row = indexPath.row;
    NSString *First_CellIdentifier = @"First_tabelCell";
    NSString *Second_CellIdentifier = @"Second_tabelCell"; 
    NSString *More_CellIdentifier = @"More_tabelCell"; 
    NSString *Color_CellIdentifier = @"Color_tabelCell";
    NSString *Size_CellIdentifier = @"Size_tabelCell";
    NSString *Buy_CellIdentifier = @"Buy_tabelCell";
    
    UITableViewCell *cell = nil;
        switch (row){
        case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:First_CellIdentifier];
                if (cell == nil) {
					NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCN_productDetail_tabelCell" owner:self options:nil];
					cell = [cellNib objectAtIndex:0];
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
				
				SCN_productDetail_tabelCell_First *first_cell = (SCN_productDetail_tabelCell_First *)cell;
				[self layout_TopPcitureView:first_cell.m_topView];
            }
            break;
        case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:Second_CellIdentifier];
                if (cell == nil) {
//                NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCN_productDetail_tabelCell" owner:self options:nil];
//                    SCN_productDetail_tabelCell_Second *second_cell = (SCN_productDetail_tabelCell_Second *)[cellNib objectAtIndex:1];
//                    UIFont *font = second_cell.m_nameLable.font;
//                    NSLog(@"%@,%@",font.familyName,font.fontName);
//                    Helvetica,Helvetica-Bold
//                    cell = second_cell;
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Second_CellIdentifier];
                    cell.frame = CGRectMake(0, 0, 320, 144);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
				[self layout_secondTableViewCell:cell];

            }
            break;
        case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:More_CellIdentifier];
                if (cell == nil) {
                    NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCN_productDetail_tabelCell" owner:self options:nil];
                    SCN_productDetail_tabelCell_More *more_cell = (SCN_productDetail_tabelCell_More *)[cellNib objectAtIndex:2];
                    more_cell.m_backImageV.backgroundColor  = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:0.8f];
                    more_cell.m_descLable.text = @"咨询信息,评论信息,品牌,商品编号......";
                    //more_cell.m_descLable.text = self.m_productDetailDatas.m_desc;
                    cell = more_cell;
                }

            }
            
            break;
        case 3:
            {
				SCN_productDetail_tabelCell_Color *color_cell = nil;
                if ([self.m_productDetailDatas.m_colorArr count]>0) 
                {
					cell = [tableView dequeueReusableCellWithIdentifier:Color_CellIdentifier];
                    if (cell == nil)
                    {
                        NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCN_productDetail_tabelCell" owner:self options:nil];
                        cell = [cellNib objectAtIndex:3];
                        color_cell = (SCN_productDetail_tabelCell_Color *)cell;
                        cell.backgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"detailcolorBg.png"]];
                        
                        self.m_colorLeftBT =  color_cell.m_colorFrontButton;
                        self.m_colorRightBT = color_cell.m_colorBehindButton;
                        
                        self.m_sizeLeftBT = color_cell.m_sizeFrontButton;
                        self.m_sizeRightBT = color_cell.m_sizeBehindButton;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
					else
						color_cell = (SCN_productDetail_tabelCell_Color *)cell;
                    
                    if ([self.m_productDetailDatas.m_colorArr count]<5)
                    {
                        self.m_colorLeftBT.hidden = YES;
                        self.m_colorRightBT.hidden = YES;
                    }
                    else
                    {
                        self.m_colorLeftBT.hidden = YES;
                    }
                    //排列颜色
                    [self layout_ColorScrollView:color_cell.m_colorLayoutView];
                    
                }
                else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:Size_CellIdentifier];
					color_cell = (SCN_productDetail_tabelCell_Color *)cell;
                    if (cell == nil) 
                    {
                        NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCN_productDetail_tabelCell" owner:self options:nil];
                        cell = [cellNib objectAtIndex:6];
                        color_cell = (SCN_productDetail_tabelCell_Color *)cell;
                        cell.backgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"detailcolorBg.png"]];
                        self.m_sizeLeftBT = color_cell.m_sizeFrontButton;
                        self.m_sizeRightBT = color_cell.m_sizeBehindButton;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
					else
						color_cell = (SCN_productDetail_tabelCell_Color *)cell;
                }
				if ([self.m_productDetailDatas.m_product_data.mpstatus intValue] == 1)
				{
					cell.hidden = YES;
				}
				else
				{
					cell.hidden = NO;
				}
				
				if ([self.m_productDetailDatas.m_sizeArr count]<5) 
                {
					self.m_sizeLeftBT.hidden = YES;
					self.m_sizeRightBT.hidden = YES;
				}
				else
				{
					self.m_sizeLeftBT.hidden = YES;
				}
				//排列尺寸
				[self layout_SizeScrollView:color_cell.m_sizeLayutView];
				
				self.m_countTextField = color_cell.m_countsTextField;
				self.m_countTextField.delegate = self;
				self.m_disCountLable = color_cell.m_disCountLable;
				self.m_disCountLable.text = [NSString stringWithFormat:@"%d",self.m_totalCount];
				[color_cell.m_cutCountButton addTarget:self action:@selector(onActionCount_add_cut:) forControlEvents:UIControlEventTouchUpInside];
				[color_cell.m_addCountButton addTarget:self action:@selector(onActionCount_add_cut:) forControlEvents:UIControlEventTouchUpInside];
				if (self.m_productDetailDatas.m_product_data.msex == nil ||[self.m_productDetailDatas.m_product_data.msex isEqualToString:@""]) 
				{
					color_cell.m_sizeSwitch.hidden = YES;
				}
				else
				{
					color_cell.m_sizeSwitch.hidden = NO;
					[color_cell.m_sizeSwitch addTarget:self
												action:@selector(onActionSwitchSize:)
									  forControlEvents:UIControlEventTouchUpInside];
				}
				
				if ([self.m_countTextField.text intValue] > self.m_totalCount) {
					self.m_countTextField.text = [NSString stringWithFormat:@"%d",self.m_totalCount];
				}
            }
            
            break;
        case 4:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:Buy_CellIdentifier];
				self.m_buy_cell = (SCN_productDetail_tabelCell_Buy *)cell;
                if (cell == nil) 
				{
                    NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCN_productDetail_tabelCell" owner:self options:nil];
                    self.m_buy_cell = (SCN_productDetail_tabelCell_Buy *)[cellNib objectAtIndex:4];
					cell = self.m_buy_cell;
					
					self.m_buy_cell.m_buyImmediatelyButton.tag = Tag_buy;
					UIImage *bgImag = [DataWorld getImageWithFile:@"com_button_normal.png"];
					bgImag = [bgImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
					
					UIImage *bgSelecImag = [DataWorld getImageWithFile:@"com_button_select.png"];
					bgSelecImag = [bgSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
					
					[self.m_buy_cell.m_buyImmediatelyButton setBackgroundImage:bgImag forState:UIControlStateNormal];
					[self.m_buy_cell.m_buyImmediatelyButton setBackgroundImage:bgSelecImag forState:UIControlStateHighlighted];
					[self.m_buy_cell.m_buyImmediatelyButton addTarget:self 
															   action:@selector(onAction_buy_shopingCar_favorite:) 
													 forControlEvents:UIControlEventTouchUpInside];
					
					
					UIImage *BlackImag = [DataWorld getImageWithFile:@"com_blackbtn.png"];
					BlackImag = [BlackImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
					UIImage *BlackSelecImag = [DataWorld getImageWithFile:@"com_blackbtn_SEL.png"];
					BlackSelecImag = [BlackSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
					
					self.m_buy_cell.m_addShopCarButton.tag = Tag_addshopingCar;
					[self.m_buy_cell.m_addShopCarButton addTarget:self 
														   action:@selector(onAction_buy_shopingCar_favorite:) 
												 forControlEvents:UIControlEventTouchUpInside];
					
					[self.m_buy_cell.m_addShopCarButton setBackgroundImage:BlackImag forState:UIControlStateNormal];
					[self.m_buy_cell.m_addShopCarButton setBackgroundImage:BlackSelecImag forState:UIControlStateHighlighted];
					
					
					self.m_buy_cell.m_addfavoriteButton.tag = Tag_addfavorite;
					[self.m_buy_cell.m_addfavoriteButton addTarget:self 
															action:@selector(onAction_buy_shopingCar_favorite:) 
												  forControlEvents:UIControlEventTouchUpInside];
					[self.m_buy_cell.m_addfavoriteButton setBackgroundImage:BlackImag forState:UIControlStateNormal];
					[self.m_buy_cell.m_addfavoriteButton setBackgroundImage:BlackSelecImag forState:UIControlStateHighlighted];
					
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
				}
				
				[self judgmentDatas:self.m_buy_cell];

            }
            
            break;
//        case 5:
//            {
//               cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//                if (cell == nil) {
//                    SCN_productDetail_tabelCell_Share *share_cell = (SCN_productDetail_tabelCell_Share *)[cellNib objectAtIndex:5];
//                    
//                    share_cell.m_shareSinaButton.shareUrl = @"http://www.baidu.com";
//                    share_cell.m_shareSinaButton.tag = Tag_share_sina;
//                    [share_cell.m_shareSinaButton addTarget:self 
//                                                     action:@selector(onActionShareButton:) 
//                                           forControlEvents:UIControlEventTouchUpInside];
//                    
//                    share_cell.m_shareTXButton.shareUrl   = @"http://www.baidu.com";
//                    share_cell.m_shareTXButton.tag = Tag_share_tx;
//                    [share_cell.m_shareTXButton addTarget:self 
//                                                   action:@selector(onActionShareButton:) 
//                                         forControlEvents:UIControlEventTouchUpInside];
//                    
//                    share_cell.m_shareMailButton.shareUrl = @"http://www.baidu.com";
//                    share_cell.m_shareMailButton.tag = Tag_share_mail;
//                    [share_cell.m_shareMailButton addTarget:self 
//                                                     action:@selector(onActionShareButton:) 
//                                           forControlEvents:UIControlEventTouchUpInside];
//                    
//                    share_cell.m_shareNoteButton.shareUrl = @"http://www.baidu.com";
//                    share_cell.m_shareNoteButton.tag = Tag_share_note;
//                    [share_cell.m_shareNoteButton addTarget:self 
//                                                     action:@selector(onActionShareButton:) 
//                                           forControlEvents:UIControlEventTouchUpInside];
//                    
//                    cell = share_cell;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//            }
//                
//            break;
                
        default:
            break;
        }
	return cell;
}
#pragma mark -
#pragma mark 购买 购物车，收藏夹按钮点击
-(void)onAction_buy_shopingCar_favorite:(id)sender
{
    if ([self hideKeyBorod]) {
        return;
    }
    int tag = ((UIButton *)(sender)).tag;
    switch (tag) {
        case Tag_buy:
        {
            if ([self judgmentDatas:nil]==YES) {
                [self immediateCashWithoutShoppingcart];
				[self immediateBuyBehavior];
            }
            
        }
            
            break;
        case Tag_addshopingCar:
        {
            
           if ([self judgmentDatas:nil]==YES) {
               
               UIImage *addShopingCarImage  =  [HJImageUtility imageFromUrl:(self.m_productDetailDatas.m_smallImagesArr.count > self.m_IndexTopSV ? [self.m_productDetailDatas.m_smallImagesArr objectAtIndex:self.m_IndexTopSV] : @"shoppingcart_product.png")];
               addShopingCarImage = addShopingCarImage !=nil? addShopingCarImage:[DataWorld getImageWithFile:@"shoppingcart_product.png"]; 
               
               YKAddShopCartAnimationView* animationView = [YKAddShopCartAnimationView animationViewWithStartPoint:CGPointMake(-50, 0)
                                                                                                      WithEndPoint:CGPointMake(105, 390)
                                                                                                withAnimationImage:addShopingCarImage];
               [animationView showAnimation];
            [self performSelector:@selector(addShopingCar) withObject:nil afterDelay:0.0];
           }
        }
            
            break;
        case Tag_addfavorite:
        {
            NSLog(@"加入收藏夹 ");    //判断是否登录
            [Go2PageUtility showloginViewControlelr:self action:@selector(request_addFavoriteInfoXmlData) withObject:nil];
			[self addFavoriteBehavior];
        }
            
            break;
            
        default:
            break;
    }
}
-(BOOL)judgmentDatas:(id)sender
{
    if (sender) 
    {
        SCN_productDetail_tabelCell_Buy *buy_cell = (SCN_productDetail_tabelCell_Buy *)sender;
        //self.m_productDetailDatas.m_product_data.mpstatus = @"1";
        if ([self.m_productDetailDatas.m_product_data.mpstatus intValue] == 1) 
        {
            buy_cell.m_buyImmediatelyButton.enabled = NO;
            buy_cell.m_addShopCarButton.enabled = NO;
            UIImage *BlackImag = [DataWorld getImageWithFile:@"com_blackbtn.png"];
            BlackImag = [BlackImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            UIImage *BlackSelecImag = [DataWorld getImageWithFile:@"com_blackbtn_SEL.png"];
            BlackSelecImag = [BlackSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            [buy_cell.m_buyImmediatelyButton setBackgroundImage:BlackImag forState:UIControlStateNormal];
            [buy_cell.m_buyImmediatelyButton setBackgroundImage:BlackImag forState:UIControlStateHighlighted];
            [buy_cell.m_addShopCarButton setTitle:@"该商品已下架" forState:UIControlStateNormal];
            return NO;
        }
        else if (self.m_totalCount<=0) 
        {
            buy_cell.m_buyImmediatelyButton.enabled = NO;
            buy_cell.m_addShopCarButton.enabled = NO;
            [buy_cell.m_addShopCarButton setTitle:@"该尺寸已无库存" forState:UIControlStateNormal];
            return NO;
        } 
        else
        {
            buy_cell.m_buyImmediatelyButton.enabled = YES;
            buy_cell.m_addShopCarButton.enabled = YES;
            UIImage *bgImag = [DataWorld getImageWithFile:@"com_button_normal.png"];
            bgImag = [bgImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            UIImage *bgSelecImag = [DataWorld getImageWithFile:@"com_button_select.png"];
            bgSelecImag = [bgSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
            [buy_cell.m_buyImmediatelyButton setBackgroundImage:bgImag forState:UIControlStateNormal];
            [buy_cell.m_buyImmediatelyButton setBackgroundImage:bgSelecImag forState:UIControlStateHighlighted];
            [buy_cell.m_addShopCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
            return YES;
        }
    }
    else if (self.m_sku ==nil || [self.m_sku isEqualToString:@""]) 
    {
        UIAlertView *alert  = [[UIAlertView alloc ]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"请选择尺码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if ( [self.m_countTextField.text intValue]<1 || [self.m_countTextField.text  isEqualToString:@""]) 
    {
        UIAlertView *alert  = [[UIAlertView alloc ]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"购买数量最少为1" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else if ( [self.m_countTextField.text  intValue]>self.m_totalCount) 
    {
        UIAlertView *alert  = [[UIAlertView alloc ]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"库存不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

    return YES;
}

-(void)immediateCashWithShoppingcart{
	[Go2PageUtility showloginViewControlelr:self action:@selector(immediateCash) withObject:nil];

}

-(void)immediateCashWithoutShoppingcart{
	
	[Go2PageUtility showloginViewControlelr:self action:@selector(go2PayPriceCenterView) withObject:nil];
}

-(void)immediateCash
{
    //立即结算，将当前商口加入购物车并进入结算中心
	if ([YKUserInfoUtility isUserLogin])
	{
		SCNViewController* viewCtrl = KAppDelegate.viewController;
		[viewCtrl setSelectedIndex:3];
		UINavigationController *navC = [viewCtrl.viewControllers objectAtIndex:3];
		[navC popToRootViewControllerAnimated:NO];
		
		NSString* _productData = [SCNStatusUtility getShoppingcartData];
		SCNCashCenterViewController* cashCenter = [[SCNCashCenterViewController alloc]initWithNibName:@"SCNCashCenterViewController" bundle:nil];
		cashCenter.m_productData = _productData;
		cashCenter.m_CashType = ECashTypeCommon;
		
        [navC pushViewController:cashCenter animated:NO];
	}
}

-(void)go2PayPriceCenterView
{
    //立即购买，直接进结算中心
	if ([YKUserInfoUtility isUserLogin]) {		
		NSString *_productData = [NSString stringWithFormat:@"%@-%@-%@",self.m_productCode,self.m_sku,self.m_countTextField.text];
		SCNCashCenterViewController* cashCenter = [[SCNCashCenterViewController alloc]initWithNibName:@"SCNCashCenterViewController" bundle:nil];
		cashCenter.m_productData = _productData;
		cashCenter.m_CashType = ECashTypeImmediately;
		
		[self.navigationController pushViewController:cashCenter animated:YES];
	}
}
-(void)addShopingCar
{
    ShoppingCartData *cartData = [[ShoppingCartData alloc]init];
    cartData.mproductCode = self.m_productCode;
	cartData.msku = self.m_sku;
    cartData.mnumber = [self.m_countTextField.text intValue];
    [SCNStatusUtility saveShoppingcart:cartData];
	
//	UIAlertView* alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"该商品已成功加入购物车！" delegate:self cancelButtonTitle:@"继续购物" otherButtonTitles:@"立即结算",nil];
//	[alerView show];
//	[alerView release];
	[[NSNotificationCenter defaultCenter] postNotificationName:YK_SHOPPINGCART_CHANGE object:self];
	[self addShoppingcartBehavior];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 1) {
//        NSLog(@"立即结算");
//		[self immediateCashWithShoppingcart];
//    }

}
#pragma mark －
#pragma mark 加入收藏夹
-(void)request_addFavoriteInfoXmlData
{

    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:YK_METHOD_GET_ADDFAVORITE forKey:@"act"];
    [extraParamsDic setObject:self.m_productCode forKey:@"productCode"];
    [YKHttpAPIHelper startLoad:SCN_URL 
                   extraParams:extraParamsDic 
                        object:self 
                      onAction:@selector(onrequest_addFavoriteXmlData:)];
}
-(void)onrequest_addFavoriteXmlData:(GDataXMLDocument*)xmlDoc
{
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"该商品已成功加入收藏夹" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] postNotificationName:YK_COLLECTION_CHANGE object:nil userInfo:nil];
    }
}
#pragma mark -
#pragma mark 分享按钮点击
-(void)onActionShareButton:(id)sender
{
    int tag = ((share_CustomButton *)(sender)) .tag;
    switch (tag) {
        case Tag_share_sina:
        {
            NSLog(@"分享到新浪微博");
            break;
        }
        case Tag_share_tx:
        {
            NSLog(@"分享到腾讯微博");
            break;
        }
            break;
        case Tag_share_mail:
        {
            NSLog(@"分享到邮箱");
            break;
        }
            break;
        case Tag_share_note:
        {
            NSLog(@"分享到短信");
            break;
        }
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self hideKeyBorod]) {
        return;
    }
    if (indexPath.row == 2) {
        [Go2PageUtility go2MoreProductInfoViewController:self withProdectCode:self.m_productCode];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //m_heightOfRow = [[NSArray alloc] initWithObjects:@"160.0f",@"115.0f",@"50.0f",@"164.0f",@"109.0f", nil];
    int row = indexPath.row;
    if (row == 1) 
    {
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
    if(row == 3)
    {
		if ([self.m_productDetailDatas.m_product_data.mpstatus intValue] == 1) 
		{
			return 0;
		}
        return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    }
    float rowheight = [[m_heightOfRow objectAtIndex:row] floatValue];
    return  rowheight;
}

-(void)refreshNowProduct{
	SCNNowProductData* _nowProductData = [[SCNNowProductData alloc]init];
	_nowProductData.m_productName = m_productDetailDatas.m_product_data.mname;
	_nowProductData.m_productCode = self.m_productCode;
	
	[DataWorld shareData].m_nowProductData = _nowProductData;
}

-(void)addShoppingcartBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	//缓存来源Id
	NSInteger _curSrcPageId = [YKStatBehaviorInterface currentSourcePageId];
	[YKStatBehaviorInterface saveSourcePageId:_curSrcPageId withSku:self.m_productCode];
	//记录加入购物车动作
	NSString* _currentPageId = [NSString stringWithFormat:@"%d",[YKStatBehaviorInterface currentSourcePageId]];
	NSString* _behaviorParam = [NSString stringWithFormat:@"%@|%@|%@|%@",_currentPageId,self.m_countTextField.text,self.m_productDetailDatas.m_product_data.mname,self.m_productCode];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_ADDSHOPPINGCART param:_behaviorParam];
#endif
}

-(void)immediateBuyBehavior{
#ifdef USE_BEHAVIOR_ENGINE
    //缓存来源Id
	NSInteger _curSrcPageId = [YKStatBehaviorInterface currentSourcePageId];
	[YKStatBehaviorInterface saveSourcePageId:_curSrcPageId withSku:self.m_productCode];
    
    NSString* _currentPageId = [NSString stringWithFormat:@"%d",[YKStatBehaviorInterface currentSourcePageId]];
	NSString* _behaviorParam = [NSString stringWithFormat:@"%@|%@|%@|%@",_currentPageId,self.m_countTextField.text,self.m_productDetailDatas.m_product_data.mname,self.m_productCode];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_BUYIMMEDIATE param:_behaviorParam];
#endif
}

-(void)addFavoriteBehavior{
#ifdef USE_BEHAVIOR_ENGINE
    NSString* _currentPageId = [NSString stringWithFormat:@"%d",[YKStatBehaviorInterface currentSourcePageId]];
	NSString* _behaviorParam = [NSString stringWithFormat:@"%@|%@|%@",_currentPageId,self.m_productDetailDatas.m_product_data.mname,self.m_productCode];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_ADDFAVORITE param:_behaviorParam];
#endif
}

#pragma mark Behavior
-(void)BehaviorPageJump{
#ifdef USE_BEHAVIOR_ENGINE
#endif
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@|%@",m_productDetailDatas.m_product_data.mname,self.m_productCode];
	return _param;
#else
	return nil;
#endif
}

@end
