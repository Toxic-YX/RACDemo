//
//  TestItem.h
//  RAC基础操作第一篇
//
//  Created by YuXiang on 2017/4/12.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *height;
+ (instancetype)testWithDict:(NSDictionary *)dict;
@end
