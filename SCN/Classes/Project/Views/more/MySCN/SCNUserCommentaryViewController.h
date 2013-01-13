//
//  SCNUserCommentaryViewController.h
//  SCN
//
//  Created by chenjie on 11-10-18.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  我的评论控制器

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "TextBlock.h"
#import "SCNMyCommentaryData.h"
#import "SCNHJManagedImageVUtility.h"

@interface SCNUserCommentaryViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet  UITableView    *m_tableview_commentary;                 //我的评论列表
    NSString                 *m_productcode;                          //商品号
    NSString                 *m_str_orderId;                          //订单ID
    
    int                       m_int_currpage;                         //数据当前页数
    int                       m_int_currtotalpage;                    //数据总页面
    
    NSMutableArray           *m_mutarray_comments;                    //装载所有评论数据数组
    SCNMyCommentaryPageData  *m_commentary_pagedata;                  //装载分页数据模型

    BOOL                      m_isRequesting;                         //判断是否正在请求
    BOOL                      m_isRequestsuccess;                     //判断是否请求成功
     
    NSNumber                 *m_number_requestID;                     
    
}
@property (nonatomic, strong) UITableView    * m_tableview_commentary;
@property (nonatomic, strong) NSNumber * m_number_requestID;
@property (nonatomic, strong) NSString * m_productcode;
@property (nonatomic, strong) NSString * m_str_orderId;
@property (nonatomic, strong) NSMutableArray * m_mutarray_comments;
@property (nonatomic, strong) SCNMyCommentaryPageData * m_commentary_pagedata;

//请求我的评论列表
-(void)requestUserCommentaryXmlData :(int)currentpage;

//解析我的评论列表
-(void)onRequestUserCommentaryDataResponse:(GDataXMLDocument*)xmlDoc;

//重置数据
-(void)resetDataSource;

-(void)onClickImage:(UIControl*)btn;
@end
