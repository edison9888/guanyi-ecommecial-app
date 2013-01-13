//
//  NSObject+Verbose.m
//  GuanyiSoft-App
//
//  Created by gakaki on 7/7/12.
//  Copyright (c) 2012 GuanyiSoft. All rights reserved.
//

#import "NSObject+Verbose.h"

@implementation NSObject (Verbose)
- (NSString *)description {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        NSString *name = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:name];
        if (value != nil) {
            [dictionary setObject:value forKey:name];
        }
    }
    free(properties);
    return [dictionary description];
}
@end
