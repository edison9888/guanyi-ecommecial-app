//
//  SCNPublishConsultationViewController.h
//  SCN
//
//  Created by chenjie on 11-10-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  发布售前咨询控制器

#import <UIKit/UIKit.h>
#import "SyTextView.h"
#import "BaseViewController.h"


@interface SCNPublishConsultationViewController : BaseViewController<UIAlertViewDelegate> {
    SyTextView                *m_textview_content;                        //装载发表评论内容
    NSString                  *m_productCode;                             //商品号
    BOOL                       m_isRequesting;                            //判断是否正在请求
    
    UIButton                  *m_button_publish;                          //发表评论按钮
}
@property (nonatomic, strong) UIButton * m_button_publish;
@property (nonatomic, strong) NSString * m_productCode;
@property (nonatomic, strong) IBOutlet SyTextView * m_textview_content;

//发表评论按钮
-(void)PublishConsultation:(id)sender;

//检测用户输入
-(BOOL)checkUserInput;

-(void)requestpublishConsultationXmlData:(NSString *)productCode;

-(void)onRequestpublishConsultationXmlDataResponse:(GDataXMLDocument*)xmlDoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productCode:(NSString *)prodictCode;

-(void)publishConsultationBehavior;//发布咨询行为统计
-(NSString*)pageJumpParam;
@end
