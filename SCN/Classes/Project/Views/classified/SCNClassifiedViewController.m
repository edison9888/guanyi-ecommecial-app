//
//  SCNClassifiedViewController.m
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNClassifiedViewController.h"

#import "GY_Brands_Controller.h"
#import "SCNProductListViewController.h"

#import "YKHttpAPIHelper.h"
#import "SCNClassfiledData.h"
#import "YKStringHelper.h"

#import "HJManagedImageV.h"
#import "HJImageUtility.h"
#import "SCNStatusUtility.h"
#import "Go2PageUtility.h"

#import "GY_Model_Category.h"

@implementation SCNClassifiedViewController

#define tag_HJManagedImageV 1
#define tag_nameLable 2

@synthesize m_tableview;
@synthesize m_FatherId,m_title;
@synthesize m_categorysArr;
@synthesize m_requsetID;
@synthesize m_classIdNameDic;
@synthesize m_classLayer;
//@synthesize m_goBrandClassified;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil FatherId:(NSString *)fatherId Title:(NSString *)title{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_FatherId = fatherId;
        self.m_title    = title;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.m_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStylePlain];
    self.m_tableview.backgroundColor = [UIColor clearColor];
    self.m_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_tableview.delegate = self;
    self.m_tableview.dataSource = self;
    [self.view addSubview:self.m_tableview];
    
	m_classIdNameDic = [[NSMutableDictionary alloc] initWithCapacity:10];
	
    self.m_requsetID = [[NSNumber alloc]init];
    
    self.title = self.m_title ? self.m_title :@"分类浏览";
	self.pathPath = @"/classified";
    self.m_FatherId = self.m_FatherId ? self.m_FatherId :[NSString stringWithFormat:@"0"];
    
    if ([self.m_FatherId intValue] == 0) {
        [self setNormalNavigationItem];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
	if (![self.m_FatherId isEqualToString:@"0"]) {
		m_classLayer = 1;//目前为止就两层，这里是第二级分类
	}else {
		m_classLayer = 0;//根目录，也就是第一级分类
		[super BehaviorPageJump];
	}
	
    if (self.m_categorysArr == nil) {
        [self requestGetCategoryListJSONData];
    }
    
}
#pragma mark -
#pragma mark 导航栏

-(void)setNormalNavigationItem
{   
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 0,80,32)];
	[button setTitle:@"品牌浏览" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
	
	[button setBackgroundImage:[[UIImage imageNamed:@"com_btn.png"] 
								stretchableImageWithLeftCapWidth:20 
								topCapHeight:20] forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"com_btn_SEL.png"] 
								stretchableImageWithLeftCapWidth:20 
								topCapHeight:20] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(goBrandClassified:) forControlEvents:UIControlEventTouchUpInside];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:button.frame];
	[ricusview addSubview:button];
	
	UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:ricusview];
	[self.navigationItem  setRightBarButtonItem:item];
}

#pragma mark-
#pragma mark 请求 分类列表数据
-(void)requestGetCategoryListJSONData
{
    //http://appapi.loc/api.php?method=shopcats.category.get
    [self startLoading];
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:MMUSE_METHOD_GET_CATEGORYLIST forKey:@"method"];
     self.m_FatherId = self.m_FatherId != nil ?self.m_FatherId:[NSString stringWithFormat:@"0"];
    [extraParamsDic setObject:self.m_FatherId forKey:@"fatherId"];
    self.m_requsetID = [YKHttpAPIHelper startLoadJSON:MMUSE_URL 
                                      extraParams:extraParamsDic 
                                           object:self 
                                         onAction:@selector(response_data_category:)];
}


#pragma mark-
#pragma mark 获取 分类列表数据

-(void)response_data_category:(id)json_obj
{
    [self stopLoading];
    NSLog(@"json_obj is %@",json_obj);

    if (json_obj == nil) {
        NSLog(@"is null %@",json_obj);
        WBNoticeView *nm = [WBNoticeView defaultManager];
        [nm showErrorNoticeInView:self.view title:@"Network 错误" message:@"可能服务器连接错误"];
        return;
    }else{


    }

    if ([SCNStatusUtility isRequestSuccessJSON:json_obj] == YES)
    {
        GY_Collection_Category* tmp = [[GY_Collection_Category alloc]initWithJSON:json_obj];
        self.m_categorysArr =  tmp.arr_dict_categories;
    }
    [self.m_tableview reloadData];
}

//
//-(void)response_data_category:(id)json_obj
//{
//    [self stopLoading];
//    NSLog(@"json_obj is %@",json_obj);
//    
//    if (json_obj == nil) {
//        NSLog(@"is null %@",json_obj);
//        WBNoticeView *nm = [WBNoticeView defaultManager];
//        [nm showErrorNoticeInView:self.view title:@"Network 错误" message:@"可能服务器连接错误"];
//        return;    
//    }else{
//        
//        
//    }
//      
//    if ([SCNStatusUtility isRequestSuccessJSON:json_obj] == YES)
//    {
//       NSArray *categorysNodeArr = (NSArray*)[json_obj objectForKey:@"data"];
//       if ([categorysNodeArr count]>0) 
//       {
//            NSMutableArray *categoryArr = [[NSMutableArray alloc]init];
//            self.m_categorysArr = categoryArr;
//            
//            for (id category in categorysNodeArr) 
//            {
//                //Category_Data *categorysData = [[Category_Data alloc]init];
//                GY_Model_Category *category_data =  [[GY_Model_Category alloc]init];
//
////                NSString *mimage;
////                NSString *mname;
////                NSString *mfatherId;
////                NSString *mcategoryId;
////                NSString *mchildNum;
//                
//                [category_data parseFromJSON:category];
//                
//                //if ([m_FatherId isEqualToString:@"0"]) {
//                //					[self.m_classIdNameDic setObject:categorysData.mname forKey:categorysData.mcategoryId];
//                //				}else if (![categorysData.mname isEqualToString:[m_classIdNameDic valueForKey:categorysData.mcategoryId]]) {
//                //					[self.m_classIdNameDic setObject:categorysData.mname forKey:categorysData.mcategoryId];
//                //				}
//                    
//                [self.m_categorysArr addObject:category_data];
//            }
//       }
//    }
//      
//    [self.m_tableview reloadData];
//}

-(void)setNowClassifiedData:(int)_index classLayer:(int)_classLayer{
	
	if (_classLayer == 0) {
		//根目录
		if ([DataWorld shareData].m_nowClassifiedData) {
			[DataWorld shareData].m_nowClassifiedData = nil;
		}
		return;
	}
	//把当前分类名和上级分类名存入DataWorld(以便页面跳转统计)
	if ([self.m_categorysArr count]>0) {
//		Category_Data* _cData = [self.m_categorysArr objectAtIndex:_index];
        
        
        NSMutableDictionary* dict = (NSMutableDictionary*)[self.m_categorysArr objectAtIndex:_index];
        
		if ([DataWorld shareData].m_nowClassifiedData) {
			//原来存在
			NSString* _parentName = [DataWorld shareData].m_nowClassifiedData.m_classifiedName;
			if (_parentName && (![_parentName isEqualToString:@""] || [_parentName length]>0)) {
				//把原来的classifiedName改为parentClassifiedName
				[DataWorld shareData].m_nowClassifiedData.m_parentClassifiedName = _parentName;
			}
//			[DataWorld shareData].m_nowClassifiedData.m_classifiedName = _cData.mname;
            [DataWorld shareData].m_nowClassifiedData.m_classifiedName = dict[@"name"];

		}else {
			//原来没有，需新建
			SCNNowClassifiedData* _nowClassifiedData = [[SCNNowClassifiedData alloc]init];
//			_nowClassifiedData.m_classifiedName = _cData.mname;
            _nowClassifiedData.m_classifiedName = dict[@"name"];
            
			[DataWorld shareData].m_nowClassifiedData = _nowClassifiedData;
		}
	}
}

-(void)goBrandClassified:(id)sender
{
    [Go2PageUtility go2BrandClassifiedViewController:self withFatherId:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.m_tableview = nil;
    self.m_requsetID = nil;
	self.m_classIdNameDic = nil;
   
	if (self.m_FatherId && [self.m_FatherId intValue] != 0) {
		self.m_categorysArr = nil;
	}
}


- (void)dealloc {
    [YKHttpAPIHelper cancelRequestByID:self.m_requsetID];
}

#pragma mark －
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.m_categorysArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    int row= indexPath.row;
	static NSString *Classfiled_CellIdentifier = @"ClassfiledCell";
    
//    Category_Data *categorysData = (Category_Data *)[self.m_categorysArr objectAtIndex:row];
    
    NSMutableDictionary* dict = (NSMutableDictionary*)[self.m_categorysArr objectAtIndex:row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Classfiled_CellIdentifier];
    if (cell == nil) {
        NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNClassfiledViewCell" owner:self options:nil];
        cell = [cellNib objectAtIndex:0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"classified_cellBg.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[DataWorld getImageWithFile:@"classified_cellBg_SEL.png"]];
    }
	
    HJManagedImageV *images = (HJManagedImageV *)[cell viewWithTag:tag_HJManagedImageV];
    images.image = [DataWorld getImageWithFile:@"classified_loading.png"];
    [HJImageUtility queueLoadImageFromUrl:dict[@"image"] imageView:images];
    
    UILabel *nameLable = (UILabel *)[cell viewWithTag:tag_nameLable];
    nameLable.text = dict[@"name"];
	return cell;

}
	
#pragma mark -
#pragma mark UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = indexPath.row;
//    Category_Data *categorysData = (Category_Data *)[self.m_categorysArr objectAtIndex:row];
    
    NSMutableDictionary* dict = (NSMutableDictionary*)[self.m_categorysArr objectAtIndex:row];
    
    
//    NSString *categoryID = categorysData.mcategoryId;
//    NSString *childNum = categorysData.mchildNum;
//    NSString *title   = categorysData.mname;


    NSString *categoryID = dict[@"categoryId"];
    NSString *childNum = dict[@"childNum"];
    NSString *title   = dict[@"name"];
    
    if ([childNum intValue]==0)
    {
        [Go2PageUtility go2ProductListViewController:self withKeyword:nil withCategoryId:categoryID withIsSearch:NO withCategoryName:title withBrandId:nil withTypeId:nil withType:nil];
    }
    else
    {
		[self setNowClassifiedData:indexPath.row classLayer:1];
		
		//页面跳转行为统计
		[super BehaviorPageJump];
		
        [Go2PageUtility go2ClassFiledViewController:self categoryID:categoryID Title:title];
    }

}



-(void)goBack{
	//把DataWorld中的nowClassifiedData更新
	[self setNowClassifiedData:0 classLayer:0];
	[super goBack];
}

-(NSString*)fillRootName:(NSString*)str{
	return ((str==nil||[str length]==0)?@"分类浏览":str);
}

//-(void)reFreshVc{
//	
//	if (!m_FatherId) {
//		[super BehaviorPageJump];
//	}
//}

#pragma mark Behavior
-(void)BehaviorPageJump{
#ifdef USE_BEHAVIOR_ENGINE
#endif
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _parentName = [self fillRootName:KDataWorld.m_nowClassifiedData.m_parentClassifiedName];
	NSString* _name = [YKStringUtility strOrEmpty:KDataWorld.m_nowClassifiedData.m_classifiedName];
	NSString* _param = nil;
	if ([_name length]>0) {
		_param = [NSString stringWithFormat:@"%@|%@",_parentName,_name];
	}else {
		_param = [NSString stringWithFormat:@"%@",_parentName];
	}

	NSLog(@"%@",_param);
	return _param;
#else
	return nil;
#endif
}

@end
