//
//  KeyboardView.m
//  SCN
//
//  Created by huangwei on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyboardView.h"

@interface NSObject(hidden)
- (NSString *)className;
@end

@implementation KeyboardView

@synthesize m_keyboardDelegate;
@synthesize m_currentKeyboard;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	UIView* vi = [super hitTest:point withEvent:event];
	NSString* _viClassName = [vi className];
	if ([vi isKindOfClass:[UITextView class]] || [vi isKindOfClass:[UITextField class]])
	{
		self.m_currentKeyboard = vi;
		return vi;
	}
	else if([vi isKindOfClass:[KeyboardView class]])
	{
		return vi;
	}
	else if([_viClassName isEqualToString:@"UIInlineCandidateTextView"]){
		return vi;
	}
	else if([_viClassName isEqualToString:@"UIAutocorrectInlinePrompt"])
	{
		return vi;		
	}


	if (self.m_currentKeyboard) 
	{
		if ([m_keyboardDelegate respondsToSelector:@selector(KeyboardNeedHide:)]) {
			[m_keyboardDelegate KeyboardNeedHide:self.m_currentKeyboard];
		}
		self.m_currentKeyboard = nil;
	}
	return vi;
}

@end
