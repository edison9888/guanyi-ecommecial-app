//
//  YKBIConfigLoader.h
//  Moonbasa
//
//  Created by zhu zhi on 11-11-3.
//  Copyright 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PageConfig;
@interface YKGo2PageConfigLoader : NSObject<NSXMLParserDelegate>
{
    NSMutableDictionary *m_dict_pageParams;
}

+(YKGo2PageConfigLoader *)instance;

-(BOOL)loadGo2PageConfig;

-(NSString *)getGo2PageSelectorStrWithPath:(NSString *)path;

-(NSString *)getBIIsSourceWithPath:(NSString *)path;
-(NSString *)getBIPageIdWithPath:(NSString *)path;
-(NSString *)getBIParamSelectorStrWithPath:(NSString *)path;
@end
