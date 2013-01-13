//
//  HJImageUtility.h
//  Moonbasa
//
//  Created by zwh on 11-7-26.
//  Copyright 2011 yek.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJManagedImageV.h"


@interface HJImageUtility : NSObject

static void addRoundedRectToPath(CGContextRef context, CGRect rect, 
								 float ovalWidth,float ovalHeight) ;
- (UIImage *) roundCorners: (UIImage*) img;
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage ;
+(UIImageView *) getUIImageView:(UIImage *)img;
+(UIImage *)getUIImage:(NSString *) filePath;
+(UIImage *)getUIImage_releaseVersion:(NSString *) filePath;
+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toEllipseInRect:(CGRect)rect;//按椭圆切图
/*
 从网址中加载图片，会阻塞
 */
+(UIImage*) imageFromUrl:(NSString*) url;

+(void) queueLoadImageFromUrl:(NSString*) url imageView:(HJManagedImageV*) imageView;
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param;

@end
