
#import <UIKit/UIKit.h>

@interface UIViewController (custom)
#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_X ([[UIScreen mainScreen] bounds].size.height == 812.0f)

#define IPHONE_X_RATIO 0.821
#define TABLE_CELL_H_5 45
#define TABLE_CELL_H_6 45
#define TABLE_CELL_H_PLUS 50

#define TABLE_CELL_H_IMG 80
-(void)createBackItem;
-(void)createBackItem:(SEL)selector;
-(UIButton*)createRightItemWithImage:(UIImage*)image action:(SEL)selector;
-(UIButton*)createRightItemWithTitle:(NSString*)title action:(SEL)selector;

-(void)addGestureForKeyboardDismiss;
-(void)customNavItem;
-(void)customNavItem:(UINavigationController *) navController;
-(UIFont *)adjustFont:(UIFont *)font;

@end
