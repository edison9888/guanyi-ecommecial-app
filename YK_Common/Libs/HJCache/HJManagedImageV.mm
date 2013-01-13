//
//  HJManagedImageV.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJManagedImageV.h"


@implementation HJManagedImageV


@synthesize oid;
@synthesize url;
@synthesize moHandler;

@synthesize callbackOnSetImage;
@synthesize callbackOnCancel;
@synthesize modification;
@synthesize loadingWheel;
@synthesize index;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		isCancelled=NO;
		modification=0;
		url=nil;
		onImageTap = nil;
		index = -1;
		self.backgroundColor = [UIColor lightGrayColor];
		self.userInteractionEnabled = NO; //because want to treat it like a UIImageView. Just turn this back on if you want to catch taps.
    }
    return self;
}

- (void)dealloc {
	[self clear];
	self.callbackOnCancel=nil;
	self.callbackOnSetImage=nil;
	self.loadingWheel=nil;
    [super dealloc];
	//NSLog(@"ManagedImage dealloc");
}

-(void) seturlByStr:(NSString*) imgurl needEncode:(BOOL)needEncode
{
	if (!imgurl)
	{
		self.url = nil;
		return;
	}
	NSString *encodeurl = imgurl;
	if (needEncode)
	{
		encodeurl = [imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	self.url = [NSURL URLWithString:encodeurl];
}

-(void) clear {
	[self.moHandler removeUser:self];
	self.moHandler=nil;

	self.image = nil;
	self.oid=nil;
	self.url=nil;
	[self stopLoadingWheel];
}

/*
-(void) clear {
	self.url = nil;
	self.callbackOnSetImage = nil;
	//int rc1 = [image retainCount];
	[self.imageView removeFromSuperview];
	self.imageView = nil;
	//int rc2 = [image retainCount];
	[image release]; image=nil; //do this instead of self.image=nil because setImage has more code
	self.loadingWheel = nil;
}
*/


-(void) changeManagedObjStateFromLoadedToReady {
	//NSLog(@"managedStateReady %@",managedState);
	if (moHandler.moData) {
		moHandler.managedObj=[UIImage imageWithData:moHandler.moData];
	} else if (moHandler.moReadyDataFilename) {
		moHandler.managedObj=[UIImage imageWithContentsOfFile:moHandler.moReadyDataFilename];
	} else {
		//error? 
		NSLog(@"HJManagedImageV error in changeManagedObjStateFromLoadedToReady ?");
	}
}

-(void) managedObjFailed {
	NSLog(@"moHandlerFailed %@",moHandler);
	//self.image = nil;
	[self stopLoadingWheel];
}

-(void) managedObjReady {
	//NSLog(@"moHandlerReady %@",moHandler);
	[self setImage:moHandler.managedObj];
	[self stopLoadingWheel];
}


-(void) markCancelled {
	isCancelled = YES;
	[callbackOnCancel managedImageCancelled:self];
}

-(UIImage*) modifyImage:(UIImage*)theImage modification:(int)mod {
	return theImage;
}


-(void) setImage:(UIImage*)theImage modification:(int)mod {
	if (mod==modification) {
		[self setImage:theImage];
	} else {
		UIImage* modified = [self modifyImage:theImage modification:(int)mod];
		[self setImage:modified];
	}
}


-(void) setImage:(UIImage*)theImage {
	if (theImage==self.image) {
		//when the same image is on the screen multiple times, an image that is alredy set might be set again with the same image.
		[self stopLoadingWheel];
		return; 
	}
	
	[super setImage:theImage];
	//NSLog(@"setImageCallback from %@ to %@",self,callbackOnSetImage);
	if (theImage!=nil) {
		[callbackOnSetImage managedImageSet:self];
	}
}

-(void) showLoadingWheel {
	[loadingWheel removeFromSuperview];
	self.loadingWheel = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	loadingWheel.hidesWhenStopped=YES;
	[self addSubview:loadingWheel];
	CGRect whellrect = loadingWheel.frame;
	whellrect.origin.x = (self.frame.size.width - whellrect.size.width) / 2;
	whellrect.origin.y = (self.frame.size.height - whellrect.size.height) / 2;
	loadingWheel.frame = whellrect;
	[loadingWheel startAnimating];	
}

-(void) stopLoadingWheel
{
	[loadingWheel stopAnimating];
	[loadingWheel removeFromSuperview];
	self.loadingWheel = nil;
}

-(void) setCallbackOnImageTap:(id)obj method:(SEL)m {
	NSInvocation* invo = [NSInvocation invocationWithMethodSignature:[obj methodSignatureForSelector:m]]; 
	[invo setTarget:obj];
	[invo setSelector:m];
	[invo setArgument:&self atIndex:2];
	[invo retain];
	[onImageTap release];
	onImageTap = invo;
	self.userInteractionEnabled=YES; //because it's NO in the initializer, but if we want to get a callback on tap, 
									 //then need to get touch events.
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (onImageTap) {
		[onImageTap invoke];
	}
    else {
        [super touchesEnded:touches withEvent:event];
    }
}

-(void)layoutSubviews
{
	if (loadingWheel)
	{
		CGRect whellrect = loadingWheel.frame;
		whellrect.origin.x = (self.frame.size.width - whellrect.size.width) / 2;
		whellrect.origin.y = (self.frame.size.height - whellrect.size.height) / 2;
		loadingWheel.frame = whellrect;
	}
}

@end
