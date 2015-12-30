//
//  ArictDetailViewController.m
//  loveleft
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "ArictDetailViewController.h"

@interface ArictDetailViewController ()

@end

@implementation ArictDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self createUI];
}
#pragma amrk -- 创建UI
-(void)createUI{

    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    //loadHTMLString加载的类似标签的字符串，loadRequest加载的市网址
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:ARTICALDETAILURL,self.model]]]];
    //使得webView适应屏幕大小
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];

    //webView 与javaSript的交互



}
-(void)settingNav{

    self.titleLabel.text = @"详情";
    [self.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self setRightButtonClick:@selector(rightButtonClick)];
    [self setLeftButtonClick:@selector(leftButtonClick)];
}
#pragma mark -- 按钮响应方法
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//友盟分享
-(void)rightButtonClick{
    //下载网络图片
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.pic]]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:APPKEY shareText:[NSString stringWithFormat:ARTICALDETAILURL,self.model] shareImage:image shareToSnsNames:@[UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatTimeline] delegate:nil];
}
@end
