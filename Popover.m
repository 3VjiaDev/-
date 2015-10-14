//
//  Popover.m
//  导客宝
//
//  Created by 3Vjia on 15/10/14.
//  Copyright (c) 2015年 3vja. All rights reserved.
//

#import "Popover.h"
#import "ShopViewController.h"

@interface Popover ()
{
    ShopViewController *oceanaViewController;
    NSString *selectStr;
}
@property(nonatomic,strong)NSArray *menus;
@end

@implementation Popover

-(NSArray *)menus
 {
    if (_menus==nil) {
            _menus=@[@"曲美装饰",@"云库"];
        }
    return _menus;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
     return self.menus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = NO;
    tableView.scrollEnabled = NO;
    static NSString *ID=@"ID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            //239/255.0, 142/255.0, 61/255.0
            cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0 green:142/255.0 blue:61/255.0 alpha:1.0f];
        }
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 20)];
    lab.text = self.menus[indexPath.row];
    lab.font = [UIFont systemFontOfSize:15.0f];
    lab.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == 0) {
        lab.textColor = [UIColor whiteColor];
    }
    [cell.contentView addSubview:lab];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectStr =[[NSString alloc] initWithFormat:@"%@",[[self menus] objectAtIndex:indexPath.row]];
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:selectStr,@"type", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    
    //通过通知中心发送通知
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
