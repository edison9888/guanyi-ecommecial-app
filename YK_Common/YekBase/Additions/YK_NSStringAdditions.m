//
//  YK_NSStringAdditions.m
//  MoonbasaIpad
//
//  Created by fan wt on 11-9-16.
//  Copyright 2011年 Yek. All rights reserved.
//

#import "YK_NSStringAdditions.h"

#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YK_NSStringAdditions)

- (NSUInteger)count{
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray* words = [self componentsSeparatedByCharactersInSet:whiteSpace];
    return [words count];
}

- (BOOL)isEmptyOrWhitespace{
    // A nil or NULL string is not the same as an empty string
    return 0 == self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (NSString*)stripWhiteSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*)stripWhiteSpaceAndNewLine{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)md5Hash{
    const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (NSString*)sha1Hash{
    const char *cStr = [self UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

- (NSString*)encodeBase64
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString* base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString* base64Str = [NSString stringWithFormat:@"%@", base64String];
    return base64Str;
} 

+ (NSString*)nowTimestamp{
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

-(CGFloat)getStringHightWithfont:(UIFont*)font width:(CGFloat)width
{
    if ( font == nil || width <= 0) {
        return 0.0f;
    }
    
    CGSize s = CGSizeMake(width, 99999.0);
	CGSize size = [self sizeWithFont:font 
                    constrainedToSize:s
                        lineBreakMode:UILineBreakModeWordWrap];
    
	return size.height;
}

@end
