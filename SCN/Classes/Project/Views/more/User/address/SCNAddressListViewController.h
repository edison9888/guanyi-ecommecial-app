//
//  SCNAddressListViewController.h
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNAddressEditViewController.h"

enum ViewControllerFrom {
	DefaultViewTag=0,
	cashCenterTag =1,
	myAddressTag=2
	
};


@interface SCNAddressListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,YK_SCN_AddressEditDelegate> {
	UITableView* m_tableView;
	
	NSMutableArray* m_addressList;		//地址列表
	BOOL m_isRequesting;                //判断是否正在请求服务器
	NSString *defaultSelectedAddressId;//默认选择的地址id
	int currentViewFromTag;
}
@property(nonatomic,strong)IBOutlet UITableView* m_tableView;
@property(nonatomic,strong)NSMutableArray* m_addressList;
@property(nonatomic,copy)NSString *defaultSelectedAddressId;
@property (nonatomic)int currentViewFromTag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)requestAddressListXmlData;
-(void)onRequestAddressListXmlDataResponse:(GDataXMLDocument*)xmlDoc;
-(void)parseAddressListXmlDataResponse:(GDataXMLDocument*)xmlDoc;
-(void)setNormalNavigationItem;
-(void)addMyAddress:(UIButton*)_btn;

-(void)onReloadAddressList:(NSNotification*)_notification;
-(void)onSetDefaultAddress:(NSNotification*)_notification;

//页面跳转行为统计
//-(void)BehaviorPageJump;
-(NSString*)pageJumpParam;
-(void)behaviorSelectAddress:(addressData*)_addressData;
@end
