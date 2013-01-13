//
//  BaseDataDemoAppDelegate.h
//  BaseDataDemo
//
//  Created by wtfan on 11-11-10.
//  Copyright 2011年 Yek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseDataDemoViewController;

@interface BaseDataDemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BaseDataDemoViewController *viewController;

@end
