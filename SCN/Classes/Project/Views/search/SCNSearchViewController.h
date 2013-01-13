//
//  SCNSearchViewController.h
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
/**
    此类的功能是搜索商品；
    可以直接点击热门关键字搜索
    也可以输入关键字搜索,有自动联想功能
 */

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum{
	YKSearch_UserInput = 0,
	YKSearch_History,
	YKSearch_Hot
}BehaviorSource;

@interface SCNSearchViewController : BaseViewController <UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
 
    BOOL _isRequestSuccess;                     //是否请求成功的标记位
    BOOL _isRequesting;                         //是否请求中
    int m_int_rowsOfTable;                      //记录行数
    NSNumber *m_number_requestID;               //标记上一次请求ID
}
@property(nonatomic,strong)IBOutlet UISearchBar *m_searchBar_keywordSearch;//搜索栏
@property(nonatomic,strong)IBOutlet UITableView *m_tableView_keywords; //关键字列表
@property(nonatomic,strong)NSMutableArray *m_array_keywords;//接收搜索热门关键字的数组
@property(nonatomic,strong)NSMutableArray *m_array_filterKeywords;//动态查询的数组
@property(nonatomic,strong)UISearchDisplayController *m_searchDisplay_filterController;//查询显示控制器

-(void)requestSearchViewJSONData;//请求热门关键字数据
-(void)requestSearchViewAssociateJSONData:(NSString*)keyword;//请求搜索关联数据

//搜索行为统计
-(void)behaviorSearch:(NSString*)_keyword searchSource:(NSInteger)_searchSource;
@end
