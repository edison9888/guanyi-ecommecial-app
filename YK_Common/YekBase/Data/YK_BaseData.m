//
//  YK_BaseData.m
//  m5173
//
//  Created by fan wt on 11-6-15.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YK_BaseData.h"

@implementation YK_BaseData

+(NSDictionary*)getStructsList{
    return nil;
}

/**
	根据XmlElement中的XmlNode填充相应的属性值。
	xmlNode的name对应该类中的mname属性, 例如: xmlNode的name为address, 则对应本类的属性为maddress。
	@param xmlElement Xml数据
	@returns 已填充了属性值的YK_BaseData实例化对象
 */
-(YK_BaseData*)parseFromGDataXMLElement:(GDataXMLElement*)xmlElement
{
	NSString* l_str_key;
	NSString* l_str_value;
	for(GDataXMLNode* childNode in [xmlElement attributes]){
		l_str_key = [NSString stringWithFormat:@"setM%@:",
					 [childNode name]];
		l_str_value = [childNode stringValue];
		if ([self respondsToSelector:NSSelectorFromString(l_str_key)])
		{
			[self performSelector:NSSelectorFromString(l_str_key) withObject:l_str_value];
		}
	}
	return self;
}

-(YK_BaseData*)parseStringValueFromGDataXmlElement:(GDataXMLElement*)xmlElement{
    NSString* l_str_key;
	NSString* l_str_value;
    for (GDataXMLElement* childEle in [xmlElement children]) {
        l_str_key = [NSString stringWithFormat:@"setM%@:",
					 [childEle name]];
		l_str_value = [childEle stringValue];
		if ([self respondsToSelector:NSSelectorFromString(l_str_key)])
		{
			[self performSelector:NSSelectorFromString(l_str_key) withObject:l_str_value];
		}
    }
    
    return self;
}

-(YK_BaseData*)parseAttriAndNodeFromXmlElement:(GDataXMLElement*)xmlElement
{
    [self parseFromGDataXMLElement:xmlElement];
    NSString* l_str_key;
	NSString* l_str_value;
    for (GDataXMLElement* childEle in [xmlElement children])
    {
        if ([[childEle attributes] count] > 0 || [[childEle children] count] > 1)
        {
            continue;
        }
        else
        {
            l_str_key = [NSString stringWithFormat:@"setM%@:", [childEle name]];
            l_str_value = [childEle stringValue];
            if ([self respondsToSelector:NSSelectorFromString(l_str_key)])
            {
                [self performSelector:NSSelectorFromString(l_str_key) withObject:l_str_value];
            }
        }
    }
    return self;
}

/**
	根据dict中的key填充相应的属性值。
	key 对应本类中的mkey属性, 例如: key为address, 则对应本类的属性为maddress。
	@param dict 数据字典
	@returns 已填充了属性值的YK_BaseData实例化对象
 */
-(YK_BaseData*)parseFromDictionary:(NSDictionary*)dict
{
	NSString* l_str_key;
	NSString* l_str_value;
	for(NSString* k in [dict allKeys]){
		l_str_key = [NSString stringWithFormat:@"setM%@:",
					 k];
		l_str_value = [dict objectForKey:k];
        if ([self respondsToSelector:NSSelectorFromString(l_str_key)])
		{
            [self performSelector:NSSelectorFromString(l_str_key)
                       withObject:l_str_value];
            
            NSString* object_key_name = [@"m" stringByAppendingString:k];
            id object_val   = [self valueForKey:object_key_name];
            
            if( object_val == NULL || object_val == nil || object_val == [NSNull null]){
                [self setValue:@"" forKey:object_key_name];
            }

        }
        
       	}
	return self;
}

+(NSArray*)easyParseFromGDataXMLElement:(GDataXMLElement*)xmlElement{
    NSDictionary* l_dict_struct = [[self class] getStructsList];
    NSString* l_str_class = [l_dict_struct objectForKey:@"Class"];
    Class l_class = NSClassFromString(l_str_class);
    NSString* l_str_cdatapath = [l_dict_struct objectForKey:@"CDATAName"];
    NSString* l_str_cdatavalue = [l_dict_struct objectForKey:@"CDATAValue"];
    if ([l_str_cdatavalue length]>0) {
        l_str_cdatavalue = [NSString stringWithFormat:@"set%@%@:", 
                            [[l_str_cdatavalue substringToIndex:1] uppercaseString],
                            [l_str_cdatavalue substringFromIndex:1]];
    }
    NSString* l_str_nodepath = [l_dict_struct objectForKey:@"NodePath"];

    // 断言: 类型是否为空
    assert(l_class!=nil);
    // 断言: cdatapath不能为空
    assert(l_str_cdatapath!=nil);
    // 断言: NodePath不能为空
    assert(l_str_nodepath!=nil);
    
    NSMutableArray* l_mutArray_nodes = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (GDataXMLElement* l_xmlEle in [xmlElement nodesForXPath:l_str_nodepath error:nil]) {
        // Step1: 创建一个Class的实例话对象
        id l_node = [[l_class alloc] init];
        // Step2: 解析node的属性
        [l_node parseFromGDataXMLElement:l_xmlEle];
        // Step3: 解析CDATA
        GDataXMLElement* l_xmlEle_CDATA = [[l_xmlEle elementsForName:l_str_cdatapath] objectAtIndex:0];
        if ([l_node respondsToSelector:NSSelectorFromString(l_str_cdatavalue)]){
            [l_node performSelector:NSSelectorFromString(l_str_cdatavalue) withObject:
             [l_xmlEle_CDATA stringValue]];
        }
        NSString* l_str_method;
        // Step4: 解析子节点, 添加到数组中
        for (NSString* l_str_key in [l_dict_struct allKeys]) {
            // 在本对象中查看l_str_key对象，假若是数组，则进入嵌套解析
            if ([l_node respondsToSelector:NSSelectorFromString(l_str_key)]) {
                id l_node_type = [l_node performSelector:NSSelectorFromString(l_str_key)];
                if ([[l_node_type class] isSubclassOfClass:[NSArray class]]) {
                    // 获取到值，该值是数组成员的类名
                    l_str_class = [l_dict_struct objectForKey:l_str_key];
                    l_class = NSClassFromString(l_str_class);
                    // 断言: 类型是否为空
                    assert(l_class!=nil);
                    
                    l_str_method = [NSString stringWithFormat:@"add%@:", l_str_key];
                    for (id l_id_childnode in [l_class easyParseFromGDataXMLElement:l_xmlEle]) {
                        if ([l_node respondsToSelector:NSSelectorFromString(l_str_method)])
                        {
                            [l_node performSelector:NSSelectorFromString(l_str_method) withObject:l_id_childnode];
                        }
                    }
                }
            }
        }
        
        [l_mutArray_nodes addObject:l_node];
    }
    return l_mutArray_nodes;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[[self class] clearCache];
}

@end
