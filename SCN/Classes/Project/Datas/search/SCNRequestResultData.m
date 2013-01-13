//
//  SCNRequestResultData.m
//  SCN
//
//  Created by xie xu on 11-10-19.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNRequestResultData.h"

@implementation SCNRequestResultData

- (id)init
{
    self = [super init];
    if (self) {
       
    }
    
    return self;
}
-(BOOL)isSuccess{
	return [self.mresult isEqualToString:@"SUCCESS"];
}
@end
