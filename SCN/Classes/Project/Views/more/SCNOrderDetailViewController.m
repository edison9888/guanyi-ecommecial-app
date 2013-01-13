//
//  SCNOrderDetailViewController.m
//  SCN
//
//  Created by chenjie on 11-10-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNOrderDetailViewController.h"
#import "YKHttpAPIHelper.h"
#import "SCNUserInformationData.h"
#import "SCNStatusUtility.h"
#import "YKStringUtility.h"
#import "SCNOrderDetailData.h"
#import "Go2PageUtility.h"
#import "HJManagedImageV.h"
#import "TextBlock.h"

#define LABELTAG_ORDERID       101
#define LABELTAG_STATE         102
#define LABELTAG_TIME          103
#define LABELTAG_TOTALPRICE    201
#define LABELTAG_FREIGHT       202
#define LABELTAG_SAVEPRICE     301
#define LABELTAG_SAVEPHONE     302
#define LABELTAG_SELLPRICE     401
#define LABELTAG_TOTALNUMBER   402
#define IMAGEVIEWTAG_IMAGE     501
#define LABELTAG_NAME          502
#define LABELTAG_NUMBER        503
#define LABELTAG_PRICE         504
#define LABELTAG_ORDERTIME     601
#define LABELTAG_ORDERSTATE    603
#define LABELTAG_ENDORDERTIME  602
#define LABELTAG_EDDORDERSTATE 604
#define LABELTAG_ADRESS        701
#define LABELTAG_CONSIGNEE     702
#define LABELTAG_PHONE         703
#define LABELTAG_LEAVENAME     704
#define LABELTAG_LEAVEWORD     705
#define WEBVIEWTAG_WEBVIEW     801

@implementation SCNOrderDetailViewController


@synthesize m_mutableArray_title,m_orderID;
@synthesize m_orderdeail_data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
orderId : (NSString *) orderid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.m_orderID = orderid;
    }
    return self;
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    self.m_mutableArray_title = nil;
    self.m_orderdeail_data = nil;
    [self resetDataSource];

}
- (void)dealloc
{
    
    NSLog(@"订单详情页面dealloc调用");
}


#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!m_isRequestsuccess) {
        [m_OrderDetail setHidden:YES];
        [self requestOrderDetailXmlData];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YKHttpAPIHelper cancelAllRequest];

}
- (void)resetDataSource
{
    m_isRequestsuccess = NO;
    [m_OrderDetail setHidden:YES];

}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
	self.pathPath = @"/orderdetail";
    
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:
                                 @"商品信息",@"订单追踪",@"收货信息",@"配送方式", nil];
    self.m_mutableArray_title = tempArray;
    
    self.view.backgroundColor = [UIColor whiteColor];
    m_OrderDetail.backgroundColor = [UIColor clearColor];
}

-(void)requestOrderDetailXmlData
{
    if (m_isRequesting) {
        return;
    }
	m_isRequesting = YES;
    [self startLoading];
    
    NSString* v_method =  [YKStringUtility strOrEmpty:@"getOrderInfo"];
    NSString* v_orderId = [YKStringUtility strOrEmpty:m_orderID];
    NSDictionary* extraParam = @{@"act": v_method,
                                @"orderId": v_orderId};	
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestOrderDetailXmlDataResponse:)];


}
-(void)onRequestOrderDetailXmlDataResponse:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    m_isRequesting = NO;

    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        m_isRequestsuccess = YES;
        
        GDataXMLElement * datainfo = [SCNStatusUtility paserDataInfoNode:xmlDoc];
        
        SCNOrderDetailData * _orderdetail_data = [[SCNOrderDetailData alloc] init];
        
        _orderdetail_data.morderId = [[[datainfo oneElementForName:@"orderInfo"] attributeForName:@"orderId"] stringValue];
        _orderdetail_data.mlogisticsTrack = [[datainfo oneElementForName:@"logisticsTrack"]  stringValue];
        _orderdetail_data.mmsg = [[datainfo oneElementForName:@"msg"] stringValue];
        
        GDataXMLElement * orderinfo = [datainfo oneElementForName:@"orderInfo"];
        
        _orderdetail_data.morderStatus = [[orderinfo oneElementForName:@"orderStatus"] stringValue];
        _orderdetail_data.morderTime = [[orderinfo oneElementForName:@"orderTime"]stringValue];
        _orderdetail_data.mtotalMoney = [[orderinfo oneElementForName:@"totalMoney"]stringValue];
        _orderdetail_data.mfreight = [[orderinfo oneElementForName:@"freight"]stringValue];
        _orderdetail_data.msavePrice = [[orderinfo oneElementForName:@"savePrice"]stringValue];
        _orderdetail_data.mpayMoney = [[orderinfo oneElementForName:@"payMoney"]stringValue];
        _orderdetail_data.msavePhonePrice = [[orderinfo oneElementForName:@"savePhonePrice"]stringValue];
        _orderdetail_data.mnumber = [[orderinfo oneElementForName:@"number"]stringValue];
        
        GDataXMLElement * _address = [orderinfo oneElementForName:@"address"];
        _orderdetail_data.maddress = [_address stringValue];
        _orderdetail_data.mconsignee = [[_address attributeForName:@"consignee"] stringValue];
        _orderdetail_data.mphone  = [[_address attributeForName:@"phone"] stringValue];
        _orderdetail_data.mprovince = [[_address attributeForName:@"province"] stringValue];
        _orderdetail_data.mcity = [[_address attributeForName:@"city"] stringValue];
        _orderdetail_data.marea = [[_address attributeForName:@"area"] stringValue];
        _orderdetail_data.mpayType = [[orderinfo oneElementForName:@"payType"]stringValue];
        
        NSLog(@"morderStatus>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.morderStatus);
        NSLog(@"morderTime>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.morderTime);
        NSLog(@"mtotalMoney>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mtotalMoney);
        NSLog(@"mfreight>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mfreight);
        NSLog(@"msavePrice>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.msavePrice);
        NSLog(@"msavePhonePrice>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.msavePhonePrice);
        NSLog(@"mpayMoney>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mpayMoney);
        NSLog(@"mnumber>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mnumber);
        NSLog(@"maddress>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.maddress);
        NSLog(@"mconsignee>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mconsignee);
        NSLog(@"mphone>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mphone);
        NSLog(@"mpayType>>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderdetail_data.mpayType);

                   
        NSArray * _productlistArray = [datainfo nodesForXPath:@"productList/item" error:nil];
        NSMutableArray * tempArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (GDataXMLElement * _productlist in _productlistArray){
            
            SCNOrderProductListData * _productlist_data = [[SCNOrderProductListData alloc] init];
            
            [_productlist_data parseFromGDataXMLElement:_productlist];
            
            [tempArray addObject:_productlist_data];
            _orderdetail_data.m_mutarray_productlist = tempArray;
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_productlist_data.msku);
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_productlist_data.mname);
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_productlist_data.mimage);
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_productlist_data.msellPrice);
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_productlist_data.mnumber);
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_productlist_data.mproductCode);
            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%d",[_orderdetail_data.m_mutarray_productlist count]);
        }
        
        NSArray * _orderTrackArray = [datainfo nodesForXPath:@"orderTrack/status" error:nil];
        
        NSMutableArray * _tempArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (GDataXMLElement * _orderTrack in _orderTrackArray){
            
            SCNOrderStatusData * _orderstatus_data = [[SCNOrderStatusData alloc] init];
            
            _orderstatus_data.mstatus = [_orderTrack stringValue]; 
            _orderstatus_data.mtime = [[_orderTrack attributeForName:@"time"]stringValue];
            
//            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderstatus_data.mstatus);
//            NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",_orderstatus_data.mtime);
            
            [_tempArray addObject:_orderstatus_data];
            
        }
        _orderdetail_data.m_mutarray_status = _tempArray;
        
        self.m_orderdeail_data = _orderdetail_data;
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>%@",m_orderdeail_data.maddress);
        
        if (m_OrderDetail != nil) {
            [m_OrderDetail reloadData];
            [m_OrderDetail setHidden:NO];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numberofRows = 0;
    if (section == 0) {
        numberofRows = 4;
    }
    else if (section == 1) {
        numberofRows = [m_orderdeail_data.m_mutarray_productlist count];
    }
    else if (section == 2){
        numberofRows = 2;
    }else {
        numberofRows = 1;
    }
    return numberofRows;
} 
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
    NSString * NumberCellidentifier = @"NumberCellidentifier";
    NSString * TotalCellidentifier = @"TotalCellidentifier";
    NSString * SaveCellidentifier = @"SaveCellidentifier";
    NSString * PayForCellidentifier = @"PayForCellidentifier";
    NSString * ProductCellidentifier = @"ProductCellidentifier";
    NSString * StatesCellidentifier = @"StatesCellidentifier";
    NSString * PursueCellidentifier = @"PursueCellidentifier";
    NSString * AdressCellidentifier = @"AdressCellidentifier";
    NSString * SCNCellidentifier = @"SCNCellidentifier";
    
	UITableViewCell *cell = nil;
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if (section == 0) {
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:NumberCellidentifier];
            if (cell == nil) {
                 NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
                 cell = [xib objectAtIndex:0];
            }
            UILabel* _label_orderid = (UILabel *)[cell viewWithTag:LABELTAG_ORDERID];
            _label_orderid.text = m_orderdeail_data.morderId;
            
            UILabel* _label_state = (UILabel *)[cell viewWithTag:LABELTAG_STATE];
            _label_state.text = m_orderdeail_data.morderStatus;
            
            UILabel* _label_time = (UILabel *)[cell viewWithTag:LABELTAG_TIME];
            _label_time.text = m_orderdeail_data.morderTime;
            
        }else if (row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:TotalCellidentifier];
            if (cell == nil) {
                 NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
                cell = [xib objectAtIndex:1];
            }
            
            UILabel* _label_totalprice = (UILabel *)[cell viewWithTag:LABELTAG_TOTALPRICE];
            _label_totalprice.text = [SCNStatusUtility getPriceString:m_orderdeail_data.mtotalMoney];
            
            UILabel* _label_freight = (UILabel *)[cell viewWithTag:LABELTAG_FREIGHT];
            _label_freight.text = [SCNStatusUtility getPriceString:m_orderdeail_data.mfreight];   
            
        }
        else if (row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:SaveCellidentifier];
            if (cell == nil) {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
                cell = [xib objectAtIndex:2];
            }
            UILabel* _label_savepricd = (UILabel *)[cell viewWithTag:LABELTAG_SAVEPRICE];
            UILabel* _label_savephone = (UILabel *)[cell viewWithTag:LABELTAG_SAVEPHONE];
            
            if (!m_orderdeail_data.msavePrice || [m_orderdeail_data.msavePrice doubleValue] <= 0) {
                [_label_savepricd setHidden:YES];
                
                _label_savephone.frame = _label_savepricd.frame;
                
            }else{
                _label_savepricd.text = [NSString stringWithFormat:@"优惠金额:   %@",[SCNStatusUtility getPriceString:m_orderdeail_data.msavePrice] ];
            }
            
            if (!m_orderdeail_data.msavePhonePrice ||[m_orderdeail_data.msavePhonePrice doubleValue] <= 0) {
                [_label_savephone setHidden:YES];
            }else{
                _label_savephone.text =[NSString stringWithFormat:@"手机下单立减:  %@",[SCNStatusUtility getPriceString:m_orderdeail_data.msavePhonePrice] ] ;
            }
                  
        }
        else  {
            cell = [tableView dequeueReusableCellWithIdentifier:PayForCellidentifier];
            if (cell == nil) {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
                cell = [xib objectAtIndex:3];
            }
            UILabel* _label_sellprice = (UILabel *)[cell viewWithTag:LABELTAG_SELLPRICE];
            _label_sellprice.text =[NSString stringWithFormat:@"¥ %.2f",[m_orderdeail_data.mpayMoney floatValue]]; 
            _label_sellprice.textColor = [UIColor redColor];
            
            UILabel* _label_totalnumber = (UILabel *)[cell viewWithTag:LABELTAG_TOTALNUMBER];
            _label_totalnumber.text = m_orderdeail_data.mnumber;
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	else if (section == 1){
        
        cell = [tableView dequeueReusableCellWithIdentifier:ProductCellidentifier];
        if (cell == nil) {
             NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
            cell = [xib objectAtIndex:4];
        }   
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        SCNOrderProductListData * _productlist_data = [self.m_orderdeail_data.m_mutarray_productlist objectAtIndex:[indexPath row]];
        HJManagedImageV * _imageview_product = (HJManagedImageV *)[cell viewWithTag:IMAGEVIEWTAG_IMAGE];
        [HJImageUtility queueLoadImageFromUrl:_productlist_data.mimage imageView:_imageview_product];
        _imageview_product.layer.borderWidth = 1;
        [_imageview_product.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
        
        UILabel* _label_number = (UILabel *)[cell viewWithTag:LABELTAG_NUMBER];
        _label_number.text = [NSString stringWithFormat:@"%@", _productlist_data.mnumber ];
        
        UILabel* _label_name = (UILabel *) [cell viewWithTag:LABELTAG_NAME];
        _label_name.text = _productlist_data.mname;
        
        UILabel* _label_price = (UILabel *)[cell viewWithTag:LABELTAG_PRICE];
        _label_price.text = [NSString stringWithFormat:@"¥%.2f",[_productlist_data.msellPrice floatValue]];
        
        }
    else if (section == 2){
        
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:StatesCellidentifier];
            if (cell == nil) {   
//                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
//                cell = [xib objectAtIndex:5];
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StatesCellidentifier];
                
                UILabel * label_states = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 64, 21)];
                label_states.text = @"订单状态";
                label_states.font = [UIFont systemFontOfSize:14];
                label_states.backgroundColor = [UIColor clearColor];
                [cell addSubview:label_states];
                
                for (int i = 0; i<[m_orderdeail_data.m_mutarray_status count]; i ++) {
                    UILabel * label_time = [[UILabel alloc] initWithFrame:CGRectMake(22, 20*(i+1), 140, 21)];
                    label_time.tag = i+600;
                    label_time.font = [UIFont systemFontOfSize:12];
                    label_time.backgroundColor = [UIColor clearColor];
                    
                    TextBlock * textblock_status = [[TextBlock alloc]initWithFrame:CGRectMake(150, 22*(i+1), 170, 0)];
                    textblock_status.tag = i+620;
                    textblock_status.font = [UIFont systemFontOfSize:11];
                    textblock_status.backgroundColor = [UIColor clearColor];
                    
                    [cell addSubview:label_time];
                    [cell addSubview:textblock_status];
                    
                
                }

            }
            CGFloat CellY = 0;
            CGFloat height = 0;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([m_orderdeail_data.m_mutarray_status count] > 0) {
                for ( int i = 0; i< [m_orderdeail_data.m_mutarray_status count]; i ++){
                    SCNOrderStatusData * _orderstatus_data =  [m_orderdeail_data.m_mutarray_status objectAtIndex:i];
                    
                    UILabel * label_time = (UILabel *)[cell viewWithTag:600+i];
                    label_time.text = _orderstatus_data.mtime;
                    
                    TextBlock * textblock_status = (TextBlock *)[cell viewWithTag:620+i];
                    [textblock_status setText:[YKStringUtility stripWhiteSpaceAndNewLineCharacter:_orderstatus_data.mstatus]];
                    
                    height = textblock_status.frame.size.height;
                    CellY = (20*(i+1)+height);
                    NSLog(@"=========================%f",CellY);

                }
            }
            cell.frame = CGRectMake(0, 0, 300, CellY);
            
        }else if (row == 1){
           
            cell  = [tableView dequeueReusableCellWithIdentifier:PursueCellidentifier];
            if (cell == nil) {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
                cell = [xib objectAtIndex:6];
                
            }
             cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    else if (section == 3){
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:AdressCellidentifier];
        if (cell == nil) {
             NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
             cell = [xib objectAtIndex:7];
        }
        NSString * str_tempaddress = [YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_orderdeail_data.maddress];
//        NSString * str_Address = [NSString stringWithFormat:@"%@%@%@%@",m_orderdeail_data.mprovince,m_orderdeail_data.mcity,m_orderdeail_data.marea,str_tempaddress];
		NSString* str_Address = str_tempaddress;
        CGSize size = [str_Address sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(218.0f, 300.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        m_CGfloat_height = size.height;
        
        UILabel *_label_address = (UILabel *)[cell viewWithTag:LABELTAG_ADRESS];
        _label_address.frame = CGRectMake(76.0f, 7.0f, 218.0f, size.height);//显示字符串的label
        _label_address.text = str_Address;
        
        UILabel* _label_consignee = (UILabel *)[cell viewWithTag:LABELTAG_CONSIGNEE];
        _label_consignee.frame = CGRectMake(12, m_CGfloat_height+7,268 , 21);
        _label_consignee.text = [NSString stringWithFormat:@"收  货  人:   %@",[YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_orderdeail_data.mconsignee] ];
        
        UILabel* _label_phone = (UILabel *)[cell viewWithTag:LABELTAG_PHONE];
        _label_phone.frame = CGRectMake(12, m_CGfloat_height+26, 268, 21);
        _label_phone.text =[NSString stringWithFormat:@"联系电话:  %@",m_orderdeail_data.mphone];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * _label_leavename = (UILabel *)[cell viewWithTag:LABELTAG_LEAVENAME];
        [_label_leavename setHidden:YES];
        UILabel * _label_leaveword = (UILabel *)[cell viewWithTag:LABELTAG_LEAVEWORD];
        
        if (!m_orderdeail_data.mmsg || [m_orderdeail_data.mmsg length] < 1 ) {
            [_label_leaveword setHidden:YES];
        }else{
            _label_leavename.frame = CGRectMake(12, m_CGfloat_height +43, 64, 21);
            [_label_leavename setHidden:NO];
            CGSize size_leaveword = [m_orderdeail_data.mmsg sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(218.0f, 40.0f) lineBreakMode:UILineBreakModeCharacterWrap];
            
            _label_leaveword.frame = CGRectMake(76, m_CGfloat_height+47, size_leaveword.width,size_leaveword.height);
            _label_leaveword.text = [NSString stringWithFormat:@"%@",[YKStringUtility stripWhiteSpaceAndNewLineCharacter:m_orderdeail_data.mmsg]];
             NSLog(@"mmsg>>>>>>>>>>>>>>>>>>>>>>>>>%@",m_orderdeail_data.mmsg);
        }
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:SCNCellidentifier];
        if (cell == nil) {
             NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNOrderDetailListCell" owner:self options:nil];
            cell = [xib objectAtIndex:8];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }	
    
    cell.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
	return cell;
}   
// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    CGFloat heght = 0;
    
    UITableViewCell * cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *_label_address = (UILabel *)[cell viewWithTag:LABELTAG_ADRESS];
    UILabel *_label_leaveword = (UILabel *)[cell viewWithTag:LABELTAG_LEAVEWORD];
    
    CGRect rect = [_label_leaveword frame]; 
    CGFloat tempheght = _label_address.frame.size.height;
    
    if (section == 0) {
        if (row == 0) {
            heght = 63;
        }else if (row == 1){
        
            heght = 45;
        }
        else if (row == 2)
		{
            if (!m_orderdeail_data.msavePhonePrice || [m_orderdeail_data.msavePhonePrice doubleValue] <= 0 || !m_orderdeail_data.msavePrice || [m_orderdeail_data.msavePrice doubleValue] <=0)
			{
				if ( (!m_orderdeail_data.msavePhonePrice || [m_orderdeail_data.msavePhonePrice doubleValue] <= 0)
					&& (!m_orderdeail_data.msavePrice || [m_orderdeail_data.msavePrice doubleValue] <=0))
				{
					heght = 0;
				}
				else
					heght = 33;
            }
			else
			{
                heght = 47;
            }
        }
        else {
            heght = 46;
        }
    }
    else if (section == 1){
          heght = 63;
    }
    else if (section == 2){
        if (row == 0) {
            heght = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height+10;
            NSLog(@"--------------------------------%f",cell.frame.size.height);
        }else {
            heght = 36;
        }
    }
    else if (section == 3){
        if (!m_orderdeail_data.mmsg || [m_orderdeail_data.mmsg length] < 1) {
            heght = (tempheght + 50 ) ;
        }else{
            heght = (tempheght + rect.size.height + 50);
        }
    }
    else {
        heght = 36;
    }
    return  heght;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        SCNOrderProductListData * _productlist_data = [self.m_orderdeail_data.m_mutarray_productlist objectAtIndex:[indexPath row]];
        
        [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:_productlist_data.mproductCode withPstatus:_productlist_data.mpstatus withImage:_productlist_data.mimage];

    }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            [Go2PageUtility go2LogisticsTrackingViewController:self Logistics:m_orderdeail_data.mlogisticsTrack];
        }
    }
       
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* _view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 28)];

    UILabel* _label_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 320, 20)];
    _label_title.lineBreakMode = 0;
    _label_title.textColor = [UIColor whiteColor];
    _label_title.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        _view_content.backgroundColor = [UIColor clearColor];
    }
    else {
        if (section == 1) {
            _label_title.text = [self.m_mutableArray_title objectAtIndex:0];
        }
        else if (section ==2) {
            _label_title.text = [self.m_mutableArray_title objectAtIndex:1];
        }
        else if (section ==3) {
            _label_title.text = [self.m_mutableArray_title objectAtIndex:2];
        }
        else if (section ==4) {
            _label_title.text = [self.m_mutableArray_title objectAtIndex:3];
        }
        _view_content.backgroundColor = [UIColor colorWithRed:(float)(68/255.0f) green:(float)(68/255.0f) blue:(float)(68/255.0f) alpha:1];
    }


    UIView* _backgroundview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    _backgroundview.backgroundColor = [UIColor whiteColor];
    
    [_view_content addSubview:_label_title];
    [_backgroundview addSubview:_view_content];
    return _backgroundview;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 35;
}


#pragma mark Behavior
-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	NSString* _param = [NSString stringWithFormat:@"%@",self.m_orderID];
	return _param;
#else
	return nil;
#endif
}
@end
