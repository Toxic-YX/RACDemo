//
//  NetworkEntity.h
//  RAC多任务处理
//
//  Created by YuXiang on 2017/4/10.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Model.h"

@interface NetworkEntity : NSObject
@property (nonatomic, strong) RACCommand *fetchEntity;
@end
