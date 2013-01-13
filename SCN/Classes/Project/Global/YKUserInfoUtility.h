//
//  YKUserInfoUtility.h
//  SCN
//
//  Created by user on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

#define K_YKUserInfoUtility [YKUserInfoUtility shareData]

@interface UserData : YK_BaseData {
    NSString* mname;
    NSString* muserid;
    NSString* muserstyle;
}
@property (nonatomic, retain) NSString* mname;
@property (nonatomic, retain) NSString* muserid;
@property (nonatomic, retain) NSString* muserstyle;
@end




@interface YKUserInfoUtility : NSObject {
    
}
+(YKUserInfoUtility*)shareData;
@end
