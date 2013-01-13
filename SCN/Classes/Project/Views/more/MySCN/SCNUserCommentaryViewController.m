//
//  SCNUserCommentaryViewController.m
//  SCN
//
//  Created by chenjie on 11-10-18.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNUserCommentaryViewController.h"
#import "SCNPublishCommentaryViewController.h"
#import "Go2PageUtility.h"
#import "YKStringUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNUserCommentaryTableCell.h"
#import "HJManagedImageV.h"

#define IMAGEVIEWTAG_WARE               200 
#define TEXTBLOCKTAG_INFO               201
#define LABELTAG_COMMENTARYNUM          202
#define LABELTAG_PAGE                   203
#define BUTTONTAG_PUBLISH               204
#define LABELTAG_COMMENTARY             101
#define LABELTAG_COMMENTARTINFO         102
#define LABELTAG_CREATTIME              103

@implementation SCNUserCommentaryViewController

@synthesize m_productcode,m_str_orderId;
@synthesize m_mutarray_comments;
@synthesize m_commentary_pagedata;
@synthesize m_number_requestID;
@synthesize m_tableview_commentary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)isNeedLogin
{
	return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.m_commentary_pagedata = nil;
    self.m_str_orderId = nil;
    self.m_productcode = nil;
	self.m_tableview_commentary = nil;
    [self resetDataSource];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"我的评论页面dealloc调用");
    [YKHttpAPIHelper cancelRequestByID:self.m_number_requestID];

}

#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!m_isRequestsuccess) {
        m_int_currpage = 1;
        m_commentary_pagedata.mpageSize = @"10";
        [m_tableview_commentary setHidden:YES];
        [self requestUserCommentaryXmlData:m_int_currpage];
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
-(void)resetDataSource
{
    m_isRequestsuccess = NO;
    m_int_currpage = 1;
    [self.m_mutarray_comments removeAllObjects];
    [m_tableview_commentary reloadData];

}
#pragma mark
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的评论";
	self.pathPath = @"/mycomment";
    //初始化评论页数数据模型
    m_commentary_pagedata= [[SCNMyCommentaryPageData alloc] init];
    m_commentary_pagedata.mpageSize = @"10";
    
    //初始化装载临时数据数组
    NSMutableArray * mut_temparray = [[NSMutableArray alloc] initWithCapacity:0];
    self.m_mutarray_comments = mut_temparray;
    [self resetDataSource];
    
}
#pragma mark
#pragma mark - 发表评论按钮
-(void)toPublishCommentary:(id)sender
{
	UIButton* _btn = (UIButton*)sender;
	NSLog(@"%d",_btn.tag);
    
	SCNMyCommentaryData* _commentData = [self.m_mutarray_comments objectAtIndex:_btn.tag];
	NSLog(@"%@",_commentData.mname);
    
    if ([_commentData.mcanComment isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetDataSource) name:YK_PUBLISH_SUCCESS object:nil];
    }
    
    SCNPublishCommentaryViewController* publishcommentary = [[SCNPublishCommentaryViewController alloc] initWithNibName:@"SCNPublishCommentaryViewController" bundle:nil orderId:_commentData.morderId productCode:_commentData.mproductCode productName:_commentData.mname];
    [self.navigationController pushViewController:publishcommentary animated:YES];
    
}
#pragma mark
#pragma mark - 请求网络
-(void)requestUserCommentaryXmlData :(int)currentpage;
{
    if (m_isRequesting) {
        return;
    }
	m_isRequesting = YES;
	[self startLoading];
    NSString* v_method = [YKStringUtility strOrEmpty:YK_METHOD_GET_MYCOMMENTLIST];
    NSString* v_page = [NSString stringWithFormat:@"%d",currentpage];
    NSString* v_pagesize = [YKStringUtility strOrEmpty:m_commentary_pagedata.mpageSize];
    
    NSDictionary * extraParam = @{@"act": v_method,
                                 @"page": v_page,
                                 @"pagesize": v_pagesize};
    
   self.m_number_requestID = [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestUserCommentaryDataResponse:)];
    
}

-(void)onRequestUserCommentaryDataResponse:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    m_isRequesting = NO;
    
    if ([SCNStatusUtility isRequestSuccess:xmlDoc ]) {
        m_isRequestsuccess = YES;
        
        GDataXMLElement * data_info =[SCNStatusUtility paserDataInfoNode:xmlDoc];
        
        
        GDataXMLElement * pageinfo = [data_info oneElementForName:@"pageinfo"];
        
        if (pageinfo) {
            [self.m_commentary_pagedata parseFromGDataXMLElement:pageinfo];
            
            m_int_currpage=[m_commentary_pagedata.mpage intValue];
            m_int_currtotalpage = [m_commentary_pagedata.mtotalPage intValue];
        }
        
        else{
            if ([self.m_mutarray_comments count] > 0) {
                m_int_currpage ++;
            }
        }
        
        NSString* path_comment = [NSString stringWithFormat:@"comments/product"];
        
        NSArray* commentaryArray = [data_info nodesForXPath:path_comment error:nil];
        
        if ([commentaryArray count]>0) {
            for (GDataXMLElement * _comments in commentaryArray){
                
                SCNMyCommentaryData * _commentary_product = [[SCNMyCommentaryData alloc] init];
                [_commentary_product parseFromGDataXMLElement:_comments];
                _commentary_product.mdesc = [[_comments oneElementForName:@"desc"] stringValue];
                
                NSArray* _commentArray = [_comments elementsForName:@"comment"];
                
                NSMutableArray * tempArray = [[NSMutableArray alloc]initWithCapacity:0];
                _commentary_product.m_mutarray_comment = tempArray;
                
                if ([_commentArray count]>0) {
                    for (GDataXMLElement * _comment in _commentArray){
                        SCNMyCommentListData* _comment_List = [[SCNMyCommentListData alloc] init];
                        [_comment_List parseFromGDataXMLElement:_comment];
                        _comment_List.m_comment_content = [_comment stringValue];
                        [_commentary_product.m_mutarray_comment addObject:_comment_List];
                    } 
                }
                
                [self.m_mutarray_comments addObject:_commentary_product];
            }
            
        }
        if ([m_mutarray_comments count] >0) {
            [m_tableview_commentary reloadData];
            [m_tableview_commentary setHidden:NO];
            [self hideNotecontent];
        }else{
            [self showNotecontent:@"您暂无任何评论."];
        }
    }
}

#pragma mark
#pragma mark - UITableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [m_mutarray_comments count];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SCNMyCommentaryData * _commentary_product = [m_mutarray_comments objectAtIndex:section];
    if ([_commentary_product.m_mutarray_comment count] == 0) {
        return 1;
    }
    else  if ([_commentary_product.m_mutarray_comment count] == 1 ){
        return 2;
    }else{
        return  3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)TableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * UserProductCellIdentifier = @"UserProductCellIdentifier";
    NSString * SCNCommentaryCellIdentifier = @"SCNCommentaryCellIdentifier";
    SCNUserCommentaryTableCell * commentaryCell = nil;
    NSUInteger row =[indexPath row];
    
    {
        SCNMyCommentaryData * _commentary_product = [m_mutarray_comments objectAtIndex:indexPath.section];
        if (row == 0) 
        {
            commentaryCell= (SCNUserCommentaryTableCell *) [TableView dequeueReusableCellWithIdentifier:UserProductCellIdentifier];
            if (commentaryCell== nil) {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNUserCommentaryTableCell" owner:self options:nil];
                commentaryCell = [xib objectAtIndex:0];
                
                commentaryCell.m_label_info.backgroundColor = [UIColor clearColor];
                commentaryCell.m_view_bgviewinfo.layer.borderColor = [UIColor colorWithRed:(float)(145/255.0f) green:(float)(145/255.0f) blue:(float)(145/255.0f) alpha:1].CGColor;
                commentaryCell.m_view_bgviewinfo.layer.borderWidth = 1;
            }
            
            [commentaryCell.m_label_info setText:_commentary_product.mname];

            commentaryCell.m_imageview_info.image = [UIImage imageNamed:@"commentary_loading303x228.png" ];
            
			SCNHJManagedImageVUtility* showimge = commentaryCell.m_SCNImageview;
            showimge.m_bgImage = commentaryCell.m_imageview_info;
			
			UIControl* showbtn = nil;
			for (UIView* vi in showimge.subviews) {
				if ([vi isKindOfClass:[UIControl class]]) 
				{
					showbtn = (UIControl*)vi;
					break;
				}
			}
			if (!showbtn) 
			{
				showbtn = [[UIControl alloc] initWithFrame:showimge.bounds];
				showbtn.tag = indexPath.section;
				[showbtn addTarget:self action:@selector(onClickImage:) forControlEvents:UIControlEventTouchUpInside];
				[showimge addSubview:showbtn];
				showimge.userInteractionEnabled = YES;
			}
			
            [HJImageUtility queueLoadImageFromUrl:_commentary_product.mimage imageView:showimge];
			[showimge setBackgroundColor:[UIColor clearColor]];
            
            commentaryCell.m_label_commentaryNumber.text =[NSString stringWithFormat:@"%d",[_commentary_product.m_mutarray_comment count]] ;
            
            UIImage * _button_normal = [UIImage imageNamed:@"com_button_normal.png"];
            [commentaryCell.m_button_publish setBackgroundImage:[_button_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
            
            UIImage * _button_select = [UIImage imageNamed:@"com_button_select.png"];
            [commentaryCell.m_button_publish setBackgroundImage:[_button_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
            
            [commentaryCell.m_button_publish addTarget:self action:@selector(toPublishCommentary:) forControlEvents:UIControlEventTouchUpInside];
            commentaryCell.m_button_publish.tag = indexPath.section;
            
            //判断用户是否可以评论:                
            if ([_commentary_product.mcanComment isEqualToString:@"0"]) {
                UIImage * _button_normal = [UIImage imageNamed:@"com_blackbtn.png"];
                [commentaryCell.m_button_publish setBackgroundImage:[_button_normal stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
                
                UIImage * _button_select = [UIImage imageNamed:@"com_blackbtn_SEL.png"] ;
                [commentaryCell.m_button_publish setBackgroundImage:[_button_select stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
                commentaryCell.m_button_publish.enabled = NO;
            }
        }
        else
        {
            commentaryCell =(SCNUserCommentaryTableCell *) [TableView dequeueReusableCellWithIdentifier:SCNCommentaryCellIdentifier];
            if (commentaryCell == nil) 
            {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNUserCommentaryTableCell" owner:self options:nil];
                commentaryCell = [xib objectAtIndex:1];
                
                commentaryCell.m_imageview_star.layer.borderWidth = 1;
                [commentaryCell.m_imageview_star.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
            }
            if (row > 0)
            {
                 int commentrow = row - 1;
                 if (row <= [_commentary_product.m_mutarray_comment count])
                 {
                     SCNMyCommentListData* _comment_List = [_commentary_product.m_mutarray_comment objectAtIndex:commentrow];
                     
                     NSLog(@".......>>>>>>>>>>>>>>>>>>>%@",_comment_List.musername);
                     commentaryCell.m_imageview_star.image = [UIImage imageNamed:@"com_loading53x50.png"];  
                     [HJImageUtility queueLoadImageFromUrl:_comment_List.mstarImage imageView:commentaryCell.m_imageview_star];
                      
                     //如果账号名字大于5位的
                     if ([_comment_List.musername length] >5 )
                     {
                         NSMutableString * str_starname = [NSMutableString stringWithCapacity:0];
                         NSString * str_frontname = [_comment_List.musername substringToIndex:2];
                         NSString * str_backname = [_comment_List.musername substringFromIndex:[_comment_List.musername length]-2];
                         for (int i = 1; i <= [_comment_List.musername length] -4; i++) {
                             NSString * str_star = @"*";
                             [str_starname appendString:str_star];
                         }
                         commentaryCell.m_label_username.text = [NSString stringWithFormat:@"%@%@%@",str_frontname,str_starname,str_backname];
                         
                     }
                     //如果账号名字小于5位 大于2位的 
                     else if (2<[_comment_List.musername length] <=5)
                     {
                         NSMutableString * str_starname = [NSMutableString stringWithCapacity:0];
                         NSString * str_frontname = [_comment_List.musername substringToIndex:1];
                         NSString * str_backname = [_comment_List.musername substringFromIndex:[_comment_List.musername length]-1];
                         for (int i = 1; i <= [_comment_List.musername length] -2; i++) {
                             NSString * str_star = @"*";
                             [str_starname appendString:str_star];
                         }
                         
                         commentaryCell.m_label_username.text = [NSString stringWithFormat:@"%@%@%@",str_frontname,str_starname,str_backname];
                     }
                     else
                     {
                         commentaryCell.m_label_username.text = _comment_List.musername;
                     }
                     
                     commentaryCell.m_label_commentaryClass.text = _comment_List.mcommentStar;
                     commentaryCell.m_label_content.text = _comment_List.m_comment_content;
                     commentaryCell.m_label_creatTime.text = _comment_List.mcreateTime;
                 }
            }
            
        }
    }
    
    commentaryCell.m_view_bgcommentaryCell.layer.borderColor = [UIColor colorWithRed:(float)(145/255.0f) green:(float)(145/255.0f) blue:(float)(145/255.0f) alpha:1].CGColor;
    commentaryCell.m_view_bgcommentaryCell.layer.borderWidth = 1;   
    
    commentaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return commentaryCell;
}

-(void)onClickImage:(UIControl*)btn
{
	NSLog(@"clicked at row %d", btn.tag);
	SCNMyCommentaryData * _commentary_product = [m_mutarray_comments objectAtIndex:btn.tag];
	self.m_productcode = _commentary_product.mproductCode;
	[Go2PageUtility go2ProductDetail_OR_SecKill_ViewController:self withProductCode:self.m_productcode withPstatus:_commentary_product.mpstatus withImage:_commentary_product.mimage];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    SCNMyCommentaryData * _commentary_product = [m_mutarray_comments objectAtIndex:[indexPath section]];
    self.m_productcode = _commentary_product.mproductCode;
    
    if (row == 0) {
        
    }else{
        
        [Go2PageUtility go2CommentaryListViewController:self productCode:self.m_productcode];
        
    }
    
    return indexPath;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    
    if (row == 0) {
        return 336;
    }else{
        
        return 64;
    }
	
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString * _str_tempname = nil;
    SCNMyCommentaryData * _commentary_product = [self.m_mutarray_comments objectAtIndex:section];
    NSArray *temparray = [_commentary_product.mname componentsSeparatedByString:@" "];
    if ([temparray count ] > 2) {
        _str_tempname = [NSString stringWithFormat:@"%@ %@ ",[temparray objectAtIndex:0],[temparray objectAtIndex:1]];
    }
    
    UIView* _view_content = [[UIView alloc] initWithFrame:CGRectMake(0, 9, 320, 30)] ;
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [backImageView setImage:[DataWorld getImageWithFile:@"com_sectionBackground.png"]];
    [_view_content addSubview:backImageView];
    
    
    UILabel* _label_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 320, 22)];
    _label_title.lineBreakMode = 0;
    _label_title.textColor = [UIColor whiteColor];
    _label_title.backgroundColor = [UIColor clearColor];
    _label_title.text = _str_tempname;
    _label_title.font = [UIFont systemFontOfSize:15];
    
    UILabel* _label_page = [[UILabel alloc] initWithFrame:CGRectMake(180, 4, 135, 22)];
    _label_page.lineBreakMode = 0;
    _label_page.textColor = [UIColor whiteColor];
    _label_page.backgroundColor = [UIColor clearColor];
    _label_page.textAlignment = UITextAlignmentRight;
    _label_page.text = [NSString stringWithFormat:@"%d/%@",section+1,m_commentary_pagedata.mnumber];
    
    _label_page.font = [UIFont systemFontOfSize:15];
    
    [_view_content addSubview:_label_title];
    [_view_content addSubview:_label_page];
    
    return _view_content;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	int int_row = indexPath.row+1;
    NSLog(@"display.......%d>>>>>>>>>>>>>>>>>>>",int_row);
    if( int_row == [self.m_mutarray_comments count]-1 && m_int_currpage < m_int_currtotalpage){
        //加载下一页
        NSLog(@"准备加载下一页.......>>>>>>>>>>>>>>>>>>>");
        if (!m_isRequesting)
        {
            NSLog(@"加载下一页.......>>>>>>>>>>>>>>>>>>>");
            [self requestUserCommentaryXmlData:m_int_currpage +1];
        }		
    }
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}
@end
