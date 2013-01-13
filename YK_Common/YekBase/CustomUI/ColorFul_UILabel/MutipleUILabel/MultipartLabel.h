//
//  MultipartLabel.h
//  YMW
//
//  Created by user on 11-11-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultipartLabel : UIView {
}

@property (nonatomic,retain) UIView *containerView;
@property (nonatomic,retain) NSMutableArray *labels;
@property (nonatomic) UIViewContentMode contentMode;

- (void)updateNumberOfLabels:(int)numLabels;
- (void)setText:(NSString *)text forLabel:(int)labelNum;
- (void)setText:(NSString *)text andFont:(UIFont*)font forLabel:(int)labelNum;
- (void)setText:(NSString *)text andColor:(UIColor*)color forLabel:(int)labelNum;
- (void)setText:(NSString *)text andFont:(UIFont*)font andColor:(UIColor*)color forLabel:(int)labelNum;

@end
