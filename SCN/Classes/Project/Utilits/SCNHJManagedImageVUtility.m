//
//  SCNHJManagedImageVUtility.m
//  SCN
//
//  Created by user on 11-11-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SCNHJManagedImageVUtility.h"


@implementation SCNHJManagedImageVUtility
@synthesize m_bgImage;

-(void) managedObjReady {
	//NSLog(@"moHandlerReady %@",moHandler);
	[self setImage:moHandler.managedObj];
	[self stopLoadingWheel];
    if(moHandler.managedObj)
    {
		self.m_bgImage.hidden = YES;
		self.m_bgImage = nil;
        self.hidden = NO;
    }
}


@end
