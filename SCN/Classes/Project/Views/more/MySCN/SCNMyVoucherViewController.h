//
//  SCNMyVoucherViewController.h
//  SCN
//
//  Created by chenjie on 11-10-17.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//
//  我的优惠券
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNMyVoucherViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView  *m_tableview_voucher;
    
    NSMutableArray        *m_mutarray_usercoupon;            //优惠券数组
    BOOL                   m_isRequestsuccess;               //判断请求是否成功
    BOOL                   m_isRequesting;                   //判断是否在请求
}
@property (nonatomic, strong) NSMutableArray *m_mutarray_usercoupon;

-(void)onRequestmyvoucher;//请求我的优惠券

-(void)parsemyvoucher:(GDataXMLDocument*)xmlDoc;//XML解析
@end
