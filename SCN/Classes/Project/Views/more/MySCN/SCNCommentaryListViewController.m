//
//  SCNCommentaryListViewController.m
//  SCN
//
//  Created by chenjie on 11-10-19.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNCommentaryListViewController.h"
#import "YKHttpAPIHelper.h"
#import "YKStringUtility.h"
#import "SCNConsultationData.h"
#import "TextBlock.h"
#import "SCNStatusUtility.h"
#import "YKButtonUtility.h"
#import "GY_BaseCollection.h"

#define TEXTBLOCKTAG_ASK         111
#define LABELTAG_ASKTIME         112
#define LABELTAG_ASKUSERNAME     113
#define TEXTBLOCKTAG_REPLY       221
#define LABELTAG_REPLYUSERNAME   222
#define LABELTAG_REPLYTIME       223
#define IMAGEVIEW_BGVIEW         224

@implementation SCNCommentaryListViewController

@synthesize m_mutabledic_askreply;
@synthesize m_mutarray_reply;
@synthesize m_productCode;
@synthesize m_isuserconsultation;
@synthesize m_tableview_commentary;
@synthesize m_commentary_commentsdata,m_commentary_pagedata;
@synthesize m_number_requestID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productCode:(NSString *)productid
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_productCode = productid;
        // Custom initialization
    }
    return self; 
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_commentary_pagedata = nil;
    self.m_commentary_commentsdata = nil;
    self.m_tableview_commentary = nil;
    self.m_mutabledic_askreply = nil;
    self.m_mutarray_reply = nil;
    self.m_productCode = nil;
    
    [self resetDataSource];
}

- (void)dealloc
{
    NSLog(@"评论列表dealloc被调用");
}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    m_int_currPage = 1;
    m_commentary_pagedata.mpageSize = @"10";
    
    if (!m_isRequestsuccess) {
        [self.m_tableview_commentary setHidden:YES];
        [self onRequestgetCommentaryList:m_productCode CurrentPage:m_int_currPage];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (m_isRequesting && m_number_requestID != nil) {
        m_isRequesting = NO;
        [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];
        self.m_number_requestID = nil;
    }

}
-(void)resetDataSource
{
    m_isRequesting = NO;
	[self stopLoading];
    [self.m_commentary_commentsdata.m_mutarray_commentary removeAllObjects];
    [self.m_mutarray_reply removeAllObjects];
    self.m_mutabledic_askreply = nil;


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"评论列表";
    self.pathPath = @"/buyercomment";
    //初始化页数模型
    m_commentary_pagedata= [[SCNCommentaryPageData alloc] init];
    m_commentary_pagedata.mpageSize = @"10";
    
    //初始化评论数据模型
    m_commentary_commentsdata = [[SCNCommentaryData alloc] init];
    NSMutableArray * tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.m_commentary_commentsdata.m_mutarray_commentary = tempArray;
    [self resetDataSource];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark
#pragma mark 评论列表
-(void)onRequestgetCommentaryList:(NSString *)productCode CurrentPage :(int)currentpage{
    
    if (m_isRequesting) {
        return;
    }
	[self startLoading];
    m_isRequesting = YES;
    
    NSString* v_method = [YKStringUtility strOrEmpty:MMUSE_METHOD_GET_COMMENTLIST];
    NSString* v_productCode = [YKStringUtility strOrEmpty:productCode];
    NSString* v_page = [NSString stringWithFormat:@"%d",currentpage];
    NSString* v_pagesize = [YKStringUtility strOrEmpty:m_commentary_pagedata.mpageSize];
    NSString* v_comment_type = [YKStringUtility strOrEmpty:@"ask"];
    
    NSDictionary* extraParam= @{@"method": v_method,
                               @"good_id": v_productCode,
                               @"page": v_page,
                               @"pagesize": v_pagesize,
                               @"comment_type": v_comment_type};
    
   self.m_number_requestID = [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onResponseComments:)];
    
}
#pragma mark
#pragma mark 评论列表解析
-(void)onResponseComments:(id)json_obj
{
    [self stopLoading];
    
    m_isRequesting = NO;
    
    if([SCNStatusUtility isRequestSuccessJSON:json_obj])
    {
        m_isRequestsuccess = YES;
		
        GY_BaseCollection* coll = [[GY_BaseCollection alloc]initWithJSON:json_obj];
        
        //pageinfo data
        if (coll.page) {
                                    
            m_int_currPage  =   coll.page;          //当前页
            m_int_pagetotal =   coll.total_page;    //总页数
            
        }else{
            
            if ([m_commentary_commentsdata.m_mutarray_commentary count] > 0) {
                m_int_currPage ++;
            }
                    
        }
        // 用户是否可以评论
        m_commentary_commentsdata.mcanComment =[coll get_string_value_init_for_key:@"can_comment"];
        
        if ([coll.collection_data count]>0) {
            for (NSMutableDictionary* item in coll.collection_data ){
             
                 SCNCommentaryMember* _commentary_info =[[SCNCommentaryMember alloc]init];
                _commentary_info.musername = [item objectForKey:@"user_name"];
                _commentary_info.mcreateTime = [item objectForKey:@"create_time"];_commentary_info.maskcontent = [item objectForKey:@"ask"];
                
                SCNCommentaryGroup * _commentary_group = [[SCNCommentaryGroup alloc] init];
                
                _commentary_group.m_mutdictionary_askAndreply = [@{} mutableCopy];
                _commentary_group.mcommentId = [item objectForKey:@"comment_id"];
                [ _commentary_group.m_mutdictionary_askAndreply setObject:_commentary_info forKey:@"ask"];
                
                
                //replys
                NSMutableArray* replyArray = [item objectForKey:@"replys"];
                self.m_mutarray_reply = [NSMutableArray arrayWithCapacity:0];
                
                if ([replyArray count] > 0) {
                    for ( NSMutableDictionary* _reply in replyArray){
                        
                        SCNCommentaryMember * _commentary_info =[[SCNCommentaryMember alloc]init];
                        
                        _commentary_info.musername = [_reply objectForKey:@"user_name"];
                        _commentary_info.mcreateTime = [_reply objectForKey:@"create_time"];
                        _commentary_info.mreplycontent = [_reply objectForKey:@"reply"];
                        
                        [m_mutarray_reply addObject:_commentary_info];
                    }
                    [ _commentary_group.m_mutdictionary_askAndreply setObject:self.m_mutarray_reply forKey:@"reply"];
                }
                
                [m_commentary_commentsdata.m_mutarray_commentary addObject:_commentary_group];
                NSLog(@">>>>>><<商品评论信息数量<<<<<<<<<<%d",[m_commentary_commentsdata.m_mutarray_commentary count]);

            }
        }      
    }
    
    if ([m_commentary_commentsdata.m_mutarray_commentary count] > 0) {
        
        [self.m_tableview_commentary setHidden:NO];
        [self.m_tableview_commentary reloadData];
        [self hideNotecontent];
    }else{
        
        [self showNotecontent:@"该商品暂无任何评论."];
        
    }
    

}
-(void)parseCommentaryXmlData:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    
    m_isRequesting = NO;

    
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        m_isRequestsuccess = YES;
        
        GDataXMLElement * data_info = [SCNStatusUtility paserDataInfoNode:xmlDoc];
                
        GDataXMLElement* page_info	=	[data_info oneElementForName:@"pageinfo"];
        
        
        if (page_info) {
            
            [self.m_commentary_pagedata parseFromGDataXMLElement:page_info];
            
            m_int_currPage=[m_commentary_pagedata.mpage intValue];
            m_int_pagetotal=[m_commentary_pagedata.mtotalPage intValue];
        }else{
            if ([m_commentary_commentsdata.m_mutarray_commentary count] > 0) {
                m_int_currPage ++;
            }
        
        
        }
        
        GDataXMLElement * comments = [SCNStatusUtility paserDataInfoNode:xmlDoc];
        
        NSString* path_comment = [NSString stringWithFormat:@"comments"];
        NSArray* commentaryArray = [comments nodesForXPath:path_comment error:nil];
        
        if ([commentaryArray count]>0) {
            for (GDataXMLElement * _e in commentaryArray ){
                
                m_commentary_commentsdata.mcanComment =[[_e attributeForName:@"canComment"] stringValue];
                
                NSArray * commentArray = [_e elementsForName:@"comment"];
                
                if ([commentArray count]>0) {
                    
                    for(GDataXMLElement * _e in commentArray){
                        
                        SCNCommentaryGroup * _commentary_group = [[SCNCommentaryGroup alloc] init];
                        NSMutableDictionary * tempdictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
                        _commentary_group.m_mutdictionary_askAndreply = tempdictionary;
                        
                        NSString * tempcommentid = [[_e  attributeForName:@"commentId"] stringValue];
                        _commentary_group.mcommentId = tempcommentid;
                        
                        NSArray* askArray  =  [_e elementsForName:@"ask"] ;
                        for (GDataXMLElement * _ask in askArray){
                            
                            SCNCommentaryMember * _commentary_info =[[SCNCommentaryMember alloc]init];
                            
                            _commentary_info.musername = [[_ask attributeForName:@"username"] stringValue];
                            _commentary_info.mcreateTime = [[_ask attributeForName:@"createTime"]stringValue];
							_commentary_info.maskcontent = [[_e oneElementForName:@"ask"] stringValue];
                            
                            [ _commentary_group.m_mutdictionary_askAndreply setObject:_commentary_info forKey:@"ask"];
                        }
                        
                        NSArray* replyArray = [_e elementsForName:@"reply"];
                        
                        self.m_mutarray_reply = [NSMutableArray arrayWithCapacity:0];
                        
                        
                        if ([replyArray count] > 0) {
                            for ( GDataXMLElement * _reply in replyArray){
                                
                                SCNCommentaryMember * _commentary_info =[[SCNCommentaryMember alloc]init];
                                
                                _commentary_info.musername = [[_reply attributeForName:@"username"] stringValue];
                                _commentary_info.mcreateTime = [[_reply attributeForName:@"createTime"]stringValue];
                                _commentary_info.mreplycontent = [[_e oneElementForName:@"reply"] stringValue];
                                
                                [m_mutarray_reply addObject:_commentary_info];
                                
                            }
                            [ _commentary_group.m_mutdictionary_askAndreply setObject:self.m_mutarray_reply forKey:@"reply"];
                        }
                        
                        
                        [m_commentary_commentsdata.m_mutarray_commentary addObject:_commentary_group];
                        NSLog(@">>>>>><<<<<<<<<<<<<<22222<<<<<%d",[m_commentary_commentsdata.m_mutarray_commentary count]);
                    }
                    
                }
                
            }
            
        }
    }
    if ([m_commentary_commentsdata.m_mutarray_commentary count] > 0) {
        
        [self.m_tableview_commentary setHidden:NO];
        [self.m_tableview_commentary reloadData];
        [self hideNotecontent];
    }else{
        
        [self showNotecontent:@"该商品暂无任何评论."];
        
    }
    
}

#pragma mark
#pragma mark UITableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_commentary_commentsdata.m_mutarray_commentary count];   
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SCNCommentaryGroup * _commentary_group = [self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:section];
	NSLog(@"<<<<<<<<<<<33333<<<<<<<<%d",[[_commentary_group.m_mutdictionary_askAndreply valueForKey:@"reply"] count]);
    
    if ([_commentary_group.m_mutdictionary_askAndreply valueForKey:@"reply"] != nil) {
        if ([[_commentary_group.m_mutdictionary_askAndreply valueForKey:@"reply"] count] > 0) {
            
            return [[_commentary_group.m_mutdictionary_askAndreply valueForKey:@"reply"] count]+1;
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
        if ([[[self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:[indexPath section]]m_mutdictionary_askAndreply] valueForKey:@"ask"] != nil) {
            
            SCNConsultationData * _consultation_info = [[[self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:[indexPath section]]m_mutdictionary_askAndreply] valueForKey:@"ask"];
            TextBlock *_textblock_ask = (TextBlock *)[cell viewWithTag:TEXTBLOCKTAG_ASK];
            [_textblock_ask setText:[YKStringUtility stripWhiteSpaceAndNewLineCharacter:_consultation_info.maskcontent]];
            CGRect rect = [_textblock_ask frame];
            NSLog(@"<<<<<<<<<<<<<<<<<<<<%@",_consultation_info.maskcontent);
            
            UILabel * _label_creatTime = (UILabel *)[cell viewWithTag:LABELTAG_ASKTIME];
            _label_creatTime.text = _consultation_info.mcreateTime;
            _label_creatTime.frame = CGRectMake(170, rect.size.height+15, 150, 20);
            
        }
    }
    else {
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
        if ([[[self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:[indexPath section]] m_mutdictionary_askAndreply] valueForKey:@"reply"] != nil) {
            
            self.m_mutarray_reply = [[[self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:[indexPath section]]m_mutdictionary_askAndreply] valueForKey:@"reply"];
            
            int replycount = [indexPath row] - 1;
            
            if (replycount < [self.m_mutarray_reply count]) {
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
	UIView* _view_forhead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
	UILabel* _label_title = [[UILabel alloc] initWithFrame:CGRectMake(12, 5, 320, 20)];
	_label_title.lineBreakMode = 0;
	_label_title.textColor = [UIColor whiteColor];
	_label_title.backgroundColor = [UIColor clearColor];
    _label_title.font = [UIFont systemFontOfSize:14];
	
    
	if ([[[self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:section] m_mutdictionary_askAndreply] valueForKey:@"ask"] != nil) {
		
		SCNCommentaryMember * _commentary_info = [[[self.m_commentary_commentsdata.m_mutarray_commentary objectAtIndex:section] m_mutdictionary_askAndreply] valueForKey:@"ask"];
        
       //如果账号名字大于5位的
        if ([_commentary_info.musername length] >5 ) {
            NSMutableString * str_starname = [NSMutableString stringWithCapacity:0];
            NSString * str_frontname = [_commentary_info.musername substringToIndex:2];
            NSString * str_backname = [_commentary_info.musername substringFromIndex:[_commentary_info.musername length]-2];
            for (int i = 1; i <= [_commentary_info.musername length] -4; i++) {
                NSString * str_star = @"*";
                [str_starname appendString:str_star];
            }
            NSLog(@">>>>>>>>>>>>>>>>%@",str_frontname);
            NSLog(@">>>>>>>>>>>>>>>>%@",str_backname);
            NSLog(@">>>>>>>>>>>>>>>>%@",str_starname);
            _label_title.text = [NSString stringWithFormat:@"%@%@%@  评论:",str_frontname,str_starname,str_backname];

        }
        //如果账号名字小于5位 大于2位的 
        else if (2<[_commentary_info.musername length] <=5) {
            NSMutableString * str_starname = [NSMutableString stringWithCapacity:0];
            NSString * str_frontname = [_commentary_info.musername substringToIndex:1];
            NSString * str_backname = [_commentary_info.musername substringFromIndex:[_commentary_info.musername length]-1];
            for (int i = 1; i <= [_commentary_info.musername length] -2; i++) {
                NSString * str_star = @"*";
                [str_starname appendString:str_star];
            }
            NSLog(@">>>>>>>>>>>>>>>>%@",str_frontname);
            NSLog(@">>>>>>>>>>>>>>>>%@",str_backname);
            NSLog(@">>>>>>>>>>>>>>>>%@",str_starname);
            _label_title.text = [NSString stringWithFormat:@"%@%@%@  评论:",str_frontname,str_starname,str_backname];
        }
        else{
            _label_title.text = [NSString stringWithFormat:@"%@  评论:",_commentary_info.musername];
        
        }
	}
     
    
	_view_forhead.backgroundColor = [UIColor colorWithRed:68.0/255 green:68.0/255 blue:68.0/255 alpha:1];
	[_view_forhead addSubview:_label_title];
    
	return _view_forhead;
    
    
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section] + 1;
    NSLog(@"section的值:==========%d",section);
    NSLog(@"[m_mutarray_consultation count]的值:==========%d",[m_commentary_commentsdata.m_mutarray_commentary count] - 1);
    if (section == [m_commentary_commentsdata.m_mutarray_commentary count] - 1  && m_int_currPage < m_int_pagetotal)
    {
        [self onRequestgetCommentaryList:self.m_productCode CurrentPage:m_int_currPage +1];
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>%d",m_int_currPage);
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    
    UITableViewCell * cell = [self tableView:m_tableview_commentary cellForRowAtIndexPath:indexPath];
    TextBlock* _textblock_ask = (TextBlock*)[cell viewWithTag:TEXTBLOCKTAG_ASK];
    TextBlock* _textblock_reply = (TextBlock*)[cell viewWithTag:TEXTBLOCKTAG_REPLY];
    CGRect rect_ask = [_textblock_ask frame];
    CGRect rect_reply = [_textblock_reply frame];
    
    for( UIView* subview in [cell.contentView subviews])
        [subview removeFromSuperview];
    
    for (int i = 0; i <=[self.m_commentary_commentsdata.m_mutarray_commentary count] ; i++) {
        if ([indexPath section] == i) {
            if ([indexPath row] == 0) {
                
                height = rect_ask.size.height +40;
            }
            else if ([indexPath row] > 0){
                
                height = rect_reply.size.height+60;
                
            }
        }
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
