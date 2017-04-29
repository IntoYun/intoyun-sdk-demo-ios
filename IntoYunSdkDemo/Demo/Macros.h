//
//  Macros.h
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/7.
//  Copyright © 2017年 hui he. All rights reserved.
//

#ifndef Macros_h
#define Macros_h


//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]

//判断字符串是否为空
#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)

// iPad iPhone
#define DeviceUIIdiom                           [[UIDevice currentDevice] userInterfaceIdiom]

/** 颜色 */
#define SetColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define MLColor1 [UIColor colorWithRed:(0x3a)/255.0 green:(0xdf)/255.0 blue:(0xd7)/255.0 alpha:1.0]
#define MLColor2 [UIColor colorWithRed:(0x35)/255.0 green:(0xc7)/255.0 blue:(0xec)/255.0 alpha:1.0]
#define MLColor3 [UIColor colorWithRed:(0xe9)/255.0 green:(0xad)/255.0 blue:(0x4e)/255.0 alpha:1.0]
#define MLColor4 [UIColor colorWithRed:(0x46)/255.0 green:(0xa7)/255.0 blue:(0xf1)/255.0 alpha:1.0]
#define MLColor5 [UIColor colorWithRed:(0x7a)/255.0 green:(0x91)/255.0 blue:(0xde)/255.0 alpha:1.0]
#define MLColor6 [UIColor colorWithRed:(0xe5)/255.0 green:(0x79)/255.0 blue:(0x77)/255.0 alpha:1.0]
#define DividerColor [UIColor colorWithRed:0xd6/255.0 green:0xd7/255.0 blue:0xdc/255.0 alpha:1.0]
#define PrimaryColor [UIColor colorWithRed:(0x00)/255.0 green:(0xc6)/255.0 blue:(0xff)/255.0 alpha:1.0]

/** 屏幕尺寸 */
#define MLScreenW [UIScreen mainScreen].bounds.size.width
#define MLScreenH [UIScreen mainScreen].bounds.size.height

// 状态栏(statusbar)
#define StatusBarCGRect [[UIApplication sharedApplication] statusBarFrame]



#define IntoYunDataBasePath [IntoYunUtils documentDirPathWithFilePath:@"IntoYunDataBase.sqlite"]    //设备数据库路径

#define NUMBER_DT   @"float"    //数值类型
#define ENUM_DT     @"enum"     //枚举类型
#define BOOL_DT     @"bool"     //开关类型
#define STRING_DT   @"string"   //字符串类型
#define EXTRA_DT    @"extra"    //自定义类型
#define TIMER_DT    @"timer"    //定时器
#define EMAIL_DT    @"email"    //邮件
#define MESSAGE_DT  @"msgbox"   //消息盒子


#define DIRECTION_DATA      1       //数据上报
#define DIRECTION_CMD       2       //数据下发
#define DIRECTION_BIDIR     3       //双向数据

#define SYSTEM_DEVICE_ID  @"9999999999999999"
#define SYSTEM_PRODUCT_ID  @"8999999999999999"
#define SYSTEM_DATAPOINT_TIMER  1
#define SYSTEM_DATAPOINT_EMAIL  2
#define SYSTEM_DATAPOINT_MESSAGE  3


#define RECIPE_TYPE_EDGE  @"edge"
#define RECIPE_TYPE_PERIOD  @"period"

#define RECIPE_TYPE_SCHEDULE  @"schedule"
#define RECIPE_TYPE_RECIPE  @"recipe"

#define RECIPE_ACTION_EMAIL  @"email"
#define RECIPE_ACTION_MQTT  @"mqtt"
#define RECIPE_ACTION_MSGBOX  @"msgbox"



#endif /* Macros_h */
