//
//  SCNClassifiedOneViewController.h
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2011 Yek.me. All rights reserved.
//	一级分类界面（重用）
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNClassifiedOneViewController : BaseViewController {

	UITableView     *m_tableview;
    NSString        *m_OneClassifiedId;    // 一级分类Id
	
}

@property (nonatomic,retain)IBOutlet UITableView *m_tableview;
@property (nonatomic,retain)NSString        *m_OneClassifiedId;


- (id)initWithNibName:(NSString *)nibNameOrNil withFirstClassifiedId:(NSString*)string bundle:(NSBundle *)nibBundleOrNil;

@end
