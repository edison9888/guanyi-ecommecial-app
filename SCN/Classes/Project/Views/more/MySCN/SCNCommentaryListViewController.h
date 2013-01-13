//
//  SCNCommentaryListViewController.h
//  SCN
//
//  Created by chenjie on 11-10-19.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  评论列表
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNCommentaryData.h"

@interface SCNCommentaryListViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray           *m_mutarray_reply;                       //装载reply数据
    
    NSString                 *m_productCode;                          //商品id   shopex 相当于good id
    
    BOOL                      m_isRequestsuccess;                     //请求是否成功
    BOOL                      m_isRequesting;                         //是否在请求
    
    int                       m_int_currPage;                         //当前页数
    int                       m_int_pagetotal;
    
    SCNCommentaryData        *m_commentary_commentsdata;              //评论数据模型
    SCNCommentaryPageData    *m_commentary_pagedata;                  //评论页数数据模型
    
    UITableView              *m_tableview_commentary;                 //评论列表
    NSNumber                 *m_number_requestID;
    
}
@property (nonatomic , strong) NSNumber * m_number_requestID;
@property (nonatomic , strong) NSMutableDictionary* m_mutabledic_askreply;
@property (nonatomic , strong) NSMutableArray* m_mutarray_reply;
@property (nonatomic , strong) NSString* m_productCode;

@property (nonatomic , assign) BOOL m_isuserconsultation;

@property (nonatomic , strong) IBOutlet UITableView* m_tableview_commentary;           
@property (nonatomic , strong) SCNCommentaryPageData* m_commentary_pagedata;
@property (nonatomic , strong) SCNCommentaryData* m_commentary_commentsdata;


//评论请求
-(void)onRequestgetCommentaryList:(NSString *)productCode CurrentPage :(int)currentpage; 

//用户评论解析
-(void)parseCommentaryXmlData:(GDataXMLDocument*)xmlDoc;
-(void)onResponseComments:(id)json_obj;


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productCode:(NSString *)productid;

//重置数据
-(void)resetDataSource;

//页面跳转统计
-(NSString*)pageJumpParam;
@end
