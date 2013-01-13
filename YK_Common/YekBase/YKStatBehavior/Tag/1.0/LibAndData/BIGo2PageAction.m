//
//  BIGo2PageAction.m
//  Moonbasa
//
//  Created by zhu zhi on 11-11-3.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "BIGo2PageAction.h"

@implementation BIGo2PageAction
@synthesize m_str_isSource;
@synthesize m_str_pageId;
@synthesize m_str_sel_param;
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
    m_str_isSource = nil;
    m_str_pageId = nil;
    m_str_sel_param = nil;
}
@end
