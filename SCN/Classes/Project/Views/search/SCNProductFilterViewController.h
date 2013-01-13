//
//  SCNProductFilterViewController.h
//  SCN
//
//  Created by xie xu on 11-10-13.
//  Copyright 2012年 Guanyi. All rights reserved.
//

#import "BaseViewController.h"
#import "SCNCommonPickerView.h"
#import "SCNProductListViewController.h"
#import "SCNProductFilterTableCell.h"

@interface SCNProductFilterViewController : BaseViewController<SCNProductFilterTableCellDelegate,UITableViewDataSource,UITableViewDelegate>{

    int m_int_currCell;//记录点击哪一行
    
    
}
@property(nonatomic,strong)IBOutlet UITableView *m_tableView_filterList;    //筛选表格视图
@property(nonatomic,strong)NSMutableDictionary *m_dict_filterData;          //接收筛选条件的字典
@property(nonatomic,strong)NSArray *m_array_keys;                           //接收筛选条件的Key
@property(nonatomic,strong)NSMutableDictionary *m_dict_userFilterData;      //记录用户筛选条件字典

@property(nonatomic,strong)IBOutlet UIButton* m_backBtn;
@property(nonatomic,unsafe_unretained)id<SCNProductFilterDelegate> m_delegate_filter;

@property(nonatomic,strong)NSString *test;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFilterDict:(NSMutableDictionary*)filterDict;
-(IBAction)saveFilterData;
-(IBAction)cancleFilter;

-(void)behaviorFilterData:(NSMutableDictionary*)_filterDic;
@end
