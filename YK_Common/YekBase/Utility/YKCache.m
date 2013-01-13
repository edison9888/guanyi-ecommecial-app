//
//  YKCache.m
//  BANGGO
//
//  Created by yek on 10-12-22.
//  Copyright 2010 yek. All rights reserved.
//

#import "YKCache.h"

@interface YKCacheItem : NSObject<NSCoding>
{
	id object;
	id key;
	NSDate* expireDate;
}
@property(nonatomic,strong) id object;
@property(nonatomic,strong) id key;
@property(nonatomic,strong) NSDate* expireDate;

@end

@implementation YKCacheItem
@synthesize object;
@synthesize key;
@synthesize expireDate;

-(void) encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:key forKey:@"key"];
	[aCoder encodeObject:expireDate forKey:@"expireDate"];
	[aCoder encodeObject:object forKey:@"object"];
}
-(id) initWithCoder:(NSCoder *)aDecoder{
	if(self=[super init]){
		self.key=[aDecoder decodeObjectForKey:@"key"];
		self.expireDate=[aDecoder decodeObjectForKey:@"expireDate"];
		self.object=[aDecoder decodeObjectForKey:@"object"];
	}
	return self;
}

@end



@implementation YKMemoryCache

-(id) init{
	if(self=[super init]){
		//fileBasePath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"FileCache"];
	}
	return self;
}
-(void) setObject:(id <NSCoding>)object forKey:(id)key{
	[self setObject:object forKey:key expireDate:[NSDate distantFuture]];
}
-(void) setObject:(id <NSCoding>)object forKey:(id)key expireDate:(NSDate *)expireDate{
	assert(key!=nil);
	if(object==nil){
		[self removeObjectForKey:key];
	}else{
		YKCacheItem* item=[[YKCacheItem alloc] init];
		item.key=key;
		item.object=object;
		item.expireDate=expireDate;
		[dic setObject:item forKey:key];
	}
}

-(void) removeObjectForKey:(id)key{
	assert(key!=nil);
	[dic removeObjectForKey:key];
}

-(id) objectForKey:(id)key{
	assert(key!=nil);
	id ret=nil;
	YKCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSDate* nowDate=[NSDate date];
		if([nowDate compare:item.expireDate]==NSOrderedAscending){
			ret=item.object;
		}else{
			[self removeObjectForKey:key];
		}
	}
	return ret;
}


@end

@implementation YKFileCache
const NSString* YKFileCacheFileName=@"FileCache.dat";
const NSTimeInterval dicSaveInterval=10;
-(void) internalInit{
	if([[NSFileManager defaultManager] fileExistsAtPath:dicFilePath]){
		//dic=[[NSMutableDictionary dictionaryWithContentsOfFile:dicFilePath] retain];
		dic=[NSKeyedUnarchiver unarchiveObjectWithFile:dicFilePath];
	}else{
		dic=[[NSMutableDictionary alloc] init];
	}
	assert(dic!=nil);
	//NSLog(@"YKFileCache::internalInit dic=%@",dic);
	needSave=NO;
	saveTimer=[NSTimer scheduledTimerWithTimeInterval:dicSaveInterval target:self selector:@selector(save:) userInfo:nil repeats:YES];
}

-(void) save{
	assert(dicFilePath!=nil);
	//NSLog(@"YKFileCache::save enter... dicFilePath=%@\n dic=%@",dicFilePath,dic);
	//BOOL success=[dic writeToFile:dicFilePath atomically:YES];	
	//TODO:fix dic has nil object 
//	NSArray* keyArray=[dic allKeys];
//	NSMutableArray* toRemoveKeyArray=[[NSMutableArray alloc] init];
//	for(id key in keyArray){
//		if([dic objectForKey:key]==nil){
//			[toRemoveKeyArray addObject:key];
//		}
//	}
//	[dic removeObjectsForKeys:toRemoveKeyArray];
//	[toRemoveKeyArray release];
//	toRemoveKeyArray = nil;
//	BOOL success=[NSKeyedArchiver archiveRootObject:dic toFile:dicFilePath];
//	assert(success);
    
    //Modified by Junshuang on 2011.11.24, add|@synchronized(dic){}|
    @synchronized(dic) {
        // Modify by KangQiang:2011-08-15
        NSMutableArray *toRemoveKeyArray = [[NSMutableArray alloc] init];
        for ( id key in [dic allKeys] ) {
            if ( [dic objectForKey:key] == nil ){
                if (key != nil) {
                    [toRemoveKeyArray addObject:key];
                }
            }
        }
        [dic removeObjectsForKeys:toRemoveKeyArray];
        toRemoveKeyArray = nil;
        BOOL success = [NSKeyedArchiver archiveRootObject:dic toFile:dicFilePath];
        assert(success);
        if (!success)
        {
            return;
        }
    }//Junshuang end
}

-(void) save:(NSTimer*) timer{
	@autoreleasepool {
		if(needSave){
			[self save];
		}
		needSave=NO;
	}
}

-(id) init{
	if(self=[super init]){
		dicFilePath=documentFilePath((NSString*)YKFileCacheFileName);
		[self internalInit];
	}
	return self;
}

-(id) initWithFileName:(NSString*) fileName{
	if(self=[super init]){
		dicFilePath=documentFilePath(fileName);
		[self internalInit];
	}
	return self;
}

-(void) dealloc{
	[saveTimer invalidate];
	[self save];
}
/*
 return $(tempdir)/[yyyy]/[MM]/[dd]/[HH]/[mm]
 */
-(NSString*) getPath:(YKCacheItem*)item{
	NSDate* nowDate=[NSDate date];
	
	NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
	NSArray* formatterArray=@[@"yyyy",@"MM",@"dd",@"HH",@"mm"];
	NSString* ret=NSTemporaryDirectory();
	for(NSString* formatter in formatterArray){
		[dateFormatter setDateFormat:formatter];
		ret=[ret stringByAppendingPathComponent:[dateFormatter stringFromDate:nowDate]];
	}
	NSFileManager* fm=[NSFileManager defaultManager];
	if(![fm fileExistsAtPath:ret]){
		[fm createDirectoryAtPath:ret withIntermediateDirectories:YES attributes:nil error:nil];
	}
	ret=[ret stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.dat",[nowDate timeIntervalSince1970] ]];
	//NSLog(@"YKFileCache::getPath return %@",ret);
	assert(ret!=nil);
	return ret;
}
-(void) setObject:(id <NSCoding>)object forKey:(id)key{
	[self setObject:object forKey:key expireDate:[NSDate distantFuture]];
}

-(void) setObject:(id <NSCoding>)object forKey:(id)key expireDate:(NSDate *)expireDate{
	//NSLog(@"object is %@ , key is %@ expireData is %@",[object class], [key class], [expireDate class]);
    assert(key!=nil);
    if(object==nil){
        [self removeObjectForKey:key];
    }
    //Modified by Junshuang on 2011.11.24, add|@synchronized(dic){}|
    @synchronized(dic) {
        YKCacheItem* item=[dic objectForKey:key];
        if(nil==item){
            item=[[YKCacheItem alloc] init];
            item.key=key;
            item.object=[self getPath:key];
            item.expireDate=expireDate;
            [dic setObject:item forKey:key];
        }
        NSString* objectFilePath=(NSString*)item.object;
        assert(objectFilePath!=nil);
        [NSKeyedArchiver archiveRootObject:object toFile:objectFilePath];
        needSave=YES;
    }//Junshuang end
}

-(id) objectForKey:(id)key{
	assert(key!=nil);
	id ret=nil;
    //Modified by Junshuang on 2011.11.24, add|@synchronized(dic){}|
    @synchronized(dic) {
        YKCacheItem* item=[dic objectForKey:key];
        if(item!=nil){
            NSDate* nowDate=[NSDate date];
            if([nowDate compare:item.expireDate]==NSOrderedDescending){
                //过期
                [self removeObjectForKey:key];
            }else{
                NSString* objectFilePath=(NSString*)item.object;
                assert(objectFilePath!=nil);
                if([[NSFileManager defaultManager] fileExistsAtPath:objectFilePath]){
                    ret=[NSKeyedUnarchiver unarchiveObjectWithFile:objectFilePath];
                }
            }
        }
    }
	return ret;
}

-(void) removeObjectForKey:(id)key{
	assert(key!=nil);
    //Modified by Junshuang on 2011.11.24, add|@synchronized(dic){}|
    @synchronized(dic) {
        YKCacheItem* item=[dic objectForKey:key];
        if(item!=nil){
            NSString* objectFilePath=(NSString*)item.object;
            [[NSFileManager defaultManager] removeItemAtPath:objectFilePath error:nil];
            [dic removeObjectForKey:key];
        }
        needSave=YES;
    }
}

+(void) test{
	YKFileCache* cache=[[YKFileCache alloc] init];
	const NSString* oriString=@"fdsafdsafdsa fdsjaf dls辅导士大夫的萨芬大师傅d";
	const NSString* key=@"oriString";
	[cache setObject:(id<NSCoding>)oriString forKey:key];
	[cache save];
	NSString* newString=[cache objectForKey:key];
	if([oriString compare:newString]!=NSOrderedSame){
		NSLog(@"!!!error cache 可能工作不正常");		
	}
	NSLog(@"oriString=%@\n newString=%@",oriString,newString);
}

@end



NSString* documentFilePath(NSString* fileName){
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSLog(@"dataFilePath=%@",[documentsDirectory stringByAppendingPathComponent:fileName]);
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

