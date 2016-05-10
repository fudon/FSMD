//
//  FDDClass.m
//  FDDClass
//
//  Created by HYYT on 14-5-15.
//  Copyright (c) 2014年 hyw_fdd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FuData.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/ASIdentifierManager.h>
//#import "QREncoder.h"
#include <net/if.h>
#include <net/if_dl.h>
#import "FuSoft.h"
#import "sys/utsname.h"

#define FUDATAKEY_LOGINFLAG    @"FUDATAKEY_LOGINFLAG"
#define FUDATAKEY_FIRSTHANDLE  @"FUDATAKEY_FIRSTHANDLE"

#define kChosenDigestLength     CC_SHA1_DIGEST_LENGTH
#define DESKEY @"D6D2402F1C98E208FF2E863AA29334BD65AE1932A821502D9E5673CDE3C713ACFE53E2103CD40ED6BEBB101B484CAE83D537806C6CB611AEE86ED2CA8C97BBE95CF8476066D419E8E833376B850172107844D394016715B2E47E0A6EECB3E83A361FA75FA44693F90D38C6F62029FCD8EA395ED868F9D718293E9C0E63194E87"

static CGRect oldframe;

@implementation FuData

- (void)dealloc
{
    
}

+ (void)nilUserdefaultWithKey:(NSString *)key
{
    NSUserDefaults *fdd = [NSUserDefaults standardUserDefaults];
    [fdd setObject:@"" forKey:key];
    [fdd synchronize];
}

+ (void)showAlertViewWithTitile:(NSString *)string
{
    UIAlertView *aView = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [aView show];
}

+ (void)copyToPasteboard:(NSString *)copyString
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:copyString];
}

+ (void)userDefaultsKeepData:(id)instance  withKey:(NSString *)key
{
    NSUserDefaults *fdd = [NSUserDefaults standardUserDefaults];
    [fdd setObject:instance forKey:key];
    [fdd synchronize];
}

+ (id)userDefaultsDataWithKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)isFirstStart
{
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    //NSString *versionNum =[infoDict objectForKey:@"CFBundleVersion"];// 获取Build版本号
    NSString *versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
        
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *version = [first objectForKey:FIRSTSTARTFC];
    if (version) {
        if ([version isEqualToString:versionNum]) {
            return NO;
        }else{
            [first setObject:versionNum forKey:FIRSTSTARTFC];
            [first synchronize];
            return YES;
        }
    }else{
        [first setObject:versionNum forKey:FIRSTSTARTFC];
        [first synchronize];
        return YES;
    }
    return YES;
}

+ (BOOL)checkLoginSuccess
{
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *loginFlag = [first objectForKey:FUDATAKEY_LOGINFLAG];
    if (loginFlag && [loginFlag isEqualToString:FUDATAKEY_LOGINFLAG]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)checkLoginSuccess:(BOOL)saveOrClear
{
    NSUserDefaults *dyd = [NSUserDefaults standardUserDefaults];
    if (saveOrClear) {
        [dyd setObject:FUDATAKEY_LOGINFLAG forKey:FUDATAKEY_LOGINFLAG];
    }else{
        [dyd setObject:@"" forKey:FUDATAKEY_LOGINFLAG];
    }
    [dyd synchronize];
}

+ (BOOL)checkFirstHandle
{
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    NSString *loginFlag = [first objectForKey:FUDATAKEY_FIRSTHANDLE];
    if ([loginFlag isEqualToString:FUDATAKEY_FIRSTHANDLE]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)checkFirstHandle:(BOOL)saveOrClear
{
    NSUserDefaults *first = [NSUserDefaults standardUserDefaults];
    if (saveOrClear) {
        [first setObject:FUDATAKEY_FIRSTHANDLE forKey:FUDATAKEY_FIRSTHANDLE];
    }else{
        [first setObject:@"" forKey:FUDATAKEY_FIRSTHANDLE];
    }
    [first synchronize];
}

+ (void)showImage:(UIImageView *)avatarImageView
{
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    }completion:^(BOOL finished) {
        
    }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha=0;
    }completion:^(BOOL finished) {
        [backgroundView
         removeFromSuperview];
    }];
}

+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

+ (float)folderSizeAtPath:(NSString*)folderPath extension:(NSString *)extension
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        if (extension) {
            if ([[fileAbsolutePath pathExtension] isEqualToString:extension]) {
                folderSize += [self fileSizeAtPath:fileAbsolutePath];
            }
        }else{
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
//    return folderSize / (1024.0 * 1024.0);
    return folderSize / 1024.0;
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (CGFloat)textHeight:(NSString *)text fontInt:(NSInteger)fontInt labelWidth:(CGFloat)labelWidth
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRange allRange = [text rangeOfString:text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:fontInt]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];
    
    NSRange destRange = [text rangeOfString:text];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:destRange];
    
    CGFloat titleHeight;
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height);
//    return titleHeight + 2;  // 加两个像素,防止emoji被切掉.
    return titleHeight;
}

+ (double)distanceBetweenCoordinate:(CLLocationCoordinate2D)coordinateA toCoordinateB:(CLLocationCoordinate2D)coordinateB
{
    static double EARTH_RADIUS = 6378.137;//地球半径
    
    double lat1 = coordinateA.latitude;
    double lng1 = coordinateA.longitude;
    double lat2 = coordinateB.latitude;
    double lng2 = coordinateB.longitude;
    
    double radLat1 = [self rad:lat1];
    double radLat2 = [self rad:lat2];
    double a = radLat1 - radLat2;
    double b = [self rad:lng1] - [self rad:lng2];

    double s = 2 * sin(sqrt(pow(sin(a/2),2) + cos(radLat1) * cos(radLat2)* pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    return s;
}

+ (double)rad:(double)d
{
    return d * 3.141592653 / 180.0;
}

+ (NSArray *)maxandMinNumberInArray:(NSArray *)array
{
    if (array.count == 0) {
        return nil;
    }
    int i;
    double max = [array[0] doubleValue];
    double min = max;
    
     for (i = 1; i < array.count; i++)
     {
        CGFloat number = [array[i] doubleValue];
         
        if (number > max)
               max = number;
         
       if (number < min)
                min = number;
          }
    return @[@(max),@(min)];
}

+ (NSArray *)maopaoArray:(NSArray *)array
{
    if (array.count == 0) {
        return nil;
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:array];
    for (int x = 0; x < mArray.count - 1; x ++) {
        for (int y = 0; y < mArray.count - 1 - x; y ++) {
            double first = [mArray[y] floatValue];
            double second = [mArray[y + 1] floatValue];
            if (first > second) {
                double temp = first;
                [mArray replaceObjectAtIndex:y withObject:@(second)];
                [mArray replaceObjectAtIndex:y+1 withObject:@(temp)];
            }
        }
    }
    return mArray;
}

+ (NSArray *)addCookies:(NSArray *)nameArray value:(NSArray *)valueArray cookieDomain:(NSString *)cookName
{
    if (nameArray.count != valueArray.count) {
        return nil;
    }
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < nameArray.count; x ++) {
        NSMutableDictionary *cookieProperties = [[NSMutableDictionary alloc] init];
        [cookieProperties setObject:nameArray[x] forKey:NSHTTPCookieName];
        [cookieProperties setObject:valueArray[x] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookName forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookName forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [cookieArray addObject:cookie];
    }
    return cookieArray;
}

+ (NSString *)appVersionNumber
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appName
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleDisplayName"];
}

+ (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSDate *)dateFromStringByHotline:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([string isKindOfClass:[NSString class]] && string.length == 0) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];  // 仍然会有8个小时的误差
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
    [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [dateFormatter dateFromString:string];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

+ (NSDate *)dateFromStringByHotlineWithoutSeconds:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    if ([string isKindOfClass:[NSString class]] && string.length == 0) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date= [dateFormatter dateFromString:string];
    return date;
}

+ (NSDate *)chinaDateByDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date dateByAddingTimeInterval: interval];
}

+ (NSDate *)chinaDateByTimeInterval:(NSString *)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]];
    NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date dateByAddingTimeInterval: interval];
}

//+ (UIImage *)QRImageFromString:(NSString *)string
//{
//    return [QREncoder encode:string];
//}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    CGContextSetLineWidth(context,2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    //在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (NSURL *)convertTxtEncoding:(NSURL *)fileUrl
{
    NSString *filePath = [fileUrl path];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        if ( [[manager attributesOfItemAtPath:filePath error:nil] fileSize] > 1024*1024.0f) {
            return fileUrl;
        }
    }
    
    NSString *tmpFilePath = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), [fileUrl lastPathComponent]];
    NSLog(@"tmpFilePath=%@", tmpFilePath);
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:tmpFilePath];
    NSStringEncoding encode;
    NSString *contentStr = [NSString stringWithContentsOfURL:fileUrl usedEncoding:&encode error:NULL];
    
    if (contentStr)
    {
        [contentStr writeToURL:tmpFileUrl atomically:YES encoding:NSUTF16StringEncoding error:NULL];
        return tmpFileUrl;
    }else{
        NSStringEncoding convertEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        contentStr = [NSString stringWithContentsOfURL:fileUrl encoding:convertEncoding error:NULL];
        
        if (contentStr)
        {
            [contentStr writeToURL:tmpFileUrl atomically:YES encoding:NSUTF16StringEncoding error:NULL];
            
            return tmpFileUrl;
        }
        else
        {
            return fileUrl;
        }
    }
}

+ (id)storyboardInstantiateViewControllerWithStoryboardID:(NSString *)storybbordID
{
    if (storybbordID == nil) {
        return nil;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [sb instantiateViewControllerWithIdentifier:storybbordID];
}
//
//+ (AppDelegate *)appDelegate
//{
//    return (AppDelegate *)[UIApplication sharedApplication].delegate;
//}
//
//+ (id)windowRootViewController
//{
//    AppDelegate *delegate = [self appDelegate];
//    return delegate.window.rootViewController;
//}

+ (NSTimeInterval)secondsSince1970
{
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    return seconds;
}

+ (NSTimeInterval)chinaSecondsSince1970
{
    NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
    return seconds + 8 * 3600;
}

+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects: @(0), @(7), @(1), @(2), @(3), @(4), @(5), @(6), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [[weekdays objectAtIndex:theComponents.weekday] integerValue];
}

+ (NSDateComponents *)yearMonthDayFromDate:(NSDate *)date
{
    if (date == nil) {
        return nil;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit year = NSCalendarUnitYear;
    NSCalendarUnit month = NSCalendarUnitMonth;
    NSCalendarUnit day = NSCalendarUnitDay;
    NSCalendarUnit hour = NSCalendarUnitHour;
    NSCalendarUnit minute = NSCalendarUnitMinute;
    NSCalendarUnit second = NSCalendarUnitSecond;
    NSCalendarUnit weekday = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:year|month|day|hour|minute|second|weekday fromDate:date];
    return theComponents;
//    return @[@(theComponents.year),@(theComponents.month),@(theComponents.day),@(theComponents.hour),@(theComponents.minute),@(theComponents.second),@(theComponents.weekday)];
}

+ (NSString *)iPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (NSString *)chinaFormatterTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}

+ (NSArray *)arrayFromArray:(NSArray *)array withString:(NSString *)string
{
    if (array == nil || string == nil) {
        return nil;
    }
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:string];
    for (int x = 0; x < str.length; x ++) {
        [retArray addObject:[str substringWithRange:NSMakeRange(x, 1)]];
    }
    
    for (int x = 0; x < retArray.count; x ++) {
        for (int y = 0; y < array.count; y ++) {
            NSRange range = [array[y] rangeOfString:retArray[x]];
            if (range.location != NSNotFound) {
                if (![result containsObject:array[y]]) {
                    [result addObject:array[y]];
                }
            }
        }
    }
    return result;
}

+ (NSArray *)arrayFromJsonstring:(NSString *)string
{
    NSData *data = [self dataFromString:string];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return result;
}

+ (NSArray *)arrayReverseWithArray:(NSArray *)array
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger x = array.count - 1; x >= 0; x --) {
        [temp addObject:array[x]];
    }
    return temp;
}

+ (NSString *)randomNumberWithDigit:(int)digit
{
    NSUInteger value = arc4random();
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%lu",(unsigned long)value];
    NSMutableString *strLst;
    if (string.length >= digit) {
        strLst = (NSMutableString *)[string substringFromIndex:string.length - digit];
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int x = 0; x < digit - string.length; x ++) {
            NSInteger count = arc4random();
            int last = count % 10;
            NSString *str = [[NSString alloc] initWithFormat:@"%d",last];
            [array addObject:str];
        }
        [array addObject:string];
        strLst = (NSMutableString *)[array componentsJoinedByString:@""];
    }
    return strLst;
}

+ (BOOL)isNegativeNumber:(NSString *)number
{
    if ([number floatValue] < 0) {
        return YES;
    }
    
    if ( [self isPureFloat:number] || [self isPureInt:number]) {
        if (number < 0) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPureInt:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isLeapYear:(int)year
{
    if ((year % 4  == 0 && year % 100 != 0)  || year % 400 == 0)
        return YES;
    else
        return NO;
}

+ (BOOL)emptyData:(id)instance class:(id)fClass sel:(SEL)fSEL
{
    if (instance == nil) {
        return YES;
    }
    
    if ([instance isKindOfClass:[NSString class]]) {
        NSString *str = instance;
        if (str.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSMutableString class]]) {
        NSMutableString *str = instance;
        if (str.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSArray class]]) {
        NSArray *str = instance;
        if (str.count == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *str = instance;
        if (str.count == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSDictionary class]]) {
        NSDictionary *str = instance;
        if (str.count == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *str = instance;
        if (str.count == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSData class]]) {
        NSData *str = instance;
        if (str.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSMutableData class]]) {
        NSMutableData *str = instance;
        if (str.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSNumber class]]) {
        NSNumber *str = instance;
        NSString *string = [str stringValue];
        if (string.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    
    if ([instance isKindOfClass:[NSValue class]]) {
        NSValue *str = instance;
        NSString *string = [NSString stringWithFormat:@"%@",str];
        if (string.length == 0) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

+ (NSArray *)arrayByOneCharFromString:(NSString *)string
{
    if (string.length == 0) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int x = 0; x < string.length; x ++) {
        [array addObject:[string substringWithRange:NSMakeRange(x, 1)]];
    }
    return array;
}

+ (NSString *)blankInChars:(NSString *)string byCellNo:(int)num
{
    if (string.length == 0) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int x = 0; x < string.length; x ++) {
        [array addObject:[string substringWithRange:NSMakeRange(x, 1)]];
    }
    
    NSMutableArray *last = [[NSMutableArray alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < array.count;  x++) {
        
        [temp addObject:array[x]];
        if (temp.count == num ) {
            [last addObject:temp];
            temp = [[NSMutableArray alloc] init];
        }
        
        if ((temp.count + last.count * num) == array.count) {
            [last addObject:temp];
        }
    }
    
    NSMutableArray *finish = [[NSMutableArray alloc] init];
    for (int x = 0; x < last.count; x ++) {
        [last[x] addObject:@" "];
        NSMutableArray *tempArr = last[x];
        for (int y = 0; y < tempArr.count; y ++) {
            [finish addObject:tempArr[y]];
        }
    }
    NSString *lastString = [finish componentsJoinedByString:@""];
    return lastString;
}

+ (NSString *)jsonStringWithObject:(id)dic
{
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

+ (NSString *)JSONString:(NSString *)aString
{
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

+ (id)objectFromJSonstring:(NSString *)jsonString;
{
    if (jsonString.length == 0) {
        return nil;
    }
    
    NSError *error;
//    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    id dataClass = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return dataClass;
}

+ (NSData *)dataFromString:(NSString *)string
{
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)dataToString:(NSData *)data
{
    return [[NSString alloc] initWithData:data
                                  encoding:NSUTF8StringEncoding];
}

+ (NSString *)dataToString:(NSData *)data withEncoding:(NSStringEncoding)encode
{
    return [[NSString alloc] initWithData:data
                                 encoding:encode];
}

+ (NSString *)homeDirectoryPath:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)documentsPath:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)temporaryDirectoryFile:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *filePath = [tmpDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (BOOL)keyedArchiverWithArray:(NSArray *)array toFilePath:(NSString *)fileName
{
    if (array.count == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSArray *)keyedUnarchiverWithArray:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)keyedArchiverWithData:(NSData *)data toFilePath:(NSString *)fileName
{
    if (data.length == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSData *)keyedUnarchiverWithData:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (NSData*)rsaEncryptString:(SecKeyRef)key data:(NSString*) data
{
    if (key == nil) {
        return nil;
    }
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [data dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        int bufferSize = (int)MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer)
                free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer)
        free(cipherBuffer);
    return encryptedData;
}

+ (BOOL)keyedArchiverWithNumber:(NSNumber *)number toFilePath:(NSString *)fileName
{
    if (number == nil || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:number toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSNumber *)keyedUnarchiverWithNumber:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (BOOL)keyedArchiverWithString:(NSString *)string toFilePath:(NSString *)fileName
{
    if (string.length == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:string toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSString *)keyedUnarchiverWithString:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (BOOL)keyedArchiverWithDictionary:(NSDictionary *)dic toFilePath:(NSString *)fileName
{
    if (dic.count == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:dic toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)keyedUnarchiverWithDictionary:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (BOOL)createFile:(NSString *)fileName withContent:(NSString *)string
{
    if (fileName.length == 0 || string.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

+ (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)newPath
{
    if (filePath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:filePath toPath:newPath error:nil];
}

+ (BOOL)renameFile:(NSString *)filePath toPath:(NSString *)newPath
{
    if (filePath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:filePath toPath:newPath error:nil];
}

+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)newPath
{
    if (filePath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager copyItemAtPath:filePath toPath:newPath error:nil];
}

+ (BOOL)removeFile:(NSString *)filePath
{
    if (filePath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist) {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)string
{
    NSString *chinese = @"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$";
    NSLog(@"%@",chinese);
    return YES;
}

+ (BOOL)isValidateEmail : (NSString *) email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    BOOL validate = [emailTest evaluateWithObject:emailRegex];
//    return validate;
}

+ (BOOL)isValidateUserPasswd :(NSString *)str
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z0-9]{6,16}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isChar:(NSString *)str
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z]*$"    //^[0-9]*$
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isNumber:(NSString *)str
{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[0-9]*$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isDateAEarlierThanDateB:(NSDate *)aDate bDate:(NSDate *)bDate
{
    NSTimeInterval aTime = [aDate timeIntervalSince1970];
    NSTimeInterval bTime = [bDate timeIntervalSince1970];
    if (aTime < bTime) {
        return YES;
    }
    return NO;
}

+ (BOOL)isString:(NSString *)aString containString:(NSString *)bString
{
    for (int x = 0; x < aString.length; x ++) {
        NSRange range = NSMakeRange(x,1);
        NSString *subString = [aString substringWithRange:range];
        if ([subString isEqualToString:bString]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isStringContainsStringAndNumber:(NSString *)sourceString
{
    if ([sourceString isKindOfClass:[NSString class]]) {
        if (sourceString.length == 0) {
            return NO;
        }
        BOOL containsNumber = NO;
        BOOL containsChar = NO;
        for (int x = 0; x < sourceString.length; x ++) {
            NSString *componentString = [sourceString substringWithRange:NSMakeRange(x, 1)];
            if ([FuData isPureInt:componentString]) {
                containsNumber = YES;
            }else{
                containsChar = YES;
            }
        }
        return containsChar&&containsNumber;
    }else{
        return NO;
    }
    return NO;
}

+ (int)isTheSameDayA:(NSDate *)aDate b:(NSDate *)bDate
{
    // 是返回1 不是返回2 其他返回0
    if (aDate == nil  || bDate == nil) {
        NSLog(@"error");
        return 0;
    }
    NSCalendar *calendarA = [NSCalendar currentCalendar];
    NSDateComponents *componentsA = [calendarA components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:aDate];
    NSInteger yearA = [componentsA year];
    NSInteger monthA = [componentsA month];
    NSInteger dayA = [componentsA day];
    
    NSCalendar *calendarB = [NSCalendar currentCalendar];
    NSDateComponents *componentsB = [calendarB components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:bDate];
    NSInteger yearB = [componentsB year];
    NSInteger monthB = [componentsB month];
    NSInteger dayB = [componentsB day];

    if ((yearA == yearB) && (monthA == monthB) && (dayA == dayB)) {
        return 1;
    }
    return 2;
}

+ (BOOL)isDateA:(NSDate *)aDate earlierToB:(NSDate *)bDate
{
    if (aDate == nil  || bDate == nil) {
        return NO;
    }
    
    NSTimeInterval aTimeInterval = [aDate timeIntervalSince1970];
    NSTimeInterval bTimeInterval = [bDate timeIntervalSince1970];
    if (aTimeInterval < bTimeInterval) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkTextFieldHasValidInput:(UITextField *)textField
{
    NSString *text = [FuData cleanString:textField.text];
    return text.length;
}

+ (NSInteger)intByFloat:(double)floatValue
{
    if (floatValue < 1) {
        return 0;
    }
    
    NSString *string = [[NSString alloc] initWithFormat:@"%lf",floatValue];
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (array) {
        return [array[0] integerValue];
    }
    return  0;
}

+ (CGFloat)absoluteValue:(CGFloat)value
{
    if (value < 0.00001) {
        return -value;
    }
    return value;
}

//+ (NetStatus)netWorkStatus
//{
//    Reachability *reach = [Reachability reachabilityWithHostName:URL_NETWORKSTATUS_FUDATA];
//    int flag = reach.currentReachabilityStatus;
//    return flag;
//}

+ (NSNumber *)fileSize:(NSString *)filePath
{
    if (filePath.length == 0) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrDic = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSNumber *fileSize = [attrDic objectForKey:NSFileSize];
    return fileSize;
}

+ (NSValue *)rangeValue:(NSRange)range
{
    return [NSValue valueWithRange:range];
}

+ (NSString *)localFilePath:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)documentsPathMethod:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)md5:(NSString *)str
{
    if (str.length == 0) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];//16
    CC_MD5(cStr, (CC_LONG)strlen(cStr),result);
    return [NSString  stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

+ (NSString *)stringDeleteNewLineAndWhiteSpace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)adID
{
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return nil;
}

+ (NSString *)pathForResource:(NSString *)name type:(NSString *)type
{
    return [[NSBundle mainBundle] pathForResource:name ofType:type];
}

//+ (NSString *)tripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey
//{
//    const void *vplainText;
//    size_t plainTextBufferSize;
//    
//    if (encryptOrDecrypt == kCCDecrypt)//解密
//    {
//        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
//        plainTextBufferSize = [EncryptData length];
//        vplainText = [EncryptData bytes];
//    }else //加密
//    {
//        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//        plainTextBufferSize = [data length];
//        vplainText = (const void *)[data bytes];
//    }
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
//    
//    const void *vkey = (const void *)[encryptOrDecryptKey UTF8String];
//    // NSString *initVec = @"init Vec";
//    //const void *vinitVec = (const void *) [initVec UTF8String];
//    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       vkey,
//                       kCCKeySize3DES,
//                       nil,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//        if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
//        else if (ccStatus == kCCParamError) return @"PARAM ERROR";
//        else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
//        else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
//        else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
//        else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
//        else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED";
//    
//    NSString *result;
//    
//    if (encryptOrDecrypt == kCCDecrypt)
//    {
//        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
//                                                                length:(NSUInteger)movedBytes]
//                                        encoding:NSUTF8StringEncoding];
//    }else{
//        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//        result = [GTMBase64 stringByEncodingData:myData];
//    }
//    
//    free(bufferPtr);
//    return result;
//}

+ (NSString *)timeStamp
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    NSString* str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)identifierForVendorFromKeyChain
{
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * const KEY_USERNAME_PASSWORD = @"com.junnet.HyPhonePass";
    NSString * const KEY_PASSWORD = @"com.junnet.HyPhonePass";
    
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[self load:KEY_USERNAME_PASSWORD];
    if (!readUserPwd) {
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:identifierStr forKey:KEY_PASSWORD];
        [self save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
        return identifierStr;
    }else{
        return [readUserPwd objectForKey:KEY_PASSWORD];
    }
}

+ (NSString *)asciiCodeWithString:(NSString *)string
{
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int x = 0; x < string.length; x ++) {
        NSString *aStr = [string substringWithRange:NSMakeRange(x, 1)];
        [str appendFormat:@"%d",[aStr characterAtIndex:0]];
    }
    return str;
}

+ (NSString *)stringFromASCIIString:(NSString *)string
{
    unsigned short asciiCode = [string intValue];
    return [[NSString alloc] initWithFormat:@"%C",asciiCode];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

//取
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (NSString*)generate3DesKey:(NSString*)seed timestamp:(NSString*)timestamp
{
    NSString * keyStr = [NSString stringWithFormat:@"%@_%d_%@",
                         seed, rand(), timestamp];      // 这个值会是固定的吗?
    NSString * key = [self md5:keyStr];
    key = [key substringToIndex:24];
    return key;
}

+ (NSString *)encryptKye
{
    return @"345243523653445765874";
}

//+ (NSString*)getRsaEncryptParams:(SecKeyRef)publicKey params:(NSString*)params timestamp:(NSString*)timestamp
//{
//    NSString* key = [self generate3DesKey:[self encryptKye] timestamp:timestamp];
//    NSString* encryptParams3des = [self tripleDES:params encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:key];
//    
//    NSData* keyEncryptData = [self rsaEncryptString:publicKey data:key];
//    NSString* keyEncryptStr = [self DataToHex:keyEncryptData];
//    if(keyEncryptStr == nil || keyEncryptStr.length == 0){
//        return nil;
//    }
//    NSString* encryptParams = [NSString stringWithFormat:@"Z%@z%@", keyEncryptStr, encryptParams3des];
//    return encryptParams;
//}

+ (NSString *)DataToHex:(NSData *)data {
    
	Byte *bytes = (Byte *)[data bytes];
    NSMutableDictionary  *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:@"" forKey:@"value"];
    
	for(int i=0;i<[data length];i++)
	{
        NSString *hexStr = @"";
		NSString *newHexStr = [[NSString alloc] initWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
		if([newHexStr length] == 1)
        {
            hexStr = [[NSString alloc] initWithFormat:@"%@0%@",[temp objectForKey:@"value"],newHexStr];
            [temp setObject:hexStr forKey:@"value"];
//            [hexStr release];    //  注释被保留的原因是在非ARC模式下，会内存泄漏；如果alloc时采用autorelese，数据量大时会导致崩溃
        }else{
            hexStr = [[NSString alloc] initWithFormat:@"%@%@",[temp objectForKey:@"value"],newHexStr];
            [temp setObject:hexStr forKey:@"value"];
//            [hexStr release];
        }
//        [newHexStr release];
	}
	//JLog(@"bytes 的16进制数为:%@",hexStr);
	return [temp objectForKey:@"value"];
}

+ (NSString *)cleanString:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@" " withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

+ (NSString *)placeholderString:(NSString *)string font:(NSInteger)font back:(NSInteger)back
{
    if (string.length == 0) {
        return nil;
    }
    
    if (string.length >= 6) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int x = 0; x < string.length; x ++) {
            [array addObject:[string substringWithRange:NSMakeRange(x, 1)]];
        }
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        for (int x = 0; x < string.length; x ++) {
            
            if (x < font || x >= string.length - back) {
                [temp addObject:array[x]];
            }else{
                [temp addObject:@"*"];
            }
        }
        return [temp componentsJoinedByString:@""];
    }
    return nil;
}

+ (NSString *)stringByDate:(NSDate *)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *string = [[NSString alloc] initWithFormat:@"%@%@",@"",localeDate];
    return string;
}

+ (NSString *)bankStyleDataThree:(id)data
{
    if (!data) {
        return @"0.00";
    }
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@",data];
    if (str.length == 0) {
        return @"0.00";
    }
    
    if ([data isKindOfClass:[NSNull class]]) {
        return @"0.00";
    }
    
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
        return formattedNumberString;
    }else if([data isKindOfClass:[NSString class]]){
        if ([self isPureFloat:data] || [self isPureInt:data]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
            return formattedNumberString;
        }else{
            return [[NSString alloc] initWithFormat:@"%@",data];
        }
    }else{
        return [[NSString alloc] initWithFormat:@"%@",data];
    }
}

+ (NSString *)bankStyleData:(id)data
{
    if (!data) {
        return @"0.00";
    }
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@",data];
    if (str.length == 0) {
        return @"0.00";
    }
    
    if ([data isKindOfClass:[NSNull class]]) {
        return @"0.00";
    }
    
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
        [numberFormatter setPositiveFormat:@"0.00;"];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
        return formattedNumberString;
    }else if([data isKindOfClass:[NSString class]]){
        if ([self isPureFloat:data] || [self isPureInt:data]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"0.00;"];
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
            return formattedNumberString;
        }else{
            return [[NSString alloc] initWithFormat:@"%@",data];
        }
    }else{
         return [[NSString alloc] initWithFormat:@"%@",data];
    }
}

+ (NSString *)zeroHandle:(id)data
{
    if (!data) {
        return @"";
    }
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@",data];
    if (str.length == 0) {
        return @"";
    }
    
    if ([data isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        //        [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
        [numberFormatter setPositiveFormat:@"0.00;"];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
        return formattedNumberString;
    }else if([data isKindOfClass:[NSString class]]){
        if ([data floatValue] == 0) {
            return @"";
        }
        
        if ([self isPureFloat:data] || [self isPureInt:data]) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"0.00;"];
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
            return formattedNumberString;
        }else{
            return [[NSString alloc] initWithFormat:@"%@",data];
        }
    }else{
        return [[NSString alloc] initWithFormat:@"%@",data];
    }
}

+ (NSString *)nocrashString:(id)data
{
    if (!data) {
        return @"";
    }
    
    if ([data isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return [[NSString alloc] initWithFormat:@"%@",data];
}

+ (NSString *)fourNoFiveYes:(float)number afterPoint:(int)position  // 只入不舍
{
    NSDecimalNumberHandler  *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (double)forwardValue:(double)number afterPoint:(int)position  // 只入不舍
{
    NSNumber *classNumber = [NSNumber numberWithDouble:number];
    NSString *classString = [classNumber stringValue];
    
    NSArray *valueArray = [classString componentsSeparatedByString:@"."];
    if (valueArray.count == 2) {
        NSString *pointString = valueArray[1];
        if (pointString.length <= position) {
            return number;
        }
    }

    NSDecimalNumberHandler  *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces doubleValue];
}

+ (NSString *)newFloat:(float)value withNumber:(int)numberOfPlace
{
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", numberOfPlace];
    formatStr = [NSString stringWithFormat:formatStr, value];
    return formatStr;
}

+ (NSString *)backBankData:(NSString *)text
{
    if (text.length == 0) {
        return nil;
    }
    NSArray *array = [text componentsSeparatedByString:@"."];
    if (array.count >= 1) {
        NSString *string = array[0];
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
        return string;
    }
    return nil;
}

+ (NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue  valueB:(NSString *)multiplicandValue
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    return [product stringValue];
}

+ (NSString *)highAdd:(NSString *)aValue add:(NSString *)bValue
{
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:aValue];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:bValue];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberByAdding:augendNumber];
    return [sumNumber stringValue];
}

+ (NSString *)highSubtract:(NSString *)fontValue add:(NSString *)backValue
{
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:fontValue];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:backValue];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberBySubtracting:augendNumber];
    return [sumNumber stringValue];
}

+ (NSString *)highMultiply:(NSString *)aValue add:(NSString *)bValue
{
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:aValue];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:bValue];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberByMultiplyingBy:augendNumber];
    return [sumNumber stringValue];
}

+ (NSString *)highDivide:(NSString *)aValue add:(NSString *)bValue
{
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:aValue];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:bValue];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberByDividingBy:augendNumber];
    return [sumNumber stringValue];
}

+ (NSString *)placeholderStringFor:(NSString *)sourceString{
    if (sourceString.length == 0) {
        return @"-";
    }else{
        return sourceString;
    }
}

+ (NSString *)placeholderStringFor:(NSString *)sourceString with:(NSString *)placeholderString
{
    if ([sourceString isKindOfClass:[NSNull class]] || (sourceString == nil)) {
        return placeholderString;
    }
    sourceString = [[NSString alloc] initWithFormat:@"%@",sourceString];
    if (sourceString.length == 0) {
        return placeholderString;
    }
    return sourceString;
}

+ (NSString *)addStringWithSpace:(NSString *)aString bString:(NSString *)bString{
    if (aString.length == 0) {
        aString = @"-";
    }
    if (bString.length == 0) {
        bString = @"-";
    }
    return [[NSString alloc] initWithFormat:@"%@  %@",aString,bString];
}

+ (NSAttributedString *)attributedStringFor:(NSString *)sourceString colorRange:(NSArray *)colorRanges color:(UIColor *)color textRange:(NSArray *)textRanges font:(UIFont *)font{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:sourceString];
    for (int x = 0; x < colorRanges.count; x ++) {
        NSValue *value = colorRanges[x];
        NSRange range;
        [value getValue:&range];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }

    for (int x = 0; x < textRanges.count; x ++) {
        NSValue *value = textRanges[x];
        NSRange range;
        [value getValue:&range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}

+ (BOOL)isValidPassword:(NSString*)password
{
	BOOL valid = YES;
	if([password length] < 6 || [password length] > 30)
	{
		return NO;
	}
	
	for(int i=0; i<[password length]; i++)
	{
		unichar curChar = [password characterAtIndex:i];
		if(curChar >= '0' && curChar <= '9')
		{
			continue;
		}
		if(curChar >='a' && curChar <= 'z')
		{
			continue;
		}
		if(curChar >= 'A' && curChar <= 'Z')
		{
			continue;
		}
		valid = NO;
		break;
	}
	return valid;
}

+ (void)callPhoneNumber:(NSString *)phone
{
    if (phone != nil) {
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phone];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

//+ (void)gotoDownloadApp:(NSString *)appid
//{
//    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@",appid];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//}

+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";

    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air_5_wifi";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air_5_cell";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air_5_cell";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini_wifi";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini_cell";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    
    return deviceString;
}

+ (NSString *)easySeeTimesBySeconds:(NSInteger)timeInterVal
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterVal];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    NSInteger year = dateComponents.year - 1970;
    NSInteger month = dateComponents.month - 1;
    NSInteger day = dateComponents.day - 1;
    NSInteger hour = dateComponents.hour - 8;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    if (hour < 0) {
        hour += 24;
        day --;
    }
    NSMutableString *valueString = [[NSMutableString alloc] init];
    if (year > 0) {
        [valueString appendString:[[NSString alloc] initWithFormat:@"%@年",@(year)]];
    }
    if (month > 0) {
        [valueString appendString:[[NSString alloc] initWithFormat:@"%@月",@(month)]];
    }
    if (day > 0) {
        [valueString appendString:[[NSString alloc] initWithFormat:@"%@天",@(day)]];
    }
    [valueString appendString:[[NSString alloc] initWithFormat:@"%@时",@(hour)]];
    [valueString appendString:[[NSString alloc] initWithFormat:@"%@分",@(minute)]];
    [valueString appendString:[[NSString alloc] initWithFormat:@"%@秒",@(second)]];
    return valueString;
}

//+ (NSString *)base64Code:(NSData *)data
//{
//    return [GTMBase64 stringByEncodingData:data];
//}

+ (NSString *)tenThousandNumber:(double)value
{
    if (value <= 100000) {
        return [[NSString alloc] initWithFormat:@"%.2f",value];
    }
    
    return [[NSString alloc] initWithFormat:@"%.2f万",value / 10000];
}

+ (NSString *)tenThousandNumberString:(NSString *)value
{
    double number = [value doubleValue];
    if (number <= 100000) {
        return value;
    }
    return [[NSString alloc] initWithFormat:@"%.2f万",number / 10000];
}

+ (NSString *)urlEncodedString:(NSString *)urlString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
}

+ (NSString *)urlDecodedString:(NSString *)urlString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)urlString,CFSTR(""),kCFStringEncodingUTF8));
}

+ (NSString *)replaceString:(NSMutableString *)string byString:(NSString *)replaceString
{
    // 必须是NSMutableString
    if (replaceString.length == 0) {
        replaceString = @"";
    }
    [string replaceOccurrencesOfString:@"\n" withString:replaceString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    return string;
}

+ (void)openAppByURLString:(NSString *)str
{
    NSString *string = [NSString stringWithFormat:@"%@://://",str];
    NSURL *myURL_APP_A = [NSURL URLWithString:string];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        [[UIApplication sharedApplication] openURL:myURL_APP_A];
    }
}

+ (void)gotoDownloadApp:(NSString *)str
{
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", str];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


@end
