//
//  QjtView.m
//  导客宝
//
//  Created by 3Vjia on 15/10/12.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "QjtView.h"

@implementation QjtView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.qjtImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.qjtImageView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, (5/6)*self.frame.size.height, self.frame.size.width, (1/6)*self.frame.size.height)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, (titleView.frame.size.height - 20)/2, self.frame.size.width-130, 20)];
    titleLab.text = self.title;
    titleLab.font = [UIFont systemFontOfSize:18.0f];
    
    self.isCollectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-85, (titleView.frame.size.height - 30)/2, 30, 30)];
    [self addSubview:self.isCollectionImageView];
}


@end
