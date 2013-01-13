//
//  NSString+SHAAddition.h
//  UIDeviceAddition
//
//  Created by deVbug on 2011.08.25
//  Copyright 2011 deVbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(SHAAddition)

- (NSString *)stringFromSHA1;
- (NSString *)stringFromSHA224;
- (NSString *)stringFromSHA256;
- (NSString *)stringFromSHA384;
- (NSString *)stringFromSHA512;

@end
