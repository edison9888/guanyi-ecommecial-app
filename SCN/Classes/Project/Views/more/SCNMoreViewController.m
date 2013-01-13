
#import "SCNMoreViewController.h"
#import "SCNMySCNController.h"
#import "SCNAppDelegate.h"
#import "SCNMyOrderFormViewController.h"
#import "SCNAnnalViewController.h"
#import "SCNMycollectionViewController.h"
#import "Go2PageUtility.h"
#import "SCNStatusUtility.h"
#import "SCNConfig.h"

#define CELL_LABLETAG             111
#define IMAGEVIEWTAG_CELLIMG      211
#define IMAGEVIEWTAG_PHONEIMG     311
#define BUTTONTAG_PHONEBUTTON     312

@implementation SCNMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.title = @"更多";
	self.pathPath = @"/more";
	NSArray *array1 = [[NSArray alloc] initWithObjects:@"品牌浏览",@"商品浏览记录",nil];
	self.section1 = array1;
	NSArray *array2 = [[NSArray alloc] initWithObjects:@"我的名鞋库",@"我的收藏",@"我的订单",nil];
	self.section2 = array2;
	NSArray *array3 = [[NSArray alloc] initWithObjects:@"帮助",@"关于",nil];
	self.section3 = array3;
	
    UITableView * temp_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [SCNStatusUtility getShowViewHeight]) style:UITableViewStyleGrouped];
    self.m_tableView = temp_tableview;
    
    self.m_tableView.backgroundColor = [UIColor clearColor];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    [self.view addSubview:self.m_tableView];
    
	self.m_tableView.separatorColor = YK_CELLBORDER_COLOR;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
    self.m_tableView = nil;
}



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section==0) {
		return 2;
	}else if (section==1) {
		return 3;
	}else if (section == 2){
		return 3;
	}
    return section;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *moreIndex = @"moreIndex";
    NSString *callphoneIdentifier = @"callphoneIdentifier";
    
	UITableViewCell *cell = nil;
	NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section) {
        case 0:
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:moreIndex];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:moreIndex];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                UILabel* _label = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 158, 18)];
                _label.font = [UIFont systemFontOfSize:14.0f];
                _label.tag = CELL_LABLETAG;
                _label.lineBreakMode=0;
                _label.backgroundColor = [UIColor clearColor];
                
                UIImageView* imageview_select = [[UIImageView alloc] initWithFrame:CGRectMake(272, 9, 9, 16)];
                imageview_select.image = [UIImage imageNamed:@"com_arrow.png"];
                
                UIImageView* _imageview_cellimg = [[UIImageView alloc ] initWithFrame:CGRectMake(11, 12, 18, 18)];
                _imageview_cellimg.tag = IMAGEVIEWTAG_CELLIMG;
                
                [cell.contentView addSubview:imageview_select];
                [cell.contentView addSubview:_imageview_cellimg];
                [cell.contentView addSubview:_label];
                
            }  
            if (section == 0) {
                
                if (row == 0) {
                    UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                    _imageview_cell.image = [UIImage imageNamed:@"more_icon_brand.png"];
                }else if (row == 1) {
                    UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                    _imageview_cell.image = [UIImage imageNamed:@"more_icon_annal.png"];
                }
                
                UILabel* _label = (UILabel*)[cell viewWithTag:CELL_LABLETAG];
                _label.text = [self.section1 objectAtIndex:[indexPath row]];
                
            }else if (section == 1) {
                if (row == 0) {
                    UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                    _imageview_cell.image = [UIImage imageNamed:@"more_icon_myscn.png"];
                }else if (row == 1) {
                    UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                    _imageview_cell.image = [UIImage imageNamed:@"more_icon_collection.png"];
                }else if (row == 2) {
                    UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                    _imageview_cell.image = [UIImage imageNamed:@"more_icon_order.png"];
                }
                
                UILabel* _label = (UILabel*)[cell viewWithTag:CELL_LABLETAG];
                _label.text = [self.section2 objectAtIndex:[indexPath row]];
                
            }
                
            
        }
            break;
            
        case 2:{
            switch (row ) {
                case 0:
                case 1:{
                    cell = [tableView dequeueReusableCellWithIdentifier:moreIndex];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:moreIndex];
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        
                        UILabel* _label = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 158, 18)];
                        _label.font = [UIFont systemFontOfSize:14.0f];
                        _label.tag = CELL_LABLETAG;
                        _label.lineBreakMode=0;
                        _label.backgroundColor = [UIColor clearColor];
                        
                        UIImageView* imageview_select = [[UIImageView alloc] initWithFrame:CGRectMake(272, 9, 9, 16)];
                        imageview_select.image = [UIImage imageNamed:@"com_arrow.png"];
                        
                        UIImageView* _imageview_cellimg = [[UIImageView alloc ] initWithFrame:CGRectMake(11, 12, 18, 18)];
                        _imageview_cellimg.tag = IMAGEVIEWTAG_CELLIMG;
                        
                        [cell.contentView addSubview:imageview_select];
                        [cell.contentView addSubview:_imageview_cellimg];
                        [cell.contentView addSubview:_label];
                        
                    }
                    if (row == 0) {
                        UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                        _imageview_cell.image = [UIImage imageNamed:@"more_icon_help.png"];
                        
                        UILabel* _label = (UILabel*)[cell viewWithTag:CELL_LABLETAG];
                        _label.text = [self.section3 objectAtIndex:[indexPath row]];
                        
                    }else if (row == 1) {
                        
                        UIImageView* _imageview_cell = (UIImageView*)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                        _imageview_cell.image = [UIImage imageNamed:@"more_icon_about.png"];
                        
                        UILabel* _label = (UILabel*)[cell viewWithTag:CELL_LABLETAG];
                        _label.text = [self.section3 objectAtIndex:[indexPath row]];
                    }
                    break;
                    
                }
                case 2: {
                    cell = [tableView dequeueReusableCellWithIdentifier:callphoneIdentifier];
                    if (cell == nil) {
                        
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:callphoneIdentifier];
                        UIImageView* _imageview_phone = [[UIImageView alloc ] initWithFrame:CGRectMake(65, 8, 22, 21)];
                        _imageview_phone.tag = IMAGEVIEWTAG_PHONEIMG;
                        
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        button.tag = BUTTONTAG_PHONEBUTTON;  
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [button setFrame:CGRectMake(40, 5, 220, 30)];
                        
                        [cell.contentView addSubview:button];
                        [cell.contentView addSubview:_imageview_phone];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIImageView * _imageview_phone = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_PHONEIMG];
                    _imageview_phone.image = [UIImage imageNamed:@"com_phone.png"];
                    
                    
                    UIButton * button = (UIButton *)[cell viewWithTag:BUTTONTAG_PHONEBUTTON];
                    [button setTitle:YK_DISPLAY400PHONE_NUMBER forState:UIControlStateNormal];
                    
                    
                    UIImage * _button_normal = [UIImage imageNamed:@"com_button_normal.png"];
                    [button setBackgroundImage:[_button_normal stretchableImageWithLeftCapWidth:21 topCapHeight:0] forState:UIControlStateNormal];
                    
                    UIImage * _button_select = [UIImage imageNamed:@"com_button_select.png"] ;
                    [button setBackgroundImage:[_button_select stretchableImageWithLeftCapWidth:21 topCapHeight:0] forState:UIControlStateHighlighted];
                    [button addTarget:self action:@selector(pressPhone:) forControlEvents:UIControlEventTouchUpInside];
                
                }  
            
            }    
            
        }
            
    }
    cell.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ([indexPath section] == 0) {
        
		switch ([indexPath row]) {
			case 0:
				//品牌浏览
                [Go2PageUtility go2BrandClassifiedViewController:self withFatherId:nil];                
    			break;
			case 1:
				//商品浏览记录
                [Go2PageUtility go2AnnalViewController:self];     
				break;
			default:
				break;
		}
	}
	else if ([indexPath section] == 1) {
        
		switch ([indexPath row]) {
			case 0:{
                //我的名鞋库
                SCNMySCNController *MySCN = [[SCNMySCNController alloc]initWithNibName:
                                             @"SCNMySCNController" bundle:nil];
			    [Go2PageUtility showViewControllerNeedLogin:self toViewCtrl:MySCN];

            }
                break;
			case 1:{
				//我的收藏
                SCNMycollectionViewController *Mycollection = [[SCNMycollectionViewController alloc]initWithNibName:  
                                            @"SCNMycollectionViewController" bundle:nil];
                [Go2PageUtility showViewControllerNeedLogin:self toViewCtrl:Mycollection];
            }
				break;
			case 2:{
				//我的订单
                SCNMyOrderFormViewController *MyOrderForm = [[SCNMyOrderFormViewController alloc]initWithNibName:
                                                             @"SCNMyOrderFormViewController" bundle:nil];
                [Go2PageUtility showViewControllerNeedLogin:self toViewCtrl:MyOrderForm];
            }
				break;
			default:
				break;
		}
	}
	else {
		switch ([indexPath row]) {
			case 0:
				//帮助
                [Go2PageUtility go2HelpViewController:self];
				break;
			case 1:
				//关于
                [Go2PageUtility go2AboutViewController:self];
                break;
			default:
				break;
		}
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* _view_forhead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _view_forhead.backgroundColor = [UIColor whiteColor];
    
    return _view_forhead; 


}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    else
    {
        return 1;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* _view_forhead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _view_forhead.backgroundColor = [UIColor whiteColor];
    
    return _view_forhead; 
}
-(IBAction) pressPhone:(id)sender{
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000216161"]];
    [SCNStatusUtility makeCall:YK_400PHONE_NUMBER];
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}

@end
