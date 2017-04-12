//
//  TwoViewController.m
//  RAC基础操作第一篇
//
//  Created by YuXiang on 2017/4/11.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "TwoViewController.h"


@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

// 第二步: 监听第二个控制器按钮点击
- (IBAction)backLastPage:(UIButton *)sender {
    
    // 通知第一个控制器，告诉它，按钮被点了
    
    // 通知代理
    // 判断代理信号是否有值
    
    if (self.delegateSignal) {
        // 有值, 才需要通知
        NSLog(@"第二个页面,按钮呗点击");
        [self.delegateSignal sendNext:@5];
    }
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
