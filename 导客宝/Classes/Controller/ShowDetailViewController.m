//
//  ShowDetailViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "qjtSingleton.h"
#import "Tool.h"

@interface ShowDetailViewController ()

//分享
- (IBAction)share:(id)sender;

//收藏
- (IBAction)collect:(id)sender;

//返回
- (IBAction)return:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.qjtID = [qjtSingleton initQJTSingleton].qjtId;
    self.qjtName = [qjtSingleton initQJTSingleton].qjtName;
    self.isCollenct = [qjtSingleton initQJTSingleton].isCollent;
    
    NSString *UrlString = [NSString stringWithFormat:@"%@%@",[Tool qjtRequestUrl],self.qjtID];
    NSLog(@"%@",UrlString);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:UrlString]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)share:(id)sender {
}

- (IBAction)collect:(id)sender {
}

- (IBAction)return:(id)sender {
}


@end
