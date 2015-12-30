//
//  HomeViewController.m
//  loveleft
//
//  Created by qianfeng on 15/12/29.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "HomeViewController.h"
//打开抽屉
#import "UIViewController+MMDrawerController.h"
//二维码扫描
#import "CustomViewController.h"
//广告轮播
#import "Carousel.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "HomeDetailViewController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    Carousel * _cyclePlaying;
    UITableView * _tableView;
    int _page;


}
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self createTableHeaderView];
    [self createTableView];
    [self createRefresh];
}
#pragma mark -- 刷新数据
-(void)createRefresh{

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
    //当程序运行时自动刷新一次
    [_tableView.header beginRefreshing];


}
//下拉刷新
-(void)LoadNewData{

    _page = 1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self getData];

}
//上啦加载
-(void)LoadMoreData{

    _page ++;
    [self getData];

}
#pragma mark -- 请求数据
-(void)getData {
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:HOMEURL,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary * dic in responseObject[@"data"][@"topic"]) {
            HomeModel * model = [[HomeModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
            
        }
        if (_page == 1) {
            [_tableView.header endRefreshing];
        }
        else{
            [_tableView.footer endRefreshing];
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark -- 创建tableview的头视图
-(void)createTableHeaderView{

    _cyclePlaying = [[Carousel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3)];
    
    _cyclePlaying.needPageControl = YES;
    //是否需要轮播
    _cyclePlaying.infiniteLoop = YES;
    //设置pageController的位置
    _cyclePlaying.pageControlPositionType = PAGE_CONTROL_POSITION_TYPE_MIDDLE;
    _cyclePlaying.imageArray = @[@"shili8",@"shili2",@"shili10",@"shili13"];

}
#pragma mark -- 创建tableview
-(void)createTableView{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   [self.view addSubview:_tableView];
    //修改分割线
    //1.
    //_tableView.separatorColor = [UIColor clearColor];
    //2.
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉多余的先
    //_tableView.tableFooterView = [[UIView alloc]init];
    //设置头视图
    _tableView.tableHeaderView = _cyclePlaying;

}
#pragma mark -- 协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    if (self.dataArray) {
        HomeModel * model = self.dataArray[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeDetailViewController * vc = [[HomeDetailViewController alloc]init];
    
    HomeModel * model = self.dataArray[indexPath.row];
    
    vc.dataID = model.dataID;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark --设置导航
-(void)settingNav{

    self.titleLabel.text = @"爱生活";
    [self.leftButton setImage:[UIImage imageNamed:@"icon_function"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"2vm"] forState:UIControlStateNormal];
    //设置响应事件
    [self setLeftButtonClick:@selector(leftButtonClick)];
    [self setRightButtonClick:@selector(rightButtonClick)];


}
#pragma mark -- 按钮响应事件
-(void)leftButtonClick{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)rightButtonClick{
    CustomViewController * vc = [[CustomViewController alloc]initWithIsQRCode:NO Block:^(NSString * result, BOOL isSucceed) {
        if (isSucceed) {
            NSLog(@"%@",result);
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
