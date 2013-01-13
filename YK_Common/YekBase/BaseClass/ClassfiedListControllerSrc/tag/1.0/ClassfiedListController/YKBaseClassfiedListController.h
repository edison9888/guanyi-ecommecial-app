//
//  YKBaseClassfiedListController.h
//  YKProject
//
//  Created by guwei.zhou on 11-9-27.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YK_BaseViewController.h"
#import "YKClassfiedDataConfig.h"

/*
 1.视图加载完毕即发出网络请求
 2.
 */
@interface YKBaseClassfiedListController : YK_BaseViewController<UITableViewDelegate,UITableViewDataSource>{
    @public
    UITableView  *m_tableView;
    NSArray *m_array_classfied;
}
@property (nonatomic,retain) IBOutlet UITableView *m_tableView;
@property (nonatomic,retain) NSArray *m_array_classfied; 

/*
 网络请求部分
 */
-(void)reAsyncWebData;
-(void)startAsyncWebData;
-(void)onStartAsyncWebData:(NSObject*)response;

-(void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

/*
 重新加载tableView中的数据
 */
-(void)reloadData;
-(void)reloadDataOnThread;

@end
