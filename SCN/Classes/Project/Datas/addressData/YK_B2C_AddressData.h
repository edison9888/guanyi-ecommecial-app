//
//  YK_B2C_AddressData.h
//  YK_B2C
//
//  Created by yek yek on 5/4/11.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YK_BaseData.h"
#import "YK_B2C_CityPickerView.h"

@class YK_B2C_AddressData;
@class YKSqlCityPickerDataSource;

@protocol YK_B2C_AddressDataParse

+(YK_B2C_AddressData*) addressFromXmlElement:(GDataXMLElement*) xmlElement;

//+(NSArray*)getAddressListArray:(NSString*)_str;
//+(BOOL)saveAddressListArray:(NSArray*)addressArray filename:(NSString*)_str;

@end

@interface YK_B2C_AddressData : YK_BaseData<YK_B2C_AddressDataParse> {
	NSMutableDictionary* attributeDictionary;
	NSString* name;

}
@property (nonatomic,strong) NSMutableDictionary* attributeDictionary;
@property (nonatomic,strong) NSString* name;

-(void) setObject:(id)value forKey:(NSString *)key;
-(id) objectForKey:(NSString *)key;
+(NSArray*)parseAddressListXml:(GDataXMLDocument*)xmlDoc;

+(YK_B2C_AddressData*) dataFromXmlElement:(GDataXMLElement*) xmlElement;
/*
 生成xml，格式为
 <***eleName**** key1="value1" key2="value2" ... />
 */
-(NSString *) stringXmlElementName:(NSString*) eleName;

-(NSString *)addressId;
-(NSString *)addressName;
-(NSString *)addressProvince;
-(NSString *)addressCity;
-(NSString *)addressArea;
-(NSString *)addressDetail;
-(NSString *)addressPost;
-(NSString *)addressPhone;
-(NSString *)addressMobile;
-(NSString *)addressIsdefault;


-(void)setAddressId:(NSString *) aId;
-(void)setAddressName:(NSString *) aName;
-(void)setAddressProvince:(NSString *) aProvince;
-(void)setAddressCity:(NSString *) aCity;
-(void)setAddressArea:(NSString *) aArea;
-(void)setAddressDetail:(NSString *) aDetail;
-(void)setAddressPost:(NSString *) aPost;
-(void)setAddressPhone:(NSString *) aPhone;
-(void)setAddressMobile:(NSString *) aMobile;
-(void)setAddressProvinceId:(NSString *)aProvinceId;
-(void)setAddressAreaId:(NSString *) aAreaId;
-(void)setAddressCityId:(NSString *) aCityId;
-(void)setAddressPost:(NSString *) aPost;
-(void)setAddressIsdefault:(NSString *) aIsdefault;
@end





@interface YKCity : NSObject
{
	NSString *cityId;
	NSString *name;
	NSString *postal;
}

@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *postal;

@end


@protocol YKAddressSqlDataSource

-(id) initWithDbName:(NSString *)adbName;
+(YKSqlCityPickerDataSource *) cityPickerDataStorage;
-(NSArray *) loadCityArrayWithSql:(NSString*) sqlString;

@end



@interface YKSqlCityPickerDataSource : NSObject<YKCityPickerDataSource,YKAddressSqlDataSource>
{
	NSString* dbName;
}
@end

