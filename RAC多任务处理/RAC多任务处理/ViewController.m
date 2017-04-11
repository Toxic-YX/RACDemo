//
//  ViewController.m
//  RAC多任务处理
//
//  Created by YuXiang on 2017/4/10.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//  RAC处理多个网络请求的问题

#import "ViewController.h"
#import "NetworkEntity.h"
#import "Model.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *ageL;
@property (strong, nonatomic, nonnull) Model *M;
@property (strong, nonatomic, nonnull) NetworkEntity *entity;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _M = [Model creactModelWithName:@"李明" age:@"25"];
    self.nameL.text = _M.name;
    self.ageL.text = _M.age;
}

- (IBAction)requestDataRefreshUI:(UIButton *)sender {
    [self requestData];
}

- (void)requestData {
     @weakify(self)
    [[self.entity.fetchEntity execute:_M] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        NSLog(@"%@",tuple);
        // 更新更改后数据, 刷新UI
        self.nameL.text = tuple.first;
        self.ageL.text = tuple.last;
    }error:^(NSError *error) {
        NSLog(@"错误异常处理");
    }];
}

#pragma mark - 懒加载
- (NetworkEntity *)entity {
    if (!_entity) {
        _entity = [[NetworkEntity alloc] init];
    }
    return _entity;
}
@end
