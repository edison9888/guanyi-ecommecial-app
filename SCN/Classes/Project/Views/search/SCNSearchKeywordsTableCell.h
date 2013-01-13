//
//  SCNSearchKeywordsTableCell.h
//  SCN
//
//  Created by xie xu on 11-10-9.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCNSearchKeywordsTableCell : UITableViewCell{
    UILabel *m_label_left;
    UILabel *m_label_right;
    UIImageView *m_imageView_left;
    UIImageView *m_imageView_right;
    UIButton *m_button_left;
    UIButton *m_button_right;
}
@property(nonatomic,strong)IBOutlet UILabel *m_label_left;
@property(nonatomic,strong)IBOutlet UILabel *m_label_right;
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_left;
@property(nonatomic,strong)IBOutlet UIImageView *m_imageView_right;
@property(nonatomic,strong)IBOutlet UIButton *m_button_left;
@property(nonatomic,strong)IBOutlet UIButton *m_button_right;
@end
