//
//  SCNCommonPickerView.h
//  SCN
//
//  Created by huangwei on 11-10-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCNCommonPickerView;

@protocol SCNCommonPickerViewDelegate<NSObject>
-(NSInteger)numberOfCellsForPickerView:(SCNCommonPickerView*)aPickerView;
-(NSArray*)titleForPickerView:(SCNCommonPickerView*)aPickerView;
-(void)scnCommonPickerView:(SCNCommonPickerView*)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@interface SCNCommonPickerView : UIControl<UIPickerViewDelegate,UIPickerViewDataSource> {
	UIPickerView* m_pickerView;
	UIToolbar* m_pickerBar;
	NSInteger m_elementNum;
	NSInteger m_rowIndex;
	NSInteger m_componentIndex;
	NSInteger m_newRowIndex;
	NSArray* m_pickerArray;
	
	UIView* m_showView;
	
	id<SCNCommonPickerViewDelegate> __unsafe_unretained m_delegate;
	
}
@property(nonatomic,strong)UIPickerView* m_pickerView;
@property(nonatomic,strong)UIToolbar* m_pickerBar;
@property(nonatomic,assign)NSInteger m_elementNum;
@property(nonatomic,assign)NSInteger m_rowIndex;
@property(nonatomic,assign)NSInteger m_componentIndex;
@property(nonatomic,assign)NSInteger m_newRowIndex;
@property(nonatomic,strong)NSArray* m_pickerArray;
@property(nonatomic,unsafe_unretained)id<SCNCommonPickerViewDelegate> m_delegate;
@property(nonatomic)UIView* m_showView;

-(id)initWithFrame:(CGRect)frame;

-(void)doPickCancle;
-(void)doPickOK;
- (void)appearView;
- (void)disappearView;
@end
