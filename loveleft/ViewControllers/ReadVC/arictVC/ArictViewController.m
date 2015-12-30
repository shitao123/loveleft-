//
//  ArictViewController.m
//  loveleft
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ArictViewController.h"
#import "ReadModel.h"
#import "ArictCell.h"
#import "ArictDetailViewController.h"
@interface ArictViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView * _tabV;
    //分页
    int  _page;
    
}
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation ArictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self createRefresh];
    
}
#pragma mark -- 刷新数据
-(void)createRefresh{

    _tabV.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tabV.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_tabV.header beginRefreshing];
}
#pragma mark -- 实现刷新方法
-(void)loadNewData{
    _page = 0;
    self.dataArray = [[NSMutableArray alloc]init];
    [self getData];
}
-(void)loadMoreData{
    _page ++;
    [self getData];
}
#pragma mark -- 请求数据
-(void) getData{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //手动设置格式，默认支持json
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:[NSString stringWithFormat:ARTICALURL,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray * array = responseObject[@"data"];
        
        for (NSDictionary *dic  in array) {
            
            ReadModel * model = [[ReadModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataArray addObject:model];
            
        }
        //停止刷新
        if (_page == 0) {
            
            [_tabV.header endRefreshing];
        }
        else{
            
            [_tabV.footer endRefreshing];
        
        }
        //刷新tableView
        [_tabV reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark -- 创建tableView
-(void) createTableView{

    _tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tabV.delegate = self;
    _tabV.dataSource =self;
    
    [self.view addSubview:_tabV];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;

}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ArictCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ArictID"];
    if (!cell) {
        cell = [[ArictCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArictID"];
    }
    //给cell赋值
    if (self.dataArray) {
        ReadModel * model = self.dataArray[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}
//给cell添加小动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    //设置cell的动画效果为3D效果
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:2 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ArictDetailViewController * vc =[[ArictDetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    ReadModel * model = self.dataArray[indexPath.row];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
