//
//  SCNClassifiedTwoViewController.h
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2011 Yek.me. All rights reserved.
//	二级分类界面（暂不用）
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNClassifiedTwoViewController : BaseViewController {

	UITableView     *m_tableview;
    NSString        *m_TwoClassifiedId;
	
}

@property (nonatomic,retain)IBOutlet UITableView *m_tableview;
@property (nonatomic,retain)NSString        *m_TwoClassifiedId;

- (id)initWithNibName:(NSString *)nibNameOrNil withSecondClassifiedId:(NSString*)string bundle:(NSBundle *)nibBundleOrNil;

@end
