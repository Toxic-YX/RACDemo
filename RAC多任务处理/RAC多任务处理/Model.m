//
//  Model.m
//  RAC多任务处理
//
//  Created by YuXiang on 2017/4/11.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "Model.h"

@implementation Model
+ (instancetype)creactModelWithName:(NSString *)name age:(NSString *)age {
    Model *m = [[Model alloc] init];
    m.name = name;
    m.age = age;
    return m;
}
@end
