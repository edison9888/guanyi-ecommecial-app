//
//  YKBaseSelectionTableViewCell.h
//  testYKLiNing
//
//  Created by guwei.zhou on 11-9-29.
//  Copyright 2011年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKSelectionTableCellConfig.h"
#import <QuartzCore/QuartzCore.h>
#import "HJManagedImageV.h"
/*
 YKBaseSelectionTableViewCell
 */
@interface YKBaseSelectionTableViewCell : UITableViewCell{
    HJManagedImageV*      m_imageView_icon;
    UILabel*          m_label_title;
    NSString*         m_id;
    YK_TABLECELL_TYPE m_cellType; //目前有两种TableViewCell类型，一类带图片，另一类都是文字
}

@property (nonatomic,retain) HJManagedImageV* m_imageView_icon;
@property (nonatomic,retain) UILabel*     m_label_title;
@property (nonatomic,retain) NSString*    m_id;
@property (nonatomic,assign,setter=setM_cellType:,getter=m_cellType) YK_TABLECELL_TYPE m_cellType;
/*
 重写layoutUI方法可以获得不同的UI排列
 */
-(void)layoutUI;
@end
