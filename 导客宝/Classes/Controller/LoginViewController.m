//
//  LoginViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/7.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "LoginViewController.h"
#import "Tool.h"
#import "singleton.h"

@interface LoginViewController ()<UITextFieldDelegate>

{
    BOOL isLogin;//防止登录按钮多次点击
}
//登录
- (IBAction)login:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.phoneTextfield.text = @"qeknio";
    self.pwdTextField.text = @"123123";
    
    [self initLoginBtn];
    
}

#pragma mark 登录按钮设置

//外观设置
-(void)initLoginBtn
{
    [self.loginButton setTintColor:[UIColor whiteColor]];
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.loginButton.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 239/255.0, 142/255.0, 61/255.0, 1 });
    [self.loginButton.layer setBorderColor:colorref];//边框颜色
    
}

//登录状态
-(void)loginState:(NSString*)title
{
    isLogin = !isLogin;
    [self.loginButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark 用户登录

- (IBAction)login:(id)sender {
    if (!isLogin) {
        [self loginState:@"登录中..."];
        [self login:self.phoneTextfield.text password:self.pwdTextField.text];
    }
}

/*
 功能：用户登录
 输入：name：账号 pwd：密码
 返回：NULL
 */
-(void)login:(NSString*)name password:(NSString*)pwd
{
    if ((name.length <= 0)||(pwd.length <= 0)) {
        [Tool showAlert:@"登录失败" message:@"用户名或者密码为空"];
        [self loginState:@"登录"];
        return;
    }
    
    [NSURLConnection sendAsynchronousRequest:[self request:name password:pwd]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError) {
             [self loginState:@"登录"];
             [Tool showAlert:@"网络异常" message:@"连接超时"];
         }
         else
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             //将数据变成标准的json数据
             NSData *newData = [[Tool newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSNumber *Status = [dic objectForKey:@"Status"];
             if (Status.intValue == 200) {
                 NSString *LoginType = [[dic objectForKey:@"JSON"]objectForKey:@"LoginType"];
                 if ([LoginType isEqualToString:@"1"]) {
                     //登陆成功
                     //保存授权码
                     NSString *AuthCode = [[dic objectForKey:@"JSON"]objectForKey:@"AuthCode"];
                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setObject:[Tool encodeToPercentEscapeString:AuthCode] forKey:@"AuthCode"];
                     
                     NSString *DeptId = [[dic objectForKey:@"JSON"]objectForKey:@"DeptId"];
                     singleton *single = [singleton initSingleton];
                     single.deptid = DeptId;
                     
                     [self performSegueWithIdentifier:@"login" sender:self];
                 }
                 else
                 {
                     //登录失败
                     [self loginState:@"登录"];
                     [Tool showAlert:@"登录失败" message:@"您当前没有权限登录"];
                 }
             }
             else
             {
                 //登录失败
                 [self loginState:@"登录"];
                 [Tool showAlert:@"登录失败" message:@"用户名或密码错误"];
             }
         }
     }];
}

/*
 功能：用户登录网络请求
 输入：name：账号 pwd：密码
 返回：网络请求
 */
- (NSMutableURLRequest*)request:(NSString*)name password:(NSString*)pwd
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode = @"OnxA/jxTBSM91jGmGyREdSjObIc4Z8d2hA/95UiyOSLBUSTAYHKq75hcxsHuN5VsKCJQqB6QpbSH77xgY9lWTBs0nNajsDLpfBAVdB0bqO+RrbEhCgms7bsfclnY+XFn";
    
    NSArray *key = @[@"authCode",@"account",@"password"];
    NSArray *object = @[[Tool encodeToPercentEscapeString:authCode],name,pwd];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=COMMON/UserLogin",[Tool param:object forKey:key]];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}


#pragma mark textfielddelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int pointY;
    if (textField == self.phoneTextfield) {
        pointY = 295;
    }
    else
        pointY = 336;
    int offset = pointY + 100 - (self.view.frame.size.height - 450);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark 键盘响应函数

//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

//键盘显示
-(void)keyboardWillShow:(NSNotification *)notification
{

    int pointY = 336;
    int offset = pointY + 100 - (self.view.frame.size.height - 450);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
