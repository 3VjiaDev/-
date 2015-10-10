//
//  ShopViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "ShopViewController.h"
#import "LoginViewController.h"

@interface ShopViewController ()
{
    UIView *examineView;
}
//改变类型
- (IBAction)changeStyle:(id)sender;

//客户信息
- (IBAction)userInformation:(id)sender;
//搜索
- (IBAction)search:(id)sender;
//筛选
- (IBAction)select:(id)sender;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.faceImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouch:)];
    
    [self.faceImage addGestureRecognizer:tapGestureTel];
}

-(void)imageViewTouch:(UIGestureRecognizer*)gestureRecognizer
{

    examineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:examineView];
    examineView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
   
    float xpoint = (self.view.frame.size.width - 325)/2;
    float ypoint = (self.view.frame.size.height - 350)/2;
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(xpoint, ypoint, 325, 350)];
    infoView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    [examineView addSubview:infoView];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(15, 15, 20, 20);
    
    [closeBtn setImage:[[UIImage imageNamed:@"cha-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //[closeBtn setTitle:@"X" forState:UIControlStateNormal];
    //[closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:closeBtn];
    
    
    UIImageView *face = [[UIImageView alloc]initWithFrame:CGRectMake(132.5, 50, 60, 60)];
    face.image = self.faceImage.image;
    [infoView addSubview:face];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, 295, 20)];
    nameLab.text = @"曲美家具";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = [UIFont systemFontOfSize:15];
    [infoView addSubview:nameLab];
    
    UILabel *versionLab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 240, 100, 20)];
    versionLab1.text = @"当前版本";
    versionLab1.font = [UIFont systemFontOfSize:12.0f];
    [infoView addSubview:versionLab1];
    
    UILabel *versionLab2 = [[UILabel alloc]initWithFrame:CGRectMake(195, 240, 100, 20)];
    versionLab2.text = @"V1.0";
    versionLab2.font = [UIFont systemFontOfSize:12.0f];
    versionLab2.textAlignment = NSTextAlignmentRight;
    [infoView addSubview:versionLab2];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 275, 295, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [infoView addSubview:lineView];
    
    UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginoutBtn.frame = CGRectMake(15, 300, 295, 30);
    
    //[closeBtn setImage:[[UIImage imageNamed:@"delete_img"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [loginoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [loginoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginoutBtn.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    [loginoutBtn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:loginoutBtn];
    [loginoutBtn.layer setMasksToBounds:YES];
    [loginoutBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [loginoutBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 239/255.0, 142/255.0, 61/255.0, 1 });
    [loginoutBtn.layer setBorderColor:colorref];//边框颜色

}
-(void)close:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         examineView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [examineView removeFromSuperview];
                     }];
}

-(void)loginOut:(id)sender
{
    //loginout
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"退出登录" message:@"确定退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSegueWithIdentifier:@"loginout" sender:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeStyle:(id)sender {
}

- (IBAction)userInformation:(id)sender {
    [self performSegueWithIdentifier:@"customer" sender:self];
}

- (IBAction)search:(id)sender {
}

- (IBAction)select:(id)sender {
}


@end
