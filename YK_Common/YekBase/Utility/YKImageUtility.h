//
//  YK_MyImage.h
//  BANGGO
//
//  Created by yek on 10-11-18.
//  Copyright 2010 yek.com All rights reserved.
// 

#import <Foundation/Foundation.h>
/**
 * Convenience methods to help with resizing images retrieved from the 
 * ObjectiveFlickr library.
 */
@interface UIImage (UIImageUtility)

+ (UIImage*)imageFileNamed:(NSString*)name;

@end


@interface UIImage (OpenFlowExtras)

- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;

@end

@interface YKImageUtility : NSObject {

}
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

+(void) queueLoadImageFromUrl:(NSString*) url imageView:(UIImageView*) imageView;
+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param;

@end



