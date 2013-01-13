//
//  NSString+NSString.m
//  GuanyiSoft-App
//
//  Created by gakaki on 12-5-28.
//  Copyright (c) 2012年 GuanyiSoft. All rights reserved.
//

#import "NSString+NSString.h"

@implementation NSString (NSString)

- (BOOL)isEmptyOrNil {
    return self == nil || [@"" isEqualToString:self] || [self isKindOfClass:[NSNull class]];
}

@end
