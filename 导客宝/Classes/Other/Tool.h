//
//  Tool.h
//  导客宝
//
//  Created by 3Vjia on 15/10/9.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject

//网络请求地址
+ (NSString *)requestURL;

//将要请求的数据转换成jsonString
+ (NSString*)param:(NSArray*)objectAry forKey:(NSArray*)keyAry;

//将请求得到的数据转换成标准json格式
+ (NSString*)newJsonStr:(NSString*)string;

//将特殊字符encode编码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

//提示或者警告
+ (void)showAlert:(NSString*)title message:(NSString*)msg;

//读取授权码
+ (NSString *)readAuthCodeString;

//将NSArray转成jsonstring
+ (NSString *) arrayToJsonString:(NSArray*)array;
@end