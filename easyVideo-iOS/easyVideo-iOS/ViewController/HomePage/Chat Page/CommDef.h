#define BARWIDTH ([UIScreen mainScreen].bounds.size.width * 0.1)

#define SYS_STATUSBAR_HEIGHT                20
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT            20
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATIONBAR_HEIGHT                44
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT                      44
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT                       44
#define APP_STATUSBAR_HEIGHT  (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define IS_HOTSPOT_CONNECTED  (APP_STATUSBAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)
//fix bug xode8 init frame 1000 1000
#define CELLICONWIDTH 38
#define CANTACTIMGWIDTH 100
#define CONTACTIMGBORDERWIDTH 110
#define IMGWIDTH_PERSON 98
#define IMGWIDTH_BORDER_PERSON 108

#define TAGNUM2 2000

#define NAV_TITLE_FONT 17
#define STYLE_COLOR [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:1]
#define STYLE_TINT_COLOR [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0]
#define STYLE_SECTION_COLOR [UIColor colorWithRed:239./255. green:239./255. blue:244./255. alpha:1]
#define STYLE_TEXT_COLOR [UIColor colorWithRed:121./255. green:121./255. blue:121./255. alpha:1]
#define NAV_BAR_BORDER [UIColor colorWithRed:247./255. green:247./255. blue:247./255. alpha:1]

#define MAIN_BG_COLOR [UIColor colorWithRed:244./255. green:244./255. blue:244./255. alpha:1]

#define SEPARATOR_COLOR [UIColor colorWithRed:223./255. green:223./255. blue:223./255. alpha:0.8]

#define TEXT_COLOR_1 [UIColor colorWithRed:35./255. green:35./255. blue:35./255. alpha:1]
#define TEXT_COLOR_2 [UIColor colorWithRed:145./255. green:145./255. blue:145./255. alpha:1]
#define TEXT_COLOR_MAIN_DARK [UIColor colorWithRed:247./255. green:247./255. blue:247./255. alpha:1]
#define TEXT_COLOR_GREEN [UIColor colorWithRed:43./255. green:187./255. blue:106./255. alpha:1]
#define TEXT_COLOR_BLUE [UIColor colorWithRed:31./255. green:158./255. blue:230./255. alpha:1]

//#157DFB
#define STYLE_DEFAULT_BLUE_COLOR [UIColor colorWithRed:21.0f/255.0f green:125.0f/255.0f blue:251.0f/255.0f alpha:1.0]
//#2ac426
#define STYLE_DEFAULT_GREEN_COLOR [UIColor colorWithRed:42.0f/255.0f green:196.0f/255.0f blue:38.0f/255.0f alpha:1.0]
//#dfdfdf
#define STYLE_TABLE_LINE_COLOR [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0]


//#20b964
#define COLOR_GREEN_1 [UIColor colorWithRed:32./255. green:185./255. blue:100./255. alpha:1]
//old green color
#define COLOR_GREEN_2 [UIColor colorWithRed:105./255. green:201./255. blue:117./255. alpha:1]

#define COLOR_GREEN_STATUS [UIColor colorWithRed:92./255. green:214./255. blue:146./255. alpha:1]
//#e3bf5d
#define COLOR_YELLOW_1 [UIColor colorWithRed:227./255. green:191./255. blue:93./255. alpha:1]

#define COLOR_YELLOW_STATUS [UIColor colorWithRed:251./255. green:209./255. blue:117./255. alpha:1]

//#EEEEEE
#define COLOR_GRAY_1 [UIColor colorWithRed:238./255. green:238./255. blue:238./255. alpha:1]

//#CCCCCC
#define COLOR_GRAY_2 [UIColor colorWithRed:204./255. green:204./255. blue:204./255. alpha:1]


#define COLOR_GRAY_3 [UIColor colorWithRed:223./255. green:223./255. blue:223./255. alpha:1]

#define COLOR_GRAY_4 [UIColor colorWithRed:224./255. green:224./255. blue:224./255. alpha:1]

#define COLOR_GRAY_225 [UIColor colorWithRed:225./255. green:225./255. blue:225./255. alpha:1]

#define COLOR_GRAY_193 [UIColor colorWithRed:193./255. green:193./255. blue:193./255. alpha:1]

#define COLOR_GRAY_241 [UIColor colorWithRed:241./255. green:241./255. blue:241./255. alpha:1]

#define COLOR_GRAY_5 [UIColor colorWithRed:229./255. green:229./255. blue:229./255. alpha:1]

#define COLOR_GRAY_TABLE_HEAD [UIColor colorWithRed:244./255. green:244./255. blue:244./255. alpha:1]

//#489ED3
#define COLOR_BLUE_1 [UIColor colorWithRed:72./255. green:158./255. blue:211./255. alpha:1]
//alert button txt color
#define COLOR_BLUE_2 [UIColor colorWithRed:0/255.0f green:121.0f/255.0f blue:255.0f/255.0f alpha:1.0]

#define COLOR_RED_1 [UIColor colorWithRed:245./255. green:112./255. blue:112./255. alpha:1]
#define COLOR_RED_BAR [UIColor colorWithRed:240./255. green:72./255. blue:72./255. alpha:1]
#define COLOR_RED_BUTTON [UIColor colorWithRed:237./255. green:81./255. blue:78./255. alpha:1]


#define COLOR_BLACK_0 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]
#define COLOR_BLACK_10 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]
#define COLOR_BLACK_15 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]
#define COLOR_BLACK_30 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define COLOR_BLACK_40 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define COLOR_BLACK_50 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
#define COLOR_BLACK_60 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]
#define COLOR_BLACK_70 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define COLOR_BLACK_80 [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
#define COLOR_BULE_VIDEO [UIColor colorWithRed:84.0f/255.0f green:168.0f/255.0f blue:240.0f/255.0f alpha:1.0]

#define COLOR_NEW_UPDATE [UIColor colorWithRed:249./255. green:101./255. blue:86./255. alpha:1]
#define COLOR_BASE_GREEN [UIColor colorWithRed:24.0f/255.0f green:178.0f/255.0f blue:71.0f/255.0f alpha:1.0]

//#define STYLE_FONT_LIGHT(fontSize) [UIFont fontWithName:@"STHeitiSC-Light" size:fontSize]
//#define STYLE_FONT_MEDIUM(fontSize) [UIFont fontWithName:@"STHeitiSC-Medium" size:fontSize]

#define STYLE_FONT_LIGHT(fontSize) [UIFont systemFontOfSize:fontSize]
#define STYLE_FONT_MEDIUM(fontSize) [UIFont boldSystemFontOfSize:fontSize]

//**************** Notifiation name define *******************************NTF_CONTACT_MESSAGE_CHANGE
#define NTF_CONTACT_MESSAGE_CHANGE @"NTF_CONTACT_MESSAGE_CHANGE"
#define NTF_SHOW_PLACECALLVIEW_REQUEST @"NTF_SHOW_PLACECALLVIEW_REQUEST"
#define NTF_FULL_SCREEN_WATCH_NEMO @"NTF_FULL_SCREEN_WATCH_NEMO"
#define NTF_EXIT_FULL_SCREEN_WATCH_NEMO @"NTF_EXIT_FULL_SCREEN_WATCH_NEMO"

#define MAIN_SCREEN [UIScreen mainScreen].bounds

typedef enum _CallDirection {
    CallDirection_Incomming,
    CallDirectione_Outgoing
}CallDirection;

typedef enum _DataType
{
    eDataType_Contact,
    eDataType_Device
} DataType;

typedef enum _PrivilegeType {
    ePrivilegeType_None = 0,
    ePrivilegeType_Invisible = 1,
    ePrivilegeType_Call = 2,
    ePrivilegeType_Watch = 4,
    ePrivilegeType_Managed = 8,
    ePrivilegeType_All = ePrivilegeType_Invisible|ePrivilegeType_Call|ePrivilegeType_Watch|ePrivilegeType_Managed
}PrivilegeType;

typedef enum _DeviceType {
    eDeviceType_Soft = 1,
    eDeviceType_Hard
}DeviceType;
