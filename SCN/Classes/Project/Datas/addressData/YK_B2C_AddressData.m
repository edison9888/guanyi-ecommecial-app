//
//  YK_B2C_AddressData.m
//  YK_B2C
//
//  Created by yek yek on 5/4/11.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YK_B2C_AddressData.h"
#import <sqlite3.h>



@implementation YK_B2C_AddressData

@synthesize attributeDictionary;
@synthesize name;

-(id)init
{
	self = [super init];
	if (self) {
		attributeDictionary=[[NSMutableDictionary alloc] init];

	}
	
	return self;
}

-(void)dealloc
{
	[attributeDictionary removeAllObjects];
}


-(void) setObject:(id)value forKey:(NSString *)key{
	[attributeDictionary setValue:value forKey:key];
}
-(id) objectForKey:(NSString *)key{
	return [attributeDictionary objectForKey:key];
}

-(NSString *)addressId
{
	return [attributeDictionary objectForKey:@"addressid"];
}

-(NSString *)addressName
{
	return [attributeDictionary objectForKey:@"fullname"];
}


-(NSString *)addressProvince
{
	return [attributeDictionary objectForKey:@"province"];
}

-(NSString *)addressCity
{
	return [attributeDictionary objectForKey:@"city"];
}

-(NSString *)addressArea
{
	return [attributeDictionary objectForKey:@"area"];
}

-(NSString *)addressDetail
{
	return [attributeDictionary objectForKey:@"addressdetail"];
}


-(NSString *)addressPost
{
	return [attributeDictionary objectForKey:@"post"];
}


-(NSString *)addressPhone
{
	return [attributeDictionary objectForKey:@"phone"];
}


-(NSString *)addressMobile
{
	return [attributeDictionary objectForKey:@"mobile"];
}


-(void)setAddressId:(NSString *) aId
{
	[self setObject:aId forKey:@"addressid"];
}


-(void)setAddressName:(NSString *) aName
{
	[self setObject:aName forKey:@"fullname"];
}


-(void)setAddressProvince:(NSString *) aProvince
{
	[self setObject:aProvince forKey:@"province"];
}

-(void)setAddressCity:(NSString *) aCity
{
	[self setObject:aCity forKey:@"city"];
}

-(void)setAddressArea:(NSString *) aArea
{
	[self setObject:aArea forKey:@"area"];
}

-(void)setAddressDetail:(NSString *) aDetail
{
	[self setObject:aDetail forKey:@"addressdetail"];
}


-(void)setAddressPost:(NSString *) aPost
{
	[self setObject:aPost forKey:@"post"];
}


-(void)setAddressPhone:(NSString *) aPhone{
	[self setObject:aPhone forKey:@"phone"];
}


-(void)setAddressMobile:(NSString *) aMobile
{
	[self setObject:aMobile forKey:@"mobile"];
}

-(NSString *)addressProvinceId
{
	return [attributeDictionary objectForKey:@"provinceId"];
}

-(NSString *)addressCityId
{
	return [attributeDictionary objectForKey:@"cityId"];
}

-(NSString *)addressAreaId
{
	return [attributeDictionary objectForKey:@"areaId"];
}

-(NSString *) addressIsdefault
{
	return [attributeDictionary objectForKey:@"isdefault"];
}

-(void)setAddressProvinceId:(NSString *)aProvinceId
{
	
	[self setObject:aProvinceId forKey:@"provinceId"];
}

-(void)setAddressCityId:(NSString *) aCityId
{
	[self setObject:aCityId forKey:@"cityId"];
}

-(void)setAddressAreaId:(NSString *) aAreaId
{
	[self setObject:aAreaId forKey:@"areaId"];
}

-(void) setAddressIsdefault:(NSString *)aIsdefault
{
	[self setObject:aIsdefault forKey:@"isdefault"];
}


-(void) _parseFromXmlElement:(GDataXMLElement *)xmlElement{
	if(xmlElement==nil){return;}
	self.name=[[xmlElement name] copy];
	for(GDataXMLNode* childNode in [xmlElement attributes]){
		[self setObject:[childNode stringValue] forKey:[childNode name]];
	}
}
-(NSString *) description{
	return [self stringXmlElementName:[NSString stringWithFormat:@"%@",[self class]]];
}
+(YK_B2C_AddressData *) dataFromXmlElement:(GDataXMLElement *)xmlElement{
	YK_B2C_AddressData* data=[[YK_B2C_AddressData alloc] init];
	[data _parseFromXmlElement:xmlElement];
	return data;
}

-(NSString *) stringXmlElementName:(NSString*) eleName{
	assert(eleName!=nil);
	GDataXMLElement* element=[GDataXMLElement elementWithName:eleName];
	for(id key in [attributeDictionary allKeys]){
		NSString* _key=[key description];
		NSString* value=[[self objectForKey:key] description];
		GDataXMLNode* node=[GDataXMLNode attributeWithName:_key	stringValue:value];
		[element addAttribute:node];
	}
	NSString* ret=[element XMLString];
	assert(ret!=nil);
	NSLog(@"+(NSString *) stringXml:(YKBaseData *)data xmlElementName:(NSString*) eleName return %@",ret);
	return ret;
}


+(NSArray*)parseAddressListXml:(GDataXMLDocument*)xmlDoc
{
	assert(xmlDoc!=nil);
	
	NSMutableArray* ret=[NSMutableArray array];
	NSString* xpath=[NSString stringWithFormat:@"//addresslist//address"];
	NSArray* nodeArray = [xmlDoc nodesForXPath:xpath error:nil];
	for(GDataXMLElement* ele in nodeArray){
		YK_B2C_AddressData* l_product = [YK_B2C_AddressData addressFromXmlElement:ele];
		[ret addObject:l_product];	
	}
	return ret;
	
}

+(YK_B2C_AddressData*) addressFromXmlElement:(GDataXMLElement*) xmlElement
{
	YK_B2C_AddressData *ret=[[YK_B2C_AddressData alloc] init];
	[ret _parseFromXmlElement:xmlElement];
	return ret;
}

@end


@implementation YKCity
@synthesize  cityId;
@synthesize  name;
@synthesize  postal;

-(NSString *) description{
	return name;
}

-(void) dealloc{
	NSLog( @"city dealloced." );
}

-(BOOL) isEqual:(id)object{
	BOOL ret=NO;
	if(object!=nil && [object isKindOfClass:[self class]]){
		YKCity* c=(YKCity*) object;
		if([self.cityId isEqual:c.cityId]){
			ret=YES;
		}
	}
	return ret;
}

@end







