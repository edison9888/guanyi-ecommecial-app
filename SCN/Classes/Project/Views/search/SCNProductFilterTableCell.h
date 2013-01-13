//
//  SCNProductFilterTableCell.h
//  SCN
//
//  Created by xie xu on 11-10-13.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNProductFilterButton.h"
/*
    回传给筛选界面当前用户选择的条件
 */
@protocol SCNProductFilterTableCellDelegate
- (void)ChangeConditionWithFilterOptionData:(SCNProductFilterItemData *)filterOptionData;
@end

@interface SCNProductFilterTableCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *m_label_filterType;            //筛选类型
@property(nonatomic,strong)IBOutlet UILabel *m_label_UserFilterContent;     //用户选择信息
@property(nonatomic,strong)NSString *customIdentifier;
@property(nonatomic,unsafe_unretained)id<SCNProductFilterTableCellDelegate> m_delegate;
-(void)setConditionTitle:(NSString *)title withSelectOption:(NSString *)selectedOption;
-(void)layoutWithOptions:(NSArray *)option selectedOption:(NSString *)selectedOption;
-(void)HandleButtonTapped:(SCNProductFilterButton *)button;
-(void)removeAllOptionButtonsFromCell;
-(IBAction)cancleBtnTapped:(id)sender;
@end
