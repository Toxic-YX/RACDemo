//
//  Model.h
//  RAC多任务处理
//
//  Created by YuXiang on 2017/4/11.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
+ (instancetype)creactModelWithName:(NSString *)name age:(NSString *)age;
@end
