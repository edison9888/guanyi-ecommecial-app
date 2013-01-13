//
//  SCNMyVoucherViewController.m
//  SCN
//
//  Created by chenjie on 11-10-17.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import "SCNMyVoucherViewController.h"
#import "YKHttpAPIHelper.h"
#import "YKStringUtility.h"
#import "SCNUserCouponData.h"
#import "YKButtonUtility.h"

#define LABELTAG_COUPONID     101
#define LABELTAG_PARVALUE     102
#define LABELTAG_STATE        103
#define LABELTAG_EFFECTIVE    104

@implementation SCNMyVoucherViewController

@synthesize m_mutarray_usercoupon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)isNeedLogin
{
	return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    m_tableview_voucher = nil;
    self.m_mutarray_usercoupon = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    NSLog(@"我的优惠券dealloc页面调用");
}


#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!m_isRequestsuccess) {
        [m_tableview_voucher setHidden:YES];
        [self onRequestmyvoucher];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.pathPath = @"/coupon";
    m_tableview_voucher.separatorColor = YK_CELLBORDER_COLOR;
    // Do any additional setup after loading the view from its nib.
}
-(void)onRequestmyvoucher
{
    if (m_isRequesting) {
        return;
    }
    m_isRequesting = YES;
    [self startLoading];
    NSString* v_method =  [YKStringUtility strOrEmpty:YK_METHOD_GET_COUPONLIST];
    
    NSDictionary* extraParam = @{@"act": v_method};	
    
    [YKHttpAPIHelper startLoad:SCN_URL extraParams:extraParam object:self onAction:@selector(parsemyvoucher:)];
    
}

-(void)parsemyvoucher:(GDataXMLDocument*)xmlDoc
{
    m_isRequesting = NO;
    [self stopLoading];
    if ([SCNStatusUtility isRequestSuccess:xmlDoc]) {
        m_isRequestsuccess = YES;
        NSString* xpath = [ NSString stringWithFormat:@"//shopex/info/data_info/coupons/coupon"];
        NSArray* nodeArray	=	[xmlDoc nodesForXPath:xpath error:nil];
        self.m_mutarray_usercoupon = [NSMutableArray arrayWithCapacity:0];
        
        for (GDataXMLElement* _e in nodeArray) {
            SCNUserCouponData* usercoupon = [[SCNUserCouponData alloc]init];
            [usercoupon parseFromGDataXMLElement:_e];
            [self.m_mutarray_usercoupon addObject:usercoupon];
        }
}
    if ([self.m_mutarray_usercoupon count] > 0) {
        [m_tableview_voucher reloadData];
        [m_tableview_voucher setHidden:NO];
        [self hideNotecontent];
        
    }else{
        [self showNotecontent:@"您暂无可使用优惠劵."];
    
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [m_mutarray_usercoupon count];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //SCNUserCouponData* usercoupon = [[SCNUserCouponData alloc]init];	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCNMyVoucher_Cell"];
	if (cell == nil) {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"SCNMyVoucher_Cell" owner:self options:nil];
        cell = [xib objectAtIndex:0];
        UIView * _view_bgcellview = (UIView *) [YKButtonUtility initBgCornerViewWithHeight:70 cornerRadius:5];
        [cell.contentView insertSubview:_view_bgcellview atIndex:0];
        
    }
    
    UILabel* _label_couponId = (UILabel*)[cell viewWithTag:LABELTAG_COUPONID];
    UILabel* _label_parvalue = (UILabel*)[cell viewWithTag:LABELTAG_PARVALUE];
    UILabel* _label_state = (UILabel*)[cell viewWithTag:LABELTAG_STATE];
    UILabel* _label_effective = (UILabel*)[cell viewWithTag:LABELTAG_EFFECTIVE];
    
    SCNUserCouponData* usercoupon = [m_mutarray_usercoupon objectAtIndex:[indexPath row]];
    
    _label_couponId.text = usercoupon.mcouponId;
    _label_parvalue.text = [NSString stringWithFormat:@"¥ %@元",usercoupon.mparvalue];
    
    if ([usercoupon.mstatus isEqualToString:@"0"]) {
        _label_state.text = @"不可使用";
    }else{
    
        _label_state.text = @"可以使用";
    }
    _label_effective.text = usercoupon.meffective;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSString*)pageJumpParam{
#ifdef USE_BEHAVIOR_ENGINE
	return nil;
#endif
}

@end
