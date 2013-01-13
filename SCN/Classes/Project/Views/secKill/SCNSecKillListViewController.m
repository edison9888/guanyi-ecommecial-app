//
//  SCNSecKillListViewController.m
//  SCN
//
//  Created by xie xu on 11-10-17.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNSecKillListViewController.h"
#import "SCNSecKillListTableCell.h"
#import "Go2PageUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "SCNSecKillProductData.h"
#import "YKStringHelper.h"
#import "NSDateHelper.h"

@implementation SCNSecKillListViewController
@synthesize m_tableView_secKillList;
@synthesize m_array_seckillProduct;
@synthesize m_string_secKillID;
@synthesize m_data_listAttributeData;
@synthesize m_string_typeName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSecKillID:(NSString*)secKillID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_string_secKillID=secKillID;
        m_int_currPage=1;
        m_int_currPageSize=20;
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
	self.pathPath = @"/seckill";
    //初始化秒杀列表数组
    self.m_array_seckillProduct=[NSMutableArray arrayWithCapacity:0];
    //初始化列表属性数据模型
    SCNSearchProductListData *tempdata = [[SCNSearchProductListData alloc] init];
    self.m_data_listAttributeData=tempdata;
    [self resetDataSource];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dealAllView:YES];
	[self startTimer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
	[self stopTimer];
    [self dealAllView:NO];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.m_tableView_secKillList=nil;
}
-(void)dealAllView:(BOOL)isEnter
{
	if (!_isRequestSuccess && isEnter)
	{
		self.m_tableView_secKillList.hidden = YES;
		[self requestSeckillListXmlData:m_int_currPage];
	}
	else if(isEnter)
	{
		//处理秒杀状态
		[self dealWithSeckillStatus];
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)resetDataSource
{
	_isRequestSuccess = NO;
    [self.m_array_seckillProduct removeAllObjects];
    [self.m_tableView_secKillList reloadData];
    m_int_currPage=1;
    m_int_currPageSize=20;
}
#pragma -
#pragma mark 跳转到秒杀详情,状态为结束时跳到商品详情
-(void)goToSecKillDetailViewController:(id)sender{
    SCNProductButton *currentBtn=(SCNProductButton*)sender;
	if (!currentBtn.productCode || currentBtn.productCode.length == 0)
	{
		return;
	}
	[Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:currentBtn.productCode withPstatus:@"2" withImage:nil];
//    if (!currentBtn.isSecEnd) 
//	{
//        [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:currentBtn.productCode withPstatus:@"2" withImage:nil];
//    }
//    else
//    {
//        [Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:currentBtn.productCode withPstatus:@"0" withImage:nil];
//    }
}

#pragma -
#pragma mark UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    int int_row = indexPath.row+1;
   	if( int_row==([self.m_array_seckillProduct count]+1)/2 && m_int_currPage < [m_data_listAttributeData.mtotalPage intValue]){
    		//加载下一页
            NSLog(@"准备加载下一页.......>>>>>>>>>>>>>>>>>>>");
    		if (!_isRequesting)
    		{
    			NSLog(@"加载下一页.......>>>>>>>>>>>>>>>>>>>");
                [self requestSeckillListXmlData:m_int_currPage+1];
    		}		
    	}
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ([self.m_array_seckillProduct count]+1)/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SCNSecKillListTableCell";
    
    SCNSecKillListTableCell *cell = (SCNSecKillListTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
		NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"SCNSecKillListTableCell" owner:self options:nil];
        cell=[views objectAtIndex:0];
    }
    int row=indexPath.row;
    int leftNum=row*2;
    int rightNum=row*2+1;
    NSLog(@"left<><><>%d<><><><><>right%d",leftNum,rightNum);
    if (leftNum<=[self.m_array_seckillProduct count]-1) {
        SCNSecKillProductData *data=[self.m_array_seckillProduct objectAtIndex:leftNum];
        cell.m_button_product_left.productCode=data.mproductCode;
        [cell.m_button_product_left setBackgroundColor:[UIColor clearColor]];
        [cell.m_button_product_right setBackgroundColor:[UIColor whiteColor]];
        [cell.m_label_product_discount_left setText:[NSString stringWithFormat:@"%@折",data.mdiscount]];
        [cell.m_label_product_name_left setText:data.mname];
        [cell.m_label_product_price_left setText:[NSString stringWithFormat:@"￥%@",data.mmarketPrice]];
        [cell.m_label_product_secKillPrice_left setText:[NSString stringWithFormat:@"￥%@",data.mseckillPrice]];
        [cell.m_label_secKillPrice_status_left setText:[NSString stringWithFormat:@"￥%@",data.mseckillPrice]];
        //更新商品标签
        switch (data.mstatus) {
            case ESeckillWaitting:
			{
                [cell.m_label_product_time_left setText:[NSString stringWithFormat:@"%@开秒",[self changeTimeIntervalToHHmmString:data.mstartTime]]];
                //data.mstartTime;
                [cell.m_label_product_status_left setText:@"即将开始"];
                [cell.m_imageView_status_left setImage:[DataWorld getImageWithFile:@"seckill_willStart.png"]];
                cell.m_button_product_left.userInteractionEnabled=YES;
            }    
                break;
            case ESeckillRunning:
			{
				if (![data.mpstatus isEqualToString:@"2"] || (data.mlimit && [data.mlimit intValue] <= 0))
				{
					[cell.m_label_product_status_left setText:@"秒杀结束"];
					[cell.m_label_product_time_left setText:@"  已售完 "];
					[cell.m_imageView_status_left setImage:[DataWorld getImageWithFile:@"seckill_unactiveBg.png"]];
					cell.m_button_product_left.userInteractionEnabled=YES;
				}
				else
				{
					[cell.m_label_product_time_left setText:@"正在开秒,"];
					[cell.m_label_product_status_left setText:@"正在秒杀"];
					[cell.m_imageView_status_left setImage:[DataWorld getImageWithFile:@"seckill_activeBg.png"]];
					cell.m_button_product_left.userInteractionEnabled=YES;
				}

			}
				break;
            case ESeckillEnding:
			{
                //[cell.m_label_product_time_left setText:[NSString stringWithFormat:@"%@结束",[self changeTimeIntervalToHHmmString:data.mendTime]]];
                //data.mendTime;
                [cell.m_label_product_status_left setText:@"秒杀结束"];
                [cell.m_label_product_time_left setText:@"秒杀结束"];
                [cell.m_imageView_status_left setImage:[DataWorld getImageWithFile:@"seckill_unactiveBg.png"]];
                //屏蔽左边秒杀结束时商品不可点
                //cell.m_button_product_left.userInteractionEnabled=NO;
                cell.m_button_product_left.isSecEnd = YES;//判断秒杀是否结束
			}
                break;
            default:
                break;
        }
        cell.m_imageView_left.image = [UIImage imageNamed:@"com_loading103x103.png"];
        [HJImageUtility queueLoadImageFromUrl:data.mimage imageView:(HJManagedImageV*)cell.m_imageView_left];
        [cell.m_button_product_left addTarget:self action:@selector(goToSecKillDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (rightNum<=[self.m_array_seckillProduct count]-1) {
        SCNSecKillProductData *data=[self.m_array_seckillProduct objectAtIndex:rightNum];
        cell.m_button_product_right.productCode=data.mproductCode;
        [cell.m_button_product_right setBackgroundColor:[UIColor clearColor]];
        [cell.m_label_product_discount_right setText:[NSString stringWithFormat:@"%@折",data.mdiscount]];
        [cell.m_label_product_name_right setText:data.mname];
        [cell.m_label_product_price_right setText:[NSString stringWithFormat:@"￥%@",data.mmarketPrice]];
        [cell.m_label_product_secKillPrice_right setText:[NSString stringWithFormat:@"￥%@",data.mseckillPrice]];
        [cell.m_label_secKillPrice_status_right setText:[NSString stringWithFormat:@"￥%@",data.mseckillPrice]];
        //更新商品标签
        switch (data.mstatus) {
            case ESeckillWaitting:{
                [cell.m_label_product_time_right setText:[NSString stringWithFormat:@"%@开秒",[self changeTimeIntervalToHHmmString:data.mstartTime]]];
                //data.mstartTime;
                [cell.m_label_product_status_right setText:@"即将开始"];
                [cell.m_imageView_status_right setImage:[DataWorld getImageWithFile:@"seckill_willStart.png"]];
                cell.m_button_product_right.userInteractionEnabled=YES;
                break;
            }    
            case ESeckillRunning:
			{
				if (![data.mpstatus isEqualToString:@"2"] || (data.mlimit && [data.mlimit intValue] <= 0))
				{
					[cell.m_label_product_status_right setText:@"秒杀结束"];
					[cell.m_label_product_time_right setText:@"  已售完 "];
					[cell.m_imageView_status_right setImage:[DataWorld getImageWithFile:@"seckill_unactiveBg.png"]];
					cell.m_button_product_right.userInteractionEnabled=YES;
				}
				else
				{
					[cell.m_label_product_time_right setText:@"正在开秒"];
					[cell.m_label_product_status_right setText:@"正在秒杀"];
					[cell.m_imageView_status_right setImage:[DataWorld getImageWithFile:@"seckill_activeBg.png"]];
					cell.m_button_product_right.userInteractionEnabled=YES;
				}
			}
                break;
                
            case ESeckillEnding:
                //[cell.m_label_product_time_right setText:[NSString stringWithFormat:@"%@结束,",[self changeTimeIntervalToHHmmString:data.mendTime]]];
                //data.mendTime;
                [cell.m_label_product_time_right setText:@"秒杀结束"];
                [cell.m_label_product_status_right setText:@"秒杀结束"];
                [cell.m_imageView_status_right setImage:[DataWorld getImageWithFile:@"seckill_unactiveBg.png"]];
                //cell.m_button_product_right.userInteractionEnabled=NO;
                cell.m_button_product_right.isSecEnd = YES;
                break;
                
            default:
                break;
        }

        cell.m_imageView_right.image = [UIImage imageNamed:@"com_loading103x103.png"];
        [HJImageUtility queueLoadImageFromUrl:data.mimage imageView:(HJManagedImageV*)cell.m_imageView_right];
        [cell.m_button_product_right addTarget:self action:@selector(goToSecKillDetailViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma -
#pragma mark 时间处理
//获取小时:分钟
-(NSString*)changeTimeIntervalToHHmmString:(NSString*)fullTimeInterval{
    //获得服务器完整时间
	NSTimeInterval servertime = [fullTimeInterval doubleValue];
	NSDate* serverDate = [NSDate dateWithTimeIntervalSince1970:servertime];

//	NSString* chineseday = [serverDate FormateStringDaysAgainstDate:[SCNStatusUtility getNowDate]];
//  NSString* chineseday = [serverDate FormateStringDaysAgainstDate:[NSDate date]];
    
	NSString* chineseday = @"";
	if (chineseday && [chineseday length])
	{
		NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
		NSString* formatestr = [NSString stringWithFormat:@"%@ HH:mm", chineseday];
		[dateFormatter setDateFormat:formatestr];
		NSString* retstr = [dateFormatter stringFromDate:serverDate];
		return retstr;
	}
	
    NSString *fullTime = [self changeTimeIntervalToDate:fullTimeInterval];
    //截取时间，只显示小时:分钟
   // NSString *displayTime=[fullTime substringWithRange:NSMakeRange(11, 5)];
	return  fullTime;
    //return displayTime;
}
-(NSString*)changeTimeIntervalToDate:(NSString*)fullTimeInterval{
    //"1318521600"转化为"2011-10-14 00:00:00"
    //格式化NSString为NSTimeInterval
    NSTimeInterval servertime = [fullTimeInterval doubleValue];
    //将NSTimeInterval转化为时间格式
    NSDate *serverDate=[NSDate dateWithTimeIntervalSince1970:servertime];
	//设置时间格式
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
//	[dateFormatter setDateFormat:@"HH:mm"];
    NSString *fullTime=[dateFormatter stringFromDate:serverDate];
    NSLog(@"服务器完整时间%@",fullTime);
    return fullTime;
}
#pragma -
#pragma mark 处理商品状态
-(void)dealWithSeckillStatus{
    NSLog(@"[客户端]处理商品状态..........................");
    BOOL _isRefresh=NO;
    for (int i=0; i<[self.m_array_seckillProduct count]; i++) {
        NSLog(@"遍历秒杀列表");
        SCNSecKillProductData *seckillData=[self.m_array_seckillProduct objectAtIndex:i];
        NSTimeInterval serverStartTime=seckillData.mstartTimeInterval;
        NSLog(@"开始时间%d",(int)serverStartTime);
        NSTimeInterval serverEndTime=seckillData.mendTimeInterval;
        NSLog(@"结束时间%d",(int)serverEndTime);
        //使用[SCNStatusUtility getNowTime]会少两位数
        NSTimeInterval nowTime=[SCNStatusUtility getNowTime]; 
        NSLog(@"现在时间%d",(int)nowTime);

        if(serverStartTime-nowTime<=0&&serverEndTime-nowTime>=0)
        {
            NSLog(@"正在开秒");
            //正在开秒
            if (seckillData.mstatus!=ESeckillRunning) {
                _isRefresh|=YES;
                seckillData.mstatus=ESeckillRunning;
            }
        }
        else if(serverEndTime-nowTime<0)
        {
            NSLog(@"秒杀结束");
            //秒杀结束
            if (seckillData.mstatus!=ESeckillEnding) {
                _isRefresh|=YES;
                seckillData.mstatus=ESeckillEnding;
            }
        }
        else if(serverStartTime-nowTime>0 && serverEndTime-nowTime>0)
        {
            //即将开始
            if (seckillData.mstatus!=ESeckillWaitting) 
            {
                _isRefresh|=YES;
                seckillData.mstatus=ESeckillWaitting;
            }
        }
    }
    if (_isRefresh) 
	{
        NSLog(@"[客户端]刷新秒杀列表..........................");
        [self.m_tableView_secKillList reloadData];
    }
}
#pragma -
#pragma mark 请求秒杀列表数据
-(void)requestSeckillListXmlData:(int)currPage{
    if (_isRequesting) {
        return;
    }
    _isRequesting=YES;
    [self startLoading];
    /*
     act            对应接口的方法        N        getSeckillList
     api_version	API版本               N       1.0
     t              客户端时间戳          N	12087021
     weblogid                           N	123123
     ac             数据验证签名          N	POST提交的参数按照字母序升序组合+token，进行MD5加密
     
     page           当前页码              Y	1
     pagesize       每页显示数           Y	10
     seckillId      秒杀列表ID          N	12
     */
    NSString* page = [NSString stringWithFormat:@"%d",currPage];
    NSString* pageSize = [NSString stringWithFormat:@"%d",m_int_currPageSize];//strOrEmpty(m_data_listAttributeData.mpageSize);
    NSString* seckillId = strOrEmpty(self.m_string_secKillID);
    NSDictionary* extraParam = @{@"act": YK_METHOD_GET_SECKILLLIST,
                                @"page": page,
                                @"pagesize": pageSize,
                                @"seckillId": seckillId};
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestSeckillListXmlDataResponse:)];
}
/*
 成功：
 <?xml version=”1.0” encoding=”utf-8”?>
 <shopex>
 <result>success</result>
 <msg/>
 <info>
 <data_info>
 <weblogid>123123</weblogid>
 <stime>13131113</stime>
 <pageinfo page=”1” pageSize=”10” totalPage=”10” number=”95” ></pageinfo>
 <productList>
 <item image=”http://www.png” name=”商品名” marketPrice=”100” seckillPrice=”50” productCode=”123322” discount=”0.2” limit=”10” startTime=”2011-10-10 13:00:00” endTime=”2011-10-20 10:00:00”></item>
 <item image=”http://www.png” name=”商品名” marketPrice=”100” seckillPrice=”50” productCode=”123322” discount=”0.2” limit=”10” startTime=”2011-10-10 13:00:00” endTime=”2011-10-20 10:00:00”></item>
 </productList>
 </data_info>
 </info>
 </shopex>
 失败：
 <?xml version=”1.0” encoding=”utf-8”?>
 <shopex>
 <result>fail</result>
 <msg/>
 <info>0x001</info>
 </shopex>
 */
-(void)onRequestSeckillListXmlDataResponse:(GDataXMLDocument*)xmlDoc{
    _isRequesting = NO;
    [self stopLoading];
    if([SCNStatusUtility isRequestSuccess:xmlDoc]) 
    {
        _isRequestSuccess = YES;
        GDataXMLElement *datainfoElement=[SCNStatusUtility paserDataInfoNode:xmlDoc];
		
		//pageinfo
		GDataXMLElement *pageinfoElement = [datainfoElement oneElementForName:@"pageinfo"];
		if(pageinfoElement)
		{
			//接收列表配置信息
			[m_data_listAttributeData parseFromGDataXMLElement:pageinfoElement];
			NSLog(@"当前页数《》《》《》《》《》《》《》《\n《》《》《》《》%@",m_data_listAttributeData.mpageSize);
			m_int_currPage=[m_data_listAttributeData.mpage intValue];
			m_int_currPageSize=[m_data_listAttributeData.mpageSize intValue];
		}
		else
		{
			if([self.m_array_seckillProduct count] > 0)
			{
				m_int_currPage ++;
			}
		}
		
        NSArray *tempArray=[datainfoElement nodesForXPath:@"productList/item" error:nil];
        if ([tempArray count]>0)
		{
            [self.m_tableView_secKillList setHidden:NO];
            //接收列表商品信息
            for (GDataXMLElement* _e in tempArray) {
                SCNSecKillProductData  *product=[[SCNSecKillProductData alloc] init];
                [product parseFromGDataXMLElement:_e];
                product.mmarketPrice=[NSString stringWithFormat:@"%.2f",[product.mmarketPrice floatValue]];
                product.mseckillPrice=[NSString stringWithFormat:@"%.2f",[product.mseckillPrice floatValue]];
                product.mstartTimeInterval=[product.mstartTime doubleValue];
                product.mendTimeInterval=[product.mendTime doubleValue];
                [self.m_array_seckillProduct addObject:product];
            }
            //处理秒杀状态
            [self dealWithSeckillStatus];

            // tableView 重新加载
			[self.m_tableView_secKillList reloadData];
        }else{
            
        }
		if (self.m_array_seckillProduct.count >0) {
			[self hideNotecontent];
		}else {
			[self showNotecontent:@"当前活动暂无秒杀商品"];
		}
		[super BehaviorPageJump];
    }
    else
    {
        _isRequestSuccess = NO;
    }

}

-(void)startTimer
{
	[self stopTimer];
	//启动定时器
	m_timer_refresh=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dealWithSeckillStatus) userInfo:nil repeats:YES];
}

-(void)stopTimer
{
	if ([m_timer_refresh isValid]) {
		[m_timer_refresh invalidate];
	}
	m_timer_refresh = nil;
}

#pragma mark Behavior
-(void)BehaviorPageJump{
#ifdef USE_BEHAVIOR_ENGINE
#endif
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|商品ID
	NSString* _param = [NSString stringWithFormat:@"%@",self.m_string_typeName];
	return _param;
#else
	return nil;
#endif
}
@end
