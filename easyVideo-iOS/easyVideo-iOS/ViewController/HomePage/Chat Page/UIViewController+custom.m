
#import "UIViewController+custom.h"
#import "CommDef.h"

@implementation UIViewController (custom)

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createBackItem
{ 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"btn_back"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = [UIDevice currentDevice].systemVersion.doubleValue>=11.0?CGRectMake(0, 10, 18, 18):CGRectMake(0, 10, 18, 18);
    //[button setImage:imageview forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 42, 40);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [view addSubview:imageview];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [space setWidth:-17];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,backButtonItem, nil];
}

-(void)createBackItem:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"icon_back"];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = [UIDevice currentDevice].systemVersion.doubleValue>=11.0?CGRectMake(0, 6, 26, 26):CGRectMake(0, 6, 26, 26);
    //[button setImage:imageview forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 42, 40);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [view addSubview:imageview];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [space setWidth:-17];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,backButtonItem, nil];
}

-(UIButton*)createRightItemWithImage:(UIImage*)image action:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 42, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 42, 40);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [space setWidth:-12];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, rightButtonItem, nil];
    
    return button;
}

-(UIButton*)createRightItemWithTitle:(NSString*)title action:(SEL)selector
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:STYLE_FONT_LIGHT(15.)];
    [button setTitleColor:COLOR_RED_BAR forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [space setWidth:-12];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, rightButtonItem, nil];
    
    return button;
}

-(void)customNavItem {
    UIFont *navTitleFont = [UIFont systemFontOfSize:NAV_TITLE_FONT];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     STYLE_COLOR, NSForegroundColorAttributeName,
                                                                     navTitleFont, NSFontAttributeName,
                                                                     nil]];
    [[UIBarButtonItem appearance] setTintColor:STYLE_COLOR];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:STYLE_COLOR];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                        forBarMetrics:UIBarMetricsDefault];
//    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 1)];
//    [navBorder setBackgroundColor:NAV_BAR_BORDER];
//    [navigationBar addSubview:navBorder];
}

-(void)customNavItem:(UINavigationController *)navController {
    UIFont *navTitleFont = [UIFont systemFontOfSize:NAV_TITLE_FONT];
    [navController.navigationBar setBarTintColor:TEXT_COLOR_MAIN_DARK];
    
    [navController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     STYLE_COLOR, NSForegroundColorAttributeName,
                                                                     navTitleFont, NSFontAttributeName,
                                                                     nil]];
    [[UIBarButtonItem appearance] setTintColor:STYLE_COLOR];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [navController.navigationBar setTintColor:STYLE_COLOR];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
//    UINavigationBar *navigationBar = navController.navigationBar;
//    [navigationBar setShadowImage:[UIImage new]];
//    [navigationBar setBackgroundImage:[[UIImage alloc] init]
//                        forBarMetrics:UIBarMetricsDefault];
//    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,navigationBar.frame.size.height-1,navigationBar.frame.size.width, 1)];
//    [navBorder setBackgroundColor:NAV_BAR_BORDER];
//    [navigationBar addSubview:navBorder];
}

-(void)customRightNav{
    UIFont *navTitleFont = [UIFont systemFontOfSize:NAV_TITLE_FONT];
    [self.navigationController.navigationBar setBarTintColor:TEXT_COLOR_MAIN_DARK];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     STYLE_COLOR, NSForegroundColorAttributeName,
                                                                     navTitleFont, NSFontAttributeName,
                                                                     nil]];
    [[UIBarButtonItem appearance] setTintColor:STYLE_COLOR];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:STYLE_COLOR];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                        forBarMetrics:UIBarMetricsDefault];
}

-(void)removeKeyboard
{
    [self.view endEditing:YES];
    //    [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:NO];
}

-(void)addGestureForKeyboardDismiss
{

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeKeyboard)];
//    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
}

-(UIFont *)adjustFont:(UIFont *)font{
    return font;
}

@end
