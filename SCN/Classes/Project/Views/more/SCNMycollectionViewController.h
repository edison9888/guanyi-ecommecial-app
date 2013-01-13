//
//  SCNMycollectionViewController.h
//  SCN
//
//  Created by chenjie on 12-07-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
//  我的收藏控制器
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNMyCollectionData.h"


@interface SCNMycollectionViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{

   
    BOOL                           m_isRequesting;                //判断是否正在请求服务器
    BOOL                           m_isRequestsuccess;            //判断是否请求服务器成功
    BOOL                           m_isDeletesuccess;
    
    int                            m_int_page;
    int                            m_int_totalpage;
    
    NSIndexPath                   *m_currIndexpath;
    
}
@property (nonatomic, strong) UITableView* m_collectionTableView;    //表
@property (nonatomic, strong) NSIndexPath* m_currIndexpath;
@property (nonatomic, strong) NSMutableArray *m_mutarray_productlist;   //装载流程所有商品信息
@property (nonatomic, strong) UIButton  *m_rightbutton;              //导航栏右边按钮
@property (nonatomic, strong) SCNMyCollectionPageinfoData *m_pageinfodata;
@property (nonatomic, strong) NSNumber *m_number_requestID;

//请求收藏夹列表
-(void)requestFavorites:(int)currentpage;
-(void)onResponseFavorites:(id)json_obj;

//请求删除收藏夹列表
-(void)requestDeleteFavorite:(NSString *)productCode;
-(void)onResponseDeleteFavorite:(id)json_obj;

//add 注册监听
-(void)NotifyddnewCollection:(NSNotification *)notify;

//重置数据
-(void)resetDataSource;

//添加编辑按钮
-(void)addNavigationbuttonOfEdit;
@end
