//
//  ShopViewController.m
//  导客宝
//
//  Created by apple1 on 15/10/8.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "ShopViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "Tool.h"
#import "qjtSingleton.h"
#import "Popover.h"

@interface ShopViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *examineView;
    UITableView *qjtTableView;
    BOOL isCloud;
    
    NSMutableArray *qjtIDArray;
    NSMutableArray *qjtNameArray;
    NSMutableArray *qjtImageArray;
    
    BOOL isSelect;
    UIView *seleceView;
    
    UIView *styleView;
    UIView *areaView;
    UIView *spaceView;
    
    UIPopoverController *popover;
}
//改变类型
- (IBAction)changeStyle:(id)sender;
//客户信息
- (IBAction)userInformation:(id)sender;
//搜索
- (IBAction)search:(id)sender;
//筛选
- (IBAction)select:(id)sender;

//筛选按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *typebutton;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;

@end

@implementation ShopViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    //isCloud = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.faceImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouch:)];
    
    [self.faceImage addGestureRecognizer:tapGestureTel];

    qjtTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100)];
    qjtTableView.delegate = self;
    qjtTableView.dataSource = self;
    qjtTableView.separatorStyle = NO;
    [self.view addSubview:qjtTableView];
    
    qjtIDArray = [[NSMutableArray alloc]init];
    qjtNameArray = [[NSMutableArray alloc]init];
    qjtImageArray = [[NSMutableArray alloc]init];
    [self GetQJTList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
   
}
- (void)tongzhi:(NSNotification *)text{
    
    if (popover) {
        [popover dismissPopoverAnimated:NO];
    }
    if([text.userInfo[@"type"] isEqualToString:@"曲美装饰"])
    {
        [self.typebutton setTitle:@"曲美装饰" forState:UIControlStateNormal];
        isCloud = NO;
         [qjtTableView reloadData];
    }
    else
    {
        [self.typebutton setTitle:@"云库" forState:UIControlStateNormal];
        isCloud = YES;
        //NSLog(@"%d",qjtImageArray.count);
         [qjtTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeStyle:(id)sender {
    UIButton *button = (UIButton*)sender;
    Popover *qktb = [[Popover alloc]init];
    qktb.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    
    // 创建一个UIPopover
    
    popover = [[UIPopoverController alloc]initWithContentViewController:qktb];
    popover.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    
    // 设置尺寸
    
    popover.popoverContentSize = CGSizeMake(100, 60);
    
    // 从哪里出来
    [popover presentPopoverFromRect:button.frame inView:button.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)userInformation:(id)sender {
    [self performSegueWithIdentifier:@"customer" sender:self];
}

- (IBAction)search:(id)sender {
   
}

- (IBAction)select:(id)sender {
    if (!isSelect) {
        isSelect = !isSelect;
        [self.selectButton setImage:[[UIImage imageNamed:@"shaixuan-dianji"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self selectView];
        float ypoint = qjtTableView.frame.origin.y+95;
        qjtTableView.frame = CGRectMake(0, ypoint, self.view.frame.size.width, self.view.frame.size.height-195);
    }
    else
    {
        isSelect = !isSelect;
        [self.selectButton setImage:[[UIImage imageNamed:@"shaixuan-weidianji"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        float ypoint = qjtTableView.frame.origin.y-95;
        qjtTableView.frame = CGRectMake(0, ypoint, self.view.frame.size.width, self.view.frame.size.height-100);
        [seleceView removeFromSuperview];
    }
}

-(void)selectView
{
    seleceView = [[UIView alloc]initWithFrame:CGRectMake(0, 82, self.view.frame.size.width, 90)];
    seleceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seleceView];
    
    styleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (seleceView.frame.size.width)/3, seleceView.frame.size.width)];
    NSMutableArray *a = [[NSMutableArray alloc]initWithObjects:@"全部",@"北欧现代",@"现代",@"欧式",@"中式",@"美式",@"韩式田园",@"地中海", nil];
    [self drawSelectView:styleView title:@"风格" list:a labTag:0];
    [seleceView addSubview:styleView];
    
    areaView = [[UIView alloc]initWithFrame:CGRectMake((seleceView.frame.size.width)/3, 0, (seleceView.frame.size.width)/3, seleceView.frame.size.width)];
    
    [self drawSelectView:areaView title:@"面积" list:a labTag:1];
    [seleceView addSubview:areaView];
    
    spaceView = [[UIView alloc]initWithFrame:CGRectMake((2*seleceView.frame.size.width)/3, 0, (seleceView.frame.size.width)/3, seleceView.frame.size.width)];
    
    [self drawSelectView:spaceView title:@"空间" list:a labTag:2];
    [seleceView addSubview:spaceView];
    
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isCloud) {
        if (indexPath.row == 0) {
            return 500;
        }
        else
            return 250;
    }
    else
        return 250;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (qjtImageArray.count <= 0) {
        return 0;
    }
    else if (qjtImageArray.count%3 !=  0)
    {
        return (qjtImageArray.count/3)+1;
    }
    else
        return (qjtImageArray.count/3) ;
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

    }
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    if (!isCloud) {
        if (indexPath.row == 0) {
            if (qjtImageArray.count <= 3) {
                for (int i = 0; i < qjtImageArray.count; i++) {
                    if (i ==0) {
                        UIView *view = [self qjtDraw:CGRectMake(10, 5, 665, 490) qjtImage:[qjtImageArray objectAtIndex:0] title:[qjtNameArray objectAtIndex:0] isCollect:YES tag:0];
                        [cell.contentView addSubview:view];
                    }
                    else
                    {
                        UIView *view = [self qjtDraw:CGRectMake(690, 5+250*(i-1), 325, 240) qjtImage:[qjtImageArray objectAtIndex:i] title:[qjtNameArray objectAtIndex:i] isCollect:YES tag:i];
                        [cell.contentView addSubview:view];
                    }
                }
                
            }
            else
            {
                for (int i = 0; i < 3; i++) {
                    if (i ==0) {
                        UIView *view = [self qjtDraw:CGRectMake(10, 5, 665, 490) qjtImage:[qjtImageArray objectAtIndex:0] title:[qjtNameArray objectAtIndex:0] isCollect:YES tag:0];
                        [cell.contentView addSubview:view];
                    }
                    else
                    {
                        UIView *view = [self qjtDraw:CGRectMake(690, 5+250*(i-1), 325, 240) qjtImage:[qjtImageArray objectAtIndex:i] title:[qjtNameArray objectAtIndex:i] isCollect:YES tag:i];
                        [cell.contentView addSubview:view ];
                    }
                }
            }
        }
        else
        {
            if (indexPath.row != (qjtImageArray.count/3)) {
                
                for (int i = 0; i < 3; i++) {
                    UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[qjtImageArray objectAtIndex:3*indexPath.row+i] title:[qjtNameArray objectAtIndex:3*indexPath.row+i] isCollect:YES tag:3*indexPath.row+i];
                    [cell.contentView addSubview:view];
                }
            }
            else
            {
                for (int i = 0; i < qjtImageArray.count%3; i++) {
                    
                    UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[qjtImageArray objectAtIndex:3*indexPath.row+i] title:[qjtNameArray objectAtIndex:3*indexPath.row+i] isCollect:YES tag:3*indexPath.row+i];
                    [cell.contentView addSubview:view];
                }
            }
        }
    }
    else
    {
        if (indexPath.row != (qjtImageArray.count/3)) {
            for (int i = 0; i < 3; i++) {
                
                UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[qjtImageArray objectAtIndex:3*indexPath.row+i] title:[qjtNameArray objectAtIndex:3*indexPath.row+i] isCollect:YES tag:3*indexPath.row+i];
                [cell.contentView addSubview:view];
            }
        }
        else
        {
            for (int i = 0; i < qjtImageArray.count%3; i++) {
                
                UIView *view = [self qjtDraw:CGRectMake(10+340*i, 5, 325, 240) qjtImage:[qjtImageArray objectAtIndex:3*indexPath.row+i] title:[qjtNameArray objectAtIndex:3*indexPath.row+i] isCollect:YES tag:3*indexPath.row+i];
                [cell.contentView addSubview:view];
            }
        }
    }

    return cell;
}
#pragma mark 全景图展示

-(UIView *)qjtDraw:(CGRect)rect qjtImage:(NSString*)qjtImage title:(NSString*)qjtTitle isCollect:(BOOL)isCollect tag:(int)tag
{
    UIView *qjtView = [[UIView alloc]initWithFrame:rect];
    qjtView.tag = tag;
    
    UIImageView *qjtImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
  
    [qjtImageView sd_setImageWithURL:[NSURL URLWithString:qjtImage] placeholderImage:[UIImage imageNamed:@"jiazaipic"]];
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
    isCollectionImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *collectGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collent:)];
    
    [isCollectionImageView addGestureRecognizer:collectGestureTel];
    
    
    qjtView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touch:)];
    
    [qjtView addGestureRecognizer:tapGestureTel];
    
    return qjtView;
}

-(void)touch:(UIGestureRecognizer*)gestureRecognizer
{
    UIView *view  =(UIView*)gestureRecognizer.view;
    
    qjtSingleton *single = [qjtSingleton initQJTSingleton];
    single.qjtName = [qjtNameArray objectAtIndex:view.tag];
    single.qjtId = [qjtIDArray objectAtIndex:view.tag];
    [self performSegueWithIdentifier:@"qjtinfo" sender:self];
}
-(void)collent:(UIGestureRecognizer*)gestureRecognizer
{
    NSLog(@"11");
}
#pragma mark 获取全景图列表
/*
 功能：获取全景图列表
 输入：null
 返回：null
 */
-(void)GetQJTList
{
    [NSURLConnection sendAsynchronousRequest:[self GetQJTListRequest:@"1"]
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
                 NSString *SchemeId = [list objectForKey:@"SchemeId"];
                 NSString *SchemeName = [list objectForKey:@"SchemeName"];
                 NSString *ImagePath = [NSString stringWithFormat:@"%@%@",[Tool requestImageURL],[list objectForKey:@"ImagePath"]];
                 [qjtIDArray addObject:SchemeId];
                 [qjtNameArray addObject:SchemeName];
                 [qjtImageArray addObject:ImagePath];
             }
             [qjtTableView reloadData];
         }
     }];
}

/*
 功能：获取全景图网络请求
 输入：DeptId：商家ID pageIndex：请求页数
 返回：网络请求
 */
- (NSMutableURLRequest*)GetQJTListRequest:(NSString*)pageIndex
{
    NSURL *requestUrl = [NSURL URLWithString:[Tool requestURL]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:requestUrl];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    
    NSString *authCode =[Tool readAuthCodeString];
    
    NSArray *key = @[@"authCode",@"pageSize",@"pageIndex"];
    NSArray *object = @[authCode,@"9",pageIndex];
    
    NSString *param=[NSString stringWithFormat:@"Params=%@&Command=ShopManager/GetQJTList",[Tool param:object forKey:key]];
    NSLog(@"http://passport.admin.3weijia.com/mnmnhwap.axd?%@",param);
    
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}
#pragma mark 搜索分类

-(void)drawSelectView:(UIView*)view title:(NSString*)title  list:(NSMutableArray*)listData labTag:(int)tag
{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 100, 20)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:15];
    [view addSubview:titleLab];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(25, 34, 50, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
    [view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(75, 34, 200, 1)];
    lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:lineView2];
    
    for (int i = 0; i < listData.count; i++) {
        if (i >= 8) {
            return;
        }
        int row = i/4;
        int col = i%4;
        
        UILabel *lab = [[UILabel alloc]init];
        lab.frame = CGRectMake(25+60*col, 40+25*row, 60, 20);
        lab.tag = tag;
        lab.text = [listData objectAtIndex:i];
        if (i == 0) {
            lab.textColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
        }
        lab.font = [UIFont systemFontOfSize:12.0f];
        if (col == 0) {
            lab.textAlignment = NSTextAlignmentLeft;
        }
        else if (col == 3) {
            lab.textAlignment = NSTextAlignmentRight;
        }
        else
            lab.textAlignment = NSTextAlignmentCenter;

        [view addSubview:lab];
        
        lab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureTel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouch:)];
        
        [lab addGestureRecognizer:tapGestureTel];

    }
}
-(void)labelTouch:(UIGestureRecognizer*)gestureRecognizer
{
    UILabel *lab=(UILabel*)gestureRecognizer.view;
    if (lab.tag == 0) {
        [self setLabelColor:styleView string:lab.text];
    }
    else if (lab.tag == 1)
    {
        [self setLabelColor:areaView string:lab.text];
    }
    else
    {
        [self setLabelColor:spaceView string:lab.text];
    }
}

-(void)setLabelColor:(UIView*)view string:(NSString*)string
{
    for (id obj in [view subviews]) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel*)obj;
            
            if ([label.text isEqualToString:string]) {
                label.textColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
            }
            else
            {
                label.textColor = [UIColor blackColor];
            }
        }
    }
}

#pragma mark 个人信息设置

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
    closeBtn.frame = CGRectMake(15, 15, 14, 14);
    
    [closeBtn setImage:[[UIImage imageNamed:@"cha"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
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

@end
