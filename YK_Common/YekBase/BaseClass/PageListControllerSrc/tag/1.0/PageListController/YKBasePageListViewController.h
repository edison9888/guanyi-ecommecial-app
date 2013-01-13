//
//  YKBaseListViewController.h
//  YKPoject
//
//  Created by guwei.zhou on 11-9-26.
//  Copyright 2011年 yek. All rights reserved.
//
#import "EGORefreshTableHeaderView.h"
#import <UIKit/UIKit.h>
#import "YKListConfig.h"
#import "YK_BaseViewController.h"

typedef enum {
	defaultenum=0,
	first,
} EGORefresh;

@interface YKBasePageListViewController : YK_BaseViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource>{
    @private
    NSMutableArray  *_array_listData;   //表中数据
    @public
    int             m_page;             //页索引
    int             m_pageCount;        //页总数
    int             m_pageSize;         //每页item个数
    int             m_itemsCount;       //item总数
   
	UITableView     *m_tableView;       //表视图
	
	// --------下拉刷新
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
	EGORefresh isadd;
}

@property (nonatomic,retain,getter = listItems,setter = setListItems:) NSMutableArray* listItems;
@property (nonatomic,assign) int m_page;
@property (nonatomic,assign) int m_pageCount;
@property (nonatomic,assign) int m_pageSize;
@property (nonatomic,assign) int m_itemsCount;
@property (nonatomic,retain) IBOutlet UITableView *m_tableView;

@property (nonatomic,retain) EGORefreshTableHeaderView* _refreshHeaderView;
@property (nonatomic,assign) BOOL _reloading;
@property (nonatomic,assign) EGORefresh isadd;
/*
 初始化视图控制器设置是否下拉刷新
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  isadd:(EGORefresh)addEGORefresh;
/*
 网络请求部分
 */
-(void)reAsyncWebData;
-(void)startAsyncWebData;
-(void)onStartAsyncWebData:(NSObject*)response;

//optional

-(int)cellsSectionNumber;
/*
 重新加载tableView中的数据
 */
-(void)reloadData;
-(void)reloadDataOnThread;
-(void)appendData:(NSArray*)items;
-(void)appendDataOnThread:(NSArray*)items;
/*
 控制该tableView的大小
 */
-(void)restrictTableViewArea:(CGSize)areaSize;
/*
 创建下拉刷新的视图
 */
-(void)CreateEGORefreshTableHeaderView;

/*
 选中tableView中的某一行
 */
-(void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end
