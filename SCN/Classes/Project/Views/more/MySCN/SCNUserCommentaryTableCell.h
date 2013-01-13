//
//  SCNUserCommentaryTableCell.h
//  SCN
//
//  Created by user on 11-10-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "SCNHJManagedImageVUtility.h"

@interface SCNUserCommentaryTableCell : UITableViewCell {
    
    IBOutlet UIView           *m_view_bgviewinfo;
    IBOutlet UIImageView      *m_imageview_info;
    IBOutlet HJManagedImageV  *m_imageview_star;
    IBOutlet UIView           *m_view_bgcommentaryCell;
    IBOutlet UIView           *m_view_star;
    IBOutlet UIButton         *m_button_publish; 
    
    IBOutlet SCNHJManagedImageVUtility *m_SCNImageview;
    
    IBOutlet UILabel          *m_label_username;
    IBOutlet UILabel          *m_label_info;
    IBOutlet UILabel          *m_label_creatTime;
    IBOutlet UILabel          *m_label_content;
    IBOutlet UILabel          *m_label_commentaryClass;
    IBOutlet UILabel          *m_label_commentaryNumber;
    IBOutlet UILabel          *m_label_page;
    IBOutlet UILabel          *m_babel_titlename;
}
@property (nonatomic , strong) SCNHJManagedImageVUtility *m_SCNImageview;

@property (nonatomic , strong) UIView        *m_view_bgviewinfo;
@property (nonatomic , strong) UIButton      *m_button_publish; 
@property (nonatomic , strong) UIView        *m_view_bgcommentaryCell;
@property (nonatomic , strong) UILabel       *m_label_info;
@property (nonatomic , strong) UIImageView   *m_imageview_info;
@property (nonatomic , strong) HJManagedImageV   *m_imageview_star;
@property (nonatomic , strong) UILabel       *m_label_creatTime;
@property (nonatomic , strong) UILabel       *m_label_content;
@property (nonatomic , strong) UILabel       *m_label_commentaryClass;
@property (nonatomic , strong) UILabel       *m_label_commentaryNumber;
@property (nonatomic , strong) UILabel       *m_babel_titlename;
@property (nonatomic , strong) UILabel       *m_label_page;
@property (nonatomic , strong) UILabel       *m_label_username;

@end
