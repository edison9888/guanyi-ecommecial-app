//
//  SCNProductButton.m
//  SCN
//
//  Created by xie xu on 11-10-18.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNProductButton.h"

@implementation SCNProductButton
@synthesize productCode;
@synthesize sku;
@synthesize imagePath;
@synthesize productTag;
@synthesize pstatus;
@synthesize isSecEnd;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@end
