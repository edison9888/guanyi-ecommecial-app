//
//  YKBIConfigLoader.m
//  Moonbasa
//
//  Created by zhu zhi on 11-11-3.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YKGo2PageConfigLoader.h"
#import "PageConfig.h"
#import "BIGo2PageAction.h"

YKGo2PageConfigLoader *instance;
PageConfig *currentPageConfig;

@interface YKGo2PageConfigLoader(PrivateMethod)
-(PageConfig *)pageConfigWithPath:(NSString *)path;
@end

@implementation YKGo2PageConfigLoader
//@synthesize m_dict_pageParams;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        m_dict_pageParams = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}
+(YKGo2PageConfigLoader *)instance
{
    if (instance == nil) {
        instance = [[YKGo2PageConfigLoader alloc] init];
    }
    return instance;
}



-(BOOL)loadGo2PageConfig
{
    [m_dict_pageParams removeAllObjects];
	@autoreleasepool {
        NSXMLParser *xmlRead;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"YKGo2PageConfig" ofType:@"xml"];
        NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
        NSData *data = [file readDataToEndOfFile];//得到xml文件
        [file closeFile];
        xmlRead = [[NSXMLParser alloc] initWithData:data];//初始化NSXMLParser对象
        //[data release];
        [xmlRead setDelegate:self];//设置NSXMLParser对象的解析方法代理
        BOOL success = [xmlRead parse];//调用代理解析NSXMLParser对象，看解析是否成功
        return success;
    }
}

-(NSString *)getGo2PageSelectorStrWithPath:(NSString *)path
{
    NSString *result;
    PageConfig *l_pageConfig = [self pageConfigWithPath:path];
    if (l_pageConfig == nil) {
        result = nil;
    }
    else
    {
        result = l_pageConfig.m_str_sel_go2Method;
    }
    return result;
}
-(NSString *)getBIIsSourceWithPath:(NSString *)path
{
    NSString *result;
    PageConfig *l_pageConfig = [self pageConfigWithPath:path];
    if (l_pageConfig == nil) {
        result = nil;
    }
    else
    {
        result = l_pageConfig.m_biGo2PageAction.m_str_isSource;
    }
    return result;
}
-(NSString *)getBIPageIdWithPath:(NSString *)path
{
    NSString *result;
    PageConfig *l_pageConfig = [self pageConfigWithPath:path];
    if (l_pageConfig == nil) {
        result = nil;
    }
    else
    {
        result = l_pageConfig.m_biGo2PageAction.m_str_pageId;
    }
    return result;
}
-(NSString *)getBIParamSelectorStrWithPath:(NSString *)path
{
    NSString *result;
    PageConfig *l_pageConfig = [self pageConfigWithPath:path];
    if (l_pageConfig == nil) {
        result = nil;
    }
    else
    {
        result = l_pageConfig.m_biGo2PageAction.m_str_sel_param;
    }
    return result;
}
-(PageConfig *)pageConfigWithPath:(NSString *)path
{
    return [m_dict_pageParams objectForKey:path];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"Page"]) {
        if ([attributeDict objectForKey:@"path"] != nil) {
            PageConfig *l_pageConfig = [[PageConfig alloc] init];
            l_pageConfig.m_str_path = [attributeDict objectForKey:@"path"];
            l_pageConfig.m_str_sel_go2Method = [attributeDict objectForKey:@"sel_go2Method"];
            l_pageConfig.m_str_desc = [attributeDict objectForKey:@"desc"];
            [m_dict_pageParams setObject:l_pageConfig forKey:l_pageConfig.m_str_path];
            currentPageConfig = l_pageConfig;
        }
    }
    else if([elementName isEqualToString:@"BIGo2PageAction"])
    {
        if (currentPageConfig != nil) {
            BIGo2PageAction *l_biGo2PageAction = [[BIGo2PageAction alloc] init];
            l_biGo2PageAction.m_str_isSource = [attributeDict objectForKey:@"isSource"];
            l_biGo2PageAction.m_str_pageId = [attributeDict objectForKey:@"pageId"];
            l_biGo2PageAction.m_str_sel_param = [attributeDict objectForKey:@"sel_param"];
            currentPageConfig.m_biGo2PageAction = l_biGo2PageAction;
        }
    }
}
@end
