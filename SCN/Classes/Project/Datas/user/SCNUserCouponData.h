//
//  SCNUserCouponData.h
//  SCN
//
//  Created by chenjie on 11-10-17.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNUserCouponData : YK_BaseData {
    NSString* mcouponId;
    NSString* mparvalue;
    NSString* mstatus;
    NSString* meffective;
}
@property (nonatomic, strong) NSString* mcouponId;
@property (nonatomic, strong) NSString* mparvalue;
@property (nonatomic, strong) NSString* mstatus;
@property (nonatomic, strong) NSString* meffective;

@end
