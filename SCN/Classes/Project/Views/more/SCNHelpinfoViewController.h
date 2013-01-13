

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YK_BaseData.h"
#import "SCNHelpData.h"
@interface SCNHelpinfoViewController : BaseViewController {

  IBOutlet  UIWebView   * m_webview_helpinfo;
}

@property (nonatomic , strong) UIWebView   * m_webview_helpinfo;
@property (nonatomic , strong) NSMutableDictionary   *m_data_helpinfo;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             helpinfo:(NSMutableDictionary*)helpinfo;

@end
