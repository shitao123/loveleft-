//
//  HomeDetailViewController.m
//  loveleft
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "HomeDetailViewController.h"

@interface HomeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView * _tableView;
    //头部图片
    UIImageView * _headerImageView;
    //头部文字
    UILabel * _headerLabel;
    
}
//头部视图的数据
@property (nonatomic,strong) NSMutableDictionary * dataDic;
//tableView的数据
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self createUI];
    [self loadData];
}
#pragma mark -- 请求数据
-(void)loadData{

    self.dataDic = [[NSMutableDictionary alloc]init];
    
    self.dataArray = [[NSMutableArray alloc]init];

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:HOMEDETAIL,[self.dataID intValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //头视图的数据
        self.dataDic = responseObject[@"data"];
        //tableView的数据
        self.dataArray = self.dataDic[@"product"];
        //数据请求完成后  刷新页面
        [self reloadHeaderView];
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];



}
#pragma mark -- 刷新头视图
-(void) reloadHeaderView{


    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"pic"]] placeholderImage:[UIImage imageNamed:@""]];
    _headerLabel.text = self.dataDic[@"desc"];
    

}
#pragma mark -- 创建UI
-(void)createUI{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _headerImageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3) imageName:nil];
    
    _headerLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, _headerImageView.frame.size.height-50, SCREEN_W, 50) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10]];
    
    _headerLabel.numberOfLines=0;
    
    [_headerImageView addSubview:_headerLabel];
    
    _tableView.tableHeaderView = _headerImageView;


}
#pragma mark -- tableView的协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * sectionArray = self.dataArray[section][@"pic"];
    
    return sectionArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailID"];
        UIImageView * imageView = [FactoryUI createImageViewWithFrame:CGRectMake(10, 10, SCREEN_W-20, 200) imageName:nil];
        imageView.tag = 10;
        [cell.contentView addSubview:imageView];
    }
    //赋值
    UIImageView * imageView = (UIImageView *)[cell.contentView viewWithTag:10];
    if (self.dataArray) {
        
        NSArray * sectionArray = self.dataArray[indexPath.section][@"pic"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:sectionArray[indexPath.row][@"pic"]] placeholderImage:[UIImage imageNamed:@""]];
        
    }
    return cell;


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
return self.dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 220;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * bgView = [FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    bgView.backgroundColor = [UIColor whiteColor];
    //索引
    UILabel * indexLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, 10, 40, 40) text:[NSString stringWithFormat:@"%ld",section + 1] textColor:[UIColor redColor] font:[UIFont systemFontOfSize:16]];
    indexLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    indexLabel.layer.borderWidth = 2;
    indexLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:indexLabel];
    //标题
    UILabel * titleLabel = [FactoryUI createLabelWithFrame:CGRectMake(indexLabel.frame.size.width+indexLabel.frame.origin.x+10, 10, 200, 40) text:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:18]];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    //价钱
    UIButton * button = [FactoryUI createButtonWithFrame:CGRectMake(290, 10, 60, 40) title:nil titleColor:[UIColor darkGrayColor] imageName:nil backgroundImageName:nil target:self selector:@selector(priceButtonClick)];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:button];
    //赋值
    titleLabel.text = self.dataArray[section][@"title"];
    [button setTitle:[NSString stringWithFormat:@"¥%@",self.dataArray[section][@"price"]] forState:UIControlStateNormal];
    
    return bgView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;

}
#pragma mark -- 设置导航
-(void)settingNav{

    self.titleLabel.text = @"详情";
    
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_pressed@2x"] forState:UIControlStateNormal];
    
    [self setLeftButtonClick:@selector(leftButtonClick)];

}
#pragma mark -- 响应事件
-(void)leftButtonClick{

    [self.navigationController popViewControllerAnimated:YES];

}

@end
