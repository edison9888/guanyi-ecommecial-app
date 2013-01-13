//
//  SCNMoreProductInfoViewController.m
//  SCN
//
//  Created by admin on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SCNMoreProductInfoViewController.h"
#import "SCNProductDetailData.h"

#import "Go2PageUtility.h"

@implementation SCNMoreProductInfoViewController

@synthesize  m_tableView;
@synthesize m_infoArr;
@synthesize  m_productCode,m_comment,m_consult;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProductCode:(NSString *)productCode{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        self.m_productCode = productCode ? productCode:[NSString stringWithFormat:@"0"];;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多商品信息";
	self.pathPath = @"/productinfo";
    self.m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.backgroundColor = [UIColor clearColor];
    self.m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.m_tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.m_infoArr == nil) {
        [self request_getProductDetailXmlData];
    }
    
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.m_tableView = nil;
    self.m_infoArr = nil;
    self.m_comment = nil;
    self.m_consult = nil;
}


#pragma mark －
#pragma mark 请求数据
-(void)request_getProductDetailXmlData
{
    NSMutableDictionary *extraParamsDic = [[NSMutableDictionary alloc]init];
    [extraParamsDic setObject:YK_METHOD_GET_PRODUCTDETAIL forKey:@"act"];
    [extraParamsDic setObject:self.m_productCode forKey:@"productCode"];
    [self startLoading];
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParamsDic 
                                           object:self 
                                         onAction:@selector(onrequestgetProductDetailXmlData:)];
}
-(void)onrequestgetProductDetailXmlData:(GDataXMLDocument*)xmlDoc
{
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        GDataXMLElement *data_infoPath = [SCNStatusUtility paserDataInfoNode:xmlDoc];
        NSArray  *detailNodeArr = [data_infoPath nodesForXPath:@"details/detail" error:nil];
        
        if ([detailNodeArr count]>0) {
			NSMutableArray *titleArr = [[NSMutableArray alloc]init];
			self.m_infoArr = titleArr;
            for (GDataXMLElement *detail in detailNodeArr) {
                moreDetailInfo_Data *title_Data = [[moreDetailInfo_Data alloc]init];
                [title_Data parseFromGDataXMLElement:detail];
					
				NSMutableArray *itemDataArr = [[NSMutableArray alloc]init];
				title_Data.itemArr = itemDataArr;
                 NSArray *itemNodeArr  = [detail elementsForName:@"item"];
                
               for (GDataXMLElement *item in itemNodeArr) {
                   moreDetailInfo_item_Data *more_Data = [[moreDetailInfo_item_Data alloc]init];
                   [more_Data parseFromGDataXMLElement:item];
                   more_Data.minfo = [item stringValue];
				   [title_Data.itemArr addObject:more_Data];
                }
				[self.m_infoArr addObject:title_Data];
            }
            
        }
        
        GDataXMLNode *commentNode = [data_infoPath oneNodeForXPath:@"details/comment" error:nil];
        self.m_comment = [commentNode stringValue];
        GDataXMLNode *consultNode = [data_infoPath oneNodeForXPath:@"details/consult" error:nil];
        self.m_consult = [consultNode stringValue];
        [self.m_tableView reloadData];
    }
    [self stopLoading];
}
#pragma mark －
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([self.m_infoArr count]>0) {
		return [self.m_infoArr count]+1;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
    if(section == [self.m_infoArr count])
    {
        return 3;
    }else {
		moreDetailInfo_Data *moreData = (moreDetailInfo_Data *)[self.m_infoArr objectAtIndex:section];
		return [moreData.itemArr count];
	}

	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
	NSString *one_CellIdentifier = @"MoreProductInfoOne";
	NSString *two1_CellIdentifier = @"MoreProductInfoTwo1";
	NSString *two2_CellIdentifier = @"MoreProductInfoTwo2";
    
    UITableViewCell *cell = nil;
    
		if (section==[self.m_infoArr count] && row<2) 
		{
			cell = [tableView dequeueReusableCellWithIdentifier:two1_CellIdentifier];
			if (cell == nil) 
			{
            NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNClassfiledViewCell" owner:self options:nil];
            cell = [cellNib objectAtIndex:4];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			if (row == 0)//买家评论
			{
				UIImageView *image = (UIImageView *)[cell viewWithTag:20];
				[image setImage:[DataWorld getImageWithFile:@"more_icon_commentary.png"]];
				
				UILabel *lable = (UILabel *)[cell viewWithTag:21];
				lable.text = [NSString stringWithFormat:@"%@(%@)",@"买家评论",self.m_comment !=nil ? self.m_comment : @"0"];
			}
			else if (row == 1)//售前咨询
			{
				UIImageView *image = (UIImageView *)[cell viewWithTag:20];
				[image setImage:[DataWorld getImageWithFile:@"more_icon_consultation.png"]];
				
				UILabel *lable = (UILabel *)[cell viewWithTag:21];
				lable.text = [NSString stringWithFormat:@"%@(%@)",@"售前咨询",self.m_consult !=nil ? self.m_consult : @"0"];
			}
			
        }
	   //电话
		else if (section == [self.m_infoArr count] && row==2) 
		{
			cell = [tableView dequeueReusableCellWithIdentifier:two2_CellIdentifier];
			if (cell == nil) {
                NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNClassfiledViewCell" owner:self options:nil];
				cell = [cellNib objectAtIndex:5];
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
			}
			UIImageView *imageV = (UIImageView *)[cell viewWithTag:24];
			[imageV setImage:[[DataWorld getImageWithFile:@"com_button_normal.png"]stretchableImageWithLeftCapWidth:12 
																									   topCapHeight:12]];
			[imageV setHighlightedImage:[[DataWorld getImageWithFile:@"com_button_select.png"]stretchableImageWithLeftCapWidth:12 
																												  topCapHeight:12]];
			
			
			UILabel *phoneNumber = (UILabel *)[cell viewWithTag:25];
			phoneNumber.text = YK_DISPLAY400PHONE_NUMBER;
			UIButton *phoneButton =(UIButton *)[cell viewWithTag:23];
			[phoneButton addTarget:self action:@selector(onActionPhone:) forControlEvents:UIControlEventTouchUpInside];
        }
		else  
		{
			cell = [tableView dequeueReusableCellWithIdentifier:one_CellIdentifier];
			if (cell == nil) 
			{
                NSArray *cellNib = [[NSBundle mainBundle]loadNibNamed:@"SCNClassfiledViewCell" owner:self options:nil];
				cell = [cellNib objectAtIndex:3];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			moreDetailInfo_Data *moreData = (moreDetailInfo_Data *)[self.m_infoArr objectAtIndex:section];
			moreDetailInfo_item_Data *itemD = (moreDetailInfo_item_Data *)[moreData.itemArr objectAtIndex:row];
			UILabel *nameLable = (UILabel *)[cell viewWithTag:10];
			nameLable.text = [NSString stringWithFormat:@"%@",itemD.mname != nil ? itemD.mname :@""];
			UILabel *infoLable = (UILabel *)[cell viewWithTag:11];
			infoLable.text = [NSString stringWithFormat:@"%@",itemD.minfo != nil ? itemD.minfo :@""];
            UIImageView *separateImagV = (UIImageView *)[cell viewWithTag:12];
            separateImagV.hidden = NO;
            if (row == [moreData.itemArr count]-1) {
                separateImagV.hidden= YES;
            }
			

        }
    
    	return cell;
}
#pragma mark -
#pragma mark PhoneAction
-(void)onActionPhone:(id)sender
{
    [SCNStatusUtility makeCall:YK_400PHONE_NUMBER];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"其他商品信息";
//    }
//    if (section == 1) {
//        return @"评论与咨询";
//    }
//    return nil;
//}

#pragma mark -
#pragma mark UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row==2) {
        return 65.0f;
    }
    if (indexPath.section == 0) {
        return 30.0f;
    }
    return 44.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if ([self.m_infoArr count]>0) {
		
		UIView *headerView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 320, 20)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        [backImageView setImage:[DataWorld getImageWithFile:@"com_sectionBackground.png"]];
        [headerView addSubview:backImageView];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 20)];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [UIColor whiteColor];
        titleLable.font = [UIFont systemFontOfSize:13.0f];
        [headerView addSubview:titleLable];
		
		if (section <[self.m_infoArr count]) {
			moreDetailInfo_Data *moreData = (moreDetailInfo_Data *)[self.m_infoArr objectAtIndex:section];
            if (moreData.mtitle == nil || [moreData.mtitle isEqualToString:@""]) {
                titleLable.text = @"其他品牌信息";
            }else{
                titleLable.text = moreData.mtitle;
            }
			
		}else if (section == [self.m_infoArr count]) {
			titleLable.text = @"评论与咨询";
		}
		return headerView;
	}

    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    if (section==1) {
        if (row==0) {
            [Go2PageUtility go2CommentaryListViewController:self productCode:self.m_productCode];
        }else if(row==1){
            
            //[Go2PageUtility showloginViewControlelr:self action:@selector(go2UserConsultationViewController) withObject:nil];
			[self go2UserConsultationViewController];
        }
    }
    
}
-(void)go2UserConsultationViewController
{
    [Go2PageUtility go2UserConsultationViewController:self productCode:self.m_productCode];
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _productName = [[DataWorld shareData] m_nowProductData].m_productName;
	NSString* _productCode = [[DataWorld shareData] m_nowProductData].m_productCode;
	NSString* _param = [NSString stringWithFormat:@"%@|%@",_productName,_productCode];
	return _param;
#else
	return nil;
#endif
}

@end
