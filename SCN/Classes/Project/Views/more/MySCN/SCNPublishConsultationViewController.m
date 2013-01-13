//
//  SCNPublishConsultationViewController.m
//  SCN
//
//  Created by chenjie on 11-10-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import "YKStatBehaviorInterface.h"
#import "SCNPublishConsultationViewController.h"
#import "YKStringUtility.h"
#import "SCNStatusUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNConfig.h"

@implementation SCNPublishConsultationViewController

@synthesize m_productCode;
@synthesize m_button_publish;
@synthesize m_textview_content;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productCode:(NSString *)prodictCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_productCode = prodictCode; 
        NSLog(@">>>>>>>>>>>>>>>%@",prodictCode);
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_button_publish = nil;
    m_textview_content = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    NSLog(@"发布咨询界面dealloc调用");
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_textview_content resignFirstResponder];
    
}
#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    [m_textview_content becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布咨询";
    self.pathPath = @"/commentpublish";
    self.m_button_publish= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 80, 42)
                                                       title:@"发布咨询"
                                                 normalImage:@"com_btn.png"
                                                 highlighted:@"com_btn_SEL.png"];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:m_button_publish.frame];
	[ricusview addSubview:m_button_publish];
	
    UIBarButtonItem * _barbuttonItem_publish = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	
    [m_button_publish addTarget:self action:@selector(PublishConsultation:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_publish;

    m_textview_content.keyboardType = UIKeyboardTypeDefault;
    m_textview_content.placeholder = @"请输入要咨询的内容";
    
    [m_textview_content.layer setCornerRadius:5];
    //设self.m_contentBgview边框宽度
    [m_textview_content.layer setBorderWidth:1];
    //设置边框颜色
    [m_textview_content.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
}
-(BOOL)checkUserInput{
    
    if ([m_textview_content.text length] < 1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"咨询的内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }

    return YES;
}
#pragma mark - 发表咨询按钮
-(void)PublishConsultation:(id)sender{
    if ([self checkUserInput]) {
        [self requestpublishConsultationXmlData:m_productCode];
        [self publishConsultationBehavior];
    }
}

-(void)publishConsultationBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	//商品来源页面id|商品名称|sku|用户名|用户id
	//NSString* _sourceId = [[YKStatBehaviorInterface currentSourcePageId] stringValue];
//	NSInteger _sourceId = [YKStatBehaviorInterface currentSourcePageId];
//	NSString* _param = [NSString stringWithFormat:@"%d|%@|%@|%@|%@",
//						_sourceId,
//						[DataWorld shareData].m_nowProductData.m_productName,
//						[DataWorld shareData].m_nowProductData.m_productCode,
//						[YKUserInfoUtility shareData].m_userDataInfo.musername,
//						[YKUserInfoUtility shareData].m_userDataInfo.mweblogid
//						];
//	NSLog(@"%@",_param);
	//[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_SUBMITCONSULT param:_param];
#endif
}
#pragma mark - 发表咨询请求
-(void)requestpublishConsultationXmlData:(NSString *)productCode
{
    if (m_isRequesting) {
        return;
    }
	[self startLoading];
    m_isRequesting = YES;
    NSString* v_method = [YKStringUtility strOrEmpty:YK_METHOD_PRODUCTCONSULT];
    NSString* v_productCode = [YKStringUtility strOrEmpty:productCode];
    NSString* v_content = [YKStringUtility strOrEmpty:m_textview_content.text];
    
    NSLog(@">>>>>>>>>>>>>>>%@",productCode);
    NSDictionary* extraParam= @{@"act": v_method,
                               @"productCode": v_productCode,
                               @"content": v_content};
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestpublishConsultationXmlDataResponse:)]; 
    
}
-(void)onRequestpublishConsultationXmlDataResponse:(GDataXMLDocument*)xmlDoc
{
    m_isRequesting = NO;
    [self stopLoading];
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"发布成功,我们会及时处理.谢谢." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
    
}
#pragma mark - Alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"发布成功,我们会及时处理.谢谢."]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:YK_PUBLISH_SUCCESS object:nil];
        [self goBack];
    }
    
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
