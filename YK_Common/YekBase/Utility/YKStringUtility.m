//
//  YKStringUtility.m
//  Moonbasa
//
//  Created by user on 11-7-8.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YKStringUtility.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#import "GTMBase64.h"


const NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
const NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$";
const NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";//(-(\\d{3,}))?$";
//const NSString* REG_PHONE = @"\\b(1)[358][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\\b";

@implementation YKStringUtility

/**
	安全获取字符串
	@param str 字符串
	@returns 若字符串为nil，则返回空字符串，否则直接返回字符串
 */
+(NSString*)strOrEmpty:(NSString*)str{
	return (str==nil?@"":str);
}





/**
	去掉首尾空格
	@param str 字符串
	@returns 去掉首尾空格的字符串
 */
+(NSString*)stripWhiteSpace:(NSString*)str{
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

/**
	去掉首尾空格和换行符
	@param str 字符串
	@returns 去掉首尾空格和换行符的字符串
 */
+(NSString*)stripWhiteSpaceAndNewLineCharacter:(NSString*)str{
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
} 

/**
	将字符串转换为MD5码
	@param str 字符串
	@returns 已转码为MD5的字符串
 */
+(NSString*)YKMD5:(NSString*)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [[NSString
			 stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1],
			 result[2], result[3],
			 result[4], result[5],
			 result[6], result[7],
			 result[8], result[9],
			 result[10], result[11],
			 result[12], result[13],
			 result[14], result[15]
			 ] lowercaseString];
}

+(BOOL)isEmail:(NSString *)input{
	return [input isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_EMAIL]];
}

+(BOOL)isPhoneNum:(NSString *)input{
	return [input isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_PHONE]];
}

+(BOOL)isMobileNum:(NSString *)input{
	return [input isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_MOBILE]];
}

+(CGFloat)getStringHight:(NSString*)input font:(UIFont*)font width:(CGFloat)width
{
    if (input == nil || font == nil || width <= 0) {
        return 0.0f;
    }
    
    CGSize s = CGSizeMake(width, 99999.0);
	CGSize size = [input sizeWithFont:font 
                           constrainedToSize:s
                               lineBreakMode:UILineBreakModeWordWrap];
    
	return size.height;
}

+(NSString*)encodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

@end
/*

 字符串是否没有内容 
 
*/
inline BOOL stringIsEmpty(NSString* str){
	BOOL ret=NO;
	if(str==nil){
		ret=YES;
	}else{
		NSString * temp=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if([temp length]<1){
			ret=YES;
		}
	}
	return ret;
}

inline NSString* strOrEmpty(NSString* str){
	return (str==nil?@"":str);
}


inline NSString* stripWhiteSpace(NSString *str){
	// 去掉首尾空格
	return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}



/*
 返回当前时间
*/
NSString* nowTimestamp(void){
	@autoreleasepool{
        NSString* format=@"yyyyMMddHHmmss";
        assert(format!=nil);
        NSDate* nowDate=[NSDate date];
        NSDateFormatter* dateFormater=[[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:format];
        [dateFormater stringFromDate:nowDate];
        NSString* timestamp=[[dateFormater stringFromDate:nowDate] copy];
        return timestamp;
    }
} 

NSString* YKMD5( NSString *str ) {
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [[NSString
			 stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			 result[0], result[1],
			 result[2], result[3],
			 result[4], result[5],
			 result[6], result[7],
			 result[8], result[9],
			 result[10], result[11],
			 result[12], result[13],
			 result[14], result[15]
			 ] lowercaseString];
}
