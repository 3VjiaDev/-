//
//  qjtSingleton.m
//  导客宝
//
//  Created by 3Vjia on 15/10/12.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "qjtSingleton.h"

@implementation qjtSingleton
static qjtSingleton *instance = nil;

+(qjtSingleton*)initQJTSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[qjtSingleton alloc]init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}

@end
