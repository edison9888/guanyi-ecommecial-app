//
//  SCNOrderDetailViewController.h
//  SCN
//
//  Created by chenjie on 11-9-30.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  我的订单控制器

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YKUserInfoUtility.h"

@interface SCNMyOrderFormViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate> {
    UITableView               *m_tableView_orderForm;   //订单详情表
    UIView                    *m_view_totalView;        //小计视图
    UIView                    *m_view_buttonBGview;     //按钮背景视图
    
    UIButton                  *m_button_leftbutton;     //一个月内的清单
    UIButton                  *m_button_rightbutton;    //历史清单
    NSString                  *m_str_months;            //月数
    
    NSMutableArray            *m_mutarray_temparray;    //装载流程临时数据
    
    BOOL                       m_isRequesting;
    BOOL                       m_isRuquestsuccess;
    
    int                        m_int_istagsame;
    
    int                        m_int_currpage;           //当前页数
    int                        m_int_currtotalpage;      //每页显示的行数
    
    NSNumber                  *m_number_requestID;
    SCNOrderPageinfoData      *m_orderpage_data;         //装载页码数据
    
}
@property (nonatomic, strong)SCNOrderPageinfoData* m_orderpage_data;
@property (nonatomic, strong)NSMutableArray* m_mutarray_temparray;
@property (nonatomic, strong)IBOutlet UITableView* m_tableView_orderForm;
@property (nonatomic, strong)IBOutlet UIView* m_view_totalView;
@property (nonatomic, strong)IBOutlet UIView* m_view_buttonBGview;
@property (nonatomic, strong)IBOutlet UIButton* m_button_leftbutton;
@property (nonatomic, strong)IBOutlet UIButton* m_button_rightbutton;
@property (nonatomic, strong)NSString *m_str_months;
@property (nonatomic, strong)NSNumber *m_number_requestID;

//历史清单,一个月内清单按钮
-(IBAction)onActionbuttonpress:(id)sender;

//不同月数请求
- (void)buttonrequest:(NSString *)months;

//请求我的订单列表
-(void)requestOrderformXmlData:(NSString *)months Currentpage:(int)currentpage;

-(void)onRequestOrderformXmlDataResponse:(GDataXMLDocument*)xmlDoc;

//点击清单按钮重新加载表数据;
- (void)overloadingTableview;

//重置数据
-(void)resetDataSource;
@end
