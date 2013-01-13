//
//  SCNAnnalViewController.m
//  SCN
//
//  Created by chenjie on 12-08-03.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNAnnalViewController.h"
#import "YKButtonUtility.h"
#import "SCNStatusUtility.h"
#import "SCNBrowserData.h"
#import "HJManagedImageV.h"
#import "YKButtonUtility.h"
#import "Go2PageUtility.h"
#import "SCNHJManagedImageVUtility.h"

#define IMGVIEWTAG_WAREIMG     10
#define LABELTAG_WAERINFO      11
#define LABELTAG_ORDERID       12

@implementation SCNAnnalViewController

//
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (void)dealloc
{   
     NSLog(@"最近浏览页面dealloc调用");
}
-(void)viewDidUnload
{   
    [super viewDidUnload];
	_m_browseTableView = nil;
    _m_rightbutton = nil;
    _m_mutarray_getAllBrowserdata = nil;
	_m_currIndexpath = nil;
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:(BOOL)animated];
	
	self.m_mutarray_getAllBrowserdata = [NSMutableArray arrayWithCapacity:0];

	[self.m_mutarray_getAllBrowserdata addObjectsFromArray:[SCNStatusUtility getAllBrowserData]];
    
	if ([self.m_mutarray_getAllBrowserdata count] > 0) {
        [self addNavigationbuttonOfEdit];
		[self.m_browseTableView reloadData];
		NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%d",[self.m_mutarray_getAllBrowserdata count]);
	}else{
        [self showNotecontent:@"您还未浏览任何商品."];
    
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品浏览记录";
	self.pathPath = @"/explore";
    
    _m_browseTableView.separatorColor = YK_CELLBORDER_COLOR;

}   
-(void)addNavigationbuttonOfEdit
{
    self.m_rightbutton= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 40, 42)
                                                    title:@"编辑"
                                              normalImage:@"com_btn.png"
                                              highlighted:@"com_btn_SEL.png"];
    //customview
	UIView* ricusview = [[UIView alloc] initWithFrame:self.m_rightbutton.frame];
	[ricusview addSubview:self.m_rightbutton];
	
    UIBarButtonItem * _barbuttonItem_edit = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	
    [self.m_rightbutton addTarget:self action:@selector(toEdit:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_edit;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.m_mutarray_getAllBrowserdata count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"SCNAnnal_ListCell"];
    
    if ( !cell )
	{		
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNAnnal_ListCell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
        
        UIView * _view_bgcell = [YKButtonUtility initBgCornerViewWithHeight:63 cornerRadius:5];
		[cell.contentView insertSubview:_view_bgcell atIndex:0];
        
    }
	int index = [self.m_mutarray_getAllBrowserdata count] - 1 -indexPath.row;
    
	if (index >= 0)
    {
		SCNBrowserData * _browserdata = [self.m_mutarray_getAllBrowserdata objectAtIndex:index];
				
		// 1.产品图片
        SCNHJManagedImageVUtility *images = (SCNHJManagedImageVUtility *)[cell viewWithTag:IMGVIEWTAG_WAREIMG];
        images.image = [UIImage imageNamed:@"com_loading103x103.png"];
        [HJImageUtility queueLoadImageFromUrl:_browserdata.mimageUrl imageView:images];
        images.layer.borderWidth = 1;
        [images.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
		
		// 2.品牌名+商品名+类别
		UILabel *pTitleLbl = (UILabel *)[cell viewWithTag:LABELTAG_WAERINFO];
		pTitleLbl.text =  [NSString stringWithFormat:@"%@,%@",_browserdata.mbrand,_browserdata.mname];
		
		// 3.编码
		UILabel *pPriceLbl = (UILabel *)[cell viewWithTag:LABELTAG_ORDERID];
		pPriceLbl.text =  _browserdata.mbn;
		CGRect pRect = CGRectMake(pPriceLbl.frame.origin.x , pPriceLbl.frame.origin.y, pPriceLbl.frame.size.width, pPriceLbl.frame.size.height);
		pPriceLbl.frame = pRect;
		
		
	}
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
	return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70.0f;
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.m_currIndexpath = indexPath;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:SCN_DEFAULTTIP_TITLE 
													message:@"您确认要删除此记录吗？" 
												   delegate:self 
										  cancelButtonTitle:@"取消" 
										  otherButtonTitles:@"确定",nil];
	[alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int index = [self.m_mutarray_getAllBrowserdata count] - 1 -self.m_currIndexpath.row;
    if (buttonIndex == 1 && index >= 0)
	{		
		[SCNStatusUtility deleteBrowserData:[self.m_mutarray_getAllBrowserdata objectAtIndex:index]];
	    
		[self.m_mutarray_getAllBrowserdata removeObjectAtIndex:index];
        
        [self.m_browseTableView deleteRowsAtIndexPaths:@[self.m_currIndexpath] withRowAnimation:UITableViewRowAnimationRight];
        
        if ([self.m_mutarray_getAllBrowserdata count] < 1) {
            [self showNotecontent:@"您还未浏览任何商品."];
            [self.m_rightbutton setHidden:YES];
            
        }
        //[m_browseTableView reloadData];         
        NSLog(@"===================删除浏览记录成功");
		
    }    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [self.m_mutarray_getAllBrowserdata count] - 1 -indexPath.row;
	SCNBrowserData * _browserdata = nil;
	if (index >= 0) 
	{
		_browserdata = [self.m_mutarray_getAllBrowserdata objectAtIndex:index];
	}
    if (!_browserdata) {
		return;
	}

    [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:_browserdata.mproudctCode withPstatus:_browserdata.mpstatus withImage:_browserdata.mimageUrl];
	
	
}
-(IBAction)toEdit:(id)sender{
    [self.m_browseTableView setEditing: !self.m_browseTableView.editing animated:YES];
	
    if (self.m_browseTableView.editing){
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
     