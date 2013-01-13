//
//  TextBlock.h
//  YesMyWine
//
//  Created by yekapple on 11-7-8.
//  Copyright 2011 yek.com All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextBlock : UILabel {
	
}
-(void)setText:(NSString *)string;
-(void)adjustSize;//自适应高度当修改宽度时调用，重置文本内容时不需重置
@end
