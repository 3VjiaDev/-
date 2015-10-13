//
//  SearchResultViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
//返回


- (IBAction)return:(UIButton *)sender;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        tableView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = NO;
        for (int i = 0; i < 3; i++) {
            UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[UIImage imageNamed:@"jiazaipic"] title:@"ddddddddd" isCollect:YES];
            [cell.contentView addSubview:view];
        }
    }
    return cell;
}

#pragma mark 全景图展示

-(UIView *)qjtDraw:(CGRect)rect qjtImage:(UIImage*)qjtImage title:(NSString*)qjtTitle isCollect:(BOOL)isCollect
{
    UIView *qjtView = [[UIView alloc]initWithFrame:rect];
    
    UIImageView *qjtImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    qjtImageView.image = qjtImage;
    [qjtView addSubview:qjtImageView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, (5*rect.size.height)/6, rect.size.width, rect.size.height/6)];
    titleView.backgroundColor = [UIColor whiteColor];
    [qjtView addSubview:titleView];
    
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, (titleView.frame.size.height - 20)/2, rect.size.width-130, 20)];
    titleLab.text = qjtTitle;
    titleLab.font = [UIFont systemFontOfSize:15.0f];
    [titleView addSubview:titleLab];
    
    UIImageView *isCollectionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width-30, (titleView.frame.size.height - 15)/2, 15, 15)];
    
    if (isCollect) {
        isCollectionImageView.image = [UIImage imageNamed:@"xiangqingbaocun-dianji" ];
    }
    else
    {
        isCollectionImageView.image = [UIImage imageNamed:@"xiangqingbaocun-dianji" ];
    }
    [titleView addSubview:isCollectionImageView];
    
    
    qjtView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touch:)];
    
    [qjtView addGestureRecognizer:tapGestureTel];
    
    return qjtView;
}

-(void)touch:(UIGestureRecognizer*)gestureRecognizer
{
    UIView *view  =(UIView*)gestureRecognizer.view;
    
    NSLog(@"%ld",(long)view.tag);
    //qjtInfo
   // [self performSegueWithIdentifier:@"qjtinfo" sender:self];
}


- (IBAction)return:(UIButton *)sender {
}
@end
