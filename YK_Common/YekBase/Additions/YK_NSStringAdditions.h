//
//  YK_NSStringAdditions.h
//  MoonbasaIpad
//
//  Created by fan wt on 11-9-16.
//  Copyright 2011年 Yek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YK_NSStringAdditions)

/*
 计算文字总数
 */
- (NSUInteger)count;
/**
    判断是否为空字符串。
 */
- (BOOL)isEmptyOrWhitespace;

/**
    去除两端空格。
 */
- (NSString*)stripWhiteSpace;

/**
 去除两端空格及换行。
 */
- (NSString*)stripWhiteSpaceAndNewLine;

/**
    计算md5hash
 */
- (NSString*)md5Hash;

/**
    计算sha1hash
 */
- (NSString*)sha1Hash;

/**
    获取当前时间，格式为yyyyMMddHHmmss
 */
+(NSString*)nowTimestamp;

/**
 根据指定的字体，和宽度计算字符串的高度
 @param font  使用的字体
 @param width 宽度
 */
-(CGFloat)getStringHightWithfont:(UIFont*)font width:(CGFloat)width;

@end

