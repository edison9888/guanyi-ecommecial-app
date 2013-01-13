//
//  SCNHelpViewController.h
//  SCN
//
//  Created by chenjie on 12-07-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GY_Collections.h"

@interface SCNHelpViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate> {

    BOOL                   m_isRequesting;                       
    BOOL                   m_isRequestsuccess; 
}
@property(nonatomic,strong) IBOutlet UITableView  *m_tableview_help;     //帮助列表
@property(nonatomic,strong) NSMutableArray *m_helpArray;                 //装载帮助数据数组

-(void)requestHelp;

-(void)onResponseHelp:(id)json_obj;

//重置数据
-(void)resetDataSource;

@end
