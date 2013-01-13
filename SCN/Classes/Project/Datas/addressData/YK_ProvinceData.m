//
//  ProvinceData.m
//  YK_Address
//
//  Created by fan wt on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "YK_ProvinceData.h"



@implementation YK_SystemAddressData
@synthesize mparentid;
@synthesize mid;
@synthesize mname;

DECLARE_PROPERTIES(
				   DECLARE_PROPERTY(@"mparentid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mid", @"@\"NSString\""),
				   DECLARE_PROPERTY(@"mname", @"@\"NSString\"")
				   )


- (NSString *)description{
	return mname;
}

-(NSString*)showMeYourName:(NSString*)name{
    if (name==nil) {
        return @"";
    }
    return @"00";
}

-(void)showArrayIndexOfRow:(int)row{

}

@end


#pragma mark -
#pragma mark ProvinceLoadOperation
@interface YK_ProvinceLoadOperation(PrivateMethod)
-(void)loadDataFromXml;
@end

@implementation YK_ProvinceLoadOperation

-(void)main{
	[self loadDataFromXml];
    
}

-(void)loadDataFromXml{
#if 0
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSError* error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ProvinceData" ofType:@"xml"];
	NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:fileContent options:1 error:&error];
	GDataXMLElement* _rootEle = [document rootElement];
	NSArray* _array_provinceData_ele = [_rootEle nodesForXPath:@"//home/province" error:nil];
	for (GDataXMLElement* _p_e in _array_provinceData_ele) {
		YK_SystemAddressData* _provinceData = [[YK_SystemAddressData alloc] init];
		[_provinceData parseFromGDataXMLElement:_p_e];
		[_provinceData save];
		NSLog(@"province: parentid: %@, id: %@, name: %@", _provinceData.mparentid, _provinceData.mid, _provinceData.mname);
		NSArray* _array_cityData_ele = [_p_e elementsForName:@"city"];
		for (GDataXMLElement* _c_e in _array_cityData_ele) {
			YK_SystemAddressData* _cityData = [[YK_SystemAddressData alloc] init];
			[_cityData parseFromGDataXMLElement:_c_e];
			_cityData.mparentid = _provinceData.mid;
			[_cityData save];
			NSLog(@"city: parentid: %@, id: %@, name: %@", _cityData.mparentid, _cityData.mid, _cityData.mname);
			NSArray* _array_areaData_ele = [_c_e elementsForName:@"area"];
			for (GDataXMLElement* _a_e in _array_areaData_ele) {
				YK_SystemAddressData* _areaData = [[YK_SystemAddressData alloc] init];
				[_areaData parseFromGDataXMLElement:_a_e];
				_areaData.mparentid = _cityData.mid;
				NSLog(@"area: parentid: %@, id: %@, name: %@", _areaData.mparentid, _areaData.mid, _areaData.mname);
				[_areaData save];
				[_areaData release];
			}
			
			[_cityData release];
		}
		[_provinceData release];
	}
	[document release];
	[pool release];
#endif
}

@end
