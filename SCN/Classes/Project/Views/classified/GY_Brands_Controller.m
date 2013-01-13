//
//  SCNBrandClassifiedViewController.m
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GY_Brands_Controller.h"
#import "Go2PageUtility.h"

#import "HJManagedImageV.h"
#import "HJImageUtility.h"
#import "YKHttpAPIHelper.h"


@implementation GY_Brands_Controller
#define tag_mTableView  100
#define tag_picTableView 200

#define tag_HJManagedImageV 1
#define tag_nameLable 2

#define tag_outdoorsSports 91
#define tag_femaleShoes 92
#define tag_maleShoes 93

@synthesize m_tableview;
@synthesize m_backView,m_pictureStyleView;
@synthesize m_FatherId;

@synthesize m_isText;
@synthesize m_brandClassDatas;

@synthesize m_p_tableView;
@synthesize m_p_outdoorsSports,m_p_femaleShoes,m_p_maleShoes;
@synthesize m_top_p_outdoorsSports,m_top_p_femaleShoes,m_top_p_maleShoes;
@synthesize m_currentIndex,m_finishFor;
@synthesize m_titleForSection;


@synthesize m_collection_brands;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
         withFatherId:(NSString*)fatherId {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_FatherId = fatherId;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌浏览";
	self.pathPath = @"/brandexplore";
    self.m_isText = NO;
    [self setNormalNavigationItem:NO];
    
    
    self.m_backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight])];
    self.m_backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.m_backView];
    [self.m_backView sendSubviewToBack:self.view];
    
    self.m_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight])];
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    self.m_tableview.tag = tag_mTableView;
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.m_backView addSubview:self.m_tableview];
    
    self.m_p_tableView.tag = tag_picTableView;
    self.m_p_tableView.delegate = self;
    self.m_p_tableView.dataSource = self;
    self.m_titleForSection = @"户外运动";
    
  
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.m_brandClassDatas == nil) {
        [self requestgetBrandListJSONData];
    }
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    self.m_backView = nil;
    self.m_tableview = nil;
    self.m_brandClassDatas = nil;
    
    self.m_collection_brands = nil;



    self.m_pictureStyleView = nil;
    self.m_p_tableView = nil;
    self.m_p_outdoorsSports = nil;
    self.m_p_femaleShoes = nil;
    self.m_p_maleShoes = nil;
    
    self.m_top_p_outdoorsSports = nil;
    self.m_top_p_femaleShoes = nil;
    self.m_top_p_maleShoes = nil;
//    m_top_p_outdoorsSports,m_top_p_femaleShoes,m_top_p_maleShoes;
    

    
    self.m_titleForSection = nil;
    
}



#pragma mark -
#pragma mark 导航栏

-(void)setNormalNavigationItem:(BOOL)isText
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 0,33,32)];
	[button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
    if (isText == NO) {
        [button setBackgroundImage:[UIImage imageNamed:@"com_button_imageModel.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"com_button_imageModel_SEL.png"] forState:UIControlStateHighlighted];
    }else if (isText == YES){
        [button setBackgroundImage:[UIImage imageNamed:@"com_button_listModel.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"com_button_listModel_SEL.png"] forState:UIControlStateHighlighted];
    }
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:button.frame];
	[ricusview addSubview:button];

	UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:ricusview];
	[self.navigationItem  setRightBarButtonItem:item];
}
#pragma mark-
#pragma mark 图片翻转切换
-(void)changeViewController:(id)sender
{
    if(self.m_isText == NO){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft 
                               forView:self.m_backView cache:YES];
        [m_tableview removeFromSuperview];
        [self.m_backView addSubview:self.m_pictureStyleView];
        [UIView commitAnimations];
        self.m_isText = YES;
        [self setNormalNavigationItem:YES];
    }
    else if(self.m_isText == YES)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.m_backView cache:YES];
        [self.m_pictureStyleView removeFromSuperview];
        [self.m_backView addSubview:m_tableview];
        [UIView commitAnimations];
        self.m_isText = NO;
        [self setNormalNavigationItem:NO];
    }
    
    
}
-(void)layoutCellSubViews:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    //10,11,12分别代表三张不同的HJManagedImageV
    int row = indexPath.row;
    int section = indexPath.section;
    for (int i=0; i<3;i++) {
        int imageVtag = 10 + i%3;
        int buttontag = 20 + i%3;
        HJManagedImageV *ImageV = (HJManagedImageV *)[cell viewWithTag:imageVtag];
        ImageV.hidden = YES;
        Brand_pictureButton *brandButton = (Brand_pictureButton *)[cell viewWithTag:buttontag];
        brandButton.hidden = YES;
        brandButton.enabled = NO;
        brandButton.backgroundColor = [UIColor clearColor];
        brandButton.frame = ImageV.frame;
        [brandButton addTarget:self action:@selector(onActionGo2ProductList:) 
              forControlEvents:UIControlEventTouchUpInside];
        
    }


    self.m_currentIndex = row *3;
    self.m_finishFor = self.m_currentIndex +3;
    
    if (section==0) {
        int count = [self.m_collection_brands.arr_brand_icon_hot count];
        if (count -(row +1)*3 <0) {
            self.m_finishFor = self.m_currentIndex + count%3;
        }
        
    }else if(section ==1){
        int count = [self.m_collection_brands.arr_brand_icon_all count];
        if (count -(row +1)*3 <0) {
            self.m_finishFor = self.m_currentIndex + count%3;
        }
    }
    
    for (int i=self.m_currentIndex; i<self.m_finishFor;i++) {
        int imageVtag = 10 + i%3;
        int buttontag = 20 + i%3;
        HJManagedImageV *ImageV = (HJManagedImageV *)[cell viewWithTag:imageVtag];
        ImageV.hidden = NO;
        ImageV.userInteractionEnabled = YES;
        ImageV.layer.borderWidth = 1;
        ImageV.layer.borderColor = YK_IMAGEBORDER_COLOR.CGColor;
        ImageV.image = [DataWorld getImageWithFile:@"com_loading103x103.png"];
        
        Brand_pictureButton *brandButton = (Brand_pictureButton *)[cell viewWithTag:buttontag];
        
        if (section==0) {
            
            NSDictionary* hot = [self.m_collection_brands.arr_brand_icon_hot objectAtIndex:i];
            
            brandButton.m_brandId = [hot objectForKey:@"brandId"];
            brandButton.m_brandName = [hot objectForKey:@"name"];
            [HJImageUtility queueLoadImageFromUrl:[hot objectForKey:@"image"]
                                        imageView:ImageV];
            
        }else if(section==1){
            NSDictionary* all = [self.m_collection_brands.arr_brand_icon_all objectAtIndex:i];

            brandButton.m_brandId =[all objectForKey:@"brandId"];
            brandButton.m_brandName = [all objectForKey:@"name"];
            [HJImageUtility queueLoadImageFromUrl:[all objectForKey:@"image"]
                                        imageView:ImageV];
        }
        
        
        brandButton.hidden = NO;
        brandButton.enabled = YES;
        brandButton.backgroundColor = [UIColor clearColor];
        brandButton.frame = ImageV.frame;
        
        [brandButton addTarget:self action:@selector(onActionGo2ProductList:) 
              forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    
}
#pragma mark -
#pragma mark 切换到商品列表
-(void)onActionGo2ProductList:(id)sender
{
    Brand_pictureButton *brandBT = (Brand_pictureButton *)sender;
    [Go2PageUtility go2ProductListViewController:self withKeyword:nil withCategoryId:nil withIsSearch:NO withCategoryName:brandBT.m_brandName withBrandId:brandBT.m_brandId withTypeId:nil withType:nil];
}

#pragma mark -
#pragma mark 切换不同种类的鞋子
- (IBAction)onActionChangeStyleShoes:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.selected == YES) {
        return;
    }
    int tag = button.tag;
    
    [button setSelected:YES];
    switch (tag) {
        case 91:
        {
            self.m_collection_brands.arr_brand_icon_hot = self.m_collection_brands.arr_brand_icon_outdoor_sport_hot;
            self.m_collection_brands.arr_brand_icon_all = self.m_collection_brands.arr_brand_icon_outdoor_sport_all;
            
            [self.m_p_outdoorsSports setSelected:YES];
            self.m_titleForSection =  self.m_p_outdoorsSports.titleLabel.text;
            [self.m_p_maleShoes setSelected:NO];
            [self.m_p_femaleShoes setSelected:NO];
  
            [self.m_top_p_femaleShoes setSelected:NO];
            [self.m_top_p_maleShoes setSelected:NO];
        }
            
            break;
        case 92:
        {
            
            self.m_collection_brands.arr_brand_icon_hot = self.m_collection_brands.arr_brand_icon_female_hot;
            self.m_collection_brands.arr_brand_icon_all = self.m_collection_brands.arr_brand_icon_female_all;            
            
            [self.m_p_femaleShoes setSelected:YES];
             self.m_titleForSection =  @"女鞋";//self.m_p_femaleShoes.titleLabel.text;
            [self.m_p_outdoorsSports setSelected:NO];
            [self.m_p_maleShoes setSelected:NO];
            
            [self.m_top_p_outdoorsSports setSelected:NO];
            [self.m_top_p_maleShoes setSelected:NO];

        }
            
            break;
        case 93:
        {
//            self.m_hotSellProductArr = self.m_brandClassDatas.m_hotmaleShoesArr;
//            self.m_allSellProductArr = self.m_brandClassDatas.m_allmaleShoesArr;
            self.m_collection_brands.arr_brand_icon_hot = self.m_collection_brands.arr_brand_icon_male_hot;
            self.m_collection_brands.arr_brand_icon_all = self.m_collection_brands.arr_brand_icon_male_all;    
            
            [self.m_p_maleShoes setSelected:YES];
            self.m_titleForSection =  @"男鞋";//self.m_p_maleShoes.titleLabel.text;
            [self.m_p_femaleShoes setSelected:NO];
            [self.m_p_outdoorsSports setSelected:NO];
            
            [self.m_top_p_femaleShoes setSelected:NO];
            [self.m_top_p_outdoorsSports setSelected:NO];
        }
            
            break;
            
        default:
            break;
    }
    [self.m_p_tableView reloadData];
}

#pragma mark-
#pragma mark 请求数据
-(void)requestgetBrandListJSONData
{
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:MMUSE_METHOD_GET_BRANDLIST forKey:@"method"]; 
    [self startLoading];
    [YKHttpAPIHelper startLoadJSON:MMUSE_URL 
                   extraParams:extraParamsDic 
                        object:self 
                      onAction:@selector(onRequestgetBrandListJSONData:)];
}


#pragma mark-
#pragma mark 获取 分类列表数据
-(void)onRequestgetBrandListJSONData:(id)json_obj
{
    [self stopLoading];

    if (json_obj == nil) {
        WBNoticeView *nm = [WBNoticeView defaultManager];
        [nm showErrorNoticeInView:self.view title:@"Network 错误" message:@"可能服务器连接错误"];
        return;
    }
   
   if ([SCNStatusUtility isRequestSuccessJSON:json_obj])
   {
       m_collection_brands = [[GY_Collection_Brands alloc]initWithJSON:json_obj];
   }    
 
    [self.m_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark －
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==tag_mTableView) 
    {
        NSUInteger sections_count = [self.m_collection_brands.arr_brands_list_view_sections count];
        return sections_count;
    }
    else
    {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == tag_mTableView) 
    {
        NSMutableArray* rows_in_section = [self.m_collection_brands.arr_brands_list_view_rows objectAtIndex:section];
        NSUInteger row_in_section_count = [rows_in_section count];
        return row_in_section_count;
    }
    else
    {
        NSMutableArray* arr_hots    = self.m_collection_brands.arr_brand_icon_hot;
        NSMutableArray* arr_normals = self.m_collection_brands.arr_brand_icon_all;
        
        if (section==0) {
            return [self get_brand_icon_tableview_row_in_section_count:arr_hots];
        }else if(section ==1){
            return [self get_brand_icon_tableview_row_in_section_count:arr_normals];
        }
    }
    return 0;
}

-(NSUInteger)get_brand_icon_tableview_row_in_section_count:(NSMutableArray*)data{
    if ([data count] %3 != 0) {
        return [data count]/3+1;
    }else{
        return [data count]/3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int row = indexPath.row;
    int section = indexPath.section;
    
    //NSLog(@" rows is %d sections is %d",row,section);
    NSString *brandlist_CellIdentifier = @"brandlistCell";
    NSString *brandPicture_CellIdentifier = @"brandPictureCell";

    UITableViewCell *cell = nil;
    
    if (tableView.tag == tag_mTableView) 
    {
        cell = [tableView dequeueReusableCellWithIdentifier:brandlist_CellIdentifier];
        if (cell == nil) 
		{
			NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNClassfiledViewCell" owner:self options:nil];
			cell = [cellNib objectAtIndex:1];
			[YKButtonUtility setCommonCellBg:cell];
			HJManagedImageV *icon = (HJManagedImageV *)[cell viewWithTag:tag_HJManagedImageV];
			icon.layer.borderWidth = 1;
			icon.layer.borderColor = YK_IMAGEBORDER_COLOR.CGColor;
        }

        NSMutableArray* brands_group_by_tag = [self.m_collection_brands.arr_brands_list_view_rows objectAtIndex:section];

        NSDictionary* brands_data = [brands_group_by_tag objectAtIndex:row];
        NSString* image_url = [brands_data valueForKey:@"image"];
        NSString* name      = [brands_data valueForKey:@"name"];
        
        HJManagedImageV *icon = (HJManagedImageV *)[cell viewWithTag:tag_HJManagedImageV];
        icon.image = [DataWorld getImageWithFile:@"com_loading45x45.png"];
        [HJImageUtility queueLoadImageFromUrl:image_url imageView:icon];
        
        UILabel *nameLable = (UILabel *)[cell viewWithTag:tag_nameLable];
        nameLable.text = name;

    }
    else if(tableView.tag == tag_picTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:brandPicture_CellIdentifier];
        if (cell == nil) {
            NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNClassfiledViewCell" owner:self options:nil];
            cell = [cellNib objectAtIndex:2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [self layoutCellSubViews:cell indexPath:indexPath];
    }

	return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == tag_mTableView) {
        return self.m_collection_brands.arr_brands_list_view_sections;
    }
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    headerView.backgroundColor  = [UIColor clearColor];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
            backImageView.backgroundColor = [UIColor colorWithRed:149.0f/255.0f green:149.0f/255.0f blue:149.0f/255.0f alpha:1.0];
    [headerView addSubview:backImageView];
    
    UILabel *brandLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 300, 20)];
    brandLable.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
    [headerView addSubview:brandLable];
    brandLable.backgroundColor = [UIColor clearColor];
    brandLable.textColor = [UIColor whiteColor];

    
    if (tableView.tag == tag_mTableView) 
    {
        brandLable.text = [self.m_collection_brands.arr_brands_list_view_sections objectAtIndex:section];
        return headerView;
    }
    else if(tableView.tag == tag_picTableView)
    {
        NSMutableArray* arr_hots    = self.m_collection_brands.arr_brand_icon_hot;
        NSMutableArray* arr_all     = self.m_collection_brands.arr_brand_icon_all;
        
        if (section==0 && [arr_hots count]>0) {
            brandLable.text  =  [NSString stringWithFormat:@"热门%@品牌",self.m_titleForSection];
            return headerView;
        }else if(section==1 && [arr_all count]>0){
            brandLable.text =  [NSString stringWithFormat:@"全部%@品牌",self.m_titleForSection];
            return headerView;
        }
    }
    return nil;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView.tag == tag_picTableView) {
//        if (section==0 && [self.m_hotSellProductArr count]>0) {
//            return [NSString stringWithFormat:@"热门%@品牌",self.m_titleForSection];
//        }else if(section==1 && [self.m_allSellProductArr count]>0){
//            return [NSString stringWithFormat:@"全部%@品牌",self.m_titleForSection];
//        }
//    }
//    return nil;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == tag_mTableView) {
        return 50.0f;
    }
    return 108.0f;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==tag_mTableView) {
        int section = indexPath.section;
        int row = indexPath.row;
        NSMutableArray *brandsDataArr = [self.m_collection_brands.arr_brands_list_view_rows objectAtIndex:section];
        brandClassfiledBrandsData *brandsDatas = (brandClassfiledBrandsData *)[brandsDataArr objectAtIndex:row];
        [Go2PageUtility go2ProductListViewController:self withKeyword:nil withCategoryId:nil withIsSearch:NO withCategoryName:brandsDatas.mname withBrandId:brandsDatas.mbrandId withTypeId:nil withType:nil];
    }


}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
}

@end

@implementation Brand_pictureButton
@synthesize m_brandId,m_brandName;
-(void)dealloc{
    m_brandId = nil;
    m_brandName = nil;
}
@end