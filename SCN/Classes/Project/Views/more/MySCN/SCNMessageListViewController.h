//
//  SCNMessageListViewController.h
//  SCN
//
//  Created by chenjie on 12-07-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNMessageListViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>{

    BOOL                  m_isRequesting;                            //判断是否正在请求
    BOOL                  m_isRequestsuccess;                        //判断是否请求成功
    
}
@property (nonatomic , strong) IBOutlet UITableView *m_tableview_Messagelist;    //消息列表
@property (nonatomic , strong) NSMutableArray *m_mutarray_MessageList;  //装载消息列表数据数组

-(void)requestMessageList;

-(void)onResponseMessageList:(id)json_obj;

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//重置数据
- (void)resetDataSource;

//增加注册监听
- (void)readNewmessage:(NSNotification *)notify;

//刷新所有的VIEW
-(void)dealAllView:(BOOL)isEnter;
@end
