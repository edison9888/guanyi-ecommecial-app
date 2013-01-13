

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SCNMoreViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSArray *section1; //块1的数据
@property (nonatomic,strong) NSArray *section2; //块2的数据
@property (nonatomic,strong) NSArray *section3; //块3的数据
@property (nonatomic,strong) IBOutlet UITableView* m_tableView;


-(IBAction) pressPhone:(id)sender;  //点击电话

-(NSString*)pageJumpParam;


@end
