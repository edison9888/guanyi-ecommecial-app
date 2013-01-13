//
//  SCNAnnalViewController.h
//  SCN
//
//  Created by chenjie on 11-9-30.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  最近浏览控制器
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNAnnalViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>



@property (nonatomic , strong) IBOutlet UITableView   *m_browseTableView;   // 表
@property (nonatomic , strong) NSIndexPath      *m_currIndexpath;
@property (nonatomic , strong) NSMutableArray   *m_mutarray_getAllBrowserdata; // 商品信息数据模型
@property (nonatomic , strong) UIButton         *m_rightbutton;             // 导航栏右边按钮


-(IBAction)toEdit:(id)sender;

//是否添加编辑按钮
-(void)addNavigationbuttonOfEdit;
@end
