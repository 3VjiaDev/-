
//
//  UserViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/5.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "UserViewController.h"
#import "Tool.h"
#import "singleton.h"

@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *nameAry;
    NSMutableArray *IDAry;
    NSMutableArray *phoneAry;
    NSMutableArray *addrAry;
    NSMutableArray *styleAry;
    NSMutableArray *markAry;
}

@property (weak, nonatomic) IBOutlet UITableView *customerTable;

//添加客户
- (IBAction)addClient:(id)sender;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCustomerList];
    nameAry = [[NSMutableArray alloc]init];
    IDAry = [[NSMutableArray alloc]init];
    phoneAry = [[NSMutableArray alloc]init];
    addrAry = [[NSMutableArray alloc]init];
    styleAry = [[NSMutableArray alloc]init];
    markAry = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addClient:(id)sender {
}
#pragma mark 获取客户列表
/*
 功能：获取客户列表
 输入：null
 返回：null
 */
-(void)getCustomerList
{
    NSString *deptid = [singleton initSingleton].deptid;
    
    [NSURLConnection sendAsynchronousRequest:[self GetCustomerListRequest:deptid pageIndex:@"1"]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError) {
             [Tool showAlert:@"网络异常" message:@"连接超时"];
         }
         else
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             //将数据变成标准的json数据
             NSData *newData = [[Tool newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSArray *ReturnList = [[dic objectForKey:@"JSON"]objectForKey:@"ReturnList"];
             for (id list in ReturnList) {
                 NSString *CustomerName = [list objectForKey:@"CustomerName"];
                 NSString *CustomerId = [list objectForKey:@"CustomerId"];
                 NSString *Mobile = [list objectForKey:@"Mobile"];
                 NSString *Address = [list objectForKey:@"Address"];
                 
                 [nameAry addObject:CustomerName];
                 [IDAry addObject:CustomerId];
                 [phoneAry addObject:Mobile];
                 [addrAry addObject:Address];
                 
             }
             [self.customerTable reloadData];
         }
     }];
}

/*
 功能：用户登录网络请求
 输入：DeptId：商家ID pageIndex：请求页数
 返回：网络请求
 */

- (NSMutableURLRequest*)GetCustomerListRequest:(NSString*)DeptId pageIndex:(NSString*)pageIndex
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode =[Tool readAuthCodeString];
    
    NSArray *key = @[@"authCode",@"DeptId",@"pageSize",@"pageIndex"];
    NSArray *object = @[authCode,DeptId,@"10",pageIndex];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=ShopManager/GetCustomerList",[Tool param:object forKey:key]];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}
#pragma mark 添加客户信息
/*
 功能：添加客户信息
 输入：null
 返回：null
 */

-(void)addCustomer
{
    [NSURLConnection sendAsynchronousRequest:[self addCustomer:@"li" sex:@"女" phone:@"13623658965" address:@"tianheruanjian" mark:@"12211" style:@[@"11",@"12"]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError) {
             [Tool showAlert:@"网络异常" message:@"连接超时"];
         }
         else
         {
             NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             //将数据变成标准的json数据
             NSData *newData = [[Tool newJsonStr:str] dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
             NSString *Json = [dic objectForKey:@"JSON"];
             if (Json != nil) {
                 //添加客户成功
                 NSLog(@"1");
             }
             else
             {
                 //添加客户失败
                 NSLog(@"2");
             }
         }
     }];
}

/*
 功能：添加客户信息网络请求
 输入：name：客户姓名 sex：性别 phone： address mark style
 返回：网络请求
 */
- (NSMutableURLRequest*)addCustomer:(NSString*)name sex:(NSString *)sex phone:(NSString*)phone address:(NSString *)address
                               mark:(NSString *)mark style:(NSArray*)styAry
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode =[Tool readAuthCodeString];
    
    //生成上传数据
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:authCode forKey:@"authCode"];
    
    NSMutableDictionary *jsonInfoDic = [[NSMutableDictionary alloc]init];
    
    [jsonInfoDic setValue:name forKey:@"name"];
    [jsonInfoDic setValue:sex forKey:@"sex"];
    [jsonInfoDic setValue:phone forKey:@"mobile"];
    [jsonInfoDic setValue:address forKey:@"address"];
    [jsonInfoDic setValue:mark forKey:@"remark"];
    [jsonInfoDic setValue:styAry forKey:@"categoryIds"];
    
    [dic setValue:jsonInfoDic forKey:@"JsonInfo"];
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=ShopManager/EditCustomerInfo",string];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameAry.count+1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [self cellFristRow:cell.contentView];
        }
        else
        {
            [self cellRow:cell.contentView name:[nameAry objectAtIndex:indexPath.row-1] phone:[phoneAry objectAtIndex:indexPath.row-1] address:[addrAry objectAtIndex:indexPath.row-1] style:[nameAry objectAtIndex:indexPath.row-1]];
        }
    }
    return cell;
}

-(void)cellFristRow:(UIView*)view
{
    NSArray *infoAry = @[@"客户姓名",@"手机号",@"地址",@"风格",@"备注"];
    NSArray *xAry = @[@0,@150,@300,@610,@870];
    NSArray *widthAry = @[@149,@149,@309,@259,@134];
    float h = view.frame.size.height;
    for (int i = 0; i < infoAry.count; i++) {
        id xPoint = [xAry objectAtIndex:i];
        id width = [widthAry objectAtIndex:i];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake([xPoint floatValue], 0, [width floatValue], h)];
        lab.text = [infoAry objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        
        if (i != 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake([xPoint floatValue], 0, 1, h)];
            lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [view addSubview:lineView];
        }
    }
}

-(void)cellRow:(UIView*)view name:(NSString *)name phone:(NSString*)phone address:(NSString*)address style:(NSString*)style
{
    NSArray *infoAry = @[name,phone,address,style,@"查看"];
    NSArray *xAry = @[@0,@150,@300,@610,@870];
    NSArray *widthAry = @[@149,@149,@309,@259,@134];
    float h = view.frame.size.height;
    for (int i = 0; i < infoAry.count; i++) {
        id xPoint = [xAry objectAtIndex:i];
        id width = [widthAry objectAtIndex:i];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake([xPoint floatValue], 0, [width floatValue], h)];
        lab.text = [infoAry objectAtIndex:i];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
    }
}

@end
