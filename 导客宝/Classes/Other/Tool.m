//
//  Tool.m
//  Test
//
//  Created by 3Vjia on 15/10/7.
//  Copyright (c) 2015年 3Vjia. All rights reserved.
//

#import "Tool.h"

@implementation Tool


/*
 功能：得到网络请求地址
 输入：null
 返回：网络请求地址
 */
+ (NSString *)requestURL
{
    //mnmnh 3weijia
    return @"http://passport.admin.3weijia.com/mnmnhwap.axd";
}

/*
 功能：得到图片网络请求地址
 输入：null
 返回：图片网络请求地址
 */
+ (NSString *)requestImageURL
{
    //mnmnh
    return @"http://passport.admin.3weijia.com";
}

/*
 功能：得到全景图网络请求地址
 输入：null
 返回：全景图网络请求地址
 */
+(NSString *)qjtRequestUrl
{
    return @"http://passport.admin.3weijia.com/PMC/Panorama/Show360Test.aspx?SchemeId=";
}
/*
 功能：错误提示或者警告
 输入：title：UIAlertView的title msg：UIAlertView的message
 返回：NUll
 */
+ (void)showAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


/*
 功能：读取授权码
 输入：NUll
 返回：授权码
 */
+(NSString *)readAuthCodeString
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *authCode = [userDefaultes stringForKey:@"AuthCode"];
    return authCode;
}

/*
 功能：将要请求的数据转换成jsonString
 输入：objectAry：NSMutableDictionary的object  keyAry：NSMutableDictionary的key
 返回：jsonString
 */
+ (NSString*)param:(NSArray*)objectAry forKey:(NSArray*)keyAry
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < keyAry.count; i++) {
        
        [dic setValue:[objectAry objectAtIndex:i] forKey:[keyAry objectAtIndex:i]];
    }
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return string;
}

/*
 功能：将请求得到的数据转换成标准json格式
 输入：string：网络请求得到的数据
 返回：标准json
 */
+ (NSString*)newJsonStr:(NSString*)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"JSON\":\"" withString:@"\"JSON\":"];
    string = [string stringByReplacingOccurrencesOfString:@"}\"," withString:@"},"];
    string = [string stringByReplacingOccurrencesOfString:@"]\"," withString:@"],"];
    string = [string stringByReplacingOccurrencesOfString:@"\"JSON\":\"\\\"\\\"\"" withString:@"\"JSON\":\"\""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\"JSON\":\"\"" withString:@"\"JSON\":\""];
    string = [string stringByReplacingOccurrencesOfString:@"\"\",\"ErrorMessage\"" withString:@"\",\"ErrorMessage\""];
    
    return string;
}

/*
 功能：将特殊字符encode编码  转义的字符 !*'();:@&=+$,/?%#[]
 输入：input：待转义的字符串
 返回：转义之后的字符串
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

/*
 功能：将NSArray转成jsonstring
 输入：array：待转换得数组
 返回：转换之后的字符串
 */
+ (NSString *) arrayToJsonString:(NSArray*)array
{
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:array
                                                        options:kNilOptions
                                                          error:nil];
    
    return [[NSString alloc]initWithData:JSONData encoding:NSUTF8StringEncoding];
}
@end

