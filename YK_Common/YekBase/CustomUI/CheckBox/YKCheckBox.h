#import <UIKit/UIKit.h>


@interface YKCheckBox : UIButton {
	BOOL isChecked;
}
@property (nonatomic,assign) BOOL isChecked;
-(BOOL) checkBoxClicked;
@end
