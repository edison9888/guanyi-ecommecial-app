//
//  SCNSecKillListViewController.h
//  SCN
//
//  Created by xie xu on 11-10-17.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNSearchData.h"

@interface SCNSecKillListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *m_tableView_secKillList;                       //秒杀列表
    NSMutableArray *m_array_seckillProduct;                     //秒杀商品数组
    NSString *m_string_secKillID;                               //秒杀列表ID
    NSString *m_string_typeName;                                //秒杀专题名称
    int m_int_currPage;                                         //当前页码
    int m_int_currPageSize;                                     //每页显示数量
    SCNSearchProductListData *m_data_listAttributeData;         //记录商品列表的属性
    BOOL _isRequesting;                                         //标记是否正在请求
    BOOL _isRequestSuccess;                                     //标记是否请求成功
    NSTimer *m_timer_refresh;                                   //秒杀列表商品状态更新定时器
}
@property(nonatomic,strong)IBOutlet UITableView *m_tableView_secKillList;
@property(nonatomic,strong)NSMutableArray *m_array_seckillProduct;
@property(nonatomic,strong)NSString *m_string_secKillID;
@property(nonatomic,strong)NSString *m_string_typeName;
@property(nonatomic,strong)SCNSearchProductListData *m_data_listAttributeData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSecKillID:(NSString*)secKillID;
-(NSString*)changeTimeIntervalToHHmmString:(NSString*)fullTimeInterval;   //转化时间的完整格式为只显示时间:分钟
-(NSString*)changeTimeIntervalToDate:(NSString*)fullTimeInterval;//"1318521600"转化为"2011-10-14 00:00:00"
-(void)dealWithSeckillStatus;                                   //处理商品状态
-(void)requestSeckillListXmlData:(int)currPage;                     //请求秒杀列表数据
-(void)onRequestSeckillListXmlDataResponse:(GDataXMLDocument*)xmlDoc;//解析返回数据
-(void)resetDataSource;
-(void)dealAllView:(BOOL)isEnter;
-(void)startTimer;
-(void)stopTimer;

//页面跳转行为统计
-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;
@end
