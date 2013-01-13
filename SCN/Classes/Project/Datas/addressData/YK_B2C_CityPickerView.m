
#import "YK_B2C_CityPickerView.h"
#import "YK_ProvinceData.h"

const int numOfComponents=3;
@implementation  YKCityPickerView
@synthesize delegate;

-(void) internalInit{
	currentProvinceArray=nil;
	currentCityArray=nil;
	currentAreaArray=nil;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
	if((self=[super initWithCoder:aDecoder])){
		[self internalInit];
	}
	return self;
}
-(id) initWithFrame:(CGRect)frame{
	if((self=[super initWithFrame:frame])){
		[self internalInit];
	}
	return self;
}

-(void) dealloc{
	
	NSLog(@"YKPickerView dealloced");
	
}

-(NSUInteger) findIndexByName:(NSString*) name array:(NSArray*) array
{
	NSUInteger ret = NSNotFound;
	for(int i=0;i<[array count];++i){
		YK_SystemAddressData* city=(YK_SystemAddressData*)[array objectAtIndex:i];
		if([city.mname isEqualToString:name ]){
			ret=i;
			break;
		}
	}
	return ret;
}

#pragma mark UIPickerView DataRelated

-(void) setDataSource:(id <YKCityPickerDataSource>) ds{
	dataSource= ds;
	currentProvinceArray=[dataSource provinceArray];
	[pickerView reloadAllComponents];
	if(dataSource!=nil && [dataSource respondsToSelector:@selector(defaultProvince)])
	{
		id defaultProvince=[dataSource defaultProvince];
		YK_SystemAddressData* defaultCity=[dataSource defaultCity];
		YK_SystemAddressData* defaultArea=[dataSource defaultArea];
		
		NSLog(@"defaultProvince=%@ defaultCity=%@ defaultArea=%@",defaultProvince,defaultCity,defaultArea);
		//if(defaultProvince!=nil){
		NSUInteger provinceRow=[currentProvinceArray indexOfObject:defaultProvince];
		if(NSNotFound==provinceRow)
		{
			provinceRow=0;
		}
		//currentProvinceRow=provinceRow;
		[pickerView selectRow:provinceRow inComponent:0 animated:YES];
		[self pickerView:pickerView didSelectRow:provinceRow inComponent:0];
		
		if([dataSource respondsToSelector:@selector(defaultCity)])
		{
			
			//if(defaultCity!=nil){
			
			NSUInteger cityRow=[self findIndexByName:defaultCity.mname array:currentCityArray];
			
			//NSUInteger cityRow=[currentCityArray indexOfObject:defaultCity];
			if(cityRow==NSNotFound)
			{ 
				cityRow=0; 
			}
			[pickerView selectRow:cityRow inComponent:1 animated:YES];
			[self pickerView:pickerView didSelectRow:cityRow inComponent:1];
			//currentCityRow=cityRow;
			//
			if([dataSource respondsToSelector:@selector(defaultArea)])
			{
				
				//if(nil!=defaultArea){
				NSUInteger areaRow=[self findIndexByName:defaultArea.mname array:currentAreaArray];
				//NSUInteger areaRow=[currentAreaArray indexOfObject:defaultArea];
				if(areaRow==NSNotFound)
				{ 
					areaRow=0; 
				}
				[pickerView selectRow:areaRow inComponent:2 animated:YES];
				[self pickerView:pickerView didSelectRow:areaRow inComponent:2];
				//currentAreaRow=areaRow;
				//}
			}
			//}
		}
		//}
	}
}

-(id <YKCityPickerDataSource>) dataSource{
	return dataSource;
}


#pragma mark UIPickerView

-(id) currentProvince{
	if(currentProvinceRow>=0 && currentProvinceRow<[currentProvinceArray count]){
		return [currentProvinceArray objectAtIndex:currentProvinceRow];
	}else{
		return nil;
	}
	
}
-(id) currentCity{
	if(currentCityRow>=0 && currentCityRow <[currentCityArray count]){
		return [currentCityArray objectAtIndex:currentCityRow];
	}else{
		return nil;
	}
}
-(id) currentArea{
	if(currentAreaRow>=0 && currentAreaRow<[currentAreaArray count]){
		return [currentAreaArray objectAtIndex:currentAreaRow];
	}else{
		return nil;
	}
}


-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 3;
}

-(NSInteger) pickerView:(UIPickerView *)apickerView numberOfRowsInComponent:(NSInteger)component{
	NSArray* array=@[currentProvinceArray==nil?@[]:currentProvinceArray,
					currentCityArray==nil?@[]:currentCityArray,
					currentAreaArray==nil?@[]:currentAreaArray];
	return [[array objectAtIndex:component] count];
}

-(NSString *) pickerView:(UIPickerView *)apickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSArray* array=@[currentProvinceArray==nil?@[]:currentProvinceArray,
					currentCityArray==nil?@[]:currentCityArray,
					currentAreaArray==nil?@[]:currentAreaArray];
	return [[[array  objectAtIndex:component] objectAtIndex:row] description];
}

-(void) pickerView:(UIPickerView *)apickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	int count=[self numberOfComponentsInPickerView:apickerView];
	switch (component) {
		case 0:
			currentProvinceRow=row;
			break;
		case 1:
			currentCityRow=row;
			break;
		case 2:
			currentAreaRow=row;
			break;
		default:
			break;
	}
	for(int i=component+1;i<count;++i){
		switch (i) {
			case 0:
				if(currentProvinceArray!=nil){}
				currentProvinceArray=[dataSource provinceArray];
				[apickerView reloadComponent:i];
				currentProvinceRow=[apickerView selectedRowInComponent:i];
				break;
			case 1:
				if(currentCityArray!=nil){  }
				if([self currentProvince]!=nil){
					currentCityArray=[dataSource cityArrayByProvince:[self currentProvince]];
					[apickerView reloadComponent:i];
					currentCityRow=[apickerView selectedRowInComponent:i];
				}else{
					currentCityArray=nil;
					[apickerView reloadComponent:i];
					currentCityRow=-1;
				}
				break;
			case 2:
				if( currentAreaArray!=nil){  }
				if(nil!=[self currentCity]){
					currentAreaArray=[dataSource areaArrayByCity:[self currentCity]];
					[apickerView reloadComponent:i];
					currentAreaRow=[apickerView selectedRowInComponent:i];
				}else{
					currentAreaArray=nil;
					[apickerView reloadComponent:i];
					currentAreaRow=-1;
				}
			default:
				break;
		}
	}
	if(delegate!=nil){
		[delegate cityPicker:self changeProvince:[self currentProvince] city:[self currentCity] area:[self currentArea]];
	}
	
}

@end
