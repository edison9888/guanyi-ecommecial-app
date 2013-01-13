//
//  YK_MyImage.m
//  BANGGO
//
//  Created by yek on 10-11-18.
//  Copyright 2010 yek.com All rights reserved.
//

#import "YKImageUtility.h"
#import "YKCache.h"

#pragma mark YKImageLoadOperation

@class YKImageLoadOperation;

@protocol YImageLoadOperationDelegate<NSObject>
/*
 图片加载完成
 */
-(void) imageLoadOperation:(YKImageLoadOperation*) imageLoadOperation loadedImage:(UIImage*) image url:(NSString*) url ;
@end

@interface YKImageLoadOperation : NSOperation
{
	NSString* url;
	id<YImageLoadOperationDelegate> delegate;
}
-(id) initWithImageUrl:(NSString*) aurl  delegate:(id<YImageLoadOperationDelegate>) adelegate;

@end

/*
 //TODO:添加缓存移除策略
 */
@implementation YKImageLoadOperation

const int CACHE_CAPACITY=50;
const BOOL CACHE_ENABLE=YES;
NSMutableDictionary* cache;
+(void) initialize{
	if(CACHE_ENABLE){
		assert(CACHE_CAPACITY>0);
		cache=[[NSMutableDictionary alloc] initWithCapacity:CACHE_CAPACITY];
	}
}

-(id) initWithImageUrl:(NSString*) aurl  delegate:(id<YImageLoadOperationDelegate>) adelegate{
	//assert(aurl!=nil);
	if( aurl == nil ){
		return nil;
	}
	
	if(self=[super init]){
		url=aurl;
		delegate=adelegate;
	}
	return self;
}

-(void) performDelegateMethod:(id) sender{
	UIImage* image=(UIImage*) sender;
	[delegate imageLoadOperation:self loadedImage:image url:url ];
}
-(void) main{
	@autoreleasepool {
		UIImage* image=nil;
    //modified by Junshuang on 2011.11.24, add |synchronized(cache)|
    @synchronized(cache) {
        if(CACHE_ENABLE){
            image=(UIImage*)[cache objectForKey:url];
        }
    }//Junshuang end
		if(image==nil){
			image = [YKImageUtility imageFromUrl:url];
			if(image != nil && CACHE_ENABLE)
			{
				@synchronized(cache)
				{
					if([cache count]>CACHE_CAPACITY)
					{
						[cache removeObjectForKey:[[cache allKeys] objectAtIndex:0]];
					}
					
					
					[cache setObject:image forKey:url];
					
				}
			}
		}
		if(delegate!=nil){
			//[delegate imageLoadOperation:self loadedImage:image url:url ];
			[self performSelectorOnMainThread:@selector(performDelegateMethod:) withObject:image waitUntilDone:NO];
		}
	}
}

@end


#pragma mark YKImageLoadOperationHandler
@interface YKImageLoadOperationHandler : NSObject<YImageLoadOperationDelegate>
{
	id object;
	SEL action;
	id param;
}
/*
 action:
 (void) *****:(UIImage*) image url:(NSString*) url;
 */
-(id) initWithObject:(id) aobject action:(SEL)aaction param:(id) aparam;
@end

@implementation YKImageLoadOperationHandler


NSTimeInterval startTime;
-(id) initWithObject:(id)aobject action:(SEL)aaction param:(id) aparam{
	if(self=[super init]){
		startTime=[[NSDate date] timeIntervalSince1970];
		object=aobject;
		action=aaction;
		param=aparam;
	}
	return self;
}

-(void) imageLoadOperation:(YKImageLoadOperation *)imageLoadOperation loadedImage:(UIImage *)image url:(NSString *)url{
	[object performSelector:action withObject:image withObject:param];
	//NSTimeInterval endTime=[[NSDate date] timeIntervalSince1970];
	//NSLog(@"%@ timespan %f startTime:%f endTime:%f",[self class],endTime-startTime,startTime, endTime);
}


@end

#pragma mark YKImageLoadOperationHandlerSetImage
@interface YKImageLoadOperationHandlerSetImage : NSObject
{
	UIImageView* imageView;
	UIActivityIndicatorView* indicatorView;
}
-(id) initWithImageView:(UIImageView*) aimageView;
-(void) onLoadedImage:(UIImage*) image url:(NSString*) url;

@end

@implementation YKImageLoadOperationHandlerSetImage

-(void) showIndicator:(id) obj{
	//return;
	indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	indicatorView.frame=CGRectMake(0, 0, 20, 20);
	
	/*NSLog( @"indicatorView:Frame %f %f %f %f imageView:frame %f %f %f %f", indicatorView.frame.origin.x, indicatorView.frame.origin.y,
		  indicatorView.frame.size.width, indicatorView.frame.size.height,
		  imageView.frame.origin.x, imageView.frame.origin.y,
		  imageView.frame.size.width, imageView.frame.size.height );*/
	[imageView addSubview:indicatorView];
	
	indicatorView.frame = CGRectMake( imageView.frame.size.width/2 - indicatorView.frame.size.width/2, imageView.frame.size.height/2 - indicatorView.frame.size.height/2, indicatorView.frame.size.width, indicatorView.frame.size.height );
	
	/*NSLog( @"indicatorView:Frame %f %f %f %f imageView:frame %f %f %f %f", indicatorView.frame.origin.x, indicatorView.frame.origin.y,
		  indicatorView.frame.size.width, indicatorView.frame.size.height,
		  imageView.frame.origin.x, imageView.frame.origin.y,
		  imageView.frame.size.width, imageView.frame.size.height );*/
	
	
	[indicatorView startAnimating];
	//imageView.backgroundColor=[UIColor redColor];
}
-(void) hideIndicator:(id) obj{
	//return;
	//NSLog(@"%@ :: -(void) onLoadedImage:(UIImage *)image url:(NSString *)url enter...",[self class] );
	[indicatorView stopAnimating];
	[indicatorView removeFromSuperview];
	indicatorView=nil;
}

-(id) initWithImageView:(UIImageView *)aimageView{
	if(self=[super init]){
		imageView=aimageView;
		[self performSelectorOnMainThread:@selector(showIndicator:) withObject:nil waitUntilDone:NO];
	}
	return self;
}

-(void) onLoadedImage:(UIImage *)image url:(NSString *)url{
	[self hideIndicator:nil];
	
	if( image == nil ){
		return;
		image=[UIImage imageNamed:@"home_cover_default.jpg"];
	}
	
	[imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
	//[imageView setImage:image];
}

-(void) dealloc{
	[self hideIndicator:nil];
}

@end





@implementation YKImageUtility
#pragma mark ======================image tool======================
static void addRoundedRectToPath(CGContextRef context, CGRect rect, 
								 float ovalWidth,float ovalHeight) 
{ 
	float fw, fh; 
	if (ovalWidth == 0 || ovalHeight == 0) { 
		CGContextAddRect(context, rect); 
		return; 
	} 
	
	CGContextSaveGState(context); 
	CGContextTranslateCTM (context, CGRectGetMinX(rect), 
						   CGRectGetMinY(rect)); 
	CGContextScaleCTM (context, ovalWidth, ovalHeight); 
	fw = CGRectGetWidth (rect) / ovalWidth;
	fh = CGRectGetHeight (rect) / ovalHeight; 
	CGContextMoveToPoint(context, fw, fh/2); 
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); 
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); 
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); 
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); 
	CGContextClosePath(context); 
	CGContextRestoreGState(context); 
} 

- (UIImage *) roundCorners: (UIImage*) img
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, 100, 100);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	UIImage *retImage = [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
    return retImage;
}
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
	
	CGImageRef maskRef = maskImage.CGImage; 
	
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
	return [UIImage imageWithCGImage:masked];
	
}
+(UIImageView *) getUIImageView:(UIImage *)img
{
	UIImageView *tmpView = [ [UIImageView alloc] initWithImage:img];
	return tmpView;
}
+(UIImage *)getUIImage:(NSString *) filePath
{
	UIImage *tmp_img = [UIImage imageNamed:filePath];
	
	if(tmp_img)
	{
		//NSLog(@"--->Image normal version %@ is loaded",filePath);
	}
	else
		NSLog(@"Image %@ load failed",filePath);
	return tmp_img;
}
+(UIImage *)getUIImage_releaseVersion:(NSString *) filePath
{
	UIImage *tmp_img  =[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath],filePath]];
	if(tmp_img)
	{
		//
		//NSLog(@"===>Image release version%@ is loaded",filePath);
	}
	else
			NSLog(@"Image %@ load failed",filePath);
	return tmp_img;
}

+ (UIImage*)imageByCropping:(UIImage *)imageToCrop toEllipseInRect:(CGRect)rect
{
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGMutablePathRef path = CGPathCreateMutable();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGPathAddEllipseInRect(path, NULL, clippedRect);
    CGContextAddPath(currentContext, path);
    CGContextClip(currentContext);
    CGPathRelease(path);
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y,
								 imageToCrop.size.width,
								 imageToCrop.size.height);
	
	//Quartz 2d uses a different co-ordinate system, where the origin is in the lower left corner.
	//The x co-ordinate system matches, so you will need to flip the y co-ordinates.
	CGContextTranslateCTM(currentContext, 0, imageToCrop.size.height);
	CGContextScaleCTM(currentContext, 1.0, -1.0);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}

static YKFileCache* fileCache;
//同步加载方式
+(UIImage*) imageFromUrl:(NSString *)url
{
	if ( url == nil ) 
	{
		NSLog( @"url is NULL string." );
		return nil;
	}
	
	@autoreleasepool{
                
            UIImage* ret = nil;
            NSData* data = [fileCache objectForKey:url];
            if( data != nil )
            {
                ret = [UIImage imageWithData:data];
                if( ret != nil)
                {
                    return ret;
                }
            }
            
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if(data!=nil)
            {
                ret = [UIImage imageWithData:data];//[UIImage imageNamed:@"home_cover_default.jpg"];
                NSLog(@"ret.size(%f,%f)",ret.size.width,ret.size.height);
            }
            
            
            if(ret == nil)
            {
                NSLog(@"*************************************************************");
                NSLog(@"**NO image data from imageUrl:(NSString *)url=%@;return nil**", url);
                NSLog(@"*************************************************************");
                return nil;
            }
            else
            {
                [fileCache setObject:data forKey:url expireDate:[[NSDate date] dateByAddingTimeInterval:60*60*24*7 ] ];
                return ret;
            }
        
        }
}

//static NSMutableArray* queueOperation;
static NSOperationQueue* queue;
+(void) initialize{
	//queueOperation=[[NSMutableArray alloc] init];
	queue=[[NSOperationQueue alloc] init];
	fileCache=[[YKFileCache  alloc] initWithFileName:@"imageFileCache.dat"];
}

+(void) queueLoadImageFromUrl:(NSString *)url imageView:(UIImageView *)imageView{
	@autoreleasepool {
		YKImageLoadOperationHandlerSetImage* setImageHandler=[[YKImageLoadOperationHandlerSetImage alloc] initWithImageView:imageView];
		[YKImageUtility queueLoadImageFromUrl:url object:setImageHandler action:@selector(onLoadedImage:url:) param:nil];
	}
}

+(void) queueLoadImageFromUrl:(NSString *)url object:(id) object action:(SEL) action  param:(id)param{
	@autoreleasepool {
		YKImageLoadOperationHandler* handler=[[YKImageLoadOperationHandler alloc] initWithObject:object action:action param:param];
		YKImageLoadOperation* operation=[[YKImageLoadOperation alloc] initWithImageUrl:url delegate:handler];
		[queue performSelectorInBackground:@selector(addOperation:) withObject:operation];
		//[queueOperation addObject:queueOperation];
		//[queue addOperation:operation];
	}
}

@end


@implementation UIImage (OpenFlowExtras)

- (UIImage *)rescaleImageToSize:(CGSize)size {
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

- (UIImage *)cropImageToRect:(CGRect)cropRect {
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox {
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize {
	UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}

@end

@implementation UIImage (UIImageUtility)

+ (UIImage*)imageFileNamed:(NSString*)name{
	return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name]];
}

@end


