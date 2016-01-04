//
//  ImageScrollTableViewCell.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"

@interface ImageScrollTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ImageScrollView *imageScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;




@end
