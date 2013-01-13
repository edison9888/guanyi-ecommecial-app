//
//  SCNProductFilterTableCell.m
//  SCN
//
//  Created by xie xu on 11-10-13.
//  Copyright 2011年 yek. All rights reserved.
//

#import "SCNProductFilterTableCell.h"

@implementation SCNProductFilterTableCell
#define COLUMN_HEIGHT 6
#define BUTTON_WIDTH 90
#define BUTTON_WIDTH_SHOE 50
#define BUTTON_HEIGHT 40
#define BUTTON_SPACE 12
#define BUTTON_X (320-(3*BUTTON_WIDTH+2*BUTTON_SPACE))/2
#define BUTTON_X_SHOE (320-(5*BUTTON_WIDTH_SHOE+4*BUTTON_SPACE))/2
#define PRICE_BUTTON_WIDTH 48
#define PRICE_BUTTON_HEIGHT 20
#define BUTTON_IMAGE_TAG 999

#define BtnStartTag 1000


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}
-(void)setConditionTitle:(NSString *)title withSelectOption:(NSString *)selectedOption
{
	if (!selectedOption || [selectedOption isEqualToString:@""])
	{
		selectedOption = @"全部";
	}
	self.m_label_filterType.text = [NSString stringWithFormat:@"%@:  %@", title, selectedOption];
    
}
-(void)removeAllOptionButtonsFromCell{
	for(UIView* btn in [self subviews])
	{
		if (btn.tag >= BtnStartTag)
		{
			[btn removeFromSuperview];
		}
	}
}

-(void)layoutWithOptions:(NSArray *)option selectedOption:(NSString *)selectedOption
{
	[self removeAllOptionButtonsFromCell];
	if (option != nil) {
		SCNProductFilterItemData *_data=[option objectAtIndex:0];

			if ([_data.mdisplayName isEqualToString:selectedOption]) 
			{
				for (int i=0; i<[option count]; i++) 
				{
					SCNProductFilterButton *button=[SCNProductFilterButton buttonWithType:UIButtonTypeCustom];
					
					UIImageView *tempView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shoppingcart_defaultAddress_selectArrow.png"]];
					tempView.tag=BUTTON_IMAGE_TAG;
					[tempView setHidden:YES];
					[button addSubview:tempView];
					
					if ([_data.mname isEqualToString:@"size"])
					{
						[button setFrame:CGRectMake(BUTTON_X_SHOE+i%5*(BUTTON_WIDTH_SHOE+BUTTON_SPACE),32+COLUMN_HEIGHT+i/5*(BUTTON_HEIGHT+COLUMN_HEIGHT), BUTTON_WIDTH_SHOE, BUTTON_HEIGHT)];
						UIImageView *imgView=(UIImageView *)[button viewWithTag:BUTTON_IMAGE_TAG];
						[imgView setFrame:CGRectMake(35,26,15,14)];
					}
					else
					{
						[button setFrame:CGRectMake(BUTTON_X+i%3*(BUTTON_WIDTH+BUTTON_SPACE),32+COLUMN_HEIGHT+i/3*(BUTTON_HEIGHT+COLUMN_HEIGHT), BUTTON_WIDTH, BUTTON_HEIGHT)];
						UIImageView *imgView=(UIImageView *)[button viewWithTag:BUTTON_IMAGE_TAG];
						[imgView setFrame:CGRectMake(75,26,15,14)];
					}
					//设置button圆角
					button.layer.cornerRadius=3;
					button.layer.borderWidth=1;
					button.layer.borderColor=[UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1].CGColor;
					[button setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:236.0/255]];
					[button.titleLabel setFont:[UIFont systemFontOfSize:14]];
					[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
					[button addTarget:self action:@selector(HandleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

					SCNProductFilterItemData *itemData=[option objectAtIndex:i];
					button.m_filterItemData=itemData;
                    
                    [button setTitle:itemData.mcontent forState:UIControlStateNormal];
				
					if (itemData.mselected)
					{
						UIImageView *imgView=(UIImageView *)[button viewWithTag:BUTTON_IMAGE_TAG];
						[imgView setHidden:NO];
                        [self setConditionTitle:itemData.mdisplayName withSelectOption:itemData.mcontent];
                        [self.m_delegate ChangeConditionWithFilterOptionData:itemData];
					}
					else
					{
						UIImageView *imgView=(UIImageView *)[button viewWithTag:BUTTON_IMAGE_TAG];
						[imgView setHidden:YES];
					}
					
					button.tag = BtnStartTag + i;
					[self addSubview:button];
				}
			}
		}
}

- (void)HandleButtonTapped:(SCNProductFilterButton *)button
{
	if (button.m_filterItemData.mselected)
	{
		button.m_filterItemData.mselected=NO;
		//修改图片
		UIImageView *imgView=(UIImageView *)[button viewWithTag:BUTTON_IMAGE_TAG];
		[imgView setHidden:YES];
		[self setConditionTitle:button.m_filterItemData.mdisplayName withSelectOption:nil];
        
        SCNProductFilterItemData *data=[[SCNProductFilterItemData alloc] init];
        data.mname=button.m_filterItemData.mname;
        data.mdisplayName=button.m_filterItemData.mdisplayName;
        data.mcontent=@"";
        data.mid=@"";
        data.mselected=NO;
        [self.m_delegate ChangeConditionWithFilterOptionData:data];
	}
	else
	{
		for(SCNProductFilterButton * btn in [self subviews])
		{
			if (btn.tag >= BtnStartTag && btn.m_filterItemData.mselected)
			{
				btn.m_filterItemData.mselected = NO;
				//修改图片
				UIImageView *imgView=(UIImageView *)[btn viewWithTag:BUTTON_IMAGE_TAG];
				[imgView setHidden:YES];
			}
		}
		
		button.m_filterItemData.mselected = YES;
		UIImageView *imgView=(UIImageView *)[button viewWithTag:BUTTON_IMAGE_TAG];
		[imgView setHidden:NO];
		[self setConditionTitle:button.m_filterItemData.mdisplayName withSelectOption:button.m_filterItemData.mcontent];
        [self.m_delegate ChangeConditionWithFilterOptionData:button.m_filterItemData];
	}
}

-(IBAction)cancleBtnTapped:(id)sender
{
	for(SCNProductFilterButton * btn in [self subviews])
	{
		if (btn.tag >= BtnStartTag && btn.m_filterItemData.mselected)
		{
			btn.m_filterItemData.mselected = NO;
			//修改图片
			UIImageView *imgView=(UIImageView *)[btn viewWithTag:BUTTON_IMAGE_TAG];
			[imgView setHidden:YES];
		}
	}
	SCNProductFilterButton * btn = (SCNProductFilterButton *)[self viewWithTag:BtnStartTag];
	if (btn)
	{
		[self setConditionTitle:btn.m_filterItemData.mdisplayName withSelectOption:nil];
        
        SCNProductFilterItemData *data=[[SCNProductFilterItemData alloc] init];
        data.mname=btn.m_filterItemData.mname;
        data.mdisplayName=btn.m_filterItemData.mdisplayName;
        data.mcontent=@"";
        data.mid=@"";
        data.mselected=NO;
        [self.m_delegate ChangeConditionWithFilterOptionData:data];
	}
}

- (NSString *) reuseIdentifier {
	return self.customIdentifier;
}
@end