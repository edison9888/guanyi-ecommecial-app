//
//  ModalAlert.h
//  SCN
//
//  Created by yekmacminiserver on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModalAlert : NSObject {

}

+ (NSUInteger)queryWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton otherButton1:(NSString *)otherButton1;

+ (BOOL)confirm:(NSString *)title message:(NSString *)message;
+ (BOOL)ask:(NSString *)title message:(NSString *)message;
+ (void)showTip:(NSString *)title message:(NSString *)message;//只有确定按钮
+ (void)showTip:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton;
@end
