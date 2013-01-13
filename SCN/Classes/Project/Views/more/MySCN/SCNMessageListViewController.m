//
//  SCNMessageListViewController.h
//  SCN
//
//  Created by chenjie on 12-07-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNMessageListViewController.h"
#import "YKStringUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "YKButtonUtility.h"
#import "SCNMessageListData.h"
#import "SCNMessageContentViewController.h"
#import "GY_Collections.h"

#define LABELTAG_TITLE          111
#define LABELTAG_CONTENT        112
#define LABELTAG_CREATTIME      113
#define IMAGEVIEW_MESSAGE       114
#define LABELTAG_IS_READED      115

@implementation SCNMessageListViewController


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
    self.m_tableview_Messagelist = nil;
    self.m_mutarray_MessageList = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resetDataSource];
 
}
- (void)dealloc
{
    NSLog(@"信息列表界面dealloc调用");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)resetDataSource
{
    m_isRequestsuccess = NO;
    [self.m_mutarray_MessageList removeAllObjects];
    [self.m_tableview_Messagelist setHidden:YES];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!m_isRequestsuccess) {
        [self.m_tableview_Messagelist setHidden:YES];
        [self requestMessageList];
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息阅读";
    self.pathPath = @"/messageread";
    self.m_tableview_Messagelist.separatorColor = YK_CELLBORDER_COLOR;
    //初始化装载消息数据
    self.m_mutarray_MessageList = [NSMutableArray arrayWithCapacity:0];
    
    [self resetDataSource];
    
}

- (void)readNewmessage:(NSNotification *)notify
{
    [self.m_mutarray_MessageList removeAllObjects];
	[self requestMessageList];
}
-(void)dealAllView:(BOOL)isEnter
{
	if (!m_isRequestsuccess && isEnter)
	{
		self.m_tableview_Messagelist.hidden = YES;
        [self requestMessageList];
	}
    
}
-(void)requestMessageList
{
    [self startLoading];
  
    NSDictionary* extraParam= @{@"method": @"more.view.new_message_list"};
    
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onResponseMessageList:)];

}

-(void)onResponseMessageList:(id)json_obj
{
    [self stopLoading];
    
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]) {
        m_isRequestsuccess = YES;
        
        GY_BaseCollection* coll = [[GY_BaseCollection alloc]initWithJSON:json_obj];
        NSMutableArray* arr = coll.collection_data;
        
        if ([arr count] > 0) {
            self.m_mutarray_MessageList = arr;
            NSLog(@" 用户的留言内容长度为>>>>>>>>>>>>>>>>>>%d",[self.m_mutarray_MessageList count]);
        }
        if ([self.m_mutarray_MessageList count] > 0) {
            [self.m_tableview_Messagelist reloadData];
            [self.m_tableview_Messagelist setHidden:NO];
            [self hideNotecontent];
        }else{
            [self showNotecontent:@"您暂无任何信息"];
        }
    }
}

#pragma mark
#pragma mark - UITableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.m_mutarray_MessageList count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* UserConsultation = @"SCNMessageListViewController";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:UserConsultation];
    
    if ( cell == nil ) {	
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:UserConsultation];
        
        cell.contentView.backgroundColor = [UIColor clearColor];//圆角的cornet bg view
        UIView * _view_bgcellview = (UIView *)[YKButtonUtility initBgCornerViewWithHeight:60 cornerRadius:5];
        [cell.contentView insertSubview:_view_bgcellview atIndex:0  ];
        //标题
        UILabel* _label_title = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 200, 15)];
        _label_title.font = [UIFont systemFontOfSize:15];
        _label_title.numberOfLines = 0;
        _label_title.tag = LABELTAG_TITLE;
        _label_title.backgroundColor = [UIColor clearColor];
        
        //内容
        UILabel* _label_content = [[UILabel alloc] initWithFrame:CGRectMake(12, 29, 290, 20)];
        _label_content.font = [UIFont systemFontOfSize:13];
        _label_content.backgroundColor = [UIColor clearColor];
        _label_content.lineBreakMode = UILineBreakModeTailTruncation;
        _label_content.tag = LABELTAG_CONTENT;
        
        //时间
        UILabel* _label_creatTime = [[UILabel alloc]initWithFrame:CGRectMake(180,46, 150, 20)];
        _label_creatTime.font =[UIFont systemFontOfSize:13];
        _label_creatTime.alpha = 0.6;
        _label_creatTime.backgroundColor = [UIColor clearColor];
        _label_creatTime.tag = LABELTAG_CREATTIME;
        
        
        UIImageView * _imageview_message = [[UIImageView alloc] initWithFrame:CGRectMake(275, 9, 20, 15)];
        _imageview_message.tag = IMAGEVIEW_MESSAGE;
        
        //已读 未读
        UILabel* _label_is_readed = [[UILabel alloc]initWithFrame:CGRectMake(234, 9, 30, 15)];
        _label_is_readed.font =[UIFont systemFontOfSize:13];
        _label_is_readed.alpha = 0.6;
        _label_is_readed.backgroundColor = [UIColor clearColor];
        _label_is_readed.tag = LABELTAG_IS_READED;
        
        [cell.contentView addSubview:_label_content];
        [cell.contentView addSubview:_label_title];
        [cell.contentView addSubview:_label_creatTime];
        [cell.contentView addSubview:_imageview_message];
        [cell.contentView addSubview:_label_is_readed];
    }
    
    NSMutableDictionary* _dict  = [self.m_mutarray_MessageList objectAtIndex:[indexPath row]];
    NSString* _status           = [_dict objectForKey:@"status"];   //0 是未读 1是已读
    NSString* _content          = [_dict objectForKey:@"content"];
    NSString* _created_at       = [_dict objectForKey:@"created_at"];
    
    if ([_status isEqualToString:@"1"]) {
        UIImageView * _imageview_message = (UIImageView *)[cell viewWithTag:IMAGEVIEW_MESSAGE];
        _imageview_message.image = [UIImage imageNamed:@"more_icon_newmessage.png"];
    }else{
        UIImageView * _imageview_message = (UIImageView *)[cell viewWithTag:IMAGEVIEW_MESSAGE];
        _imageview_message.image = [UIImage imageNamed:@"more_oldmessage.png"];    
    }
    //标题
    UILabel* _label_title = (UILabel *)[cell viewWithTag:LABELTAG_TITLE];
    _label_title.text = [_dict objectForKey:@"title"];   
    
    //内容
    UILabel* _label_content = (UILabel *)[cell viewWithTag:LABELTAG_CONTENT];
    _label_content.text = _content;   
    
    //时间
    UILabel* _label_creatTime = (UILabel *)[cell viewWithTag:LABELTAG_CREATTIME];
    _label_creatTime.text = _created_at;
    	
     //已读 未读
    UILabel* _label_is_readed = (UILabel *)[cell viewWithTag:LABELTAG_IS_READED];
    _label_is_readed.text = @"未读";
    if ([_status isEqualToString:@"1"]){
        _label_is_readed.text = @"已读";//0 是未读 1是已读
        [_label_is_readed setTextColor:[UIColor grayColor]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* _dict  = [self.m_mutarray_MessageList objectAtIndex:[indexPath row]];
    NSString* _status           = [_dict objectForKey:@"status"];

    if ([_status isEqualToString:@"1"]) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readNewmessage:) name:YK_MYSCNMESSAGE_READ object:nil];
    }
    
    SCNMessageContentViewController * messagecontent = [[SCNMessageContentViewController alloc] initWithNibName:@"SCNMessageContentViewController" bundle:nil messagedata:_dict];
    [self.navigationController pushViewController:messagecontent animated:YES];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    return indexPath;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80;

}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
}
@end
