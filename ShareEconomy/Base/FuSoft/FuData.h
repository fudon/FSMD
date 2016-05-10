//
//  FDDClass.h
//  FDDClass
//
//  Created by HYYT on 14-5-15.
//  Copyright (c) 2014年 hyw_fdd. All rights reserved.
//

/*
            INFO
                @VERSION    2015.00.00
 */


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/*
 Notice:
 1.含有返回广告ID的方法，可能在发布时会被苹果检测到，注意屏蔽；
 
 */

/************************************************************************************************/
#define  URL_NETWORKSTATUS_FUDATA      @"www.baidu.com"                             //检测网络的URL
#define  FIRSTSTARTFC                  @"FIRSTSTARTFC"

/************************************************************************************************/
typedef enum : NSInteger {
    NetStatusNot = 0,
    NetStatusWiFi,
    NetStatusWWAN
} NetStatus;

/************************************************************************************************/

@interface FuData : NSObject

+ (void)userDefaultsKeepData:(id)instance  withKey:(NSString *)key;
+ (id)userDefaultsDataWithKey:(NSString *)key;
+ (id)objectFromJSonstring:(NSString *)jsonString;
+ (void)nilUserdefaultWithKey:(NSString *)key;
+ (void)showAlertViewWithTitile:(NSString *)string;
+ (void)copyToPasteboard:(NSString *)copyString;

+ (BOOL)checkLoginSuccess;
+ (void)checkLoginSuccess:(BOOL)saveOrClear;
+ (BOOL)checkFirstHandle;
+ (void)checkFirstHandle:(BOOL)saveOrClear;
+ (void)showImage:(UIImageView *)avatarImageView;

+ (BOOL)isFirstStart;
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isNegativeNumber:(NSString *)number;
+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isPureFloat:(NSString*)string;
+ (BOOL)isLeapYear:(int)year;
+ (BOOL)isValidPassword:(NSString*)password;
+ (BOOL)emptyData:(id)instance class:(id)fClass sel:(SEL)fSEL;
+ (BOOL)keyedArchiverWithArray:(NSArray *)array toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithData:(NSData *)data toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithNumber:(NSNumber *)number toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithString:(NSString *)string toFilePath:(NSString *)fileName;
+ (BOOL)keyedArchiverWithDictionary:(NSDictionary *)dic toFilePath:(NSString *)fileName;
+ (BOOL)createFile:(NSString *)fileName withContent:(NSString *)string;
+ (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)newPath;
+ (BOOL)renameFile:(NSString *)filePath toPath:(NSString *)newPath;
+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)newPath;
+ (BOOL)removeFile:(NSString *)filePath;
+ (BOOL)isChinese:(NSString *)string;
+ (BOOL)isValidateEmail : (NSString *) str;
+ (BOOL)isValidateUserPasswd :(NSString *)str;
+ (BOOL)isChar:(NSString *)str;
+ (BOOL)isNumber:(NSString *)str;
+ (BOOL)isDateAEarlierThanDateB:(NSDate *)aDate bDate:(NSDate *)bDate;
+ (BOOL)isString:(NSString *)aString containString:(NSString *)bString;
+ (BOOL)isStringContainsStringAndNumber:(NSString *)sourceString;
+ (int)isTheSameDayA:(NSDate *)aDate b:(NSDate *)bDate;
+ (BOOL)isDateA:(NSDate *)aDate earlierToB:(NSDate *)bDate;
+ (BOOL)checkTextFieldHasValidInput:(UITextField *)textField;
+ (NSInteger)intByFloat:(double)floatValue;
+ (CGFloat)absoluteValue:(CGFloat)value;

+ (NSTimeInterval)secondsSince1970;
+ (NSTimeInterval)chinaSecondsSince1970;
+ (NSInteger)weekdayStringFromDate:(NSDate *)inputDate;
+ (NSDateComponents *)yearMonthDayFromDate:(NSDate *)date;

+ (double)forwardValue:(double)number afterPoint:(int)position;  // 只入不舍
+ (double)usedMemory;                                                               // 获得应用占用的内存，单位为M
+ (double)availableMemory;                                                          // 获得当前设备可用内存,单位为M
+ (float)folderSizeAtPath:(NSString*)folderPath extension:(NSString *)extension;    // 获取文件夹目录下的文件大小
+ (long long)fileSizeAtPath:(NSString*)filePath;                                    // 获取文件的大小
+ (CGFloat)textHeight:(NSString *)text
              fontInt:(NSInteger)fontInt                                            // 计算字符串放在label上需要的高度,font数字要和label的一样
           labelWidth:(CGFloat)labelWidth;                                          // label调用 sizeToFit 可以实现自适应
+ (double)distanceBetweenCoordinate:(CLLocationCoordinate2D)coordinateA toCoordinateB:(CLLocationCoordinate2D)coordinateB;

+ (NSString *)appVersionNumber;                                                     // 获得版本号
+ (NSString *)appName;                                                              // 获得应用的Bundle Display Name
+ (NSString *)iPAddress;
+ (NSString *)chinaFormatterTime;
+ (NSString *)randomNumberWithDigit:(int)digit;
+ (NSString *)blankInChars:(NSString *)string byCellNo:(int)num;
+ (NSString *)jsonStringWithObject:(id)dic;
+ (NSString *)JSONString:(NSString *)aString;
+ (NSString *)dataToString:(NSData *)data;
+ (NSString *)dataToString:(NSData *)data withEncoding:(NSStringEncoding)encode;
+ (NSString *)homeDirectoryPath:(NSString *)fileName;
+ (NSString *)keyedUnarchiverWithString:(NSString *)fileName;
+ (NSString *)documentsPath:(NSString *)fileName;
+ (NSString *)temporaryDirectoryFile:(NSString *)fileName;
+ (NSString *)localFilePath:(NSString *)fileName;
+ (NSString *)documentsPathMethod:(NSString *)fileName;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)stringDeleteNewLineAndWhiteSpace:(NSString *)string;
+ (NSString *)adID;
+ (NSString *)pathForResource:(NSString *)name type:(NSString *)type;
//+ (NSString *)tripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey;
+ (NSString *)timeStamp;
+ (NSString *)macaddress;
+ (NSString *)identifierForVendorFromKeyChain;
+ (NSString *)asciiCodeWithString:(NSString *)string;
+ (NSString *)stringFromASCIIString:(NSString *)string;          
+ (NSString *)DataToHex:(NSData *)data;                          // 将二进制转换为16进制再用字符串表示
+ (NSString *)cleanString:(NSString *)str;
+ (NSString *)placeholderString:(NSString *)string font:(NSInteger)font back:(NSInteger)back;
+ (NSString *)stringByDate:(NSDate *)date;                       // 解决差8小时的问题
+ (NSString *)bankStyleData:(id)data;
+ (NSString *)zeroHandle:(id)data;
+ (NSString *)bankStyleDataThree:(id)data;
+ (NSString *)nocrashString:(id)data;
+ (NSString *)fourNoFiveYes:(float)number afterPoint:(int)position;  // 四舍五入
+ (NSString *)newFloat:(float)value withNumber:(int)numberOfPlace;
+ (NSString *)backBankData:(NSString *)text;
+ (NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue  valueB:(NSString *)multiplicandValue;
+ (NSString *)deviceModel;
+ (NSString *)easySeeTimesBySeconds:(NSInteger)seconds;
//+ (NSString *)base64Code:(NSData *)data;                // 用来将图片转换为字符串
+ (NSString *)tenThousandNumber:(double)value;
+ (NSString *)tenThousandNumberString:(NSString *)value;
+ (NSString *)urlEncodedString:(NSString *)urlString;
+ (NSString *)urlDecodedString:(NSString *)urlString;
+ (NSString *)replaceString:(NSMutableString *)string byString:(NSString *)replaceString;
+ (NSString *)placeholderStringFor:(NSString *)sourceString;
+ (NSString *)placeholderStringFor:(NSString *)sourceString with:(NSString *)placeholderString;
+ (NSString *)addStringWithSpace:(NSString *)aString bString:(NSString *)bString;
/*  NSAttributedString *connectAttributedString = [FuData attributedStringFor:connectString colorRange:@[[NSValue valueWithRange:connectRange]] color:GZS_RedColor textRange:@[[NSValue valueWithRange:connectRange]] font:FONTFC(25)];*/
+ (NSAttributedString *)attributedStringFor:(NSString *)sourceString colorRange:(NSArray *)colorRanges color:(UIColor *)color textRange:(NSArray *)textRanges font:(UIFont *)font;

// 高精度计算
+ (NSString *)highAdd:(NSString *)aValue add:(NSString *)bValue;
+ (NSString *)highSubtract:(NSString *)fontValue add:(NSString *)backValue;
+ (NSString *)highMultiply:(NSString *)aValue add:(NSString *)bValue;
+ (NSString *)highDivide:(NSString *)aValue add:(NSString *)bValue;

//+ (AppDelegate *)appDelegate;
//+ (id)windowRootViewController;
+ (void)callPhoneNumber:(NSString *)phone;
+ (void)gotoDownloadApp:(NSString *)appid;
+ (void)openAppByURLString:(NSString *)str;

+ (NSArray *)arrayFromArray:(NSArray *)array withString:(NSString *)string;
+ (NSArray *)arrayByOneCharFromString:(NSString *)string;
+ (NSArray *)keyedUnarchiverWithArray:(NSString *)fileName;
+ (NSArray *)arrayFromJsonstring:(NSString *)string;
+ (NSArray *)arrayReverseWithArray:(NSArray *)array;
+ (NSArray *)maxandMinNumberInArray:(NSArray *)array;                           // 找出数组中最大的数 First Max, Last Min
+ (NSArray *)maopaoArray:(NSArray *)array;
+ (NSArray *)addCookies:(NSArray *)nameArray value:(NSArray *)valueArray cookieDomain:(NSString *)cookName;

+ (NSDictionary *)keyedUnarchiverWithDictionary:(NSString *)fileName;

+ (NSData *)dataFromString:(NSString *)string;
+ (NSData *)keyedUnarchiverWithData:(NSString *)fileName;
+ (NSData*)rsaEncryptString:(SecKeyRef)key data:(NSString*) data;

+ (NSNumber *)keyedUnarchiverWithNumber:(NSString *)fileName;
+ (NSNumber *)fileSize:(NSString *)filePath;
+ (NSValue *)rangeValue:(NSRange)range;

+ (UIColor *)randomColor;
+ (UIColor *)colorWithHexString: (NSString *)color;                             // 根据16进制字符串获得颜色类对象

+ (NSDate *)dateFromStringByHotline:(NSString *)string;
+ (NSDate *)dateFromStringByHotlineWithoutSeconds:(NSString *)string;
+ (NSDate *)chinaDateByDate:(NSDate *)date;                                     // 解决差8小时问题
+ (NSDate *)chinaDateByTimeInterval:(NSString *)timeInterval;                   // 解决差8小时问题

//+ (UIImage *)QRImageFromString:(NSString *)string;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset;

+ (NSURL *)convertTxtEncoding:(NSURL *)fileUrl;

+ (id)storyboardInstantiateViewControllerWithStoryboardID:(NSString *)storybbordID;

@end
