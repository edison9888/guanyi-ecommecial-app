//
//  PageConfig.h
//  Moonbasa
//
//  Created by zhu zhi on 11-11-3.
//  Copyright 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIGo2PageAction.h"
@interface PageConfig : NSObject{
    NSString *m_str_path;
    NSString *m_str_sel_go2Method;
    NSString *m_str_desc;
    BIGo2PageAction *m_biGo2PageAction;
}
@property (nonatomic,strong) NSString *m_str_path;
@property (nonatomic,strong) NSString *m_str_sel_go2Method;
@property (nonatomic,strong) NSString *m_str_desc;
@property (nonatomic,strong) BIGo2PageAction *m_biGo2PageAction;
@end
