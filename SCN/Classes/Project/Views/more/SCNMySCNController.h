//我的名鞋库

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "YKUserInfoUtility.h"
#import "YKButtonUtility.h"

@interface SCNMySCNController : BaseViewController <UITableViewDataSource,UITableViewDelegate,YKUserInfoUtilityDelegate,UIAlertViewDelegate>{
                                  
    BOOL             m_isRequestsuccess;                      //判断请求网络是否成功
    BOOL             m_isRequesting;                          //判断是否正在请求网络
}
@property (nonatomic, strong) NSNumber *m_request;

@property (nonatomic, strong) UIButton *m_button_logout;         //注销按钮
@property (nonatomic, strong) IBOutlet UITableView *m_tableview_myscn;  //我的名鞋库列表
@property (nonatomic, strong) NSArray *m_array_section1;
@property (nonatomic, strong) NSArray *m_array_section2;
@property (nonatomic, strong) YKUserDataInfo *m_userinfo;//装载用户临时数据模型


//注销按钮
-(IBAction)OnActionlogoutButtonPress:(id)sender;

//请求我的名鞋库
-(void)requestMySCNJSONData;
-(void)onRequestMySCNDataResponse:(id)json_obj;


-(void)dealAllView:(BOOL)isEnter;
@end
