//
//  SCNViewController.h
//  SCN
//
//  Created by yekmacminiserver on 11-9-20.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"
#import "LeveyTabBarController.h"

@interface SCNViewController : LeveyTabBarController<LeveyTabBarControllerDelegate> {
	BadgeView *m_badgeView;
}
@property (nonatomic, strong) BadgeView *m_badgeView;

-(void)setBadgeNumber:(int)num;
-(void)viewControllerBackRoot:(NSInteger)index;
-(void)callViewControllerFresh:(NSInteger)index;
@end

