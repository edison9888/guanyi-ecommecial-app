//
//  SCNOrderDetailViewController.h
//  SCN
//
//  Created by chenjie on 11-9-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
//  订单详情控制器
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNUserInformationData.h"
#import "SCNOrderDetailData.h"
#import "TextBlock.h"
@interface SCNOrderDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView        *m_OrderDetail;   //订单详情表
    
    NSMutableArray              *m_mutableArray_title;
    
    NSString                    *m_orderID;
    
    SCNOrderDetailData          *m_orderdeail_data;
    
    BOOL                        m_isRequesting;
    BOOL                        m_isRequestsuccess;
    
    CGFloat                     m_CGfloat_height;
    
}
@property (nonatomic, strong) NSMutableArray *m_mutableArray_title;
@property (nonatomic, strong) NSString *m_orderID;
@property (nonatomic, strong) SCNOrderDetailData *m_orderdeail_data;

//请求我的订单详情
-(void)requestOrderDetailXmlData;
-(void)onRequestOrderDetailXmlDataResponse:(GDataXMLDocument*)xmlDoc;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             orderId : (NSString *) orderid;
//重置数据
- (void)resetDataSource;

#pragma mark behavior
-(NSString*)pageJumpParam;
@end
