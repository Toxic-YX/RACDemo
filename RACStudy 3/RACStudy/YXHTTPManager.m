//
//  YXHTTPManager.m
//  RACStudy
//
//  Created by 骆驼鱼 on 17/3/15.
//  Copyright © 2017年 毒药_YX. All rights reserved.
//

#import "YXHTTPManager.h"

@implementation YXHTTPManager
+ (instancetype)manager {
  
  YXHTTPManager *mgr = [super manager];
  NSMutableSet *mgrSet = [NSMutableSet set];
  mgrSet.set = mgr.responseSerializer.acceptableContentTypes;
  [mgrSet addObject:@"text/html"];
  mgr.responseSerializer.acceptableContentTypes = mgrSet;

  return mgr;
}

@end
