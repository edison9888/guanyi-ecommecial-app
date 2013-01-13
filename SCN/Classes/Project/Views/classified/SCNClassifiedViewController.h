//
//  SCNClassifiedViewController.h
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//	分类浏览界面
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNClassifiedViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
	
	int				m_classLayer;

}
@property (nonatomic, strong) NSString                *m_title;              //导航条标题
@property (nonatomic, strong) NSNumber                *m_requsetID;          //请求id用于取消请求时的标识
@property (nonatomic, strong) NSMutableArray          *m_categorysArr;       //有多少类型的商品
@property (nonatomic, strong) NSString                *m_FatherId;           //请求的商品id
@property (nonatomic, strong) UITableView             *m_tableview;
@property (nonatomic, strong) NSMutableDictionary     *m_classIdNameDic;         //存放classId与className的字典
@property (nonatomic, assign) int m_classLayer;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil FatherId:(NSString *)fatherId Title:(NSString *)title;

-(void)setNormalNavigationItem;                     //设置导航条
-(void)requestGetCategoryListJSONData;              //请求数据

-(void)setNowClassifiedData:(int)_index classLayer:(int)_classLayer;

//页面跳转行为统计
-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;
@end
