//
//  YK_UserUtility.h
//  m5173
//
//  Created by blackApple-1 on 11-7-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YK_UserData;

@interface YK_UserUtility : NSObject {

}
+(void)userParamFromDictionary:(NSDictionary*)dictionary;
+(void)setUserParam:(NSString*)param forKey:(NSString*)key;
+(NSString*)userParamForKey:(NSString*)key;
+(NSArray*)userAllKeyParams;
+(NSArray*)userAllParams;
@end
