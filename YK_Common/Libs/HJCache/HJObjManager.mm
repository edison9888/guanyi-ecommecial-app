//
//  HJObjManager.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/


#import "HJObjManager.h"

@interface NSMutableArray(hidde)
-(id)findObject:(id)key;
@end

static HJObjManager* s_ObjManager;

@implementation HJObjManager


@synthesize policy;
@synthesize loadingHandlers;
@synthesize memCache, fileCache;
@synthesize waitingHandlers, maxWaitCount;


+(HJObjManager*)shareManager
{
	@synchronized(self)
	{
		if (s_ObjManager==nil)
		{
			s_ObjManager = [[self alloc] init];
			
			NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/"] ;
			HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
			s_ObjManager.fileCache = fileCache;
			
			// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
			fileCache.fileCountLimit = 1000000;
			fileCache.fileAgeLimit = 60*60*24*7; //1 week
			[fileCache trimCacheUsingBackgroundThread];
		}
	}
	return s_ObjManager;
}

-(HJObjManager*) init {
	return [self initWithLoadingBufferSize:16 memCacheSize:20];
}

-(HJObjManager*) initWithLoadingBufferSize:(int)loadingBufferSize memCacheSize:(int)memCacheSize {
	[super init];
	self.policy = [HJMOPolicy smallImgFastScrollLRUCachePolicy];
	self.loadingHandlers = [HJCircularBuffer bufferWithCapacity:loadingBufferSize];
	self.memCache = [HJCircularBuffer bufferWithCapacity:memCacheSize];
	flyweightManagedState = [[HJMOHandler alloc] init];
	
	maxWaitCount = 80;
	self.waitingHandlers = [NSMutableArray arrayWithCapacity:20];
	
	return self;
}

-(void) dealloc {
	//if the HJObjManager is stored in a view that gets dealloced, and that view is also using the object managers
	// managed objects, then its possible for the object manager to dealloc before the HJMOHandlers.
	// For this reason, have to cancel any loading handlers here, so that they don't finish loading when the 
	// object manager itself is dealloced.
	[self cancelLoadingObjects];
	
	self.loadingHandlers=nil;
	self.waitingHandlers=nil;
	self.memCache=nil;
	self.policy=nil;
	[flyweightManagedState release];
	self.fileCache=nil;
	[super dealloc];
}

/* 
 If HJObjManager needs to be used to load a lot of managed objects at once, it's loading buffer needs to be big enough
 to hold them all. This method can be used to change loading buffer size to accomodate the application going into
 a different mode that needs to do this. It will cancel the loading of any objects that are loading at the time.
 */
-(void) resetLoadingBufferToSize:(int)loadingBufferSize {
	[self cancelLoadingObjects];
	self.loadingHandlers = [HJCircularBuffer bufferWithCapacity:loadingBufferSize];
}

/*
 tells object manager to manage this user object, which will cause the object to 
 be loaded from in-memory cache, file cache, or its url.
 This method should only be called from the main thread of the app. If you need to call
 it from a different thread, use this: 
 [self.objectManager performSelectorOnMainThread:@selector(manage:) withObject:managedImage waitUntilDone:YES];
 */
-(BOOL) manage:(id<HJMOUser>)user {
	id oid;
	if (! (oid=[user oid])) { 
		//oid is nil, try to use the url as the oid
		if (! (oid=[user url])) {
			//oid and url are nil, so can't manage this object
			return NO;
		}
		
	}
	
	//find handler for this oid in caches, or make a new handler.
	HJMOHandler* handler;
	BOOL handlerWasAllocedInThisCall=NO;
	BOOL handlerWasFromLoadingBuffer=NO;
	
	//look in loadingHandlers first.
	flyweightManagedState.oid = oid;
	handler = [loadingHandlers findObject:flyweightManagedState];
	if (handler!=nil) {
		//if handler from loadingHandlers, its probably in stateLoading, remember this so we don't add it to loadingHandlers again
		handlerWasFromLoadingBuffer = YES;
		//NSLog(@"HJCache loading from loadingBuffer");
		
	}
	else 
	{
		handler = [waitingHandlers findObject:flyweightManagedState];
		if(handler != nil)
		{
			//look in waitingHandlers second.
			//the state is on new
			handlerWasFromLoadingBuffer = YES;
		}
		else
		{
			//look in memCache for handler
			handler = [memCache findObject:flyweightManagedState];
			
			if (handler==nil) {
				//was not in loadingHandlers or memCache. have to make a new handler to load image
				handler = [[HJMOHandler alloc] initWithOid:user.oid url:user.url objManager:self];
				handlerWasAllocedInThisCall=YES;
			} else {
				//NSLog(@"HJCache loading from memCache");
			}
		}
	}

	//now use the handler can be used, whatever state its in.
	[handler addUser:user];	
	[handler activateHandlerForUser:user]; //this can 'get things going' whatever state the handler is in
	
	//check if handler is loading and needs to be added to loadingHandlers buffer
	if (!handlerWasFromLoadingBuffer && handler.state == stateLoading) {
		//put in loadingHandlers, which is a cirular buffer so we might bump a handler out
		HJMOHandler* bumpedHandler = (HJMOHandler*) [loadingHandlers addObject:handler];
		
		//the whole point of the loadingHandlers is to limit how many handlers are loading at the same time, 
		//  so if something gets bumped out of loadingHandlers, loading has to be cancelled and it won't go in to memCache.
		//  This is why the loadingHandlers should always be at least the number of managed objects on the screen at the same time,
		//  otherwise on-screen managed objects will get loading canceled.
		//  Can't just wait and cancel in dealloc because cell reuse typically means managed object users don't get
		//  dealloced until a cell gets reused.
		[bumpedHandler cancelLoading]; //usually nil, but could be non nil when scrolling fast
		
		//add by zwh
		if(bumpedHandler)
		{
			[waitingHandlers addObject:bumpedHandler];
			if(waitingHandlers.count > maxWaitCount)
			{
				[waitingHandlers removeObjectAtIndex:0];
			}
		}
	}
	
	if (handlerWasAllocedInThisCall) {
		[handler release];
	}
	
	return YES; //yes this object is now being managed. only NO if misused.
}

-(void) addHandlerToMemCache:(HJMOHandler*)handler {
	[memCache addObject:handler]; //we can ignore any handler bumped from mem cache	
}

-(void) handlerFinishedDownloading:(HJMOHandler*)handler {
	int index = [loadingHandlers findIndexOfObject:handler];
	[loadingHandlers removeObject:handler];
	
	//add by zwh
	if(index < 0)
		return;
	if(waitingHandlers.count)
	{
		HJMOHandler* waithandle = (HJMOHandler*)[waitingHandlers lastObject];
		[loadingHandlers swapObject:waithandle atIndex:index];
		[waitingHandlers removeLastObject];
		[waithandle activateHandlerForUser:nil];
	}
}

-(void) cancelLoadingObjects {
	for (HJMOHandler* handler in [loadingHandlers allObjects]) {
		[handler cancelLoading];
	}
}

-(void) removeFromHandlerFromCaches:(HJMOHandler*)handler {
	int index = [loadingHandlers findIndexOfObject:handler];
	[loadingHandlers removeObject:handler];
	[memCache removeObject:handler];
	if (fileCache) {
		[fileCache removeOid:handler.oid];
	}
	//add by zwh
	if(waitingHandlers.count && index >= 0)
	{
		HJMOHandler* waithandle = (HJMOHandler*)[waitingHandlers lastObject];
		[loadingHandlers swapObject:waithandle atIndex:index];
		[waitingHandlers removeLastObject];
		[waithandle activateHandlerForUser:nil];
	}
}

@end
