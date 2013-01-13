//
//  SCNAddressTableCell.h
//  SCN
//
//  Created by huangwei on 11-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBCustomTextField.h"

@interface SCNAddressListTableCell : UITableViewCell {
	UILabel* m_labName;
	UILabel* m_labAddress;
	UILabel* m_labArea;
	UILabel* m_labMobile;
	UIImageView* m_imageArrow;
	
	UIImageView* m_imageDefaultBox;
	UIImageView* m_imageDefaultArrow;
	UILabel* m_labDefault;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labName;
@property(nonatomic,strong)IBOutlet UILabel* m_labAddress;
@property(nonatomic,strong)IBOutlet UILabel* m_labArea;
@property(nonatomic,strong)IBOutlet UILabel* m_labMobile;
@property(nonatomic,strong)IBOutlet UIImageView* m_imageArrow;

@property(nonatomic,strong)IBOutlet UILabel* m_labDefault;
@property(nonatomic,strong)IBOutlet UIImageView* m_imageDefaultBox;
@property(nonatomic,strong)IBOutlet UIImageView* m_imageDefaultArrow;

@end

@interface AddressEditTableCell_DefaultKeyBoard : UITableViewCell{
    int m_int_row;
    UILabel* m_label;
    UITextField* m_textField;
}
@property (assign) int m_int_row;
@property (nonatomic, strong) IBOutlet UILabel* m_label;
@property (nonatomic, strong) IBOutlet UITextField* m_textField;

@end

@interface AddressEditTableCell_Phone : UITableViewCell{
    int m_int_row;
    UILabel* m_label;
    KBCustomTextField* m_textField;
}
@property (assign) int m_int_row;
@property (nonatomic, strong) IBOutlet UILabel* m_label;
@property (nonatomic, strong) IBOutlet KBCustomTextField* m_textField;

@end

@interface MorelacalEditTableCell_Edit :UITableViewCell {
	UILabel *m_lable_key;
	UITextField *m_TextField_value;
}
@property(nonatomic,strong) IBOutlet UILabel* m_lable_key;
@property(nonatomic,strong) IBOutlet UITextField* m_TextField_value;
@end

@interface MorelacalEditTableCell_Edit_One :UITableViewCell {
	UILabel *m_lable_key;
	KBCustomTextField *m_TextField_value;
}
@property(nonatomic,strong) IBOutlet UILabel* m_lable_key;
@property(nonatomic,strong) IBOutlet KBCustomTextField* m_TextField_value;
@end
