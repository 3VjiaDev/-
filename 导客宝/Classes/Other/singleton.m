//
//  singleton.m
//  导客宝
//
//  Created by 3Vjia on 15/10/9.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "singleton.h"

@implementation singleton

static singleton *instance = nil;

+(singleton*)initSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[singleton alloc]init];
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
