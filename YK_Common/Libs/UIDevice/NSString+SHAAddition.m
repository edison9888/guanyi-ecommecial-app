//
//  NSString+SHAAddition.m
//  UIDeviceAddition
//
//  Created by deVbug on 2011.08.25
//  Copyright 2011 deVbug. All rights reserved.
//

#import "NSString+SHAAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(SHAAddition)

- (NSString *)stringFromSHA:(unsigned char *(const void *, CC_LONG, unsigned char *))cryptfunc digestlen:(int)digestlen {
	if(self == nil || [self length] == 0)
        return nil;
	
	if (cryptfunc == NULL) return nil;
	
	if (digestlen != CC_SHA1_DIGEST_LENGTH && 
		digestlen != CC_SHA224_DIGEST_LENGTH && 
		digestlen != CC_SHA256_DIGEST_LENGTH && 
		digestlen != CC_SHA384_DIGEST_LENGTH && 
		digestlen != CC_SHA512_DIGEST_LENGTH)
		return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[digestlen];
    cryptfunc(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:digestlen * 2];
    for(NSInteger count = 0; count < digestlen; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)stringFromSHA1 {
	return [self stringFromSHA:CC_SHA1 digestlen:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)stringFromSHA224 {
	return [self stringFromSHA:CC_SHA224 digestlen:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)stringFromSHA256 {
	return [self stringFromSHA:CC_SHA256 digestlen:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)stringFromSHA384 {
	return [self stringFromSHA:CC_SHA384 digestlen:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)stringFromSHA512 {
	return [self stringFromSHA:CC_SHA512 digestlen:CC_SHA512_DIGEST_LENGTH];
}

@end
