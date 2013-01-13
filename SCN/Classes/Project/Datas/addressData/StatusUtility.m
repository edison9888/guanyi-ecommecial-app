//
//  StatusUtility.m
//  YK_Address
//
//  Created by fan wt on 11-9-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StatusUtility.h"
#import "YK_ProvinceData.h"

#define KCopyAddressDataSuccess @"CopyAddressDataSuccess"
//@interface UIFont (UIFontModifyFont)
//@end
//
//@implementation UIFont (UIFontModifyFont)
//+ (UIFont *)systemFontOfSize:(CGFloat)fontSize{
//	return [[self class] fontWithName:@"Helvetica" size:fontSize];
//}
//@end

@implementation StatusUtility

+(NSArray*)getSystemAddressData{
	return [YK_SystemAddressData allObjects];
}

+(NSArray*)SystemAddressDataWithParentId:(id)parentID{
	NSArray* _array_systemAddressData;
	if (parentID==nil) {
		_array_systemAddressData = [YK_SystemAddressData findByCriteria:@"WHERE mparentid is NULL"];
		
	}else {
		YK_SystemAddressData* parentCity=(YK_SystemAddressData*) parentID;
		NSString* provinceId=parentCity.mid;
		_array_systemAddressData = [YK_SystemAddressData findByCriteria:[NSString stringWithFormat:@"WHERE mparentid='%@'", provinceId]];
	}
	
	return _array_systemAddressData;
}

+(void)buildDBDataFile{
	[[self class] createEditableCopyOfDatabaseIfNeeded:@"scn.sqlite3" fromDBName:@"yk_address_tmp.sqlite3"];
}

+(void)createEditableCopyOfDatabaseIfNeeded :(NSString*) adbName fromDBName:(NSString*)fromDbName{
	@autoreleasepool {
    // First, test for existence.
	
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:adbName];
	if ([fileManager fileExistsAtPath:writableDBPath]) 
	{
		BOOL copysuccess = [[NSUserDefaults standardUserDefaults] boolForKey:KCopyAddressDataSuccess];
		if (copysuccess)
		{
			return;
		}
	}
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fromDbName];
	[fileManager removeItemAtPath:writableDBPath error:&error];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
		NSLog(@"\nfrom=%@,\nto=%@", defaultDBPath,writableDBPath );	
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
	}
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:KCopyAddressDataSuccess];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)loadAllSystemAddressData{
#if 0
	NSArray* _allProvinceData = [YK_SystemAddressData allObjects];
	if ([_allProvinceData count]==0) {
		NSOperationQueue* _queue = [[NSOperationQueue alloc] init];
		YK_ProvinceLoadOperation* _operation = [[YK_ProvinceLoadOperation alloc] init];
		[_queue addOperation:_operation];
		[_queue release];
		[_operation release];
	}
#endif
}

@end
