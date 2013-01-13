//
//  SCNShoppingcartViewController.h
//  SCN
//
//  Created by huangwei on 11-9-26.
//  Copyright 2012 GuanyiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SCNShoppingcartData.h"

@class shoppingcartProductData;
@class OffShoppingCartData;

@interface SCNShoppingcartHeadView : UIView
{
	UIImageView* m_backImage;
	UILabel* m_originalPrice;			//原始价格
	UILabel* m_preferentailPrice;		//优惠价格
	UILabel* m_totalPrice;				//商品总价
	UILabel* m_productNumber;			//商品数量
	UIButton* m_btnAccount;				//结算按钮
	UILabel* m_labTitle;
}
@property(nonatomic,strong)UIImageView* m_backImage;
@property(nonatomic,strong)IBOutlet UILabel* m_originalPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_preferentailPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_totalPrice;
@property(nonatomic,strong)IBOutlet UILabel* m_productNumber;
@property(nonatomic,strong)IBOutlet UIButton* m_btnAccount;
@property(nonatomic,strong)IBOutlet UILabel* m_labTitle;
@end


//购物车页面scetion为0时的脚
@interface SCNShoppingcartAccountBtnView : UIView
{
	UILabel* m_labAccount;
	UIButton* m_btnAccount;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labAccount;
@property(nonatomic,strong)IBOutlet UIButton* m_btnAccount;

-(id)initWithFrame:(CGRect)frame;
@end

//购物车页面scetion为1时的头
@interface SCNShoppingcartListHeadView : UIView
{
	UILabel* m_labTitle;
}
@property(nonatomic,strong)IBOutlet UILabel* m_labTitle;

@end


@interface SCNShoppingcartViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate, UIAlertViewDelegate,UITextFieldDelegate> {
	UITableView* m_tableView;
	
	SCNShoppingcartAccountBtnView* m_footerView;
	SCNShoppingcartListHeadView* m_headView;
	
	SCNShoppingcartHeadView* m_shoppingcartHeadView;
	
	//NSMutableDictionary* m_operateDic;
	
	SCNShoppingcartData* m_shoppingcartData;
	
	BOOL isEdit;
	BOOL isDeledate;
	
	UIControl *controlArea;
	
	UITextField* __unsafe_unretained m_curTxt;
	
	UIView *noProductView; 
	
	BOOL isLoginBack;
	
	BOOL isDeleting;
	
	NSMutableString* m_skuRootString;
	
	CartData* m_willDeleteItem;
	
	BOOL isTxtFieldEmpty;
	BOOL isNumberExceed;
}

@property(nonatomic,strong)IBOutlet UITableView* m_tableView;
@property(nonatomic,strong)IBOutlet SCNShoppingcartAccountBtnView* m_footerView;
@property(nonatomic,strong)IBOutlet SCNShoppingcartListHeadView* m_headView;
//@property(nonatomic,retain)NSMutableDictionary* m_operateDic;
@property(nonatomic,strong)SCNShoppingcartData* m_shoppingcartData;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,assign)BOOL isDeledate;
@property(nonatomic,strong)IBOutlet SCNShoppingcartHeadView* m_shoppingcartHeadView;
@property(nonatomic,strong)UIControl *controlArea;
@property(nonatomic,unsafe_unretained)UITextField* m_curTxt;
@property(nonatomic,strong)IBOutlet UIView *noProductView;
@property(nonatomic,assign)BOOL isDeleting;
@property(nonatomic,strong)NSMutableString* m_skuRootString;
@property(nonatomic,strong)CartData* m_willDeleteItem;
@property(nonatomic,assign)BOOL isTxtFieldEmpty;
@property(nonatomic,assign)BOOL isNumberExceed;

#pragma mark data request&response
-(void)requestGetCartXmlData:(NSString*)_data;
-(void)onRequestGetCartXmlData:(GDataXMLDocument*)xmlDoc;
-(void)parseShoppingcartXmlDataResponse:(GDataXMLDocument*)xmlDoc;

#pragma mark set navigationbar
-(void)setNormalNavigationItem;                    //设置导航条

#pragma mark getShoppingData
-(void)getShoppingCartData;
#pragma mark getShoppingType
-(NSString*)getShoppingType;
#pragma mark update headdata
-(void)refreshHeadViewData;
#pragma mark reloadProductList
-(void)reloadSaveProductList:(NSArray*)list;
-(void)reloadSaveOffProductList:(NSArray*)list;
#pragma mark from shoppingcartProductData to OffShoppingCartData
-(OffShoppingCartData*)fromProductToOffShoppingCartData:(shoppingcartProductData*)_product;

#pragma mark modify textField
-(void)resignAllKeyboard;
-(void)textFielChange:(NSNotification*)notification;
-(void)startEditOrFinishEdit:(UIButton*)item;

#pragma mark gotoCashCenter
-(IBAction)goPayPriceCenter:(id)sender;

#pragma mark Delete shoppingcartProductData
-(void)preDeleteItem:(CartData*)_item indexPath:(NSIndexPath *)_indexPath;
-(void)confirmDeleteItem;
-(void)directDeleteInLocal:(CartData*)_cartData indexPath:(NSIndexPath *)_indexPath;
-(void)genPreDeleteShoppingCartData:(CartData*)_cartData;

-(void)dealwithColorSizeText:(shoppingcartProductData*)_productData label:(UILabel*)label;

-(void)popNumberExceedAlert;
-(void)popNumberZeroAlert;

//移除购物车行为统计
-(void)removeShoppingcartBehavior:(CartData*)_cartData;
@end

