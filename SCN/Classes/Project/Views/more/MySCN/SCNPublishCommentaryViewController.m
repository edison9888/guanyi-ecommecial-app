//
//  SCNPublishCommentaryViewController.m
//  SCN
//
//  Created by chenjie on 11-10-19.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SCNPublishCommentaryViewController.h"
#import "YKStringUtility.h"
#import "YKHttpAPIHelper.h"
#import "SCNStatusUtility.h"
#import "YKStatBehaviorInterface.h"

@implementation SCNPublishCommentaryViewController

@synthesize m_array_commentarycontent;
@synthesize m_str_orderId,m_str_productCode,m_str_productName;
@synthesize m_button_publish;
@synthesize m_str_commentstar;
@synthesize m_textview_content;
@synthesize m_button_select;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil orderId:(NSString *)orderid productCode:(NSString *)productid productName:(NSString*)productName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_str_orderId = orderid;
        self.m_str_productCode = productid;
        
        NSLog(@"===============%@",orderid);
        NSLog(@"===============%@",productid);
		self.m_str_productName = productName;
        // Custom initialization
    }
    return self;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    self.m_button_publish = nil;
    self.m_str_commentstar = nil;
    self.m_button_select = nil;
    self.m_array_commentarycontent = nil;
	self.m_textview_content = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    NSLog(@"发布评论界面dealloc调用");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的评论";
	self.pathPath = @"/commentpublish";
    NSArray* temparray = [[NSArray alloc] initWithObjects:@"好评",@"中评",@"差评", nil];
    self.m_array_commentarycontent = temparray;
    
    m_textview_content.placeholder = @"请输入评论内容";
    m_textview_content.delegate =self;
    
    self.m_button_publish= [YKButtonUtility initSimpleButton:CGRectMake(0, 0, 80, 42)
                                                       title:@"发布评论"
                                                 normalImage:@"com_btn.png"
                                                 highlighted:@"com_btn_SEL.png"];
	
	//customview
	UIView* ricusview = [[UIView alloc] initWithFrame:m_button_publish.frame];
	[ricusview addSubview:m_button_publish];
	
    UIBarButtonItem * _barbuttonItem_publish = [[UIBarButtonItem alloc]initWithCustomView:ricusview];
	
    [m_button_publish addTarget:self action:@selector(onActionPublishCommentary:) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = _barbuttonItem_publish;

    [m_textview_content.layer setCornerRadius:5];
    //设self.m_contentBgview边框宽度
    [m_textview_content.layer setBorderWidth:1];
    //设置边框颜色
    [m_textview_content.layer setBorderColor:[UIColor colorWithRed:176.0/255 green:176.0/255 blue:176.0/255 alpha:1].CGColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];    
}
#pragma
#pragma - 键盘监听
- (void)keyboardWillShow:(NSNotification *)notif{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectMake(0, -80, 320, 480);
    [UIView commitAnimations];
}

#pragma
#pragma - 检测输入
-(BOOL)checkinput{
    
    if ([m_textview_content.text length]<1) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"评论内容不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

-(IBAction)clearKeyBoard
{
    [m_textview_content resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectMake(0, 0, 320, 480);
    [UIView commitAnimations];
    
}

-(void)onActionPublishCommentary:(id)sender
{
    if ([self checkinput]) {
        [self requestPublishCommentaryXmlData:m_str_productCode orderId:m_str_orderId];
    }
    
}
#pragma
#pragma - 请求发表评论
-(void)requestPublishCommentaryXmlData : (NSString *)productCode orderId:(NSString *)orderid
{
    if (m_isRequesting) {
        return;
    }
	[self startLoading];
    m_isRequesting = YES;
    
    NSString* v_method =[YKStringUtility strOrEmpty:YK_METHOD_COMMENT];
    NSString* v_orderid = [YKStringUtility strOrEmpty:orderid];
    NSString* v_productCode = [YKStringUtility strOrEmpty:productCode];
    
    NSLog(@"===============%@",orderid);
    NSLog(@"===============%@",v_productCode);
    NSString* v_content = [YKStringUtility strOrEmpty:m_textview_content.text];
    NSString* v_commentstar = nil;
    if ([m_str_commentstar isEqualToString:@""]) {
        NSLog(@",,,,,,,,,,,,,,,,,%@",m_str_commentstar);
        v_commentstar = [YKStringUtility strOrEmpty:@"1"];
    }else{
        v_commentstar = [YKStringUtility strOrEmpty:self.m_str_commentstar];
    }
    
    NSDictionary* extraParam = @{@"act": v_method,
                                @"orderId": v_orderid,
                                @"productCode": v_productCode,
                                @"content": v_content,
                                @"commentstar": v_commentstar};	
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(onRequestPublishCommentaryDataResponse:)]; 


}

-(void)publishCommentSuccessBehavior{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|sku|用户名|用户id
	NSString* _param = [NSString stringWithFormat:@"%@|%@|%@|%@",m_str_productName,
						m_str_productCode,
						[[YKUserInfoUtility shareData] m_userDataInfo].musername,
						[[YKUserInfoUtility shareData] m_userDataInfo].mweblogid
						];
    
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_COMMENTSUBMIT param:_param];
#endif
}

-(void)onRequestPublishCommentaryDataResponse:(GDataXMLDocument*)xmlDoc
{
    [self stopLoading];
    m_isRequesting = NO;
    
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"发表成功,我们会及时处理,谢谢" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
		
    
        [[NSNotificationCenter defaultCenter] postNotificationName:YK_PUBLISH_SUCCESS object:nil userInfo:nil];
		[self publishCommentSuccessBehavior];
        
    }
   
}
#pragma
#pragma - alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    if ([alertView.message isEqualToString:@"发表成功,我们会及时处理,谢谢"]) {
         [self goBack];
    }
}
#pragma
#pragma -发表评论按钮
-(IBAction)onActionselectcommentarybuttonpress:(id)sender
{
    [m_textview_content resignFirstResponder];
    SCNCommonPickerView*  m_pickview_commentary =[[SCNCommonPickerView alloc]initWithFrame:CGRectMake(0, 140, 320, 216)];
    m_pickview_commentary.m_delegate =self;
    m_pickview_commentary.m_pickerView.delegate =self;
//    [m_pickview_commentary.m_pickerView selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:m_pickview_commentary];
   // [m_pickview_commentary appearView];
}
#pragma
#pragma - pickview delegate
-(NSArray*)titleForPickerView:(SCNCommonPickerView*)aPickerView
{
    return nil;

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [m_array_commentarycontent count];
}

-(NSInteger)numberOfCellsForPickerView:(SCNCommonPickerView*)aPickerView
{
    return [m_array_commentarycontent count];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIView* _view_bgview = [[UIView alloc] initWithFrame:CGRectMake(150, 0, 40, 30)];
    UILabel* _label_content = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    _label_content.backgroundColor = [UIColor clearColor];
    _label_content.text = [m_array_commentarycontent objectAtIndex:row];
    [_view_bgview addSubview:_label_content];
    return _view_bgview;
}

-(void)scnCommonPickerView:(SCNCommonPickerView*)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    self.m_str_commentstar = [NSString stringWithFormat:@"%d",row+1];
    [m_button_select setTitle:[m_array_commentarycontent objectAtIndex:row] forState:UIControlStateNormal];
    NSLog(@">>>>>>>>>>>>>>>>>>>>%@",m_str_commentstar);

    
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	//商品名称|商品ID
	NSString* _param = [NSString stringWithFormat:@"%@|%@",m_str_productName,m_str_productCode];
	return _param;
#else
	return nil;
#endif
}
@end
