

#import "SCNMySCNController.h"
#import "Go2PageUtility.h"
#import "SCNMyOrderFormViewController.h"
#import "SCNMycollectionViewController.h"
#import "SCNRegistViewController.h"
#import "SCNMyInformationViewController.h"
#import "SCNUserCommentaryViewController.h"
#import "SCNAddressListViewController.h"
#import "YKHttpAPIHelper.h"
#import "YKUserInfoUtility.h"
#import "SCNStatusUtility.h"
#import "YKButtonUtility.h"

#define LABELTAG_USERNAME      110
#define LABELTAG_CLASS         111
#define LABELTAG_CONSUME       112
#define LABELTAG_CELL          212 
#define LABELTAG_NEWMESSAGE    213
#define IMAGEVIEWTAG_CELLIMG   311

@implementation SCNMySCNController


-(BOOL)isNeedLogin
{
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad]; 
	self.title = @"我的名鞋库";
    self.pathPath = @"/myaccount";
	
    UIImage * _button_normal = [UIImage imageNamed:@"com_button_normal.png"];
    [self.m_button_logout setBackgroundImage:[_button_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
    
    UIImage * _button_select = [UIImage imageNamed:@"com_button_select.png"] ;
    [self.m_button_logout setBackgroundImage:[_button_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];

    
	NSArray *array1 = [[NSArray alloc] initWithObjects:@"我的订单",@"我的收藏",@"我的优惠券",@"我的评论",@"我的咨询",nil];
	self.m_array_section1 = array1;
	NSArray *array2 = [[NSArray alloc] initWithObjects:@"收货地址簿",@"个人资料设置",@"修改密码",nil];
	self.m_array_section2 = array2;
    
    //add Newmessage notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readNewmessage:) name:YK_MYSCNMESSAGE_READ object:nil];
    
    self.m_tableview_myscn.separatorColor = YK_CELLBORDER_COLOR;
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    self.m_tableview_myscn = nil;
    self.m_button_logout = nil;
	self.m_array_section1 = nil;
    self.m_array_section2 = nil;
}
- (void)dealloc {
    NSLog(@"我的名鞋库页面的dealloc调用");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self dealAllView:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (m_isRequesting && self.m_request != nil) {
        m_isRequesting = NO;
        [YKHttpAPIHelper cancelRequestByID:self.m_request];
        self.m_request = nil;
    }
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",self.m_request);
}

-(void)dealAllView:(BOOL)isEnter
{
	if (!m_isRequestsuccess && isEnter)
	{
		self.m_tableview_myscn.hidden = YES;
        [self requestMySCNJSONData];
	}
}
#pragma
#pragma mark - 注销按钮
-(IBAction)OnActionlogoutButtonPress:(id)sender{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:SCN_DEFAULTTIP_TITLE message:@"确定要注销吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertview show];
    
}
#pragma
#pragma mark - 注销方法回调
-(void)CallbackLogout:(BOOL)success errMsg:(NSString*)msg{
    [self stopLoading];
    NSLog(@"回调注销方法");
    if (success) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self startLoading];
        [K_YKUserInfoUtility onrequestLogoutUser:self];
    }
}

#pragma
#pragma mark -监听阅读信息
- (void)readNewmessage:(NSNotification *)notify
{
	[self requestMySCNJSONData];
    [self.m_tableview_myscn setHidden:YES];
}
#pragma
#pragma mark - 请求我的名鞋库
-(void)requestMySCNJSONData
{
    if (m_isRequesting) {
        return;
    }
    
    [self startLoading];
	m_isRequesting = YES;
    NSString* v_method = [YKStringUtility strOrEmpty:MMUSE_METHOD_UCENTER];
    NSDictionary* extraParam= @{@"method": v_method};
    
   self.m_request = [YKHttpAPIHelper startLoadJSONWithExtraParams:extraParam object:self onAction:@selector(onRequestMySCNDataResponse:)];
}
-(void)onRequestMySCNDataResponse:(id)json_obj
{
    [self stopLoading];
    m_isRequesting = NO;
	
//	SCNRequestResultData* _data = [[SCNRequestResultData alloc] init];
//	_data.merror_Code = 2;
    if ([SCNStatusUtility isRequestSuccessJSON:json_obj]){
        m_isRequestsuccess = YES;
        
        NSMutableDictionary* dict	=	[json_obj objectForKey:@"data"];
        
     
        YKUserDataInfo* _userinfo = [[YKUserDataInfo alloc] init];
        [_userinfo parseFromDictionary:dict];
        
        self.m_userinfo = _userinfo;
        [self.m_tableview_myscn reloadData];
        [self.m_tableview_myscn setHidden:NO];
    }
}

#pragma
#pragma mark - UITableview
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return 2;
	}else if (section == 1) {
		return [self.m_array_section1 count];
	}else {
		return [self.m_array_section2 count];
	}
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *TopCellIdentifier = @"TopCellIdentifier";
    NSString *MiddleCellIdentifier = @"MiddleCellIdentifier";
    NSString *DownCellIdentifier = @"DownCellIdentifier";
    
	NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
	UITableViewCell *cell = nil;
    if (section == 0) {
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:TopCellIdentifier];
            if (cell == nil) {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNMySCNTableCell" owner:self options:nil];
                cell = [xib objectAtIndex:0];
            }
            UILabel * _laber_username = (UILabel *)[cell viewWithTag:LABELTAG_USERNAME];
            _laber_username.text = self.m_userinfo.musername;
            
            UILabel * _laber_class = (UILabel *)[cell viewWithTag:LABELTAG_CLASS];
            _laber_class.text = self.m_userinfo.mclass;
            
            UILabel * _laber_consume = (UILabel *)[cell viewWithTag:LABELTAG_CONSUME];
            _laber_consume.text =[SCNStatusUtility getPriceString:self.m_userinfo.mconsume];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else {
             cell = [tableView dequeueReusableCellWithIdentifier:MiddleCellIdentifier];
            if (cell == nil) {
                NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNMySCNTableCell" owner:self options:nil];
                cell = [xib objectAtIndex:1];
            }
            UILabel * _laber_newmessage = (UILabel *)[cell viewWithTag:LABELTAG_NEWMESSAGE];
            _laber_newmessage.text = [NSString stringWithFormat:@"%@",self.m_userinfo.mnewMessage];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        }
        
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:DownCellIdentifier];
        if (cell == nil) {
            NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNMySCNTableCell" owner:self options:nil];
            cell = [xib objectAtIndex:2];
        }
        if (section == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            UILabel * _laber_cell = (UILabel *) [cell viewWithTag:LABELTAG_CELL];
            _laber_cell.text = [self.m_array_section1 objectAtIndex:[indexPath row]];
            if (row == 0) {
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_order.png"];
            }else if (row == 1){
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_collection.png"];
                
            }else if (row == 2){
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_voucher.png"];
                
            }else if (row == 3){
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_commentary.png"];
                
            }else if (row == 4){
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_consultation.png"];
                
            }
            
        }else if (section == 2){
            
            
            UILabel * _laber_cell = (UILabel *) [cell viewWithTag:LABELTAG_CELL];
            _laber_cell.text = [self.m_array_section2 objectAtIndex:[indexPath row]];
            if (row == 0) {
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_consigneeAdress.png"];
            }else if (row == 1){
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_informationset.png"];
                
            }else if (row == 2){
                UIImageView * _imageview_cell = (UIImageView *)[cell viewWithTag:IMAGEVIEWTAG_CELLIMG];
                _imageview_cell.image = [UIImage imageNamed:@"more_icon_changepassword.png"];
                
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
        
    cell.backgroundColor = [UIColor colorWithRed:(float)(236/255.0f) green:(float)(236/255.0f) blue:(float)(236/255.0f) alpha:1];
    
    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (section == 0) 
    {
        if (row == 1)
        {
            [Go2PageUtility go2MessageListViewController:self];
        }
    }
    else if (section == 1) 
    {
        if (row == 0) 
        {
            
            SCNMyOrderFormViewController *MyOrderForm = [[SCNMyOrderFormViewController alloc]initWithNibName:
                                                         @"SCNMyOrderFormViewController" bundle:nil];
            [Go2PageUtility showViewControllerNeedLogin:self toViewCtrl:MyOrderForm];
            
        }
        
        else if (row == 1) 
        {
            SCNMycollectionViewController *Mycollection = [[SCNMycollectionViewController alloc]initWithNibName:  
                                                           @"SCNMycollectionViewController" bundle:nil];
            [Go2PageUtility showViewControllerNeedLogin:self toViewCtrl:Mycollection];
        }
        
        else if (row == 2)
        {
            [Go2PageUtility go2MyVoucherViewController:self];
        }
        
        else if (row == 3)
        {
            [Go2PageUtility go2UserCommentaryViewController:self];
            
        }
        
        else if (row == 4)
        {
            [Go2PageUtility go2UserConsultationViewController:self productCode:nil];
        }
        
    }
    else if (section == 2)
    {
		if (row == 0) 
        {
			UIViewController* nextController = nil;
			nextController=[[SCNAddressListViewController alloc] initWithNibName:@"SCNAddressListViewController" bundle:nil];
			[(SCNAddressListViewController*)nextController setCurrentViewFromTag:myAddressTag];
			if (nextController!=nil) 
            {
				[self.navigationController pushViewController:nextController animated:YES];
			}
            
		}
        
        else if (row == 1) {
            [Go2PageUtility go2MyInformationViewController:self];
        }
        else {
            NSLog(@"===========");
            [Go2PageUtility go2RejiggerPasswordController:self];
        }
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = 71;
        }else {
            height = 37;
        }
    }
    else {
        height = 44;
    }
    
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView* _view_forhead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _view_forhead.backgroundColor = [UIColor whiteColor];
    if (section == 2) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
        [button setTitle:@"注销登录状态" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(30, 13, 259, 35)];
        
        UIImage * _button_normal = [UIImage imageNamed:@"com_button_normal.png"];
        [button setBackgroundImage:[_button_normal stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateNormal];
        
        UIImage * _button_select = [UIImage imageNamed:@"com_button_select.png"] ;
        [button setBackgroundImage:[_button_select stretchableImageWithLeftCapWidth:21 topCapHeight:14] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(OnActionlogoutButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [_view_forhead addSubview:button];
        
    }
    return _view_forhead;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 2;
    }else {
        return 65;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* _view_forhead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    _view_forhead.backgroundColor = [UIColor whiteColor];
    
    return _view_forhead; 
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
	return nil;
}

@end
