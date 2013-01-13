//
//  SCNMessageContentViewController.h
//  SCN
//
//  Created by chenjie on 12-07-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SCNMessageContentViewController.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "YKStringUtility.h"
#import "SCNConfig.h"

#define LABELTAG_TITLE     111
#define LABELTAG_TIME      113


@implementation SCNMessageContentViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil messagedata:(NSMutableDictionary *)messagedata
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_messagelist_data =  messagedata;
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>m_strmessageid%@",messagedata);

    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_textblock_content = nil;

}
- (void)dealloc
{
    NSLog(@"信息详情界面dealloc调用");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!m_isRequestsuccess) {
        [self requestMessageContent];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.title = @"阅读信息";
    self.pathPath = @"/messageread";
	
    UIScrollView * _scrollview_view = (UIScrollView*)self.view;
    _scrollview_view.contentSize = CGSizeMake(320, 440);
    

    self.m_textblock_content = [[TextBlock alloc] initWithFrame:CGRectMake(5, 5, 300, 0)];
    self.m_textblock_content.textAlignment = UITextAlignmentCenter;
    
    self.m_textblock_content.text = [self.m_messagelist_data objectForKey:@"content"];
    self.m_textblock_content.font = [UIFont systemFontOfSize:15];
    self.m_textblock_content.backgroundColor = [UIColor clearColor];
    CGRect rect = [self.m_textblock_content frame];
    
     UIView * _view_bgcontent = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, rect.size.height+10)];
        [_view_bgcontent.layer setCornerRadius:4];
    //设置背景颜色
    [_view_bgcontent setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    //设self.m_contentBgview边框宽度
//    [m_textblock_content.layer setBorderWidth:1];
    //设置边框颜色
//    [m_textblock_content.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
    [_view_bgcontent addSubview:self.m_textblock_content];
    [self.view addSubview:_view_bgcontent];
    
    UILabel * _label_time = [[UILabel alloc] initWithFrame:CGRectMake(182, rect.size.height +80, 130, 21)];
    
    
    _label_time.text = [self.m_messagelist_data objectForKey:@"created_at"];
    _label_time.font = [UIFont systemFontOfSize:13];
    _label_time.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_label_time];
    
    
    UILabel * _label_title = (UILabel *)[self.view viewWithTag:LABELTAG_TITLE];//这个label的tag来自xib文件
    _label_title.text = [self.m_messagelist_data objectForKey:@"title"];
    _label_title.textColor = [UIColor redColor];
    _label_title.backgroundColor = [UIColor clearColor];

    //已读 未读
    UILabel * _label_is_readed = [[UILabel alloc] initWithFrame:CGRectMake(182-40, rect.size.height +84, 30, 15)];
    _label_is_readed.text = @"未读";
    _label_is_readed.font =[UIFont systemFontOfSize:13];
    _label_is_readed.alpha = 0.6;
    _label_is_readed.backgroundColor = [UIColor clearColor];
    
    NSString* _status = [self.m_messagelist_data objectForKey:@"status"];
    if ([_status isEqualToString:@"0"]){
        _label_is_readed.text = @"已读";//0 是未读 1是已读
        [_label_is_readed setTextColor:[UIColor grayColor]];
    }
    [self.view addSubview:_label_is_readed];

    

}
-(void)requestMessageContent
{
    if (m_isRequesting) {
        return;
    }
	[self startLoading];
    m_isRequesting = YES;
    
    NSString* v_method      = [YKStringUtility strOrEmpty:MMUSE_METHOD_READMESSAGE];
    NSString* v_messageid   = [YKStringUtility strOrEmpty:[self.m_messagelist_data objectForKey:@"message_id"]];
    
    NSDictionary* extraParam= @{@"method": v_method,
                               @"message_id": v_messageid};
    
    [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onResponseMessageContent:)];

}
-(void)onResponseMessageContent:(id)json_obj
{
    [self stopLoading];
    
    m_isRequesting = NO;
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]) {
        m_isRequestsuccess = YES;
        [self.view setHidden:NO];

        if ( [[self.m_messagelist_data objectForKey:@"status"] isEqualToString:@"1"] ) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YK_MYSCNMESSAGE_READ object:nil userInfo:nil];
        }
    }
}
@end
