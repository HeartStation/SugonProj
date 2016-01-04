//
//  ImageScrollTableViewCell.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "ImageScrollTableViewCell.h"

@implementation ImageScrollTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    // 解决子视图ScrollView将TableViewCell点击事件屏蔽的解决方案
    self.imageScrollView.userInteractionEnabled = NO;
    [self.contentView addGestureRecognizer:self.imageScrollView.panGestureRecognizer];
    
    self.imageScrollView.pageControl = self.pageControl;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
