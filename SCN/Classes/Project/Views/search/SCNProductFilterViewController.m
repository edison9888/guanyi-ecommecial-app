//
//  SCNProductFilterViewController.h
//  SCN
//
//  Created by xie xu on 11-10-13.
//  Copyright 2012年 Guanyi. All rights reserved.
//

#import "SCNProductFilterViewController.h"
#import "SCNProductFilterTableCell.h"
#import "SCNSearchData.h"
#import "YKHttpAPIHelper.h"
#import "YKStringHelper.h"
#import "YK_ButtonUtility.h"
#import "SCNAppDelegate.h"
#import "LeveyTabBarController.h"
#import "YKStatBehaviorInterface.h"

@implementation SCNProductFilterViewController
#define COLUMN_HEIGHT 6
#define BUTTON_HEIGHT 40
#define BUTTON_SPACE 12


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFilterDict:(NSMutableDictionary*)filterDict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.m_dict_filterData=filterDict;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setBackButtonStyle:self.m_backBtn];
	[self setBackText:@"返回" withButton:self.m_backBtn];
	
	self.pathPath = @"/filter";
    //初始化key条件数据
    self.m_array_keys=[self.m_dict_filterData allKeys];
    //初始化用户m_dict_userFilterData
    self.m_dict_userFilterData=[NSMutableDictionary dictionaryWithCapacity:0];
    for (int i=0; i<[self.m_array_keys count]; i++) {
        NSString *currKey=[self.m_array_keys objectAtIndex:i];
		NSArray *userFilterDataArray=[self.m_dict_filterData valueForKey:currKey];
		if (userFilterDataArray!=nil&&[userFilterDataArray count]>0) {
            SCNProductFilterItemData *tempData=[[SCNProductFilterItemData alloc] init];
            tempData.mid=@"";
            tempData.mcontent=@"";
            tempData.mname=[[userFilterDataArray objectAtIndex:0] mname];
            [self.m_dict_userFilterData setObject:tempData forKey:currKey];
        }
    }
	NSLog(@"create keys: %d", self.m_array_keys.count);
	[self.m_tableView_filterList reloadData];
//    for (int i=0; i<[self.m_array_keys count]; i++) {
//        //<><><><><>用户筛选记录提取
//        NSString *currKey=[self.m_array_keys objectAtIndex:i];
//        NSArray *userFilterDataArray=[self.m_dict_filterData valueForKey:currKey];
//        SCNProductFilterItemData *tempData=nil;
//        for (int j=0; j<[userFilterDataArray count]; j++) {
//            SCNProductFilterItemData *userfilterData=[userFilterDataArray objectAtIndex:j];
//            if (userfilterData.mselected) {
//                //tempData=[userfilterData retain];
//                tempData=[[SCNProductFilterItemData alloc] init];
//                tempData.mid=userfilterData.mid;
//                tempData.mcontent=userfilterData.mcontent;
//                tempData.mname=userfilterData.mname;
//                NSLog(@"有筛选记录<>key=>%@------value=>%@",currKey,tempData.mcontent);
//                [self.m_dict_userFilterData setObject:tempData forKey:currKey];
//                [tempData release];
//                break;
//            }else{
//                tempData=[[SCNProductFilterItemData alloc] init];
//                tempData.mid=@"";
//                tempData.mcontent=@"";
//                tempData.mname=@"";
//                [self.m_dict_userFilterData setObject:tempData forKey:currKey];
//                [tempData release];
//            }
//        }
        
        //<><><><><><>><<><><><><><>
        NSLog(@"%@",self.m_dict_userFilterData);
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.m_tableView_filterList=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    NSLog(@"筛选释放。。。。。。。。。。");
}
#pragma -
#pragma mark 保存筛选数据相关
//保存并传递筛选数据
-(IBAction)saveFilterData{
    //回调代理方法，传递筛选数值
    if (self.m_dict_userFilterData!=nil) {
		[self behaviorFilterData:self.m_dict_userFilterData];
        [self.m_delegate_filter receiveFilterData:self.m_dict_userFilterData];
    }
    [self dismissModalViewControllerAnimated:YES];
}
//取消筛选
-(IBAction)cancleFilter{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)reFreshVc
{
	[self dismissModalViewControllerAnimated:YES];
	SCNAppDelegate* delegate = (SCNAppDelegate*)[UIApplication sharedApplication].delegate;
	LeveyTabBarController* viewCtrl = (LeveyTabBarController*)delegate.viewController;
	[viewCtrl refreshCurrentViewController];
}
// 点击各种选项之后 就是打钩选中在这里
- (void)ChangeConditionWithFilterOptionData:(SCNProductFilterItemData *)filterOptionData{
	[self.m_dict_userFilterData setObject:filterOptionData forKey:filterOptionData.mdisplayName];
}
#pragma -
#pragma mark TableViewDelegate & TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row=[indexPath row];
    NSString *currKey=[self.m_array_keys objectAtIndex:row];
	NSArray *currArray=[self.m_dict_filterData valueForKey:currKey];
	CGFloat height = 0;
	if (currArray.count>0) {
		SCNProductFilterItemData *itemData=[currArray objectAtIndex:0];
		int counts=[currArray count];
		
		if([itemData.mname isEqualToString:@"size"])
		{
			int rows = (counts + 4) / 5;
			height = 32 + BUTTON_HEIGHT * rows + COLUMN_HEIGHT * (rows + 1);
			
		}
		else
		{
			int rows = (counts + 2) / 3;
			height = 32 + BUTTON_HEIGHT * rows + COLUMN_HEIGHT * (rows + 1);
		}
		
	}
    	return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_array_keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SCNProductFilterTableCell1";
    
    SCNProductFilterTableCell *cell = (SCNProductFilterTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"SCNProductFilterTableCell" owner:self options:nil];
		cell=[views objectAtIndex:0];
        cell.customIdentifier = CellIdentifier;
        cell.m_delegate=self;
    }
	int row=[indexPath row];
    NSString *currKey=[self.m_array_keys objectAtIndex:row];//eg. 品牌
	NSArray *currArray=[self.m_dict_filterData valueForKey:currKey];
	NSLog(@">>>>>>%d",currArray.count);
	[cell setConditionTitle:currKey withSelectOption:nil];
    [cell layoutWithOptions:currArray selectedOption:currKey];
	CGRect rect = cell.frame;
	rect.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
	cell.frame = rect; 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)behaviorFilterData:(NSMutableDictionary*)_filterDic{
#ifdef USE_BEHAVIOR_ENGINE
	NSMutableString* _param = [NSMutableString stringWithString:@""];
    NSArray *keys=[_filterDic allKeys];
    for (int i=0; i<[keys count]; i++) {
        NSString *currKey=[keys objectAtIndex:i];
        SCNProductFilterItemData *tempData=[_filterDic valueForKey:currKey];
        NSString *subStr=nil;
		if (tempData.mcontent && [tempData.mcontent length]>0) {
			subStr = [NSString stringWithFormat:@"%@|",strOrEmpty(tempData.mcontent)];
			[_param appendString:subStr];
		}
        
    }
	
	[YKStatBehaviorInterface logEvent_OperateWithOperateId:ACTION_FILTER param:_param];
#endif
}
@end
