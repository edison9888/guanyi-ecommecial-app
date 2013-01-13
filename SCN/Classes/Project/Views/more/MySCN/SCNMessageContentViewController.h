//
//  SCNMessageContentViewController.h
//  SCN
//
//  Created by chenjie on 12-07-25.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBlock.h"
#import "BaseViewController.h"
#import "SCNMessageListData.h"
#import "YK_BaseData.h"

@interface SCNMessageContentViewController : BaseViewController {
                 
    
    BOOL                m_isRequesting;                      //判断是否正在请求 
    BOOL                m_isRequestsuccess;                  //判断是否请求成功
    
}
@property (nonatomic , strong)IBOutlet TextBlock    *m_textblock_content;  //装载消息阅读内容
@property (nonatomic , strong)NSMutableDictionary   *m_messagelist_data;    //装载消息数据模型

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil messagedata:(NSMutableDictionary *)messagedata; 

//请求阅读信息
-(void)requestMessageContent;

//解析信息阅读
-(void)onResponseMessageContent:(id)json_obj;

@end
