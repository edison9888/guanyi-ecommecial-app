//
//  SCNUpdate.h
//  SCN
//
//  Created by xie xu on 11-10-24.
//  Copyright 2011年 yek. All rights reserved.
//

#import "YK_BaseData.h"

@interface SCNUpdate : YK_BaseData<UIAlertViewDelegate>

@property(nonatomic,strong)NSString *mprompt;       //升级提示文字
@property(nonatomic,strong)NSString *murl;          //软件下载地址
@property(nonatomic,strong)NSString *mforceUpdate;  //强制升级标志

-(void)requestUpdateData;


@end
