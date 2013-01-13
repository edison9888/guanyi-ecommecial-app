//
//  SCNUserConsultationViewController.m
//  SCN
//
//  Created by chenjie on 11-10-18.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNUserConsultationViewController.h"
#import "YKHttpAPIHelper.h"
#import "YKStringUtility.h"
#import "SCNConsultationData.h"
#import "SCNPublishConsultationViewController.h"
#import "SCNStatusUtility.h"
#import "YKButtonUtility.h"
#import "HJManagedImageV.h"
#import "Go2PageUtility.h"

#define TEXTBLOCKTAG_ASK         111
#define LABELTAG_ASKTIME         112
#define LABELTAG_ASKUSERNAME     113
#define TEXTBLOCKTAG_REPLY       221
#define LABELTAG_REPLYUSERNAME   222
#define LABELTAG_REPLYTIME       223
#define IMAGEVIEW_BGVIEW         224
@implementation SCNUserConsultationViewController

@synthesize m_mutarray_consultation;
@synthesize m_mutarray_reply;
@synthesize m_productCode;
@synthesize m_isuserconsultation;
@synthesize m_tableview_consultation;
@synthesize m_consultation_Pagedata;
@synthesize m_button_publish;
@synthesize m_number_requestID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productCode:(NSString *)productCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        self.m_productCode = productCode;
    }
    return self; 
}

-(BOOL)isNeedLogin
{
	return YES;
}
- (void)didReceiveMemoryWarning {
    [self resetDataSource];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self resetDataSource];
    self.m_button_publish = nil;
    self.m_tableview_consultation = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    NSLog(@"我的咨询页面dealloc被调用");
    [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
}
-(void)resetDataSource
{
    m_isRequestsuccess = NO;
    m_int_currPage = 1;
    [m_mutarray_consultation removeAllObjects];
    [m_mutarray_reply removeAllObjects];
//  [m_tableview_consultation reloadData];

}
#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_int_currPage = 1;
    
    m_consultation_Pagedata.mpageSize = @"10";
    
    if (m_productCode == nil || m_productCode == @"") {
        self.title = @"我的咨询";
        m_isuserconsultation = YES;
        [m_tableview_consultation setHidden:YES];
        [self onRequestgetUserConsultList:m_int_currPage];
        
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDataSource) name:YK_PUBLISH_SUCCESS object:nil];
        self.title = @"售前咨询";
        m_isuserconsultation = NO;
        if (!m_isRequestsuccess) {
            [m_tableview_consultation setHidden:YES];
            [self onRequestgetConsultList:m_productCode  CurrentPage:m_int_currPage];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (m_isRequesting && m_number_requestID != nil) {
        m_isRequesting = NO;
        [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
        self.m_number_requestID = nil;
        
    }
}
-(void)addBarButtonItemofPublishConsultation
{
    
    self.m_button_publish= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 80, 42)
                                                       title:@"发布咨询"
                                                 normalImage:@"com_btn.png"
                                                 highlighted:@"com_btn_SEL.png"];
    [m_button_publish addTarget:self action:@selector(ToUerConsultation:) forControlEvents:UIControlEventTouchUpInside];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:m_button_publish.frame];
	[ricusview addSubview:m_button_publish];
    
    UIBarButtonItem * _barbuttonItem_publish = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_publish;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pathPath = @"/consult";
    self.m_mutarray_consultation = [NSMutableArray arrayWithCapacity:0];
    
    m_consultation_Pagedata= [[SCNConsulationPageData alloc] init];
    m_consultation_Pagedata.mpageSize = @"10";
    
    [self resetDataSource];
    // Do any additional setup after loading the view from its nib.
}
-(void)ToUerConsultation:(id)sender
{    
    SCNPublishConsultationViewController* _publishconsultation = [[SCNPublishConsultationViewController alloc] 
                                                                  initWithNibName:@"SCNPublishConsultationViewController"
                                                                  bundle:nil 
                                                                  productCode:m_productCode];
    [self.navigationController pushViewController:_publishconsultation animated:YES];
//    [Go2PageUtility showViewControllerNeedLogin:self toViewCtrl:_publishconsultation];
    
}
#pragma mark
#pragma mark 我的咨询请求
-(void)onRequestgetUserConsultList :(int)currentpage{
    if (m_isRequesting) {
        return;
    }
    m_isRequesting = YES;
    
    [self startLoading];
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_MYCONSULTLIST];
    NSString* v_page = [NSString stringWithFormat:@"%d",currentpage];
    NSString* v_pagesize = [YKStringUtility strOrEmpty:m_consultation_Pagedata.mpageSize];
    
    NSDictionary* extraParam = @{@"act": v_method,
                                @"page": v_page,
                                @"pagesize": v_pagesize};	
    
   self.m_number_requestID = [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(parseConsultationXmlData:)];
    
}
-(void)parseConsultationXmlData:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    
    m_isRequesting = NO;
    
    
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        m_isRequestsuccess = YES;

        GDataXMLElement * data_info = [SCNStatusUtility paserDataInfoNode:xmlDoc];
        
        GDataXMLElement * page_info = [data_info oneElementForName:@"pageinfo" ];
        
        if (page_info) {
            [self.m_consultation_Pagedata parseFromGDataXMLElement:page_info];
            m_int_currPage = [m_consultation_Pagedata.mpage intValue];
            m_int_totalpage = [m_consultation_Pagedata.mtotalPage intValue];
        }else{
            if ([self.m_mutarray_consultation count] > 0) {
                m_int_currPage ++;
            }
        
        }
        
        NSString* path_comment = [NSString stringWithFormat:@"comments/comment"];
        NSArray* consultationArray = [data_info nodesForXPath:path_comment error:nil];
        
        if ([consultationArray count]>0) {
            for(GDataXMLElement * _e in consultationArray){
                
                NSMutableDictionary * tempdictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
                
                SCNConsulationGroup * _consultation_group = [[SCNConsulationGroup alloc] init];
                
                _consultation_group.m_mutdictionary_askAndreply = tempdictionary;
                
                NSString * tempcommentid = [[_e  attributeForName:@"commentId"] stringValue];
                _consultation_group.mcommentId = tempcommentid;
                
                NSArray* askArray  =  [_e elementsForName:@"ask"];
                for (GDataXMLElement * _ask in askArray){
                    
                    SCNConsultationData * _consultation_info =[[SCNConsultationData alloc]init];
                    
                    _consultation_info.musername = [[_ask attributeForName:@"username"] stringValue];
                    _consultation_info.mcreateTime = [[_ask attributeForName:@"createTime"]stringValue];
                    _consultation_info.maskcontent = [[_e oneElementForName:@"ask"] stringValue];
                    
                    [_consultation_group.m_mutdictionary_askAndreply setObject:_consultation_info forKey:@"ask"];
                    
                    //                    NSLog(@">>>>>>>>>>>>>>>>>>>>>%@",_consultation_info.maskcontent);
                    //                    NSLog(@">>>>>>>>>>>>>>>>>>>>>%d",[_consultation_group.m_mutdictionary_askAndreply count]);
                    //                    NSLog(@">>>>>>>>>>>>>>>>>>>>>%@",_consultation_info.mcreateTime);
                    
                }
                
                NSArray* replyArray = [_e elementsForName:@"reply"];
                self.m_mutarray_reply = [NSMutableArray arrayWithCapacity:0];
                
                if ([replyArray count] > 0) {
                    
                    for ( GDataXMLElement * _reply in replyArray){
                        
                        SCNConsultationData * _consultation_info =[[SCNConsultationData alloc]init];
                        
                        _consultation_info.mreplycontent = [[_e oneElementForName:@"reply"] stringValue];
                        _consultation_info.musername = [[_reply attributeForName:@"username"] stringValue];
                        _consultation_info.mcreateTime = [[_reply attributeForName:@"createTime"]stringValue];
                        
                        
                        [self.m_mutarray_reply addObject:_consultation_info];
                        
                    }
                    [_consultation_group.m_mutdictionary_askAndreply setObject:m_mutarray_reply forKey:@"reply"];
                }
                
                [m_mutarray_consultation addObject:_consultation_group];
                
            }
            
        }
        if ([m_mutarray_consultation count]>0) {
            [self.m_tableview_consultation setHidden:NO];
            [self.m_tableview_consultation reloadData];
            if (!m_isuserconsultation) {
                [self hideNotecontent];
                [self addBarButtonItemofPublishConsultation];
            }
        }else{
            if (m_isuserconsultation) {
                [self showNotecontent:@"您暂无任何咨询."];
            }else{
                [self addBarButtonItemofPublishConsultation];
                [self showNotecontent:@"该商品暂无任何咨询."];
            }
            
        }
        
    }
    
}
#pragma mark
#pragma mark 售前咨询请求
-(void)onRequestgetConsultList:(NSString *)productCode CurrentPage:(int)currentpage{
    if (m_isRequesting) {
        return;
    }
    m_isRequesting = YES;
    [self startLoading];
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_CONSULTLIST];
    NSString* v_page = [NSString stringWithFormat:@"%d",currentpage];
    NSString* v_pagesize = [YKStringUtility strOrEmpty:m_consultation_Pagedata.mpageSize];
    NSString* v_productCode = [YKStringUtility strOrEmpty:m_productCode];
    
    NSDictionary* extraParam = @{@"act": v_method,
                                @"page": v_page,
                                @"pagesize": v_pagesize,
                                @"productCode": v_productCode};	
    
   self.m_number_requestID =  [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(parseConsultationXmlData:)];
    
}
#pragma mark
#pragma mark UITableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.m_mutarray_consultation count];   
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    SCNConsulationGroup * _consultation_group = [self.m_mutarray_consultation objectAtIndex:section];
    
    if ([_consultation_group.m_mutdictionary_askAndreply valueForKey:@"reply"] != nil) {
        if ([[_consultation_group.m_mutdictionary_askAndreply valueForKey:@"reply"] count] > 0) {
            
            return [[_consultation_group.m_mutdictionary_askAndreply valueForKey:@"reply"] count]+1;
        }
    }
        return 1;    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *UserAskCellIdentifier = @"UserAskCellIdentifier";
	NSString *UserReplyCellIdentifier = @"UserReplyCellIdentifier";
    
    NSUInteger row = [indexPath row];
    
    UITableViewCell *cell = nil;
    if (row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:UserAskCellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:UserAskCellIdentifier];
            
            TextBlock* _textblock_ask = [[TextBlock alloc]initWithFrame:CGRectMake(15, 10, 280, 0)];
            _textblock_ask.tag = TEXTBLOCKTAG_ASK;
            _textblock_ask.font = [UIFont systemFontOfSize:14];
            _textblock_ask.textAlignment = UITextAlignmentLeft;
            _textblock_ask.backgroundColor = [UIColor clearColor];
            
            UILabel* _label_creatTime = [[UILabel alloc]initWithFrame:CGRectMake(170,0, 150, 20)];
            
            _label_creatTime.font =[UIFont systemFontOfSize:13];
            _label_creatTime.tag = LABELTAG_ASKTIME;
            _label_creatTime.alpha = 0.6;
            _label_creatTime.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:_label_creatTime];
            [cell.contentView addSubview:_textblock_ask];
            
            
            
        }
        if ([[[self.m_mutarray_consultation objectAtIndex:[indexPath section]]m_mutdictionary_askAndreply] valueForKey:@"ask"] != nil) {
            
            SCNConsultationData * _consultation_info = [[[self.m_mutarray_consultation objectAtIndex:[indexPath section]]m_mutdictionary_askAndreply] valueForKey:@"ask"];
            TextBlock *_textblock_ask = (TextBlock *)[cell viewWithTag:TEXTBLOCKTAG_ASK];
            [_textblock_ask setText:[YKStringUtility stripWhiteSpaceAndNewLineCharacter:_consultation_info.maskcontent]];
            CGRect rect = [_textblock_ask frame];
            NSLog(@"<<<<<<<<<<<<<<<<<<<<%@",_consultation_info.maskcontent);
            
            UILabel * _label_creatTime = (UILabel *)[cell viewWithTag:LABELTAG_ASKTIME];
            _label_creatTime.text = _consultation_info.mcreateTime;
            _label_creatTime.frame = CGRectMake(170, rect.size.height+15, 150, 20);
            
        }
        
    }else if (row >= 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:UserReplyCellIdentifier];
            
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:UserReplyCellIdentifier];
            
            UILabel* _label_replyname = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 25)];
            _label_replyname.tag = LABELTAG_REPLYUSERNAME;
            _label_replyname.backgroundColor = [UIColor clearColor];
            _label_replyname.font = [UIFont systemFontOfSize:15];
            
            TextBlock* _textblock_reply = [[TextBlock alloc]initWithFrame:CGRectMake(12, 30, 280, 20)];
            _textblock_reply.font = [UIFont systemFontOfSize:14];
            _textblock_reply.tag = TEXTBLOCKTAG_REPLY;
            _textblock_reply.backgroundColor = [UIColor clearColor];
            
            
            UILabel* _label_creatTime = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 
                                                                                 150, 20)];
            _label_creatTime.font =[UIFont systemFontOfSize:13];
            _label_creatTime.alpha = 0.6;
            _label_creatTime.backgroundColor = [UIColor clearColor];
            _label_creatTime.tag = LABELTAG_REPLYTIME;
            
            UIView * _view_bgview = [YKButtonUtility initBgCornerViewWithHeight:0 cornerRadius:5];
            _view_bgview.tag = IMAGEVIEW_BGVIEW;
            
            [cell.contentView insertSubview:_view_bgview atIndex:0];
            [cell.contentView addSubview:_label_replyname];
            [cell.contentView addSubview:_textblock_reply];
            [cell.contentView addSubview:_label_creatTime];
            
            
        }
        
        if ([[[self.m_mutarray_consultation objectAtIndex:[indexPath section]] m_mutdictionary_askAndreply] valueForKey:@"reply"] != nil) {
            
            self.m_mutarray_reply = [[[self.m_mutarray_consultation objectAtIndex:[indexPath section]]m_mutdictionary_askAndreply] valueForKey:@"reply"];
            
            int replycount = [indexPath row]- 1;
            if (replycount < [m_mutarray_reply count]) {
                
                SCNConsultationData * _consultation_info = [self.m_mutarray_reply objectAtIndex:replycount];
                
                UILabel * _label_replyname = (UILabel *)[cell viewWithTag:LABELTAG_REPLYUSERNAME];
                _label_replyname.text = [NSString stringWithFormat:@"%@   回答:",_consultation_info.musername];
                
                TextBlock * _textblock_reply = (TextBlock *)[cell viewWithTag:TEXTBLOCKTAG_REPLY];
                [_textblock_reply setText:_consultation_info.mreplycontent];
                CGRect rect = [_textblock_reply frame];
                
                UILabel * _label_creatTime = (UILabel *)[cell viewWithTag:LABELTAG_REPLYTIME];
                _label_creatTime.text = _consultation_info.mcreateTime;
                _label_creatTime.frame = CGRectMake(180, rect.size.height+30, 
                                                    150, 20);
                
                UIView * _view_bgview = (UIView *)[cell viewWithTag:224];
                _view_bgview.frame = CGRectMake(10, 5, 300, rect.size.height+43);
            }
        }
    }
           
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;    
	
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView * _view_content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	
    _view_content.backgroundColor = [UIColor colorWithRed:(float)(68/255.0f) green:(float)(68/255.0f) blue:(float)(68/255.0f) alpha:1];
    
    UILabel * _label_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 320, 20)];
    _label_title.lineBreakMode = 0;
    _label_title.textColor = [UIColor whiteColor];
    _label_title.backgroundColor = [UIColor clearColor];
    _label_title.font = [UIFont systemFontOfSize:15];
	
    
	if ([[[self.m_mutarray_consultation objectAtIndex:section]m_mutdictionary_askAndreply] valueForKey:@"ask"] != nil)
	{
	    SCNConsultationData * _consultation_info = [[[self.m_mutarray_consultation objectAtIndex:section]m_mutdictionary_askAndreply] valueForKey:@"ask"];

/*
        if (m_productCode == nil || m_productCode == @"") {
            
             _label_title.text = [NSString stringWithFormat:@"%@  问:",_consultation_info.musername];
            
        }else{
            //如果账号名字大于5位的
            if ([_consultation_info.musername length] >5 ) 
			{
                NSMutableString * str_starname = [NSMutableString stringWithCapacity:0];
                NSString * str_frontname = [_consultation_info.musername substringToIndex:2];
                NSString * str_backname = [_consultation_info.musername substringFromIndex:[_consultation_info.musername length]-2];
                for (int i = 1; i <= [_consultation_info.musername length] -4; i++) {
                    NSString * str_star = @"*";
                    [str_starname appendString:str_star];
                }
                
                _label_title.text = [NSString stringWithFormat:@"%@%@%@  问:",str_frontname,str_starname,str_backname];
                
            }
            //如果账号名字小于5位 大于2位的 
            else if (2<[_consultation_info.musername length] <=5)
			{
                NSMutableString * str_starname = [NSMutableString stringWithCapacity:0];
                NSString * str_frontname = [_consultation_info.musername substringToIndex:1];
                NSString * str_backname = [_consultation_info.musername substringFromIndex:[_consultation_info.musername length]-1];
                for (int i = 1; i <= [_consultation_info.musername length] -2; i++) {
                    NSString * str_star = @"*";
                    [str_starname appendString:str_star];
                }
                
                _label_title.text = [NSString stringWithFormat:@"%@%@%@  问:",str_frontname,str_starname,str_backname];
            }
            else{
                _label_title.text = [NSString stringWithFormat:@"%@  问:",_consultation_info.musername];
                
            }
        }
*/
		
		if (_consultation_info.musername)
		{
			_label_title.text = [NSString stringWithFormat:@"%@  问:",_consultation_info.musername];
		}
		else
		{
			_label_title.text = [NSString stringWithFormat:@"非会员顾客  问:"];
		}

	}
    
    [_view_content addSubview:_label_title];
    
    return _view_content;
    
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section] +1;
    NSLog(@"section的值:==========%d",section);
    NSLog(@"[m_mutarray_consultation count]的值:==========%d",[m_mutarray_consultation count]);
    if (section == [m_mutarray_consultation count] - 1  && m_int_currPage < m_int_totalpage)
    {
        if (m_productCode == nil && m_productCode == @"") {
            [self onRequestgetUserConsultList:m_int_currPage + 1];
        }else{
            [self onRequestgetConsultList:m_productCode CurrentPage:m_int_currPage +1];
        }
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>%d",m_int_currPage);
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    
    UITableViewCell * cell = [self tableView:m_tableview_consultation cellForRowAtIndexPath:indexPath];
    TextBlock* _textblock_ask = (TextBlock*)[cell viewWithTag:TEXTBLOCKTAG_ASK];
    TextBlock* _textblock_reply = (TextBlock*)[cell viewWithTag:TEXTBLOCKTAG_REPLY];
    
    CGRect rect_ask = [_textblock_ask frame];
    CGRect rect_reply = [_textblock_reply frame];
    
    if ([indexPath row] == 0) {
        
        height = rect_ask.size.height +40;
    }
    else {
        
        height = rect_reply.size.height+60;
        
    }

    return  height;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|商品ID
	NSString* _name = [DataWorld shareData].m_nowProductData.m_productName;
	NSString* _code = [DataWorld shareData].m_nowProductData.m_productCode;
	NSString* _param = [NSString stringWithFormat:@"%@|%@",_name,_code];
	return _param;
#else
	return nil;
#endif
}

@end
