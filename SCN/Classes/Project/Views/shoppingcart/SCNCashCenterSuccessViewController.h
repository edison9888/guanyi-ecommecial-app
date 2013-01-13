//
//  SCNCashCenterSuccessViewController.h
//  SCN
//
//  Created by huangwei on 11-10-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNCashCenterSuccessHeadView : UIView
{
	UILabel* m_labHeadTitle;
}

@property(nonatomic,strong)IBOutlet UILabel* m_labHeadTitle;
-(id)initWithFrame:(CGRect)frame;
@end


@interface SCNCashCenterSuccessBtnsView : UIView
{
	UIButton* m_btnContinue;
	UIButton* m_btnViewOrder;
	UIButton* m_btnMobile;
}

@property(nonatomic,strong)IBOutlet UIButton* m_btnContinue;
@property(nonatomic,strong)IBOutlet UIButton* m_btnViewOrder;
@property(nonatomic,strong)IBOutlet UIButton* m_btnMobile;
-(id)initWithFrame:(CGRect)frame;
-(void)pressPhone:(id)sender;
@end


@interface SCNCashCenterSuccessViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
	UITableView* m_tableView;
	
	SCNCashCenterSuccessBtnsView* m_footerView;
	SCNCashCenterSuccessHeadView* m_headerView;
	
	NSString* m_orderId;
	NSString* m_payMoney;
	NSString* m_payType;
}
@property(nonatomic,strong)IBOutlet UITableView* m_tableView;
@property(nonatomic,strong)IBOutlet SCNCashCenterSuccessBtnsView* m_footerView;
@property(nonatomic,strong)IBOutlet SCNCashCenterSuccessHeadView* m_headerView;
@property(nonatomic,strong)NSString* m_orderId;
@property(nonatomic,strong)NSString* m_payMoney;
@property(nonatomic,strong)NSString* m_payType;

- (id)initWithNibName:(NSString *)nibNameOrNil withOrderId:(NSString*)_orderId withPayMoney:(NSString*)_payMoney withPayType:(NSString*)_payType bundle:(NSBundle *)nibBundleOrNil;

@end
