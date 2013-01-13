//
//  SCNOrderDetailViewController.m
//  SCN
//
//  Created by chenjie on 11-9-30.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNMyOrderFormViewController.h"
#import "SCNOrderDetailViewController.h"
#import "YKHttpAPIHelper.h"
#import "SCNUserInformationData.h"
#import "SCNStatusUtility.h"
#import "Go2PageUtility.h"

#define BUTTONTAG_LEFT         11
#define BUTTONTAG_RIGHT        12
#define LABELTAG_TOTALNUMBER   13
#define LABELTAG_TOTALPRICE    14
#define LABELTAG_ORDERID       101
#define LABELTAG_STATUS        102
#define LABELTAG_PRICE         103
#define LABELTAG_NUMBER        104
#define LABELTAG_CREATTIME     105



@implementation SCNMyOrderFormViewController

@synthesize m_tableView_orderForm;
@synthesize m_view_totalView;
@synthesize m_view_buttonBGview;
@synthesize m_button_leftbutton;
@synthesize m_button_rightbutton;
@synthesize m_mutarray_temparray;
@synthesize m_orderpage_data;
@synthesize m_str_months;
@synthesize m_number_requestID;

-(BOOL)isNeedLogin
{
	return NO;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.m_orderpage_data = nil;
    self.m_view_buttonBGview = nil;
    self.m_button_leftbutton = nil;
    self.m_button_rightbutton = nil;
    self.m_view_totalView = nil;
    self.m_tableView_orderForm = nil;
    self.m_mutarray_temparray = nil;
    self.m_str_months = nil;
    [self resetDataSource];
}
- (void)dealloc
{   
    NSLog(@"我的订单页面dealloc调用");
    [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
}
- (void)overloadingTableview
{
    [self.m_mutarray_temparray removeAllObjects];
    
    [self.m_tableView_orderForm reloadData];
    
    [self.m_tableView_orderForm setHidden: YES];

}
- (void)buttonrequest:(NSString *)months{
    
    [self overloadingTableview];
    NSLog(@">>>>>>>>>>>>>>>>%d",[m_mutarray_temparray count]);
    m_int_currpage = 1;
    m_orderpage_data.mpageSize = @"10";
    m_str_months = months;
    [self requestOrderformXmlData:m_str_months Currentpage:m_int_currpage];
    
    if ([months isEqualToString:@"-1"]) {
        m_button_leftbutton.selected = NO;
        m_button_rightbutton.selected = YES;
    }else{
        m_button_leftbutton.selected = YES;
        m_button_rightbutton.selected = NO;
    }
}

-(IBAction)onActionbuttonpress:(id)sender{
    
    int index = ((UIButton*)sender).tag;
    
    switch (index) {
        case 11:
            //一个月内订单
            NSLog(@"左按钮");
            if (m_int_istagsame == index) {
                if (m_isRuquestsuccess) {
                    return;
                }else{
                    [self buttonrequest:@"1"];
                }
                
            }else{
                m_int_istagsame = index;
                [self buttonrequest:@"1"];
            }
            
            break;
            
        case 12://历史订单
            NSLog(@"右按钮");
            if (m_int_istagsame == index) {
                if (m_isRuquestsuccess)
				{
                    return;
                }
				else
				{
                    [self buttonrequest:@"-1"];
                }
                
            }
			else
			{
                m_int_istagsame = index;
                [self buttonrequest:@"-1"];
            }
            break;
        default:
            break;
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!m_isRuquestsuccess) {
        [self requestOrderformXmlData:m_str_months Currentpage:m_int_currpage];
        [m_tableView_orderForm setHidden:YES];
         m_button_leftbutton.selected = YES;
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (m_isRequesting && m_number_requestID != nil) {
        [YKHttpAPIHelper cancelAllRequest];
        self.m_number_requestID = nil;
        m_isRequesting = NO;
    }
        
}
#pragma mark -数据重置
-(void)resetDataSource{
    
    m_isRuquestsuccess = NO;
    m_int_currpage = 1;
    m_str_months = @"1";
    m_int_istagsame = 11;
    [self.m_mutarray_temparray removeAllObjects];
    [self.m_tableView_orderForm reloadData];

}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = @"我的订单";
	self.pathPath = @"/myorder";
    //初始化装载页码数据模型
     m_orderpage_data= [[SCNOrderPageinfoData alloc] init];
    //初始化装载临时数据数组
    self.m_mutarray_temparray = [NSMutableArray arrayWithCapacity:0];
    
    self.m_view_buttonBGview.backgroundColor = [UIColor blackColor];
    
    m_orderpage_data.mpageSize = @"10";
    
    [self resetDataSource];
}

-(void)requestOrderformXmlData :(NSString *)months Currentpage :(int)currentpage{
    if (m_isRequesting) {
        return;
    }

    [self startLoading];
	m_isRequesting = YES;
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_ORDERLIST];
    NSString* v_months = [YKStringUtility strOrEmpty:m_str_months];
    NSString* v_page = [NSString stringWithFormat:@"%d",currentpage];
    NSString* v_pagesize = [YKStringUtility strOrEmpty:m_orderpage_data.mpageSize];
    
    NSDictionary* extraParam = @{@"act": v_method,
                                @"page": v_page,
                                @"pagesize": v_pagesize,
                                @"months": v_months};	
    
   self.m_number_requestID = [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestOrderformXmlDataResponse:)];
}
-(void)onRequestOrderformXmlDataResponse:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];

    m_isRequesting = NO;
    
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        
        m_isRuquestsuccess = YES;
        
        GDataXMLElement * datainfo = [SCNStatusUtility paserDataInfoNode:xmlDoc];
        
        GDataXMLElement * pageinfo = [datainfo oneElementForName:@"pageinfo"];
        
        if (pageinfo) {
            [self.m_orderpage_data parseFromGDataXMLElement:pageinfo];
            
            m_int_currpage = [m_orderpage_data.mpage intValue];
            m_int_currtotalpage= [m_orderpage_data.mtotalPage intValue];
        }else{
            if ([self.m_mutarray_temparray count] > 0) {
                m_int_currpage ++;
            }
        
        }
        
        
        NSArray* nodeArray	=	[datainfo nodesForXPath:@"orders/order" error:nil];
        
        if ([nodeArray count] > 0 ) {
            for (GDataXMLElement* _e in nodeArray) {
                SCNOrderListlData* orderform = [[SCNOrderListlData alloc]init];
                [orderform parseFromGDataXMLElement:_e];
                [self.m_mutarray_temparray addObject:orderform];
                NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>%d",[m_mutarray_temparray count]);
            }

        }
        if ([self.m_mutarray_temparray count]>0) {
            [m_tableView_orderForm reloadData];
            [self.m_tableView_orderForm setHidden:NO];
            [self hideNotecontent];
        }else{
            [self showNotecontent:@"您暂时还未下任何订单."];
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.m_mutarray_temparray count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderFormListCell"];
	if (cell == nil) {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNMyOrderFormListCell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
		UIView * _view_bgcellview = (UIView *) [YKButtonUtility initBgCornerViewWithHeight:82 cornerRadius:5];
		[cell insertSubview:_view_bgcellview atIndex:0];
	}
    
    SCNOrderListlData* _orderform_data = [self.m_mutarray_temparray objectAtIndex:[indexPath row]];
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>%@",_orderform_data.morderId);

    
    UILabel* _label_orderid = (UILabel*)[cell viewWithTag:LABELTAG_ORDERID];
    _label_orderid.text = _orderform_data.morderId;
    
    UILabel* _label_status = (UILabel*)[cell viewWithTag:LABELTAG_STATUS];
    _label_status.text = _orderform_data.morderStatus;
    
    UILabel* _label_price = (UILabel*)[cell viewWithTag:LABELTAG_PRICE];
    _label_price.text = [NSString stringWithFormat:@"¥%.2f",[_orderform_data.mtotalMoney floatValue]];
    
    UILabel* _label_number = (UILabel*)[cell viewWithTag:LABELTAG_NUMBER];
    _label_number.text = _orderform_data.mnumber;
    
    UILabel* _label_creatTime = (UILabel*)[cell viewWithTag:LABELTAG_CREATTIME];
    NSString * str_temptime = [_orderform_data.mcreateTime substringToIndex:10];
    _label_creatTime.text = [YKStringUtility strOrEmpty:str_temptime];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float  temp_totalprice = 0;
    
    if ([m_mutarray_temparray count] > 0) {
        for (int i = 0; i < [m_mutarray_temparray count]; i ++) {
            
            SCNOrderListlData* _orderform_data = [self.m_mutarray_temparray objectAtIndex:i];
            
            temp_totalprice += [_orderform_data.mtotalMoney floatValue];
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>%f",temp_totalprice);
            
        }

    }
    UILabel * _label_totalprice = (UILabel *)[m_view_totalView viewWithTag:LABELTAG_TOTALPRICE];
    _label_totalprice.text = [NSString stringWithFormat:@"¥%.2f",temp_totalprice];
    
    UILabel * _label_totalnumber = (UILabel *)[m_view_totalView viewWithTag:LABELTAG_TOTALNUMBER];
    _label_totalnumber.text = m_orderpage_data.mnumber;
    
    [m_view_totalView addSubview:_label_totalprice];
    [m_view_totalView addSubview:_label_totalnumber];
  
    
    return m_view_totalView;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int int_row = [indexPath row]+1;
    NSLog(@"display.......%d>>>>>>>>>>>>>>>>>>>",int_row);
	if( int_row== [self.m_mutarray_temparray
                   count] - 1 && m_int_currpage < m_int_currtotalpage){
		//加载下一页
        NSLog(@"准备加载下一页.......>>>>>>>>>>>>>>>>>>>");
		if (!m_isRequesting)
		{
			NSLog(@"加载下一页.......>>>>>>>>>>>>>>>>>>>");
            [self requestOrderformXmlData:m_str_months Currentpage:m_int_currpage +1];
            
		}		
	}
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SCNOrderListlData* orderfrom = [self.m_mutarray_temparray objectAtIndex:[indexPath row]];
    [Go2PageUtility go2OrderDetailViewController:self orderId:orderfrom.morderId];

}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}

@end
