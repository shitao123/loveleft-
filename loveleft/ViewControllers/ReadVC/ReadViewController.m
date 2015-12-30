//
//  ReadViewController.m
//  loveleft
//
//  Created by qianfeng on 15/12/29.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ReadViewController.h"
#import "ArictViewController.h"
#import "StoryViewController.h"
@interface ReadViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    UISegmentedControl * _segmentControl;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
}
-(void)createNav{
    //创建步进器
    _segmentControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    //插入标题
    [_segmentControl insertSegmentWithTitle:@"读美文" atIndex:0 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"看语录" atIndex:1 animated:YES];
    //字体颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    //设置默认选中
    _segmentControl.selectedSegmentIndex = 0;
    //响应方法
    [_segmentControl addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentControl;
}
#pragma mark -- 创建UI
-(void)createUI{

    //创建ScrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    //设置代理
    _scrollView.delegate = self;
    //设置分页
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    //隐藏指示条
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview: _scrollView];
    //设置contentSize
    _scrollView.contentSize = CGSizeMake(SCREEN_W * 2, 0);
    
    //实例化子控制器
    ArictViewController * arictVC = [[ArictViewController alloc]init];
    
    StoryViewController * storyVC = [[StoryViewController alloc]init];
    
    NSArray * VCArray = @[arictVC,storyVC];
    
    //滚动式的框架实现
    
    int i=0;
    
    for (UIViewController * vc in VCArray) {
        
        vc.view.frame = CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H);
        
        [self addChildViewController:vc];
        
        [_scrollView addSubview:vc.view];
        
        i ++;
        
    }
}
#pragma mark -- 实现segment响应方法
-(void)changeOption:(UISegmentedControl *)segment{

    _scrollView.contentOffset = CGPointMake(segment.selectedSegmentIndex * SCREEN_W, 0);
    
}
#pragma mark -- scrollView的协议方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    _segmentControl.selectedSegmentIndex = scrollView.contentOffset.x/SCREEN_W;

}
@end
