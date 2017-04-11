//
//  Model.m
//  RACStudy
//
//  Created by 骆驼鱼 on 17/3/15.
//  Copyright © 2017年 毒药_YX. All rights reserved.
//

#import "Model.h"

@implementation Model
- (instancetype)init {
  if (self = [super init]) {
    [self setupRACCommad];
  }
  return self;
}
// 创建指令
- (void)setupRACCommad {
  @weakify(self);
  _fetchEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
      @strongify(self);
      [self requestForEntityWithUrl:input success:^(NSArray *array) {
        NSArray *arrayM = [Entity objectArrayWithKeyValuesArray:array];
        [subscriber sendNext:arrayM];
        [subscriber sendCompleted];
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      }];
      return nil;
    }];
  }];
}

// 数据请求
- (void)requestForEntityWithUrl:(NSString *)url success:(void(^)(NSArray *array))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
  [[YXHTTPManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
    
    NSString *key = [responseObject.keyEnumerator nextObject];
    NSArray *temArray = responseObject[key];
    success(temArray);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failure(operation,error);
    
  }];
}

@end
