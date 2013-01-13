//
//  SCNHelpData.h
//  SCN
//
//  Created by user on 11-10-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCNHelpData : YK_BaseData {
    NSString * mhelpId;
    NSString * mname;
    NSString * m_str_helpinfo;
}
@property (nonatomic, strong) NSString * mhelpId;
@property (nonatomic, strong) NSString * mname;
@property (nonatomic, strong) NSString * m_str_helpinfo;
@end
