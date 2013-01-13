//
//  addressData.h
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"

@interface addressData : YK_BaseData {
	NSString* maddressId;
	NSString* mdefault;
	NSString* mconsignee;
	NSString* msex;
	NSString* maddressdetail;
	NSString* mprovince;
	NSString* mcity;
	NSString* marea;
	NSString* mprovinceId;
	NSString* mcityId;
	NSString* mareaId;
	NSString* mphone;
}
@property (nonatomic, strong) NSString* maddressId;
@property (nonatomic, strong) NSString* mdefault;
@property (nonatomic, strong) NSString* mconsignee;
@property (nonatomic, strong) NSString* msex;
@property (nonatomic, strong) NSString* maddressdetail;
@property (nonatomic, strong) NSString* mprovince;
@property (nonatomic, strong) NSString* mcity;
@property (nonatomic, strong) NSString* marea;
@property (nonatomic, strong) NSString* mprovinceId;
@property (nonatomic, strong) NSString* mcityId;
@property (nonatomic, strong) NSString* mareaId;
@property (nonatomic, strong) NSString* mphone;
@end
