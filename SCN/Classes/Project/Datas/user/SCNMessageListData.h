//
//  SCNMessageListData.h
//  SCN
//
//  Created by chenjie on 11-10-24.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNMessageListData : YK_BaseData {
    NSString* mmessageId;
    NSString* mtitle;
    NSString* mcreateTime;
    NSString* mname;
    NSString* mstatus;
    NSString* mcontent;

}
@property (nonatomic , strong) NSString* mmessageId;
@property (nonatomic , strong) NSString* mtitle;
@property (nonatomic , strong) NSString* mcreateTime;
@property (nonatomic , strong) NSString* mname;
@property (nonatomic , strong) NSString* mstatus;
@property (nonatomic , strong) NSString* mcontent;
@end
