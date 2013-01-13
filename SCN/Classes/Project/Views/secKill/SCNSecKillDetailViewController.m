//
//  SCNSecKillDetailViewController.m
//  SCN
//
//  Created by yuanli on 11-10-18.
//  Copyright 2011 Yke.me. All rights reserved.
//

#import "SCNSecKillDetailViewController.h"

#import "SCN_productDetailViewController.h"
#import "SCN_BigImageViewController.h"
#import "SCNCashCenterViewController.h"
#import "Go2PageUtility.h"
#import "YKStatBehaviorInterface.h"
#import "YKHttpAPIHelper.h"
#import "HJManagedImageV.h"
#import "HJImageUtility.h"
#import "TextBlock.h"
#import "ModalAlert.h"
@implementation SCNSecKillDetailViewController
#define Tag_topScrollView 100
#define Tag_sizeScrollView 200

@synthesize m_tableView;
@synthesize m_secKillDatas;
@synthesize m_prodctCode,m_productSku,m_stock;
@synthesize m_sizeScrollView,m_topScrollView,m_pageController;
@synthesize m_leftButton,m_rightButton,m_secKilButton;
@synthesize m_sellPriceLable,m_nowPriceLable,m_remainCountLable,m_start_endLable,m_timeLable,m_secTitleLable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              withProductCode:(NSString *)productCode{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_prodctCode = productCode;
    }
    return self;
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
    self.title = @"秒杀详情";
	self.pathPath = @"/detail";
    // Do any additional setup after loading the view from its nib.
    self.m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.m_tableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotifyNoProduct:) name:YK_NO_PRODUCT object:nil];
	
    m_updateTime = [NSTimer scheduledTimerWithTimeInterval:0.5f 
                                                            target:self 
                                                          selector:@selector(autoUpdateTime:) 
                                                          userInfo:self 
                                                           repeats:YES];
	if (!self.isLoading) 
	{
		[self requestGetSecKillProductInfoXmlData];
	}
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:nil];
	
    if ([m_updateTime isValid]) {
        [m_updateTime invalidate];
        m_updateTime = nil;
    }
}

-(void)NotifyNoProduct:(NSNotification *)notify
{
	[self performSelector:@selector(go2product) withObject:nil afterDelay:0.05];
}

-(void)go2product
{
	NSString* productcode = self.m_prodctCode;
	UINavigationController* navctrl = self.navigationController;
	[navctrl popViewControllerAnimated:NO];
	
	[Go2PageUtility go2ProductDetailViewControllerWithNavCtrl:navctrl withProductCode:productcode withImage:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.m_tableView = nil;
    self.m_stock = nil;
    self.m_sizeScrollView = nil;
    self.m_topScrollView = nil;
    self.m_pageController = nil;
    
    self.m_leftButton = nil;
    self.m_rightButton = nil;
    self.m_secKilButton = nil;
    
    self.m_secTitleLable = nil;
    self.m_sellPriceLable = nil;
    self.m_nowPriceLable = nil;
    self.m_remainCountLable = nil;
    self.m_start_endLable = nil;
    self.m_timeLable = nil;
}
#pragma mark-
#pragma mark 立即秒杀
-(void)onActionSecondKill:(id)sender
{
        if (self.m_productSku ==nil || [self.m_productSku isEqualToString:@""]) 
        {
            UIAlertView *alert  = [[UIAlertView alloc ]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"请选择尺码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else if ([self.m_secKillDatas.m_skillInfo_data.mlimit isEqualToString:@"-1"])
        {
            if ([self.m_secKillDatas.m_total intValue] <= 0) 
            {
                UIAlertView *alert  = [[UIAlertView alloc ]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"该商品已秒杀完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return; 
            }
        }
        else
        {
            if ([self.m_secKillDatas.m_skillInfo_data.mlimit intValue] <= 0 ) 
            {
                UIAlertView *alert  = [[UIAlertView alloc ]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"该商品已秒杀完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    
        NSString *productData = [NSString stringWithFormat:@"%@-%@-%@",self.m_prodctCode,self.m_productSku,@"1"];
        SCNCashCenterViewController* cashCenter = [[SCNCashCenterViewController alloc] initWithNibName:@"SCNCashCenterViewController" bundle:nil];
		[Go2PageUtility go2CashCenterByShoppingType:self cashCenterViewCtrl:cashCenter withProductData:productData withCashType:ECashTypeSeckill];

		[self doSeckillBehavior];
}

-(BOOL)isProductSellOut
{
	if (!m_secKillDatas) 
	{
		return YES;
	}
	if (([m_secKillDatas.m_skillInfo_data.mlimit isEqualToString:@"-1"] && [m_secKillDatas.m_total intValue] <= 0)
		|| [m_secKillDatas.m_skillInfo_data.mlimit intValue] == 0
		|| ![self.m_secKillDatas.m_product_data.mpstatus isEqualToString:@"2"])
	{
		return YES;
	}
	return NO;
}

-(BOOL)isSeckillTimeing
{
	NSTimeInterval nowTime =  [SCNStatusUtility getNowTime];//服务器返回的当前时间
    CGFloat startORendTiem = [self.m_secKillDatas.m_skillInfo_data.mstartTime doubleValue] - nowTime;
	if (startORendTiem<0 &&([self.m_secKillDatas.m_skillInfo_data.mendTime doubleValue] - nowTime)>0) //距离秒杀结束
	{
		return YES;
	}
    else if(startORendTiem >0)//距离秒杀开始
    {
        return YES;
    }
	return NO;
}

-(BOOL)isSeckilling
{
	if ([self isSeckillTimeing] && ![self isProductSellOut])
	{
		return YES;
	}
	return NO;
}

#pragma mark-
#pragma mark 自动更新时间

-(int)getCurrentTimeState
{
	NSTimeInterval nowTime =  [SCNStatusUtility getNowTime];//服务器返回的当前时间
    CGFloat startORendTiem = [self.m_secKillDatas.m_skillInfo_data.mstartTime doubleValue] - nowTime;
	if (startORendTiem<0 &&([self.m_secKillDatas.m_skillInfo_data.mendTime doubleValue] - nowTime)>0)
	{
		//时间进行中
		return ESeckillDetailRunning;
	}
	else if(startORendTiem>0)
	{
		return ESeckillDetailUnStart;
	}
	else if(([self.m_secKillDatas.m_skillInfo_data.mendTime doubleValue] - nowTime)<0)
	{
		return ESeckillDetailEnd;
	}
	return ESeckillDetailUnStart;
}

-(void)autoUpdateTime:(id)sender
{
	NSTimeInterval nowTime =  [SCNStatusUtility getNowTime];//服务器返回的当前时间
	CGFloat startORendTiem = [self.m_secKillDatas.m_skillInfo_data.mstartTime doubleValue] - nowTime;
	
	int current_runState = [self getCurrentTimeState];
    if (ESeckillDetailRunning == current_runState) //距离秒杀结束
    {
        self.m_start_endLable.text = @"距结束:";

		if ([self isProductSellOut])
		{
			//售完了
			self.m_secKilButton.enabled = NO;
			UIImage *bgImag = [DataWorld getImageWithFile:@"com_blackbtn.png"];
			bgImag = [bgImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
			UIImage *bgSelecImag = [DataWorld getImageWithFile:@"com_blackbtn_SEL.png"];
			bgSelecImag = [bgSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
			[self.m_secKilButton setBackgroundImage:bgImag forState:UIControlStateNormal];
			[self.m_secKilButton setBackgroundImage:bgSelecImag forState:UIControlStateHighlighted];
			[self.m_secKilButton setTitle:@"该商品已售完" forState:UIControlStateNormal];
		}
		else
		{
			//立即秒杀
			self.m_secKilButton.enabled = YES;
			UIImage *bgImag = [DataWorld getImageWithFile:@"com_button_normal.png"];
			bgImag = [bgImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
			UIImage *bgSelecImag = [DataWorld getImageWithFile:@"com_button_select.png"];
			bgSelecImag = [bgSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
			[self.m_secKilButton setBackgroundImage:bgImag forState:UIControlStateNormal];
			[self.m_secKilButton setBackgroundImage:bgSelecImag forState:UIControlStateHighlighted];
			[self.m_secKilButton setTitle:@"立即秒杀" forState:UIControlStateNormal];
		}
        startORendTiem = [self.m_secKillDatas.m_skillInfo_data.mendTime  doubleValue] - nowTime;
    }
    else if(ESeckillDetailUnStart == current_runState)//距离秒杀开始
    {
        self.m_start_endLable.text = @"距开始:";
		self.m_secKilButton.enabled = NO;
		current_runState = -1;
		UIImage *bgImag = [DataWorld getImageWithFile:@"com_blackbtn.png"];
		bgImag = [bgImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
		UIImage *bgSelecImag = [DataWorld getImageWithFile:@"com_blackbtn_SEL.png"];
		bgSelecImag = [bgSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
		[self.m_secKilButton setBackgroundImage:bgImag forState:UIControlStateNormal];
		[self.m_secKilButton setBackgroundImage:bgSelecImag forState:UIControlStateHighlighted];
		[self.m_secKilButton setTitle:@"即将开始" forState:UIControlStateNormal];

    }
	else if(ESeckillDetailEnd == current_runState)
	{
		self.m_start_endLable.text = @"已结束:";
		self.m_secKilButton.enabled = NO;
		current_runState = 1;
		UIImage *bgImag = [DataWorld getImageWithFile:@"com_blackbtn.png"];
		bgImag = [bgImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
		UIImage *bgSelecImag = [DataWorld getImageWithFile:@"com_blackbtn_SEL.png"];
		bgSelecImag = [bgSelecImag stretchableImageWithLeftCapWidth:12 topCapHeight:12];
		[self.m_secKilButton setBackgroundImage:bgImag forState:UIControlStateNormal];
		[self.m_secKilButton setBackgroundImage:bgSelecImag forState:UIControlStateHighlighted];
		[self.m_secKilButton setTitle:@"秒杀结束" forState:UIControlStateNormal];
		self.m_timeLable.text  = @"本次秒杀已经结束";
	}
	
	if (current_runState != ESeckillDetailEnd)
	{
		NSString *dataStr = nil;
		if (startORendTiem < 60) 
		{//秒
			int sec = startORendTiem;
			dataStr = [NSString stringWithFormat:@"00小时00分%d秒",sec];
		}
		else if (startORendTiem < 60 * 60) 
		{  //分
			int minute = startORendTiem / 60;
			int sec =  (int)startORendTiem % 60; 
			dataStr = [NSString stringWithFormat:@"00小时%d分%d秒",minute,sec];
		}  
		else 
		{//时
			int hour = startORendTiem/60/60;
			int minute = (startORendTiem - hour*60*60) / 60;
			int sec  = (int)startORendTiem % 60;
			dataStr = [NSString stringWithFormat:@"%d小时%d分%d秒",hour,minute,sec];
		}
		self.m_timeLable.text = dataStr;
	}
	if (current_runState != m_runningState)
	{
		m_runningState = current_runState;
		[self.m_tableView reloadData];
	}
}

#pragma mark-
#pragma mark 进入大图页面
-(void)onAction_go2BigImageViewController:(UIView*)sender
{
	int index = sender.tag;
    [Go2PageUtility go2BigImageViewController:self withImageUrlArr:self.m_secKillDatas.m_bigImagesArr withIndex:index];
}
#pragma mark-
#pragma mark 请求网络
-(void)requestGetSecKillProductInfoXmlData
{
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:YK_METHOD_GET_SECKILLPRODUCTINFO forKey:@"act"];
    [extraParamsDic setObject:self.m_prodctCode !=nil ? self.m_prodctCode:@"" forKey:@"productCode"];

    [self startLoading];
    [YKHttpAPIHelper startLoad:SCN_URL 
                   extraParams:extraParamsDic 
                        object:self 
                      onAction:@selector(onRequest_getSecKillProductInfoXmlData:)];
}
-(void)onRequest_getSecKillProductInfoXmlData:(GDataXMLDocument*)xmlDoc
{
	[self stopLoading];
    if ([SCNStatusUtility isRequestSuccess:xmlDoc])
	{		
        self.m_secKillDatas = nil;
        self.m_secKillDatas = [SCNProductDetailData parserXmlDatas:xmlDoc IsSkill:YES];
		
		m_runningState = [self getCurrentTimeState];
        [self.m_tableView reloadData];

		[super BehaviorPageJump];
    }
//	
//	NSTimeInterval nowTime =  [SCNStatusUtility getNowTime];
//	self.m_secKillDatas.m_skillInfo_data.mstartTime = [NSString stringWithFormat:@"%f",nowTime +10];
//	self.m_secKillDatas.m_skillInfo_data.mendTime = [NSString stringWithFormat:@"%f",nowTime +50];
}
#pragma mark －
#pragma mark 排列 顶部图片
-(void)layout_TopScrollView:(SCN_SecKillDetail_tabelCell_One *)first_cell
{
    
    self.m_topScrollView = first_cell.m_topScrollV;
	for (UIView * vi in self.m_topScrollView.subviews) 
	{
		[vi removeFromSuperview];
	}
    self.m_topScrollView.tag = Tag_topScrollView;
    self.m_topScrollView.delegate = self;
    self.m_topScrollView.spacing = 40;
    
    [self.m_topScrollView setToNavi];
    
    for (int i=0; i<[self.m_secKillDatas.m_smallImagesArr count]; i++) {
        HJManagedImageV *hjTopPicView = [[HJManagedImageV alloc]initWithFrame:CGRectMake(0, 0, 210, 210)];
        [hjTopPicView setImage:[DataWorld getImageWithFile:@"com_loading210x210.png"]];
        hjTopPicView.userInteractionEnabled = YES;
        hjTopPicView.backgroundColor = [UIColor whiteColor];
        [self.m_topScrollView addSubview:hjTopPicView];
        if ( [hjTopPicView.layer respondsToSelector:@selector(setShadowOffset:)] ) {//设置阴影效果
            [hjTopPicView.layer setShadowOffset:CGSizeMake(5, 5)];
            [hjTopPicView.layer setShadowRadius:2];
            [hjTopPicView.layer setShadowOpacity:0.8]; 
            [hjTopPicView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
        }
		hjTopPicView.layer.borderWidth = 1;
		hjTopPicView.layer.borderColor = YK_IMAGEBORDER_COLOR.CGColor;
		
        UIButton *TopViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        TopViewButton.backgroundColor = [UIColor clearColor];
        TopViewButton.frame = CGRectMake(0, 0, 210, 210);
        [TopViewButton addTarget:self action:@selector(onAction_go2BigImageViewController:) 
                forControlEvents:UIControlEventTouchUpInside];
		TopViewButton.tag = i;
        [hjTopPicView addSubview:TopViewButton];
        
        [HJImageUtility queueLoadImageFromUrl:[self.m_secKillDatas.m_smallImagesArr objectAtIndex:i]
                                    imageView:hjTopPicView];
    }
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 210)];
    [self.m_topScrollView addSubview:view];

//    self.m_pageController = first_cell.m_pageController;
//    self.m_pageController.numberOfPages = 5;
    
    
    self.m_sellPriceLable = first_cell.m_sellPriceLable;
    self.m_nowPriceLable = first_cell.m_nowPriceLable;
    self.m_remainCountLable = first_cell.m_remainCountLable;
    self.m_secTitleLable  = first_cell.m_titleLable;
    
    self.m_secTitleLable.text = self.m_secKillDatas.m_skillInfo_data.mtitle;
    self.m_sellPriceLable.text = [SCNStatusUtility getPriceString:self.m_secKillDatas.m_product_data.mmarketPrice];
    self.m_nowPriceLable.text = [SCNStatusUtility getPriceString:self.m_secKillDatas.m_product_data.msellPrice];
    //self.m_secKillDatas.m_skillInfo_data.mlimit = @"-1";

	if ([self isSeckillTimeing] && [self isProductSellOut])
	{
		self.m_remainCountLable.text = @"0件";
	}
	else if ([self.m_secKillDatas.m_skillInfo_data.mlimit isEqualToString:@"-1"])
    {
		NSString* total = strOrEmpty(self.m_secKillDatas.m_total);
		if ([total length] == 0) {
			total = @"0";
		}
        self.m_remainCountLable.text = [NSString stringWithFormat:@"%@件",total];
    }
    else
    {
		NSString* total = strOrEmpty(self.m_secKillDatas.m_skillInfo_data.mlimit);
		if ([total length] == 0) {
			total = @"0";
		}
		
        self.m_remainCountLable.text = [NSString stringWithFormat:@"%@件",total];
    }
    
    
}
#pragma mark －
#pragma mark 排列 选择尺寸
-(void)layout_SizeScrollView:(HLayoutView *)sizeScrollview
{
    self.m_sizeScrollView = sizeScrollview;
	for (UIView *vi in sizeScrollview.subviews) {
		[vi removeFromSuperview];
	}
    sizeScrollview.spacing = 6;
    [sizeScrollview setToNavi];
    sizeScrollview.pagingEnabled = NO;
    for (int i=0; i<[self.m_secKillDatas.m_sizeArr count]; i++) {
        sizes_Data *_sizeData = (sizes_Data *)[self.m_secKillDatas.m_sizeArr objectAtIndex:i];
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
        
        if ([self.m_productSku isEqualToString:_sizeData.msku])
        {
            [self onAction_checkSize:checkSizeButton];
        }
        [sizeScrollview addSubview:checkSizeButton];
        
    }
}
-(void)onAction_checkSize:(id)sender
{
    CustomButton *checkButton = (CustomButton *)sender;
    if (checkButton.isCheck == NO) {
        [self removeImageFromCustomButton:self.m_sizeScrollView];
        [checkButton setBackgroundImage:[DataWorld getImageWithFile:@"seckillDetail_sizeBg_SEL.png"] forState:UIControlStateNormal];
        checkButton.isCheck = YES;
        self.m_productSku = checkButton.sizeSku;
        self.m_stock = checkButton.sizeStocks;
    }else{
        return;
//        [checkButton setBackgroundImage:[DataWorld getImageWithFile:@"seckillDetail_sizeBg.png"] forState:UIControlStateNormal];
//        checkButton.isCheck = NO;
//        self.m_productSku = @"";
    }
//    [self UpdateProductInfo:sender];
}
#pragma mark －
#pragma mark SwitchSizeDelegate
-(void)updateCurrentSize:(NSString *)Scode
{
    if ([self.m_productSku isEqualToString:Scode]) {
        return;
    }else{
        for (CustomButton *sizeBt in [self.m_sizeScrollView subviews] ) {
            if ([sizeBt.sizeSku isEqualToString:Scode]) {
                [self onAction_checkSize:sizeBt];
            }
        }
    }
}
#pragma mark-
#pragma mark 更新不同尺寸下的库存
-(void)UpdateProductInfo:(id)sender
{
    CustomButton *checkButton = (CustomButton *)sender;
    self.m_remainCountLable.text = [NSString stringWithFormat:@"%@件",checkButton.sizeStocks];
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
-(void)onActionSwitchSize:(id)sender
{
    NSLog(@"触发尺码转换");
    SCN_SwitchSizeViewController *sizeSwitch = 
                                               [[SCN_SwitchSizeViewController alloc]initWithNibName:@"SCN_SwitchSizeViewController" 
                                                                                             bundle:nil 
                                                                                            withSex:self.m_secKillDatas.m_product_data.msex
                                                                                          withBrand:self.m_secKillDatas.m_product_data.mbrand 
                                                                                         withSkuArr:self.m_secKillDatas.m_sizeArr];
    [self presentModalViewController:sizeSwitch animated:YES];
}
#pragma mark-
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self fixScrollowView:scrollView];
        [self ifHidenForAllertScroll:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixScrollowView:scrollView];
    [self ifHidenForAllertScroll:scrollView];
}
-(void)ifHidenForAllertScroll:(UIScrollView *)Scrollview
{
    if (Scrollview.tag==Tag_topScrollView) {
       self.m_pageController.currentPage = self.m_topScrollView.contentOffset.x/311;
    }else if(Scrollview.tag==Tag_sizeScrollView){
        if (self.m_sizeScrollView.contentOffset.x <=0) 
        {
            self.m_leftButton.hidden = YES;
            self.m_rightButton.hidden = NO;
        }
        else if((self.m_sizeScrollView.contentSize.width - self.m_sizeScrollView.contentOffset.x)<=self.m_sizeScrollView.frame.size.width)
        {
            self.m_rightButton.hidden = YES;
            self.m_leftButton.hidden =  NO;
        
        }
        else
        {
            self.m_rightButton.hidden = NO;
            self.m_leftButton.hidden =  NO;
        }
    
    }
}
-(void)fixScrollowView:(UIScrollView *)scrollView
{
    if (scrollView.tag == Tag_sizeScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        int m =  x/49;
        CGFloat ishalf = x-m*49-24;
        if (ishalf>0) 
        {
            m++;
        }
        [scrollView setContentOffset:CGPointMake(49*m, 0) animated:YES];
    }
    
    
}

#pragma mark-
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            return 329.0f;
        }
            break;
        case 1:
        {
            return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
        }
            break;
        case 2:
        {
			if ([self isSeckilling]) {
				return 51.0f;
			}
			else
			{
				return 0;
			}
            
        }
            break;
        case 3:
        {
            return 50.0f;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [Go2PageUtility go2MoreProductInfoViewController:self withProdectCode:self.m_prodctCode];
    }
}
#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    if (self.m_secKillDatas != nil) {
        return 4;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    NSString *SecKillOne_CellIdentifier = @"SecKillOne_Cell";
    NSString *SecKillTwo_CellIdentifier = @"SecKillTwo_Cell";
    NSString *SecKillMore_CellIdentifier = @"SecKillMore_Cell";
    NSString *SecKillSize_CellIdentifier = @"SecKillSize_Cell";
    
    UITableViewCell *cell = nil;
        switch (row) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:SecKillOne_CellIdentifier];
                if (cell == nil)
				{
					NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNSecKillListTableCell" owner:self options:nil];
					cell = [cellNib objectAtIndex:1];
                }
				SCN_SecKillDetail_tabelCell_One *first_cell = (SCN_SecKillDetail_tabelCell_One *)cell;
				[self layout_TopScrollView:(SCN_SecKillDetail_tabelCell_One *)first_cell];
            }
                break;
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:SecKillTwo_CellIdentifier];
                if (cell == nil) 
                {
                    
                    NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNSecKillListTableCell" owner:self options:nil];    
                    SCN_SecKillDetail_tabelCell_Two *two_cell = (SCN_SecKillDetail_tabelCell_Two *)[cellNib objectAtIndex:2];
                    [two_cell.m_secKil addTarget:self action:@selector(onActionSecondKill:) forControlEvents:UIControlEventTouchUpInside];
                    cell = two_cell;
                }
				SCN_SecKillDetail_tabelCell_Two *two_cell = (SCN_SecKillDetail_tabelCell_Two *)cell;
				self.m_start_endLable = two_cell.m_statr_EndLable;
				self.m_timeLable = two_cell.m_timeLable;
				self.m_secKilButton = two_cell.m_secKil;
				two_cell.m_secDescLable.text = self.m_secKillDatas.m_skillDesc;
				CGFloat cellY = CGRectGetMaxY(two_cell.m_secDescLable.frame);
				if (two_cell.m_secDescLable.text.length>0) 
				{
					cellY = CGRectGetMaxY(two_cell.m_secDescLable.frame)+10;
				}
				cell.frame = CGRectMake(0, 0, 320, cellY);
				[self autoUpdateTime:nil];
            }
                break;
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:SecKillMore_CellIdentifier];
                if (cell == nil) 
				{
					NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNSecKillListTableCell" owner:self options:nil];    
					SCN_SecKillDetail_tabelCell_More *more_cell = (SCN_SecKillDetail_tabelCell_More *)[cellNib objectAtIndex:3];
					more_cell.m_backImageV.backgroundColor  = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:0.8f];
				   // more_cell.m_descLable.text = self.m_secKillDatas.m_desc;
					more_cell.m_descLable.text = @"咨询信息,评论信息,品牌,商品编号......";
					cell = more_cell;
                }
            }
                break;
            case 2:
            {
				//尺码
                cell = [tableView dequeueReusableCellWithIdentifier:SecKillSize_CellIdentifier];
                if (cell == nil) 
				{
					NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNSecKillListTableCell" owner:self options:nil];    
					cell = [cellNib objectAtIndex:4];
					SCN_SecKillDetail_tabelCell_Size *four_cell = (SCN_SecKillDetail_tabelCell_Size *)cell;
					[four_cell.m_siwtchSizeButton addTarget:self action:@selector(onActionSwitchSize:) forControlEvents:UIControlEventTouchUpInside];
                }
				
				SCN_SecKillDetail_tabelCell_Size *four_cell = (SCN_SecKillDetail_tabelCell_Size *)cell;
				[self layout_SizeScrollView:four_cell.m_sizeScrollView];
				self.m_leftButton = four_cell.m_leftButton;
				self.m_rightButton = four_cell.m_rightButton;
				self.m_sizeScrollView = four_cell.m_sizeScrollView;
				self.m_sizeScrollView.tag = Tag_sizeScrollView;
				self.m_sizeScrollView.delegate = self;
				if (self.m_secKillDatas.m_product_data.msex == nil ||[self.m_secKillDatas.m_product_data.msex isEqualToString:@""]) {
					four_cell.m_siwtchSizeButton.hidden = YES;
				}else 
				{
					four_cell.m_siwtchSizeButton.hidden = NO;
				}
				
				if ([self.m_secKillDatas.m_sizeArr count]<5)
				{
					self.m_rightButton.hidden = YES;
					self.m_leftButton.hidden = YES;
				}
				else
				{
					self.m_leftButton.hidden = YES;
				}
				
				if ([self isSeckilling]) 
				{
					four_cell.hidden = NO;
				}
				else
				{
					four_cell.hidden = YES;
				}
            }
                break;
            default:
                break;
        }
    return cell;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Behavior
-(void)BehaviorPageJump{
#ifdef USE_BEHAVIOR_ENGINE
#endif
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|商品ID
	NSString* _param = [NSString stringWithFormat:@"%@|%@",self.m_secKillDatas.m_product_data.mname,self.m_prodctCode];
	return _param;
#else
	return nil;
#endif
}

-(void)doSeckillBehavior{
#ifdef USE_BEHAVIOR_ENGINE
    //缓存来源Id
	NSInteger _curSrcPageId = [YKStatBehaviorInterface currentSourcePageId];
	[YKStatBehaviorInterface saveSourcePageId:_curSrcPageId withSku:self.m_prodctCode];
    
    NSString* _currentPageId = [NSString stringWithFormat:@"%d",[YKStatBehaviorInterface currentSourcePageId]];
	//来源id|数量|商品名称|sku
	NSString* _seckillParam = [NSString stringWithFormat:@"%@|%d|%@|%@",_currentPageId,1,self.m_secKillDatas.m_product_data.mname,self.m_prodctCode];
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_SECKILL param:_seckillParam];
#endif
}
@end
