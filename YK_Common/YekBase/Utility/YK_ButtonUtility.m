//
//  YK_ButtonUtility.m
//  Moonbasa
//
//  Created by user on 11-7-20.
//  Copyright 2011 yek.com All rights reserved.
//

#import "YK_ButtonUtility.h"


@implementation YK_ButtonUtility

+(UIButton*)customButtonWithImageName:(NSString*)imageName
			 withHighlightedImageName:(NSString*)highlightedImageName
							 withRect:(CGRect)rect target:(id)target action:(SEL)sel{
	UIImage* image = [UIImage imageNamed:imageName];
	UIImage* highlightedImage = [UIImage imageNamed:highlightedImageName];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:highlightedImage forState:UIControlStateHighlighted];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	button.frame = rect;
	return button;
}

+(UIView*)customButtonViewWithImageName:(NSString*)imageName
			 withHighlightedImageName:(NSString*)highlightedImageName
							 withRect:(CGRect)rect target:(id)target action:(SEL)sel{
	UIImage* image = [UIImage imageNamed:imageName];
	UIImage* highlightedImage = [UIImage imageNamed:highlightedImageName];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:highlightedImage forState:UIControlStateHighlighted];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	button.frame = rect;
    
    UIView* buttonView = [[UIView alloc] initWithFrame:button.frame];
    [buttonView addSubview:button];
	return buttonView;
}

+(UIButton*)customButtonWithImageName:(NSString*)imageName
			 highlightedImageName:(NSString*)highlightedImageName
								title:(NSString*)title font:(UIFont *)font target:(id)target action:(SEL)sel{
	CGSize size = [title sizeWithFont:font];
	
	
	UIImage* image = [UIImage imageNamed:imageName];
	UIImage* highlightedImage = [UIImage imageNamed:highlightedImageName];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = font;
	[button setFrame:CGRectMake(0, 0, MAX((size.width+15),40), MAX(image.size.height,size.height))];
	[button setBackgroundImage:[highlightedImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
	[button setBackgroundImage:[image stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	return button;
}

+(UIView*)customButtonViewWithImageName:(NSString*)imageName
                 highlightedImageName:(NSString*)highlightedImageName
								title:(NSString*)title font:(UIFont *)font target:(id)target action:(SEL)sel{
	CGSize size = [title sizeWithFont:font];
	
	
	UIImage* image = [UIImage imageNamed:imageName];
	UIImage* highlightedImage = [UIImage imageNamed:highlightedImageName];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = font;
	[button setFrame:CGRectMake(0, 0, MAX((size.width+15),40), MAX(image.size.height,size.height))];
	[button setBackgroundImage:[highlightedImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
	[button setBackgroundImage:[image stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    button.tag = BUTTON_TAG;
    UIView* buttonView = [[UIView alloc] initWithFrame:button.frame];
    [buttonView addSubview:button];
	return buttonView;
}

+(UIView*)customButtonViewWithBackImageName:(NSString*)backImageName
                             frontImageName:(NSString*)frontImageName
                   highlightedBackImageName:(NSString*)highlightedImageName
                             frontHighlightedImageName:(NSString*)frontHighlightedImageName
                                  target:(id)target action:(SEL)sel{
	
	UIImage* backImage = [UIImage imageNamed:backImageName];
    UIImage* frontImage = [UIImage imageNamed:frontImageName];
	UIImage* highlightedBackImage = [UIImage imageNamed:highlightedImageName];
    UIImage* frontHighlightedImage = [UIImage imageNamed:frontHighlightedImageName];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
	[button setBackgroundImage:[highlightedBackImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateHighlighted];
    [button setImage:frontHighlightedImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:[backImage stretchableImageWithLeftCapWidth:20 topCapHeight:15] forState:UIControlStateNormal];
    [button setImage:frontImage forState:UIControlStateNormal];
	[button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIView* buttonView = [[UIView alloc] initWithFrame:button.frame];
    [buttonView addSubview:button];
	return buttonView;
}

@end
