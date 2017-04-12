//
//  TwoViewController.h
//  RAC基础操作第一篇
//
//  Created by YuXiang on 2017/4/11.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

// 第一步: 在第二个控制器.h，添加一个RACSubject代替代理。
@interface TwoViewController : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;
@end
