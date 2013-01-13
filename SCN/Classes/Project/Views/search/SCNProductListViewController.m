//
//  SCNProductListViewController.m
//  SCN
//
//  Created by x x on 11-10-8.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNProductListViewController.h"
#import "SCNProductListModeTableCell.h"
#import "SCNProductImageModeTableCell.h"
#import "SCNStatusUtility.h"
#import "SCNDataInterface.h"
#import "YKHttpAPIHelper.h"
#import "HJImageUtility.h"
#import "Go2PageUtility.h"
#import "SCNSearchData.h"
#import "YKStringHelper.h"
#import "SCNHomeData.h"
#import "SCNHomeViewController.h"
#import "SCNSecKillDetailViewController.h"

@implementation SCNProductListViewController
#define TABLEVIEWCELL_LABEL_TAG 222
#define PRODUCTLIST_TABLEVIEW_HEADER_HEIGHT 20
#define LISTMODECHANGE_BUTTON_TAG 998
#define FILTER_BUTTON_TAG 999
#define degreesToRadians(degrees) (M_PI * degrees / 180.0)
#define NearHotSaleScrollView 320
#define HotSellViewTag 111
//重力加速计相关
#define kAccelerometerFrequency			25 //Hz
#define kFilteringFactor				0.1
#define kMinEraseInterval				0.5
#define kEraseAccelerationThreshold		2.0

@synthesize m_button_newProduct;
@synthesize m_button_price;
@synthesize m_button_saleCount;
@synthesize m_array_productList;
@synthesize m_tableView_productList;
@synthesize m_string_keyword;
@synthesize m_string_categoryId;
@synthesize m_label_pageSchedule;
@synthesize m_view_noResult;
@synthesize m_imageView_priceSort;
@synthesize m_imageView_newSort;
@synthesize m_imageView_sellSort;
@synthesize m_string_type;
@synthesize m_string_brandId;
@synthesize _isSearch;
@synthesize m_dict_filterData;
@synthesize m_dict_userFilterData;
@synthesize m_string_filterContent;
@synthesize m_data_listAttributeData;
@synthesize m_number_requestID;
@synthesize m_string_typeId;
@synthesize m_string_typeName;
@synthesize m_label_hotSellTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keyword:(NSString *)keyword categoryId:(NSString*)categoryid  isSearch:(BOOL)isSearch brandID:(NSString*)brandid  typeId:(NSString*)typeId type:(NSString*)type{
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            self.m_string_keyword=keyword; 
            _isListMode=YES;
            m_int_currPage=1;
            m_int_lastPage=0;
            m_int_currPageSize=20;
            m_int_sorttype=SortToOldProduct;
            m_int_lastSortBtn=1;
            _isSearch=isSearch;
            
            self.m_string_categoryId=categoryid;
            self.m_string_brandId=brandid;
            self.m_string_type=type;
            self.m_string_typeId=typeId;//这个typeid不是商品类型的id，而是告诉服务器端这个是来自专题的数据请求
        }
        return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isSearch) {
        self.pathPath = @"/searchlist";
    }else if(!_isSearch && [m_string_categoryId length] > 0){
        self.pathPath = @"/catelist";
    }else if([self isActivityList]){
        self.pathPath = @"/commonTopic";
    }
	
    // Do any additional setup after loading the view from its nib.
    //初始化商品数组
    self.m_array_productList=[NSMutableArray arrayWithCapacity:0];
    //初始化商品属性
    SCNSearchProductListData *tempdata = [[SCNSearchProductListData alloc] init];
    self.m_data_listAttributeData=tempdata;
    //给进度条切圆角
    self.m_label_pageSchedule.layer.cornerRadius=5.0;
    
    self.m_tableView_productList.delegate=self;
    self.m_tableView_productList.dataSource=self;
    
    
    if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {
        CGRect tvframe = [self.m_tableView_productList frame];
        [self.m_tableView_productList setFrame:CGRectMake(tvframe.origin.x,
                                                          tvframe.origin.y,
                                                          tvframe.size.width,
                                                          tvframe.size.height +  568 - 480 )];
    }

    
    
    //设置重力加速计
//    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
//    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
    //添加自定义导航栏的右按钮
    [self rightNavigationItemCreate];
	[self resetDataSource];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//	if(_isListMode){
//		self.pathPath = @"/list";
//	}else {
//		self.pathPath = @"/listimage";
//	}
    
    if (_isSearch) {
        self.pathPath = @"/searchlist";
    }else if(!_isSearch && [m_string_categoryId length] > 0){
        self.pathPath = @"/catelist";
    }else if([self isActivityList]){
        self.pathPath = @"/commonTopic";
    }
	
	[super BehaviorPageJump];

	[self dealAllView:YES];
	
//	if([self isActivityList]) 
//	{
//		[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG] setHidden:YES];
//	}
	[self adjustNaviBtn];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isRequesting && m_number_requestID!=nil)
	{
		NSLog(@"取消最近的一次请求ID<><><><><><><><><><><>%@",m_number_requestID);
        [YKHttpAPIHelper cancelRequestByID:m_number_requestID];
		self.m_number_requestID = nil;
		_isRequesting = NO;
    }
	[self dealAllView:NO];
}

-(void)dealAllView:(BOOL)isEnter
{
    //隐藏商品浏览进度
    self.m_label_pageSchedule.alpha=0;
	
	if (!_isRequestSuccess && isEnter)
	{
		self.m_tableView_productList.hidden = YES;
		self.m_view_noResult.hidden = YES;
		[self requestProductList:m_int_currPage];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.m_button_newProduct=nil;
    self.m_button_price=nil;
    self.m_button_saleCount=nil;
    self.m_tableView_productList=nil;
    self.m_label_pageSchedule=nil;
    self.m_view_noResult=nil;
	
	[self resetDataSource];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
	m_number_requestID=nil;
}
#pragma -
#pragma mark 设置导航栏右边按钮
-(void)rightNavigationItemCreate{
    
    UIButton *rightbuttonfirst=[UIButton buttonWithType:UIButtonTypeCustom];
	UIButton *rightbuttonsecond=[UIButton buttonWithType:UIButtonTypeCustom];

	[rightbuttonfirst setBackgroundColor:[UIColor clearColor]];
    //[rightbuttonsecond setBackgroundColor:[UIColor clearColor]];
    rightbuttonfirst.tag=LISTMODECHANGE_BUTTON_TAG;
    rightbuttonsecond.tag=FILTER_BUTTON_TAG;
    [rightbuttonfirst setImage:[DataWorld getImageWithFile:@"com_button_imageModel.png"] forState:UIControlStateNormal];
    [rightbuttonfirst setImage:[DataWorld getImageWithFile:@"com_button_imageModel_SEL.png"] forState:UIControlStateHighlighted];
    [rightbuttonsecond setTitle:@"筛选" forState:UIControlStateNormal];
	[rightbuttonsecond.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [rightbuttonsecond setBackgroundImage:[DataWorld getImageWithFile:@"com_btn.png"] forState:UIControlStateNormal];
    [rightbuttonsecond setBackgroundImage:[DataWorld getImageWithFile:@"com_btn_SEL.png"] forState:UIControlStateHighlighted];
    [rightbuttonfirst addTarget:self action:@selector(onActionModeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [rightbuttonsecond addTarget:self action:@selector(onActionFilterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
    [rightbuttonfirst setAdjustsImageWhenHighlighted:NO];
    [rightbuttonsecond setAdjustsImageWhenHighlighted:NO];
	
    UIView *rightNavBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 32)];
	[rightNavBarView addSubview:rightbuttonfirst];
	[rightNavBarView addSubview:rightbuttonsecond];

	UIBarButtonItem *bar=[[UIBarButtonItem alloc] initWithCustomView:rightNavBarView];
	self.navigationItem.rightBarButtonItem=bar;
	
	[self adjustNaviBtn];
}


#pragma -
#pragma mark 列表种类事件处理
-(void)resetDataSource
{
	_isRequestSuccess = NO;
    [self.m_array_productList removeAllObjects];
    [self.m_tableView_productList reloadData];
    m_int_lastPage=0;
    m_int_currPage=1;
    m_int_currPageSize=20;
    //隐藏没有结果界面
    [self.m_view_noResult setHidden:YES];
	self.m_tableView_productList.hidden = YES;
    //隐藏商品浏览进度
    self.m_label_pageSchedule.alpha=0;
}

-(void)startViewAnimation:(UIImageView*)imgView degreesToRadians:(int)degree{
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.2];
    imgView.transform = CGAffineTransformMakeRotation(degreesToRadians(degree));
    [UIView commitAnimations];      
}
-(IBAction)onActionSortTypeButtonPressed:(id)sender{
    //Tag为上面80x40的透明按钮。+100为箭头，+200为变化的按钮
    UIButton *currButton=(UIButton*)sender;
    int currTag=currButton.tag;
    if (m_int_lastSortBtn!=currTag) {
        [(UIButton*)[self.view viewWithTag:m_int_lastSortBtn+200] setSelected:NO];
        [(UIImageView*)[self.view viewWithTag:m_int_lastSortBtn+100] setHidden:YES];
    }
    [(UIButton*)[self.view viewWithTag:currTag+200] setSelected:YES];
    [(UIImageView*)[self.view viewWithTag:currTag+100] setHidden:NO];
    m_int_lastSortBtn=currTag;
    switch (currTag) {
        case 1://新品按钮
//            _isNewSortUp=!_isNewSortUp;
			if( m_int_sorttype==SortToOldProduct)
			{
				return;
			}else
			{
				m_int_sorttype=SortToOldProduct;
			}

//            if (_isNewSortUp) {
//                m_int_sorttype=SortToNewProduct;
//                //[currButton setTitle:@"新品旧新" forState:UIControlStateNormal];
//                [self startViewAnimation:m_imageView_newSort degreesToRadians:180];
//            }else{
//                m_int_sorttype=SortToOldProduct;
//                //[currButton setTitle:@"新品新旧" forState:UIControlStateNormal];
//                [self startViewAnimation:m_imageView_newSort degreesToRadians:0];
//            }

            break;
        case 2:{//价格
            _isPriceSortUp=!_isPriceSortUp;
            if (_isPriceSortUp) {
                m_int_sorttype=PriceUp;
                //[currButton setTitle:@"价格低高" forState:UIControlStateNormal];
                [self startViewAnimation:m_imageView_priceSort degreesToRadians:180];
            }else{
                m_int_sorttype=PriceDrop;
                //[currButton setTitle:@"价格高低" forState:UIControlStateNormal];
                [self startViewAnimation:m_imageView_priceSort degreesToRadians:0];
            }
            break;
        }    
        case 3:{//销量
//            _isSellSortUp=!_isSellSortUp;
			if(m_int_sorttype==SellCountUp)
			{
				return;
			}else
			{
				m_int_sorttype=SellCountUp;
			}

//            if (_isSellSortUp) {
//                m_int_sorttype=SellCountUp;
//                //[currButton setTitle:@"销量低高" forState:UIControlStateNormal];
//                [self startViewAnimation:m_imageView_sellSort degreesToRadians:180];
//            }else{
//                m_int_sorttype=SellCountDrop;
//                //[currButton setTitle:@"销量高低" forState:UIControlStateNormal];
//                [self startViewAnimation:m_imageView_sellSort degreesToRadians:0];
//            }
            break;
        }
        default:
            break;
    }
    [self resetDataSource];
    [self requestProductList:m_int_currPage];
}

#pragma -
#pragma mark 模式选择
-(void)onActionModeButtonPressed:(id)sender{
    _isListMode=!_isListMode;
    if (_isListMode) {//列表模式时显示图片模式图片
		//self.pathPath = @"/list";
        [self.m_tableView_productList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [sender setImage:[DataWorld getImageWithFile:@"com_button_imageModel.png"] forState:UIControlStateNormal];
        [sender setImage:[DataWorld getImageWithFile:@"com_button_imageModel_SEL.png"] forState:UIControlStateHighlighted];
    }else{
		//self.pathPath = @"/listimage";
        [self.m_tableView_productList setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [sender setImage:[DataWorld getImageWithFile:@"com_button_listModel.png"] forState:UIControlStateNormal];
        [sender setImage:[DataWorld getImageWithFile:@"com_button_listModel_SEL.png"] forState:UIControlStateHighlighted];
    }
    
    if (_isSearch) {
        self.pathPath = @"/searchlist";
    }else if(!_isSearch && [m_string_categoryId length] > 0){
        self.pathPath = @"/catelist";
    }else if([self isActivityList]){
        self.pathPath = @"/commonTopic";
    }
    
	[super BehaviorPageJump];
    [self.m_tableView_productList reloadData];
}

#pragma -
#pragma mark 重力加速计 UIAccelerometerDelegate
//手机晃动切换模式
// Called when the accelerometer detects motion; plays the erase sound and redraws the view if the motion is over a threshold.
- (void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    //NSLog(@"检测晃动");
	UIAccelerationValue	length,x,y,z;
	
	//Use a basic high-pass filter to remove the influence of the gravity
	m_myAccelerometer[0] = acceleration.x * kFilteringFactor + m_myAccelerometer[0] * (1.0 - kFilteringFactor);
	m_myAccelerometer[1] = acceleration.y * kFilteringFactor + m_myAccelerometer[1] * (1.0 - kFilteringFactor);
	m_myAccelerometer[2] = acceleration.z * kFilteringFactor + m_myAccelerometer[2] * (1.0 - kFilteringFactor);
	// Compute values for the three axes of the acceleromater
	x = acceleration.x - m_myAccelerometer[0];
	y = acceleration.y - m_myAccelerometer[0];
	z = acceleration.z - m_myAccelerometer[0];
	
	//Compute the intensity of the current acceleration 
	length = sqrt(x * x + y * y + z * z);
	// If above a given threshold,切换模式
	if((length >= kEraseAccelerationThreshold) && (CFAbsoluteTimeGetCurrent() > m_lastTime + kMinEraseInterval)) {
		_isListMode=!_isListMode;
        UIButton *modeBtn=(UIButton*)[self.navigationItem.rightBarButtonItem.customView viewWithTag:LISTMODECHANGE_BUTTON_TAG];
        if (_isListMode) {
            [modeBtn setImage:[DataWorld getImageWithFile:@"com_button_imageModel.png"] forState:UIControlStateNormal];
            [modeBtn setImage:[DataWorld getImageWithFile:@"com_button_imageModel_SEL.png"] forState:UIControlStateHighlighted];

        }else{
            [modeBtn setImage:[DataWorld getImageWithFile:@"com_button_listModel.png"] forState:UIControlStateNormal];
            [modeBtn setImage:[DataWorld getImageWithFile:@"com_button_listModel_SEL.png"] forState:UIControlStateHighlighted];
        }
        [self.m_tableView_productList reloadData];

		m_lastTime = CFAbsoluteTimeGetCurrent();
	}
}

#pragma -
#pragma mark 筛选
-(void)onActionFilterButtonPressed:(id)sender{
    if ([self.m_dict_filterData count]>0)
	{
        [Go2PageUtility go2ProductFilterViewController:self withFilterDataDict:self.m_dict_filterData];
    }
	else
	{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"对不起,当前没有筛选条件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma -
#pragma mark UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView==self.m_tableView_productList) {
//        //处理浏览进度条显示动画
//        NSLog(@"上一页%d<><><><><><><><><><><><><><><下一页%d",m_int_lastPage,m_int_currPage);
//        if (m_int_lastPage<m_int_currPage) {//如果记录的上一页与当前页不同
//            //设置浏览进度label上的标题，如1/10页
//            NSString *labelTag=[NSString stringWithFormat:@"%d/%@页",m_int_currPage,m_data_listAttributeData.mtotalPage];
//            NSLog(@"浏览进度<><><><><><><>%@",labelTag);
//            [self.m_label_pageSchedule setText:labelTag];
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDelay:2];
//            self.m_label_pageSchedule.alpha=0.6;
//            [UIView commitAnimations];
//        }
//        m_int_lastPage=m_int_currPage;
//    }
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    //商品列表视图
//    if (scrollView==self.m_tableView_productList) {
//        //处理浏览进度条隐藏动画
//        if (self.m_label_pageSchedule.alpha!=0) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDelay:2];
//            self.m_label_pageSchedule.alpha=0;
//            [UIView commitAnimations];
//        }
//    }
//}

#pragma -
#pragma mark 跳转到商品详情

-(void)goToProductDetailViewController:(id)sender{
    SCNProductButton *currentBtn=(SCNProductButton*)sender;
    [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:currentBtn.productCode withPstatus:currentBtn.pstatus withImage:currentBtn.imagePath];
    NSLog(@"-----productCode%@--------sku%@------tag%@",currentBtn.productCode,currentBtn.sku,currentBtn.productTag);
}
#pragma -
#pragma mark TableViewDelegate & TableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_isSearch) {
        NSString* productNums = strOrEmpty(m_data_listAttributeData.mnumber);
        NSString *str=[NSString stringWithFormat:@"搜索-%@[%@款商品]",self.m_string_keyword, productNums];
        if (str.length>40) {
            str=[str substringFromIndex:str.length-40];
        }
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0,0,320,PRODUCTLIST_TABLEVIEW_HEADER_HEIGHT)];
        //[label setBackgroundColor:[UIColor colorWithRed:149.0/255 green:149.0/255 blue:149.0/255 alpha:149.0/255]];
        [label setBackgroundColor:[UIColor grayColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setText:[NSString stringWithFormat:@"    %@",str]];
        return label;
    }else{
        return nil;
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows=[self.m_array_productList count];
	if (_isListMode)
		return rows;
	else
		return (rows+1)/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isListMode) {
        return 60;
    }
    return 190;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	int int_row = indexPath.row + 1;
    int addRow=0;
    //NSLog(@"display.......%d>>>>>>>>>>>>>>>>>>>",int_row);
    if (_isListMode) {
        addRow=[self.m_array_productList count];
    }else{
        addRow=([self.m_array_productList count]+1)/2;
    } 
    
    if( int_row==addRow && m_int_currPage < [m_data_listAttributeData.mtotalPage intValue]){
        //加载下一页
        NSLog(@"准备加载下一页.......>>>>>>>>>>>>>>>>>>>");
        if (!_isRequesting)
        {
            NSLog(@"第%d行加载下一页.......>>>>>>>>>>>>>>>>>>>",int_row);
            [self requestProductList:m_int_currPage+1];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isListMode) {
        static NSString *CellIdentifier = @"SCNProductListModeTableCell";
        SCNProductListModeTableCell *cell = (SCNProductListModeTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"SCNProductListModeTableCell" owner:self options:nil];
            cell=[views objectAtIndex:0];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"classified_cellBg.png"]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"classified_cellBg_SEL.png"]];
        }
        SCNSearchProductData *product=[self.m_array_productList objectAtIndex:indexPath.row];
        cell.m_label_product_type1.hidden = YES;
        cell.m_label_product_type2.hidden = YES;
        if ([product.mtag length] > 0) 
        {
            NSArray *tags=[product.mtag componentsSeparatedByString:@"|"];
            if ([tags count]==1)
            {
                [cell.m_label_product_type1 setHidden:NO];
                [cell.m_label_product_type1 setText:[tags objectAtIndex:0]];
                [cell.m_label_product_type2 setHidden:YES];
            }
            else if([tags count] >= 2)
            {
                [cell.m_label_product_type1 setHidden:NO];
                [cell.m_label_product_type1 setText:[tags objectAtIndex:0]];
                [cell.m_label_product_type2 setHidden:NO];
                [cell.m_label_product_type2 setText:[tags objectAtIndex:1]];
            }
        }else{
            [cell.m_label_product_type1 setHidden:YES];
            [cell.m_label_product_type2 setHidden:YES];
        }
        
        
        [cell.m_label_product_name setText:product.mname];
        [cell.m_label_product_marketPrice setText:[NSString stringWithFormat:@"市场价:￥%@",product.mmarketPrice]];
        cell.m_label_product_marketPrice.enabled_middleLine=YES;
        [cell.m_label_product_sellPrice setText:[NSString stringWithFormat:@"￥%@",product.msellPrice]];
        cell.m_imageView_product.layer.borderWidth=1;
        cell.m_imageView_product.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [cell.m_imageView_product setImage:[UIImage imageNamed:@"com_loading53x50.png"]];
        [HJImageUtility queueLoadImageFromUrl:product.mimage imageView:(HJManagedImageV*)cell.m_imageView_product];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"SCNProductImageModeTableCell";
        SCNProductImageModeTableCell *cell = (SCNProductImageModeTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"SCNProductImageModeTableCell" owner:self options:nil];
            cell=[views objectAtIndex:0];
        }
        int row=indexPath.row;
        int leftNum=row*2;
        int rightNum=row*2+1;
        
        if (leftNum<=([self.m_array_productList count]-1)) {
            [cell.m_view_left setHidden:NO];
            [cell.m_view_right setHidden:YES];
            SCNSearchProductData *product=[self.m_array_productList objectAtIndex:leftNum];
            //传递商品信息
            [cell.m_button_product_left addTarget:self action:@selector(goToProductDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
            [cell.m_button_product_left setBackgroundColor:[UIColor clearColor]];
            [cell.m_button_product_left setUserInteractionEnabled:YES];
            [cell.m_button_product_right setBackgroundColor:[UIColor clearColor]];
            [cell.m_button_product_right setUserInteractionEnabled:NO];
            cell.m_button_product_left.productCode=product.mproductCode;
            cell.m_button_product_left.imagePath=product.mimage;
            cell.m_button_product_left.productTag=product.mtag;
            cell.m_button_product_left.pstatus=product.mpstatus;
            
            cell.m_label_product_type1_left.hidden = YES;
            cell.m_label_product_type2_left.hidden = YES;
            if (![product.mtag isEqualToString:@""]) {
                NSArray *tags=[product.mtag componentsSeparatedByString:@"|"];
                if ([tags count]==1) {
                    [cell.m_label_product_type1_left setHidden:NO];
                    [cell.m_label_product_type1_left setText:product.mtag];
                    [cell.m_label_product_type2_left setHidden:YES];
                }else{
                    [cell.m_label_product_type1_left setHidden:NO];
                    [cell.m_label_product_type1_left setText:[tags objectAtIndex:0]];
                    [cell.m_label_product_type2_left setHidden:NO];
                    [cell.m_label_product_type2_left setText:[tags objectAtIndex:1]];
                }
                
            }

            [cell.m_label_product_name_left setText:product.mname];
            
			cell.m_label_product_marketPrice_left.frame = CGRectMake(5, 160, 90, 10); 
			CGRect rect = cell.m_label_product_marketPrice_left.frame;
            NSString *markPriceStr = [NSString stringWithFormat:@"市场价:￥%@ ",product.mmarketPrice];
            CGSize labelsize = [markPriceStr sizeWithFont:cell.m_label_product_marketPrice_left.font 
                                        constrainedToSize:rect.size 
                                            lineBreakMode:UILineBreakModeWordWrap];
			[cell.m_label_product_marketPrice_left setText:markPriceStr]; 
			NSLog(@"市场价格:===%f",labelsize.width);
            cell.m_label_product_marketPrice_left.frame = CGRectMake(rect.origin.x,rect.origin.y,labelsize.width,rect.size.height);
            
            cell.m_label_product_marketPrice_left.enabled_middleLine=YES;
            
            [cell.m_label_product_sellPrice_left setText:[NSString stringWithFormat:@"￥%@",product.msellPrice]];
            [cell.m_imageView_product_left setImage:[UIImage imageNamed:@"com_loading150x130.png"]];
            cell.m_imageView_product_left.layer.borderWidth=1;
            cell.m_imageView_product_left.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [HJImageUtility queueLoadImageFromUrl:product.mbigImage imageView:(HJManagedImageV*)cell.m_imageView_product_left];
        }
        if (rightNum<=([self.m_array_productList count]-1)) {
            [cell.m_view_right setHidden:NO];
            SCNSearchProductData *product=[self.m_array_productList objectAtIndex:rightNum];
            //传递商品信息
            [cell.m_button_product_right addTarget:self action:@selector(goToProductDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
            [cell.m_button_product_right setBackgroundColor:[UIColor clearColor]];
            [cell.m_button_product_right setUserInteractionEnabled:YES];
            cell.m_button_product_right.productCode=product.mproductCode;
            cell.m_button_product_right.imagePath=product.mimage;
            cell.m_button_product_right.productTag=product.mtag;
            cell.m_button_product_right.pstatus=product.mpstatus;
            
            cell.m_label_product_type1_right.hidden = YES;
            cell.m_label_product_type2_right.hidden = YES;
            if (![product.mtag isEqualToString:@""]) {
                NSArray *tags=[product.mtag componentsSeparatedByString:@"|"];
                if ([tags count]==1) {
                    [cell.m_label_product_type1_right setHidden:NO];
                    [cell.m_label_product_type1_right setText:product.mtag];
                }else if([tags count]==2){
                    [cell.m_label_product_type1_right setHidden:NO];
                    [cell.m_label_product_type1_right setText:[tags objectAtIndex:0]];
                    [cell.m_label_product_type2_right setHidden:NO];
                    [cell.m_label_product_type2_right setText:[tags objectAtIndex:1]];
                }
                
            }else{
                [cell.m_label_product_type1_right setHidden:YES];
                [cell.m_label_product_type2_right setHidden:YES];
            }

            [cell.m_label_product_name_right setText:product.mname];
			
            cell.m_label_product_marketPrice_right.frame = CGRectMake(5, 160, 90, 10); 
            CGRect rect = cell.m_label_product_marketPrice_right.frame;
            NSString *markPriceStr = [NSString stringWithFormat:@"市场价:￥%@ ",product.mmarketPrice];
            CGSize labelsize = [markPriceStr sizeWithFont:cell.m_label_product_marketPrice_right.font 
                                    constrainedToSize:rect.size 
                                        lineBreakMode:UILineBreakModeWordWrap];
			cell.m_label_product_marketPrice_right.text = markPriceStr;
            cell.m_label_product_marketPrice_right.frame = CGRectMake(rect.origin.x,rect.origin.y,labelsize.width,rect.size.height);

            cell.m_label_product_marketPrice_right.enabled_middleLine=YES;
            
            [cell.m_label_product_sellPrice_right setText:[NSString stringWithFormat:@"￥%@",product.msellPrice]];
            [cell.m_imageView_product_right setImage:[UIImage imageNamed:@"com_loading150x130.png"]];
            cell.m_imageView_product_right.layer.borderWidth=1;
            cell.m_imageView_product_right.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [HJImageUtility queueLoadImageFromUrl:product.mbigImage imageView:(HJManagedImageV*)cell.m_imageView_product_right];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isListMode) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SCNSearchProductData *product=[self.m_array_productList objectAtIndex:indexPath.row];
        [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:product.mproductCode withPstatus:product.mpstatus withImage:product.mimage];
    }
}

-(BOOL)isActivityList
{
	//活动专题
	if (self.m_string_type && [self.m_string_type length] > 0) {
		return YES;
	}
	return NO;
}

#pragma -
#pragma mark 请求商品列表数据
-(void)requestProductList:(int)currentpage
{
    if (_isRequesting) 
	{
        return;
    }
    _isRequesting=YES;
    [self startLoading];

    NSString* page       = [NSString stringWithFormat:@"%d",currentpage];
    NSString* pageSize   = [NSString stringWithFormat:@"%d",m_int_currPageSize];
    NSString* brandId    = strOrEmpty(self.m_string_brandId);
    NSString* sorttype   = [NSString stringWithFormat:@"%d",m_int_sorttype];//NewProduct;
    NSString* keyword    = strOrEmpty(self.m_string_keyword);
    NSString* categoryId = strOrEmpty(self.m_string_categoryId);
    NSString* filter     = strOrEmpty(self.m_string_filterContent);//筛选的内容
    NSString* type       = strOrEmpty(self.m_string_type);//这个type 到底是和指什么
    NSString* typeId     = strOrEmpty(self.m_string_typeId);//这里的typeid其实是brandid
    NSString* isfilter;
    
    if (m_int_currPage==1) {
        isfilter= [NSString stringWithFormat:@"%d",1];
    }else{
        isfilter = [NSString stringWithFormat:@"%d",0];
    }
    NSDictionary* extraParam = nil;
    if([self isActivityList])//活动专题
	{
         extraParam = @{@"method": MMUSE_METHOD_GET_ACTIVITYPRODUCTLIST,
         @"filter": filter,
         @"is_filter": isfilter,
         @"page": page,
         @"pageSize": pageSize,
         @"sorttype": sorttype,
         @"type_id": type,
         @"brand_id": typeId};
    }
    else
    {
           extraParam = @{@"method": MMUSE_METHOD_GET_PRODUCTLIST,
           @"filter": filter,
           @"is_filter": isfilter,
           @"brand_id": brandId,
           @"page": page,
           @"pageSize": pageSize,
           @"keyword": keyword,
           @"cat_id": categoryId,
           @"sorttype": sorttype};
    }
    self.m_number_requestID=[YKHttpAPIHelper
                             startLoadJSONWithExtraParams:extraParam
                             object:self
                             onAction:@selector(onResponseProductList:)];
}

-(void)onResponseProductList:(id)json_obj
{
    [self stopLoading];
    if([SCNStatusUtility isRequestSuccessJSON:json_obj])
    {
        _isRequestSuccess = YES;
		m_int_lastPage = m_int_currPage;
        
        
        GY_Collection_ProductList* coll = [[GY_Collection_ProductList alloc]initWithJSON:json_obj];
        
    
        //接收列表配置信息
        NSLog(@"当前页数《》《》《》《》《》《》《》《\n《》《》《》《》%@",coll.page);
        m_int_currPage = coll.page;
        m_int_currPageSize = coll.page_size;
        
        if([self.m_array_productList count] > 0)
        {             
            m_int_currPage ++;
        }
		
		//filterinfo
		NSMutableArray *tempFilterArray= coll.arr_filter_info;
        
		if(tempFilterArray && [tempFilterArray count])
		{
            self.m_dict_filterData =[NSMutableDictionary dictionaryWithCapacity:[tempFilterArray count]];
			for (NSMutableDictionary* filter_item in tempFilterArray)
			{			
                NSString *name            =[filter_item objectForKey:@"name"];
                NSString *displayname     =[filter_item objectForKey:@"displayname"] ;
                NSMutableArray *itemArray =[filter_item objectForKey:@"items"];

				if([itemArray count]>0)
				{
					NSMutableArray *_filterDataArray=[NSMutableArray arrayWithCapacity:0];

					//用户自己选择的筛选条件
					NSArray *userFilterKeys=nil;
					if (self.m_dict_userFilterData!=nil) {
						userFilterKeys=[self.m_dict_userFilterData allKeys];
					}
                    
					for (NSMutableDictionary* item in itemArray)
					{
                        SCNProductFilterItemData *data =[[SCNProductFilterItemData alloc] init];
                        data.mname                     =name;
                        data.mdisplayName              =displayname;
                        data.mcontent                  =[item valueForKey:@"name"];
                        data.mid                       =[item valueForKey:@"id"];
						//<><><><><><><保存上一次筛选条件相关
						
						if (userFilterKeys!=nil&&[userFilterKeys containsObject:displayname]) 
						{
							NSLog(@"有相同--------筛选条件%@",displayname);
							SCNProductFilterItemData *userFilterData=[self.m_dict_userFilterData valueForKey:displayname];
							if ([data.mid isEqualToString:userFilterData.mid])
							{
								NSLog(@"有相同--筛选内容%@",userFilterData.mid);
								data.mselected=YES;
							}
						}
						//<><><><><><><><><>
						[_filterDataArray addObject:data];
					}
					
					[self.m_dict_filterData setObject:_filterDataArray forKey:displayname];
					}
				}
                NSLog(@"筛选条件数组个数%d",[self.m_dict_filterData count]);
		}
		
        //处理 产品信息列表
        NSMutableArray* tempArray = coll.arr_productList;

        if ([tempArray count]>0)
		{
            [self.m_tableView_productList setHidden:NO];
            //接收列表商品信息
            for (NSMutableDictionary* item in tempArray)
			{
                SCNSearchProductData *product=[[SCNSearchProductData alloc] init];
                // 这里处理每个 对应数据细节
                [product parseFromDictionary:item];
                product.mmarketPrice=[NSString stringWithFormat:@"%.2f",[product.mmarketPrice floatValue]];
                product.msellPrice=[NSString stringWithFormat:@"%.2f",[product.msellPrice floatValue]];

                [self.m_array_productList addObject:product];
            }
            [self.m_tableView_productList reloadData];
        }
    }
	
	//判断成功失败
	[self resetAllView];

	//解析完毕
	_isRequesting = NO;
}

-(void)resetAllView
{
	if ([self.m_array_productList count]==0) 
	{
		if (![self.m_view_noResult viewWithTag:HotSellViewTag])
		{
            //添加热卖视图
            SCNHotSellView *hotsellView=[[SCNHotSellView alloc] initWithFrame:CGRectMake(0, 287, 320, 89) parentVC:self];
            hotsellView.tag=HotSellViewTag;
            [self.m_view_noResult addSubview:hotsellView];
        }
		
		[self.m_view_noResult setHidden:NO];
        [self.m_label_hotSellTitle setText:[[DataWorld shareData] m_homeData].m_productlistTitle];
		[self.m_tableView_productList setHidden:YES];
		
		//判断无搜索结果时是否显示筛选按钮
		[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:LISTMODECHANGE_BUTTON_TAG] setHidden:YES];
			
		if(!_isRequestSuccess || [self.m_dict_filterData count] == 0)
		{
			[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG] setHidden:YES];
		}
		else
		{
			[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG] setHidden:NO];
		}
	}
	else
	{
		[self.m_view_noResult setHidden:YES];
		[self.m_tableView_productList setHidden:NO];
		[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:LISTMODECHANGE_BUTTON_TAG] setHidden:NO];
		if ([self.m_dict_filterData count] == 0)
		{
			[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG] setHidden:YES];
		}
		else
		{
			[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG] setHidden:NO];
		}
	}
	
//	if([self isActivityList]) 
//	{
//		[[(UIButton*)self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG] setHidden:YES];
//	}
	[self adjustNaviBtn];
}

-(void)adjustNaviBtn
{
	UIButton* listbtn = (UIButton*)[self.navigationItem.rightBarButtonItem.customView viewWithTag:LISTMODECHANGE_BUTTON_TAG];
	UIButton* filterbtn = (UIButton*)[self.navigationItem.rightBarButtonItem.customView viewWithTag:FILTER_BUTTON_TAG];
	if (!listbtn.hidden && !filterbtn.hidden)
	{
		listbtn.frame=CGRectMake(0, 0, 33, 32);
		filterbtn.frame=CGRectMake( 34,0, 43, 32);
	}
	else if(listbtn.hidden && !filterbtn.hidden)
	{
		filterbtn.frame=CGRectMake( 34,0, 43, 32);
	}
	else if(!listbtn.hidden && filterbtn.hidden)
	{
		listbtn.frame = CGRectMake( 44,0, 33, 32);
	}
}

#pragma -
#pragma mark SCNProductFilterDelegate
-(void)receiveFilterData:(NSMutableDictionary*)userFilterData{
    NSLog(@"接收筛选data>>>>>>>>>>>%@",userFilterData);
    self.m_dict_userFilterData=userFilterData;
    self.m_string_filterContent=[NSMutableString stringWithString:@""];
    NSArray *keys=[self.m_dict_userFilterData allKeys];
    for (int i=0; i<[keys count]; i++) {
        NSString *currKey=[keys objectAtIndex:i];
        SCNProductFilterItemData *tempData=[self.m_dict_userFilterData valueForKey:currKey];
        NSString *subStr=nil;
        if (i==[keys count]-1) {
            subStr=[NSString stringWithFormat:@"%@=%@",strOrEmpty(tempData.mname),strOrEmpty(tempData.mid)];
        }else{
            subStr=[NSString stringWithFormat:@"%@=%@|",strOrEmpty(tempData.mname),strOrEmpty(tempData.mid)];
        }
        [self.m_string_filterContent appendString:subStr];
    }
    NSLog(@"提交用户筛选条件%@",self.m_string_filterContent);
    [self resetDataSource];
    [self requestProductList:m_int_currPage];
}

-(void)BehaviorPageJump
{
#ifdef USE_BEHAVIOR_ENGINE
#endif
}

-(NSString*)pageJumpParam{
	//活动|品牌|搜索|
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = nil;
	if(_isSearch){
        NSLog(@"搜索列表页");
		_param = self.navigationItem.title;
	}else if(!_isSearch && [m_string_categoryId length] > 0){
        NSLog(@"分类商品列表页");
    }else if(m_string_brandId && [m_string_brandId length]>0){
		_param = @"品牌";
	}else if([self isActivityList]){
		_param = self.navigationItem.title;
	}
	return _param;
#else
	return nil;
#endif
}
@end
