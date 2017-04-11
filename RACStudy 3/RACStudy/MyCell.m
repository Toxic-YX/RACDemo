//
//  MyCell.m
//  RACStudy
//
//  Created by 骆驼鱼 on 17/3/15.
//  Copyright © 2017年 毒药_YX. All rights reserved.
//

#import "MyCell.h"

@interface MyCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iocn;
@property (strong, nonatomic) IBOutlet UILabel *title;
@end

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEntity:(Entity *)entity {
  self.title.text = entity.title;
  [self.iocn sd_setImageWithURL:[NSURL URLWithString:entity.imgsrc] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
  }];
}

@end
