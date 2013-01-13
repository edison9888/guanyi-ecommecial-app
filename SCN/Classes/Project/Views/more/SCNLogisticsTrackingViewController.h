//
//  SCNLogisticsTrackingViewController.h
//  SCN
//
//  Created by user on 11-11-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNLogisticsTrackingViewController : BaseViewController {
    IBOutlet UIWebView         *m_webview_logistics;
    NSString                   *m_str_logisticsTrack;
}
@property (nonatomic , strong) NSString * m_str_logisticsTrack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil logistics: (NSString *)logistics;
@end
