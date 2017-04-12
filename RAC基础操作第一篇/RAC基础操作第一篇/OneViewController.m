//
//  OneViewController.m
//  RAC基础操作第一篇
//
//  Created by YuXiang on 2017/4/11.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 第三步: 在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
- (IBAction)modalNextPage:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"TwoViewController"];
    TwoViewController *twoVC = (TwoViewController *)vc;
    // 设置代理信号
    twoVC.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    [twoVC.delegateSignal subscribeNext:^(id x) {
        NSLog(@"接收第二个界面的数据为:%@",x);
        NSLog(@"点击了通知按钮");
    }];
    
    // 跳转 第二个控制器
    [self presentViewController:twoVC animated:YES completion:nil];
}

- (IBAction)backLastPage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
