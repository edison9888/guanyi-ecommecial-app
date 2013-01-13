//
//  SCNProductFilterButton.m
//  SCN
//
//  Created by xie xu on 11-11-3.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNProductFilterButton.h"

@implementation SCNProductFilterButton
@synthesize m_filterItemData;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.layer.borderColor=[UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1].CGColor;
        self.backgroundColor=[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1];
        self.layer.borderWidth=1;
    }
    
    return self;
}
@end
