//
//  SCN_SystemAddressData.h
//  SCN
//
//  Created by user on 11-10-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface SCN_SystemAddressData : YK_BaseData {
    NSString* mparentid;
	NSString* mid;
	NSString* mname;
}
@property (nonatomic, strong) NSString* mparentid;
@property (nonatomic, strong) NSString* mid;
@property (nonatomic, strong) NSString* mname;
@end
