//
//  YK_B2C_CityPickerView.h
//  YK_B2C
//
//  Created by Guwei.Z on 11-4-27.
//  Copyright 2011 yek.com All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YKCityPickerDelegate;
@protocol YKCityPickerDataSource;
/*
 选择城市
 */
@interface YKCityPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
{
	id<YKCityPickerDataSource> dataSource;
	id<YKCityPickerDelegate> __unsafe_unretained delegate;
	IBOutlet UIPickerView* pickerView;
	
	NSArray* currentProvinceArray;
	NSInteger currentProvinceRow;
	NSArray* currentCityArray;
	NSInteger currentCityRow;
	NSArray* currentAreaArray;
	NSInteger currentAreaRow;
}
@property(nonatomic, unsafe_unretained, setter = setDataSource:) id<YKCityPickerDataSource> dataSource;
@property(nonatomic, unsafe_unretained) id<YKCityPickerDelegate> delegate;

@end

@protocol YKCityPickerDelegate<NSObject>
-(void) cityPicker:(YKCityPickerView*) pv changeProvince:(id) p city:(id) c area:(id) a;
@end

@protocol YKCityPickerDataSource<NSObject>
/*
 省列表
 */
-(NSArray*) provinceArray;
/*
 省所辖城市列表
 */
-(NSArray*) cityArrayByProvince:(id) province;
/*
 城市所辖区县列表
 */
-(NSArray*) areaArrayByCity:(id) city;

@optional
/*
 默认区域
 */
-(id) defaultProvince;
-(id) defaultCity;
-(id) defaultArea;

@end
