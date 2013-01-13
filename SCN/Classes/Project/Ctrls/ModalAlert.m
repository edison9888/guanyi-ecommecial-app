//
//  ModalAlert.m
//  SCN
//
//  Created by yekmacminiserver on 11-11-9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModalAlert.h"


@interface ModalAlertDelegate : NSObject <UIAlertViewDelegate>  
{  
    CFRunLoopRef currentLoop;  
    NSUInteger index;
}
@property (readonly) NSUInteger index;
@end

@implementation ModalAlertDelegate  
@synthesize index;  

// Initialize with the supplied run loop  
-(id) initWithRunLoop: (CFRunLoopRef)runLoop   
{  
    if (self = [super init])
	{
		currentLoop = runLoop;
	}
    return self;
}  

// User pressed button. Retrieve results  
-(void) alertView: (UIAlertView*)aView clickedButtonAtIndex: (NSInteger)anIndex   
{  
    index = anIndex;  
    CFRunLoopStop(currentLoop);  
}  
@end 

@implementation ModalAlert


+ (NSUInteger)queryWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton otherButton:(NSString *)otherButton otherButton1:(NSString *)otherButton1
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	
	// Create Alert
	ModalAlertDelegate *madelegate = [[ModalAlertDelegate alloc] initWithRunLoop:currentLoop];  
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:madelegate cancelButtonTitle:cancelButton otherButtonTitles:otherButton, otherButton1, nil];  
    [alertView show];
	
	// Wait for response  
	CFRunLoopRun();  
	
	// Retrieve answer  
	NSUInteger answer = madelegate.index;  
	return answer;
}

+ (BOOL)confirm:(NSString *)title message:(NSString *)message
{
	return [[self class] queryWithTitle:title message:message cancelButton:@"取消" otherButton:@"确定" otherButton1:nil];
}

+ (BOOL)ask:(NSString *)title message:(NSString *)message
{
	return [[self class] queryWithTitle:title message:message cancelButton:@"否" otherButton:@"是" otherButton1:nil];
}

+ (void)showTip:(NSString *)title message:(NSString *)message
{
	[[self class] queryWithTitle:title message:message cancelButton:@"确定" otherButton:nil otherButton1:nil];
}

+ (void)showTip:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancelButton
{
	[[self class] queryWithTitle:title message:message cancelButton:cancelButton otherButton:nil otherButton1:nil];
}

@end
