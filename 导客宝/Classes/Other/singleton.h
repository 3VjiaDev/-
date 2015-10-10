//
//  singleton.h
//  导客宝
//
//  Created by 3Vjia on 15/10/9.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface singleton : NSObject

@property (strong,nonatomic) NSString *deptid;

+(singleton*)initSingleton;

@end
