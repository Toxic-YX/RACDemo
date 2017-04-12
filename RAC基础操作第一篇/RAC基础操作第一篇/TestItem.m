//
//  TestItem.m
//  RAC基础操作第一篇
//
//  Created by YuXiang on 2017/4/12.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "TestItem.h"

@implementation TestItem
+ (instancetype)testWithDict:(NSDictionary *)dict {
    TestItem *item = [[TestItem alloc] init];
    item.name = dict[@"name"];
    item.age = dict[@"age"];
    item.height = dict[@"height"];
    return item;
}

-  (NSString *)description {
    return [NSString stringWithFormat:@"%@,%@, %@ ",self.name, self.age, self.height];
}
@end
