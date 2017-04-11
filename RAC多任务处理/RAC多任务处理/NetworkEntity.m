//
//  NetworkEntity.m
//  RAC多任务处理
//
//  Created by YuXiang on 2017/4/10.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "NetworkEntity.h"

@implementation NetworkEntity
- (instancetype)init {
    if (self = [super init]) {
        [self requestCommend];
    }
    return self;
}

- (void)requestCommend {
    _fetchEntity = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(Model *input) {
        Model *newM = [[Model alloc] init];
        RACSignal *signalOne = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 请求1
            [self requestFirstNetwork:input.name completedSuccess:^(NSString *name) {
                NSLog(@"请求1");
                if ([name isEqualToString:@"李明"]) {
                    newM.name = @"张三";
                    [subscriber sendNext:newM.name];
                    [subscriber sendCompleted];
                }
            } completedFail:^(id obj) {
                NSLog(@"接口1错误异常处理");
            }];
            return nil;
        }];
        
        RACSignal *signalTwo = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 请求2
            [self requestSecondNetwork:input.age completedSuccess:^(NSString *age) {
                NSLog(@"请求2");
                if ([age isEqualToString:@"25"]) {
                    newM.age = @"40";
                    [subscriber sendNext:newM.age];
                    [subscriber sendCompleted];
                }

            } completedFail:^(id obj) {
                 NSLog(@"接口2错误异常处理");
            }];
            return nil;
        }];
        
        return [signalOne combineLatestWith:signalTwo];
    }];
}

- (void)requestFirstNetwork:(NSString *)name completedSuccess:(void (^)(NSString *name))success completedFail:(void (^)(id obj))fail {
    success(name);
}

- (void)requestSecondNetwork:(NSString *)age completedSuccess:(void (^)(NSString *age))success completedFail:(void (^)(id obj))fail {
    success(age);
}
@end
