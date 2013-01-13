//
//  PageConfig.m
//  Moonbasa
//
//  Created by zhu zhi on 11-11-3.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "PageConfig.h"

@implementation PageConfig
@synthesize m_str_path;
@synthesize m_str_sel_go2Method;
@synthesize m_str_desc;
@synthesize m_biGo2PageAction;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(void)dealloc
{
    m_str_path = nil;
    m_str_sel_go2Method = nil;
    m_str_desc = nil;
    m_biGo2PageAction = nil;
}
@end
