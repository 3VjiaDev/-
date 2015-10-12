//
//  qjtSingleton.h
//  导客宝
//
//  Created by 3Vjia on 15/10/12.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface qjtSingleton : NSObject

@property (strong,nonatomic) NSString *qjtId;
@property (strong, nonatomic)NSString *qjtName;
@property (assign, nonatomic) BOOL isCollent;

+(qjtSingleton*)initQJTSingleton;
@end
