//
//  KeyboardView.h
//  SCN
//
//  Created by huangwei on 11-10-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardNeedHideDelegate<NSObject>

@optional
- (void)KeyboardNeedHide:(id)keyboard;

@end



@interface KeyboardView : UIView 
{
	id<KeyboardNeedHideDelegate> __unsafe_unretained m_keyboardDelegate;
	UIView* __unsafe_unretained m_currentKeyboard;
}

@property (nonatomic, unsafe_unretained)id<KeyboardNeedHideDelegate> m_keyboardDelegate;
@property (nonatomic, unsafe_unretained)UIView* m_currentKeyboard;

@end
