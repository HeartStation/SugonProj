//
//  ImageScrollView.h
//  ProductPush
//  图片循环滚动视图
//  Created by 高振伟 on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (nonatomic, readonly) NSInteger currentPage;

- (void)startScrollWithTimeInterval:(NSTimeInterval)intervel;
- (void)endScroll;

@end
