//
//  Utils.m
//  easyVideo-iOS
//
//  Created by quanhao huang on 2020/1/19.
//  Copyright © 2020 quanhao huang. All rights reserved.
//

#import "Utils.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
@implementation Utils

+ (void)setRemoteVideo:(NSArray *)arr{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    void * remoteArr[4];
    for (int i = 0; i<arr.count; i++) {
        UIView *view = arr[i];
        remoteArr[i] = (__bridge void *)view;
    }
    [app.evengine setRemoteVideoWindow:remoteArr andSize:4];
}

+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)                                        options:NSStringDrawingUsesLineFragmentOrigin                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}                                        context:nil];
    return rect.size.width;
}

+ (UIColor *)colorWithHexString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)judgeString:(NSString *)content
{
    //可以包含空格
    NSString *newcontent = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    //判断特殊字符正则表达式
    NSString * nameCharacters = @"[ \\~\\!\\/\\@\\#\\$\\%\\^\\&#\\$\\%\\^\\&amp;\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\&#\\$\\%\\^\\&amp;\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\&lt;\\.\\&#\\$\\%\\^\\&amp;\\*\\(\\)\\-\\_\\=\\+\\\\\\|\\[\\{\\}\\]\\;\\:\\\'\\\"\\,\\&lt;\\.\\&gt;\\/\\?]";
    
    NSPredicate * isSpecialCharacter =  [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nameCharacters];
    
    if (![isSpecialCharacter evaluateWithObject:newcontent]) {
        return content;
    }
    return @"Iphone";
}

+ (NSMutableDictionary *)getURLParameters:(NSString *)url {
    
    // 查找参数
    NSRange range = [url rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 截取参数
    NSString *parametersString = [url substringFromIndex:range.location + 1];
    
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        
        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                } else {
                    
                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }
                
            } else {
                
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数
        
        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }
        
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }
        
        // 设置值
        [params setValue:value forKey:key];
    }
    
    return params;
}

+ (void)backToRootViewcontroller{
    
    UIViewController *vc =  [self jsd_getCurrentViewController];
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

+ (UIViewController *)jsd_getCurrentViewController{

    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {

            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {

          UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];

        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {

          UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {

            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {

                currentViewController = currentViewController.childViewControllers.lastObject;

                return currentViewController;
            } else {

                return currentViewController;
            }
        }

    }
    return currentViewController;
}

+ (UIViewController *)jsd_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}

+ (void)setSpeaker
{
    //设置扬声器
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //录音+播放
    if (@available(iOS 10.0, *)) {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeVideoChat options:AVAudioSessionCategoryOptionDuckOthers|AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    } else {
        
    }
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [session setActive:YES error:nil];
}

+ (BOOL)isHeadSetPlugging {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortBuiltInReceiver] || [[desc portType] isEqualToString:AVAudioSessionPortBuiltInSpeaker])
            return NO;
    }
    return YES;
}

+ (void)setReceiver {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
}

+ (void)showAlert:(NSString *)title oneBtn:(NSString *)btnTitle1 twoBtn:(NSString *)btnTitle2 block:(AlertBtnActionBlock)block {
    [LEEAlert actionsheet].config
    .LeeContent(title)
    .LeeDestructiveAction(btnTitle1, ^{
        
        if (block) {
            block(YES);
        }
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = btnTitle2;
        
        action.titleColor = [UIColor blackColor];
        
        action.font = [UIFont systemFontOfSize:18.0f];
        
        if (block) {
            block(NO);
        }
    })
    .LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
    .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}

+ (void)showCameraAlert:(NSString *)btnTitle1 twoBtn:(NSString *)btnTitle2 threeBtn:(NSString *)btnTitle3 block:(AlertBtnActionBlock)block {
    [LEEAlert actionsheet].config
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = btnTitle1;
        
        action.titleColor = [UIColor blackColor];
        
        action.font = [UIFont systemFontOfSize:18.0f];
        
        action.clickBlock = ^{
            if (block) {
                block(YES);
            }
        };

    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = btnTitle2;
        
        action.titleColor = [UIColor blackColor];
        
        action.font = [UIFont systemFontOfSize:18.0f];
        
        action.clickBlock = ^{
            if (block) {
                block(NO);
            }
        };
 
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = btnTitle3;
        
        action.titleColor = [UIColor blackColor];
        
        action.font = [UIFont systemFontOfSize:18.0f];

    })
    .LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
    .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}

+ (CAGradientLayer *)addgradientLayer:(UIColor *)startColor withEndColor:(UIColor *)endColor view:(UIView *)view
{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}

+ (NSMutableArray *)defaultEmoticons {

    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

//时间显示内容
+ (NSString *)getDateDisplayString:(long long)miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"aaa hh:mm";
            
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"昨天 aaahh:mm";

        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                
                dateFmt.AMSymbol = @"上午";
                dateFmt.PMSymbol = @"下午";
                
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日 aaahh:mm";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一 aaahh:mm";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二 aaahh:mm";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三 aaahh:mm";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四 aaahh:mm";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五 aaahh:mm";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六 aaahh:mm";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}

static NSDateFormatter *sUserVisibleDateFormatter = nil;
+ (NSString *)userVisibleDateTimeStringForRFC3339DateTimeString:(NSString *)rfc3339DateTimeString {
    /*
      Returns a user-visible date time string that corresponds to the specified
      RFC 3339 date time string. Note that this does not handle all possible
      RFC 3339 date time strings, just one of the most common styles.
     */

    // If the date formatters aren't already set up, create them and cache them for reuse.
    static NSDateFormatter *sRFC3339DateFormatter = nil;
    if (sRFC3339DateFormatter == nil) {
        sRFC3339DateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [sRFC3339DateFormatter setLocale:enUSPOSIXLocale];
        if (rfc3339DateTimeString.length == 20) {
            //example 2019-12-14T06:37:56Z
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        }else if (rfc3339DateTimeString.length == 22) {
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S'Z'"];
        }else if (rfc3339DateTimeString.length == 23) {
            //example 2019-12-14T07:36:46.61Z yyyy-MM-dd'T'HH:mm:ss.SS'Z'
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS'Z'"];
        }else {
            //example 2019-12-14T06:36:42.184Z
            [sRFC3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sss.SSS'Z'"];
        }
        [sRFC3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }

    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *date = [sRFC3339DateFormatter dateFromString:rfc3339DateTimeString];
    NSString *userVisibleDateTimeString;
    
    if (date != nil) {
        long long timeSp = [date timeIntervalSince1970]*1000;
        userVisibleDateTimeString = [Utils getDateDisplayString:timeSp];
    }
    return userVisibleDateTimeString;
}

+ (EVContactInfo *)getContactInfo:(NSString *)evuserId
{
    AppDelegate *appDelegate = APPDELEGATE;
    return [appDelegate.evengine getContactInfo:[evuserId UTF8String] timeout:3];
}

+ (UINavigationController *)currentNC
{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

+ (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc
{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
    }
    else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }
        else {
            return vc.navigationController;
        }
    }
    else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}

+ (BOOL)judgeSpecialCharacter:(NSArray *)arr withStr:(NSString *)str {
    
    for (NSInteger i = 0; i < arr.count; i++) {
        if ([str rangeOfString:arr[i]].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

+ (void)saveImage:(UIImage *)image
{
    NSString *filePath = [[FileTools getDocumentsFailePath] stringByAppendingPathComponent:@"header.jpg"];
    
    if ([FileTools isExistWithFile:filePath]) {
        [FileTools deleteTheFileWithFilePath:filePath];
    }
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:filePath atomically:YES];
}

+ (void)sortingMessage:(MessageBody *)body
{
    body.time = [Utils userVisibleDateTimeStringForRFC3339DateTimeString:body.time];
    
    [[EMMessageManager sharedInstance] selectEntity:nil ascending:true filterString:nil success:^(NSArray * _Nonnull results) {
        
        if (results.count == 0) {
            [[EMMessageManager sharedInstance] insertNewEntity:body success:^{
                
            } fail:^(NSError * _Nonnull error) {
                
            }];
            
            [[EMManager sharedInstance].delegates onMessageReciveData:body];
        }else {
            BOOL flag = NO;
            for (MessageBody *message in results) {
                if (message.seq == body.seq) {
                    flag = NO;
                    break;
                }else {
                    flag = YES;
                }
            }
            
            if (flag) {
                [[EMMessageManager sharedInstance] insertNewEntity:body success:^{
                    
                } fail:^(NSError * _Nonnull error) {
                    
                }];
                
                [[EMManager sharedInstance].delegates onMessageReciveData:body];
            }
        }
        
    } fail:^(NSError * _Nonnull error) {
        
    }];
}

@end
