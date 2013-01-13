//
//  SCNPublishCommentaryViewController.h
//  SCN
//
//  Created by chenjie on 11-10-19.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  发表评论控制器

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNCommonPickerView.h"
#import "SyTextView.h"

@interface SCNPublishCommentaryViewController : BaseViewController <SCNCommonPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIAlertViewDelegate> {
    NSArray                 *m_array_commentarycontent;          //装载好评,中评,差评
	SyTextView				*m_textview_content;                 //评论容器
	UIButton				*m_button_select;                    //选择评论级别按钮
    
    UIButton                 *m_button_publish;                   //发表评论按钮
    NSString                 *m_str_productCode;                  //商品Id
    NSString                 *m_str_orderId;                      //订单Id
	NSString				 *m_str_productName;				  //商品名称
    
    NSString                 *m_str_commentstar;                  //评论等级
    BOOL                      m_isRequesting;
}
@property (nonatomic , strong) NSString * m_str_commentstar;
@property (nonatomic , strong) UIButton * m_button_publish;
@property (nonatomic , strong) NSArray  * m_array_commentarycontent;
@property (nonatomic , strong) NSString * m_str_productCode;
@property (nonatomic , strong) NSString * m_str_productName;
@property (nonatomic , strong) NSString * m_str_orderId;
@property (nonatomic , strong) IBOutlet SyTextView * m_textview_content;
@property (nonatomic , strong) IBOutlet UIButton *m_button_select;

-(IBAction)onActionselectcommentarybuttonpress:(id)sender;
//检测评论输入内容
-(BOOL)checkinput;

//取消键盘第一响应
-(IBAction)clearKeyBoard;

//发表评论
-(void)onActionPublishCommentary:(id)sender;

-(void)requestPublishCommentaryXmlData : (NSString *)productCode orderId:(NSString *)orderid;

-(void)onRequestPublishCommentaryDataResponse:(GDataXMLDocument*)xmlDoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil orderId:(NSString *)orderid productCode:(NSString *)productid productName:(NSString*)productName;

//发表评论行为统计
-(void)publishCommentSuccessBehavior;
@end
