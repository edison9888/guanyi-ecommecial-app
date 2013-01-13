//
//  SCNAnnalViewController.m
//  SCN
//
//  Created by chenjie on 12-07-27.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNMycollectionViewController.h"
#import "YKButtonUtility.h"
#import "YKStringUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "YKButtonUtility.h"
#import "Go2PageUtility.h"
#import "HJManagedImageV.h"
#import "SCNConfig.h"
#import "YKCustomMiddleLineLable.h"
#import "SCNStatusUtility.h"
#import "GY_Collections.h"

#define IMGVIEW_PRODUCT          10
#define LABELTAG_PRODUCTINFO     11
#define LABELTAG_MARKETPRICE     12
#define LABELTAG_SELLPRICE       13

@implementation SCNMycollectionViewController

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

- (void)dealloc
{   
   NSLog(@"我的收藏页面dealloc调用");
    [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewDidUnload
{   
    
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.m_currIndexpath = nil;
    self.m_pageinfodata = nil;
    self.m_mutarray_productlist = nil;
    self.m_rightbutton = nil;
    [self resetDataSource];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    if (!m_isRequestsuccess) {
        [self requestFavorites:m_int_page];
        [self.m_collectionTableView setHidden:YES];
    }
        
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (m_isRequesting && self.m_number_requestID != nil) {
        
        [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
        m_isRequesting = NO;
        self.m_number_requestID = nil;
    }
}
-(void)resetDataSource{
    
    [self.m_mutarray_productlist removeAllObjects];
    m_int_page = 1;
    m_isRequestsuccess = NO;
        
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = @"收藏夹";
	self.pathPath = @"/favorite";
    
    self.m_mutarray_productlist = [NSMutableArray arrayWithCapacity:0];
    
    self.m_pageinfodata= [[SCNMyCollectionPageinfoData alloc] init];
    self.m_pageinfodata.mpageSize = @"10";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(NotifyddnewCollection:)
												 name:YK_COLLECTION_CHANGE object:nil];
    
    self.m_collectionTableView.separatorColor = YK_CELLBORDER_COLOR;
    [self resetDataSource];
    
    
}
-(void)addNavigationbuttonOfEdit
{
    
    self.m_rightbutton= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 40, 42)
                                                    title:@"编辑"
                                              normalImage:@"com_btn.png"
                                              highlighted:@"com_btn_SEL.png"];
	[self.m_rightbutton addTarget:self action:@selector(toEdit:) forControlEvents:UIControlEventTouchUpInside];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:self.m_rightbutton.frame];
	[ricusview addSubview:self.m_rightbutton];
	
    UIBarButtonItem * _barbuttonItem_edit = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_edit;

    
    

}
-(void)NotifyddnewCollection:(NSNotification *)notify
{    
    [self resetDataSource];
    
}
#pragma mark -请求收藏夹列表
-(void)requestFavorites:(int)currentpage{
    if (m_isRequesting) {
        return;
    }
    
    [self startLoading];
	m_isRequesting = YES;
    NSString* v_method = [YKStringUtility strOrEmpty:MMUSE_METHOD_GET_FAVORITELIST];
    NSString* v_page = [NSString stringWithFormat:@"%d",currentpage];
    NSString* v_pagesize = [YKStringUtility strOrEmpty:self.m_pageinfodata.mpageSize];
    
    NSDictionary* extraParam= @{@"method": v_method,
                               @"page": v_page,
                               @"pagesize": v_pagesize};
    
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onResponseFavorites:)];
    
}
-(void)onResponseFavorites:(id)json_obj
{
    [self stopLoading];
    m_isRequesting =NO;
    
	
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]) {
        m_isRequestsuccess = YES;
        
        GY_BaseCollection* coll = [[GY_BaseCollection alloc]initWithJSON:json_obj];
        
//        todo this
//        if (pageinfo) {
//            [self.m_pageinfodata parseFromGDataXMLElement:pageinfo];
//            m_int_page = [m_pageinfodata.mpage intValue];
//            m_int_totalpage = [m_pageinfodata.mtotalPage intValue];
//        }else{
//            
//            if ([self.m_mutarray_productlist count] > 0) {
//                
//                m_int_page ++;
//            }
//            
//        }
        
        NSMutableArray* tempArrayList = (NSMutableArray*)coll.collection_data;
                
        if ([tempArrayList count] > 0) {
            [self addNavigationbuttonOfEdit];
            [self.m_collectionTableView setHidden:NO];
            [self.m_collectionTableView reloadData];
        }else{
            [self showNotecontent:@"您暂没有收藏的商品."];
        }
    }
}
#pragma mark -删除收藏夹列表
-(void)requestDeleteFavorite:(NSString *)productCode
{
    if (m_isRequesting) {
        return;
    }
    [self startLoading];
	m_isRequesting = YES;
    
    NSString* v_productCode = [YKStringUtility strOrEmpty:productCode];
    
    NSString* v_method = [YKStringUtility strOrEmpty:MMUSE_METHOD_DELFAVORITE];
    NSDictionary* extraParam= @{@"method": v_method,
                               @"productCode": v_productCode};
    
   self.m_number_requestID =  [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onResponseDeleteFavorite:)];

}
-(void)onResponseDeleteFavorite:(id)json_obj
{
    [self stopLoading];
    
    m_isRequesting =NO;
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]) {
        [self.m_mutarray_productlist removeObjectAtIndex:m_currIndexpath.row];
        [self.m_collectionTableView deleteRowsAtIndexPaths:@[m_currIndexpath] withRowAnimation:UITableViewRowAnimationRight];
        
        if ([self.m_mutarray_productlist count] <1) {
            [self showNotecontent:@"您暂没有收藏的商品."];
            [self.m_rightbutton setHidden:YES];
            
            }
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.m_mutarray_productlist count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"SCNMycollection_Cell"];
    
    if ( !cell ) {		
        NSArray* xib = [[NSBundle mainBundle] loadNibNamed:@"SCNMycollection_Cell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
    }
    
    [YKButtonUtility setCommonCellBg:cell];
    
    SCNMyCollectionData* collectioninfo = [self.m_mutarray_productlist objectAtIndex:[indexPath row]];
    // 1.产品图片
    
    HJManagedImageV *images = (HJManagedImageV *)[cell viewWithTag:IMGVIEW_PRODUCT];
    images.image = [UIImage imageNamed:@"com_loading103x103.png"];
    [HJImageUtility queueLoadImageFromUrl:collectioninfo.mimage imageView:images];
    images.layer.borderWidth = 1;
    [images.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];

    UIImageView	*pImgView = (UIImageView *)[cell viewWithTag:IMGVIEW_PRODUCT];
    pImgView.layer.borderWidth = 1;
    pImgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // 2.品牌名
    UILabel *pTitleLbl = (UILabel *)[cell viewWithTag:LABELTAG_PRODUCTINFO];
    pTitleLbl.text =  collectioninfo.mname;
    
    // 3.市场价
    YKCustomMiddleLineLable * label_marketprice= (YKCustomMiddleLineLable *)[cell viewWithTag:LABELTAG_MARKETPRICE];
    label_marketprice.text =[NSString stringWithFormat:@"市场价: ¥%@",[SCNStatusUtility getPriceString:collectioninfo.mmarketPrice]] ;
    label_marketprice.enabled_middleLine = YES;
    
    // 4.销售价
    UILabel * label_sellprice = (UILabel *)[cell viewWithTag:LABELTAG_SELLPRICE];
    label_sellprice.text = [NSString stringWithFormat:@"%@",[SCNStatusUtility getPriceString:collectioninfo.msellPrice]] ;
    
//    CGRect pRect = CGRectMake(pPriceLbl.frame.origin.x , pPriceLbl.frame.origin.y, pPriceLbl.frame.size.width, pPriceLbl.frame.size.height);
//    pPriceLbl.frame = pRect;
    
    
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 67;
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE 
													message:@"您确认要删除此收藏吗？" 
												   delegate:self 
										  cancelButtonTitle:@"取消" 
										  otherButtonTitles:@"确定",nil];
	[alert show];
    
    self.m_currIndexpath = indexPath;
    
    NSLog(@"[%d]",indexPath.row);
    NSLog(@"[%d]",indexPath.section);
           
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
		NSMutableDictionary* collectioninfo = [self.m_mutarray_productlist objectAtIndex:[m_currIndexpath row]];
        [self requestDeleteFavorite:[collectioninfo objectForKey:@"product_code"]];
        
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"成功删除此收藏商品!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
                       
    }    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* collectioninfo = [self.m_mutarray_productlist objectAtIndex:[indexPath row]];
    
    [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self
                                               withProductCode:[collectioninfo objectForKey:@"product_code"] withPstatus:[collectioninfo objectForKey:@"status"]
                                                     withImage:[collectioninfo objectForKey:@"image"]];


}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	int int_row = indexPath.row+1;
    NSLog(@"display.......%d>>>>>>>>>>>>>>>>>>>",int_row);
	if( int_row==([self.m_mutarray_productlist
                   count]+1)/2 && m_int_page < m_int_totalpage){
		//加载下一页
        NSLog(@"准备加载下一页.......>>>>>>>>>>>>>>>>>>>");
		if (!m_isRequesting)
		{
			NSLog(@"加载下一页.......>>>>>>>>>>>>>>>>>>>");
            [self requestFavorites:m_int_page+1];
            
		}		
	}
}
-(IBAction)toEdit:(id)sender{
    [self.m_collectionTableView setEditing:!self.m_collectionTableView.editing animated:YES];
    if (self.m_collectionTableView.editing){
        [self.m_rightbutton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else{
        [self.m_rightbutton setTitle:@"编辑" forState:UIControlStateNormal];
    }
   
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}

@end
