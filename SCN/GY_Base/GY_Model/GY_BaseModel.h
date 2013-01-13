//
//  GY_BaseModel.h
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-29.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "SQLitePersistentObject.h"

@interface GY_BaseModel : SQLitePersistentObject

#define DECLARE_STRUCTS(sd) + (NSDictionary *)getStructsList \
{ \
return (NSDictionary*)[sd JSONValue]; \
}

/**
 返回该类的结构
 */
+(NSDictionary*)getStructsList;

/**
 根据json中的key value填充相应的属性值。
 json的name对应该类中的mname属性, 例如: json的name为address, 则对应本类的属性为maddress。
 @param json 的data 数据
 @returns 已填充了属性值的GY_BaseModel 实例化对象
 */
-(GY_BaseModel*)parseFromJSON:(id)json_data;


+(NSMutableArray*)parseDataArrayFromJSON:(id)json_data;


/**
 根据XmlElement中的StringValue填充相应的属性值。
 XmlElement的name对应该类中的mname属性, 例如: XmlElement的name为address, 则对应本类的属性为maddress。
 @param xmlElement Xml数据
 @returns 已填充了属性值的YK_BaseData实例化对象
 */
-(GY_BaseModel*)parseStringValueFromGDataXmlElement:(id)json_data;
/**
 解析属性和单结点。
 XmlElement的name对应该类中的mname属性, 例如: XmlElement的name为address, 则对应本类的属性为maddress。
 @param xmlElement Xml数据
 @returns 已填充了属性值的YK_BaseData实例化对象
 */
-(GY_BaseModel*)parseAttriAndNodeFromXmlElement:(id)json_data;
/**
 根据dict中的key填充相应的属性值。
 key 对应本类中的mkey属性, 例如: key为address, 则对应本类的属性为maddress。
 @param dict 数据字典
 @returns 已填充了属性值的YK_BaseData实例化对象
 */
-(GY_BaseModel*)parseFromDictionary:(NSDictionary*)dict;

/**
 {
 Class: Class
 NodePath: "//nodepath"
 CDATAName: "mdatavalue"
 CDATAValue: "mdataname"
 数组字段: 数组成员类名
 }
 嵌套解析方法。根据配置信息自动完成属性及嵌套解析。
 @param xmlElement Xml数据
 @returns 已填充了属性值的YK_BaseData实例化对象
 */
+(NSArray*)easyParseFromGDataXMLElement:(id)xmlElement;


@end
