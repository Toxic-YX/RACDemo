//
//  ViewController.m
//  RAC基础操作第二篇
//
//  Created by YuXiang on 2017/4/10.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//  

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self racCommonlyUsedDelegate];
    /* ---------------------------------------------------------------------------------------------- */
    // RACMulticastConnection 用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
    // 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
    
    // RACMulticastConnection简单使用:
    
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // RACMulticastConnection底层原理:
    // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
    // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
    // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
    // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
    // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
    // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
    // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
    // ****** 问题重现
    // 1.创建请求信号
    __block int time = 1;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSLog(@"发送数据请求了%d次",time++);
         [subscriber sendNext:@1];
        return nil;
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收数据第一次");
        
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收数据第二次");
        
    }];
    
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求
    
    // ****** 问题解决
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSLog(@"解决问题后发送数据请求 %d次",time++);
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 2.创建连接
    RACMulticastConnection *connect = [signal2 publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者一信号");
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二信号");
        
    }];
    
    // 4.连接,激活信号
    [connect connect];
    
    
    /*  ------------------------------------------------------------------------------ */
    // RACScheduler:RAC中的队列, 用GCD封装的
    // RACUnit :表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
    // RACEvent: 把数据包装成信号事件(signal event)。它主要通过RACSignal的-materialize来使用，然并卵。
}

// ReactiveCocoa开发中常见用法。
// 开发中经常用的 监听
- (void)racCommonlyUsedDelegate {
    // 代理的替代
   // rac_signalForSelector：用于替代代理。
    
    // kvo 替代
    // rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
    
    // 监听事件
    // rac_signalForControlEvents：用于监听某个事件。
    
    // 代替通知
    // rac_addObserverForName:用于监听某个通知。
    
    // 监听文本框文字改变:
    // rac_textSignal:只要文本框发出改变就会发出这个信号。

    // 处理当界面有多次请求时，需要都获取到数据时，才能展示界面
    // rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
    // 使用注意：几个信号，参数一的方法就有几个参数，每个参数对应信号发出的数据。
    
    [self codeDemo];
    
}

- (void)codeDemo {
    // 代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redBtn调用btnClick:,就会发出信号，订阅就好了。
    
    [[self.redV rac_signalForSelector:@selector(didClickedButton:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[_redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];

}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

- (IBAction)didClickedButton:(UIButton *)sender {
}
@end
