//
//  SearchViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>
{
    NSMutableArray *hotArray;
    NSMutableArray *hisArray;
    
}
@property (weak, nonatomic) IBOutlet UIView *hotView;
@property (weak, nonatomic) IBOutlet UIView *historyView;

//取消
- (IBAction)cancel:(id)sender;
//搜索
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSMutableArray *array1 = [[NSMutableArray alloc]initWithObjects:@"111",@"1221",@"111",@"1221",@"111",@"1221", nil];
    hisArray = [self readplistData1:@"history.plist"];
    if (hisArray == nil) {
        hisArray = [[NSMutableArray alloc]init];
    }
    [self drawListView:self.hotView title:@"热门搜索" delete:NO list:array1];
    [self drawListView:self.historyView title:@"搜索历史" delete:YES list:hisArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender {
    
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    NSString *historyString = self.searchBar.text;
    if (hisArray.count <= 12) {
        [hisArray insertObject:historyString atIndex:0];
    }
    else
    {
        [hisArray replaceObjectAtIndex:0 withObject:historyString];
    }
    [self writeToPlist:@"history.plist" data:hisArray];
    [self drawListView:self.historyView title:@"搜索历史" delete:YES list:hisArray];
}

-(void)drawListView:(UIView*)view title:(NSString*)title delete:(BOOL)delete list:(NSMutableArray*)listData
{
    for (UIView *tmpView in [view subviews] )
    {
        [tmpView removeFromSuperview];
    }
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 35, 100, 20)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:18];
    [view addSubview:titleLab];
    
    if (delete == YES) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(370, 35, 50, 30);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteHistorySearch:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
    }
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(25, 65, 100, 2)];
    lineView1.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    [view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(125, 65, view.frame.size.width, 2)];
    lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:lineView2];
    
    for (int i = 0; i < listData.count; i++) {
        if (i >= 12) {
            return;
        }
        int col = i/4;
        int row = i%4;
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(25+200*col, 80+50*row, 200, 30);
        lab.text = [listData objectAtIndex:i];
        lab.textColor = [UIColor colorWithRed:0x9f/255.0 green:0xa0/255.0 blue:0xa0/255.0 alpha:1.0f];
        [view addSubview:lab];
        lab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouch:)];
        
        [lab addGestureRecognizer:tapGestureTel];

    }
}

#pragma mark 关键字搜索
-(void)labelTouch:(UIGestureRecognizer*)gestureRecognizer
{
    UILabel *lab=(UILabel*)gestureRecognizer.view;

    NSString *historyString = lab.text;
    
    if (hisArray.count <= 12) {
        [hisArray insertObject:historyString atIndex:0];
    }
    else
    {
        [hisArray replaceObjectAtIndex:0 withObject:historyString];
    }
    [self writeToPlist:@"history.plist" data:hisArray];
    [self drawListView:self.historyView title:@"搜索历史" delete:YES list:hisArray];

    [self performSegueWithIdentifier:@"searchinfo" sender:self];
}

#pragma mark 删除历史记录

-(void)deleteHistorySearch:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除搜索历史" message:@"确定删除搜索历史？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        hisArray = [[NSMutableArray alloc]init];
        [self writeToPlist:@"history.plist" data:hisArray];
        [self drawListView:self.historyView title:@"搜索历史" delete:YES list:hisArray];
    }
}

/*
 功能：向plist文件中写入数据
 输入：name：文件名
 输出：null
 */
-(void)writeToPlist:(NSString*)plistName data:(id)data
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSLog(@"%@",plistPath);
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:plistName];
    
    //写入数据
    [data writeToFile:filename atomically:YES];
}

/*
 功能：读取plist文件数据
 输入：name：plist文件名
 输出：plist数据
 */
-(NSMutableArray *)readplistData1:(NSString*)plistName
{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath stringByAppendingPathComponent:plistName];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:filename];
    return array;
    
}

@end
