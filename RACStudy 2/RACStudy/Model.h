//
//  Model.h
//  RACStudy
//
//  Created by 骆驼鱼 on 17/3/15.
//  Copyright © 2017年 毒药_YX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YXHTTPManager.h"
#import <MJExtension/MJExtension.h>
#import "Entity.h"

@interface Model : NSObject
@property (nonatomic, strong) RACCommand *fetchEntityCommand;
@end
