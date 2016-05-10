//
//  FuSoft.h
//  SendMessage
//
//  Created by FudonFuchina on 16/5/1.
//  Copyright © 2016年 fusu. All rights reserved.
//

#ifndef FuSoft_h
#define FuSoft_h

#import     "FuData.h"
#import     "FuWeb.h"
#import     "FuSing.h"
#import     "UIViewExt.h"

#ifdef DEBUG
# define FSLog(format, ...) NSLog((@"\nFSLog:%s" "%s" "- %d\n" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define FSLog(...);
#endif

/******************__system__*********************/
#define IOS(A)          (([[UIDevice currentDevice].systemVersion floatValue] >= A)?YES:NO)
#define MININ(A,B)      ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __a : __b; })
#define WEAKSELF(A)      __weak typeof(*&self)A = self

#define HEIGHTFC        ([UIScreen mainScreen].bounds.size.height)
#define WIDTHFC         ([UIScreen mainScreen].bounds.size.width)
#define IOS7FC          (([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)?YES:NO)
#define IOS8FC          (([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)?YES:NO)
#define IPAD            ([[[UIDevice currentDevice].model componentsSeparatedByString:@" "][0] isEqualToString:@"iPad"]?YES:NO)
#define isIPAD          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IPHONE          ([[[UIDevice currentDevice].model componentsSeparatedByString:@" "][0] isEqualToString:@"iPhone"]?YES:NO)
#define SEVEN64         (fIOS7?64:0)
#define SEVEN44         (fIOS7?44:0)
#define SEVEN20         (fIOS7?20:0)
#define INCH4           ((HEIGHTFC > 490 && HEIGHTFC < 570)?YES:NO)
#define INCH35          (HEIGHTFC < 490?YES:NO)

#define RGBCOLOR(R, G, B, A)    ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A])
#define IMAGENAMED(A)           [UIImage imageNamed:A]
#define ROUNDIMAGE(A,B)         ([FuData circleImage:IMAGENAMED(A) withParam:B]) // B default is 0.
#define FONTFC(A)               ([UIFont systemFontOfSize:A])
#define FONTBOLD(A)             ([UIFont fontWithName:@"Helvetica-Bold" size:A])
#define FONTOBLIQUE(A)          ([UIFont fontWithName:@"Helvetica-BoldOblique" size:A])
#define FONTLIQUE(A)            ([UIFont fontWithName:@"Helvetica-Oblique" size:A])

#define STRINGFC(A)             ([FuData nocrashString:A])
#define STRFC(A,B)              ([[NSString alloc] initWithFormat:@"%@%@",STRINGFC(A),STRINGFC(B)])
#define FLSTRING(A)             ([FuData bankStyleData:A])
#define FLSTRINGTHR(A)          ([FuData bankStyleDataThree:A])
#define FLSTRINGBACK(A)         ([FuData backBankData:A])
#define FLSTRAB(A,B)            (STRFC(A,FLSTRING(B)))
#define FLSTRBA(A,B)            (STRFC(FLSTRING(A),B))
#define FLZERONONE(A)           ([FuData zeroHandle:A])
#define GZPLACEHOLDER(A)        ([FuData placeholderStringFor:A])
#define GZPLACEHOLDERBY(A,B)    ([FuData placeholderStringFor:A with:B])
#define FABSVALUE(A)            ([FuData absoluteValue:A])

#define IS_STRING_NOT_NULL_OR_EMPTY(x) ((x) !=nil && (x).length > 0)
#define IS_STRING_NULL_OR_EMPTY(x) ((x)==nil || (x).length<=0)

/******************__tag__**********************/
#define   TAGBASEVIEW           4555
#define   TAGVIEW               1000
#define   TAGBUTTON             1100
#define   TAGTABLEVIEW          1200
#define   TAGSCROLLVIEW         1300
#define   TAGLABEL              1400
#define   TAGIMAGEVIEW          1500
#define   TAGSWITCH             1600
#define   TAGSLIDER             1700
#define   TAGSEGMENT            1800
#define   TAGWEBVIEW            1900
#define   TAGMAPVIEW            2000
#define   TAGTEXTFIELD          2100
#define   TAGTEXTVIEW           2200
#define   TAGPROGRESSVIEW       2500
#define   TAGALERT              2300
#define   TAGPICKERVIEW         2400
#define   TAGTEMPONE            3555
#define   TAGTEMPTWO            3666
#define   TAGTEMPTHE            3777

#endif /* FuSoft_h */
