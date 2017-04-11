//
//  Entity.m
//  RACStudy
//
//  Created by 骆驼鱼 on 17/3/15.
//  Copyright © 2017年 毒药_YX. All rights reserved.
//

#import "Entity.h"

@implementation Entity
+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
  Entity *model = [[self alloc]init];
  
  [model setValuesForKeysWithDictionary:dict];
  
  return model;
}

@end
