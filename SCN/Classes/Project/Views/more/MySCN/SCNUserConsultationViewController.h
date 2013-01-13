//
//  SCNUserConsultationViewController.h
//  SCN
//
//  Created by chenjie on 11-10-18.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  用户咨询控制器
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TextBlock.h"
#import "SCNConsultationData.h"

@interface SCNUserConsultationViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray           *m_mutarray_consultation;                //装载咨询流程所有数据
    NSMutableArray           *m_mutarray_reply;                       //装载reply数据
    NSString                 *m_productCode;                          //商品id
    
    BOOL                      m_isuserconsultation;                   //是否为我的咨询
    BOOL                      m_isRequestsuccess;                     //请求是否成功
    BOOL                      m_isRequesting;                         //是否在请求
    
    int                       m_int_currPage;                         //当前页数
    int                       m_int_totalpage;                        //总页数
	
    UIButton                 *m_button_publish;                       //发布咨询按钮
    SCNConsulationPageData   *m_consultation_Pagedata;                //装载分页数据模型
    UITableView              *m_tableview_consultation;               //咨询列表
    
    NSNumber                 *m_number_requestID; 
    
}

@property (nonatomic , strong) NSNumber             * m_number_requestID;
@property (nonatomic , strong) UIButton             * m_button_publish;
@property (nonatomic , strong) NSMutableArray       * m_mutarray_consultation;
@property (nonatomic , strong) NSMutableArray       * m_mutarray_reply;
@property (nonatomic , strong) NSString             * m_productCode;
@property (nonatomic , assign) BOOL m_isuserconsultation;
@property (nonatomic , strong) IBOutlet UITableView  * m_tableview_consultation;
@property (nonatomic , strong) SCNConsulationPageData* m_consultation_Pagedata;
//用户咨询请求
-(void)onRequestgetUserConsultList :(int)currentpage;

//用户咨询解析
-(void)parseConsultationXmlData:(GDataXMLDocument*)xmlDoc;

//售前咨询请求
-(void)onRequestgetConsultList:(NSString *)productCode CurrentPage:(int)currentpage;

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//添加发表咨询按钮
-(void)addBarButtonItemofPublishConsultation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productCode:(NSString *)productCode;
//重置数据
-(void)resetDataSource;

//行为统计
-(NSString*)pageJumpParam;
@end

