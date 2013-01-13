//
//  YK_TableViewUtility.h
//  YMW
//
//  Created by user on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "YK_BaseViewController.h"

@interface YK_BaseViewController (CellUI)
/*
 必须重写这个获取数据的函数
 */
-(UITableViewCell*)cellAtIndexPath:(NSIndexPath*)indexPath withIdentifier:(NSString*)cellIdentifier;
/*
 设置tableViewCell中的视图元素
 */
-(void)layoutCellUI:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
@end
