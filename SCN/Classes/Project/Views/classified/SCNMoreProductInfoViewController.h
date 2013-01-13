//
//  SCNMoreProductInfoViewController.h
//  SCN
//
//  Created by shihongqian on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//	更多商品信息
//
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNMoreProductInfoViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
    UITableView    *m_tableView;         
    NSMutableArray *m_infoArr;
    NSString       *m_productCode;//商品id
    NSString       *m_comment;//评论数
    NSString       *m_consult;//咨询数
}
@property (nonatomic, strong) NSString       *m_productCode; 
@property (nonatomic, strong) NSString       *m_comment;
@property (nonatomic, strong) NSString       *m_consult;
@property (nonatomic, strong) NSMutableArray *m_infoArr; 
@property (nonatomic, strong) UITableView *m_tableView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProductCode:(NSString *)productCode;
-(void)request_getProductDetailXmlData;
-(void)go2UserConsultationViewController;
@end
