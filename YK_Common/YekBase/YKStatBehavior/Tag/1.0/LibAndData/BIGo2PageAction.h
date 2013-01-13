//
//  BIGo2PageAction.h
//  Moonbasa
//
//  Created by zhu zhi on 11-11-3.
//  Copyright 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIGo2PageAction : NSObject{
    NSString *m_str_isSource;
    NSString *m_str_pageId;
    NSString *m_str_sel_param;
}
@property (nonatomic,strong) NSString *m_str_isSource;
@property (nonatomic,strong) NSString *m_str_pageId;
@property (nonatomic,strong) NSString *m_str_sel_param;
@end
