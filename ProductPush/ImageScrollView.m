//
//  ImageScrollView.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "ImageScrollView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ImageScrollView()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ImageScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
}

- (void)resetSubviews:(NSArray *)images
{
    CGSize size = self.frame.size;
    
    // set content size
    self.contentSize = CGSizeMake(kScreenWidth * [images count], size.height);
//    self.bounces = NO;
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    //设置页码控制器的响应方法
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    // reset sub imageviews
    if ([images count] > [self.subviews count]) {
        for (NSUInteger i = [self.subviews count]; i < [images count]; i++) {
            UIImageView *imageView = [[UIImageView alloc]
                                      initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, size.height)];
            imageView.contentMode = UIViewContentModeScaleToFill;
            [self addSubview:imageView];
        }
    } else if ([images count] < [self.subviews count]) {
        for (NSUInteger i = [self.subviews count] - 1; i > [images count]; i--) {
            UIView *view = self.subviews[i];
            [view removeFromSuperview];
        }
    }
}
- (void)changePage:(id)sender
{
    NSLog(@"指示器的当前索引值为:%ld",self.pageControl.currentPage);
    //获取当前视图的页码
    CGRect rect = self.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = self.pageControl.currentPage * self.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [self scrollRectToVisible:rect animated:YES];
}
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    [self resetSubviews:images];
    
    for (NSUInteger i = 0; i < [images count]; i++) {
        if ([images[i] isKindOfClass:[UIImage class]]) {
            UIImageView *view = self.subviews[i];
            view.image = images[i];
        }
    }
    
    // set page control
    self.pageControl.numberOfPages = [images count];
}

- (NSInteger)currentPage
{
    CGPoint offset = self.contentOffset;
    return (NSInteger)(offset.x + kScreenWidth / 2) / kScreenWidth;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.currentPage;
}

- (void)timerFireMethod:(NSTimer *)timer
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         CGPoint offset = self.contentOffset;
                         
                         NSUInteger currentPage = offset.x / kScreenWidth;
                         
                         NSUInteger nextPage = currentPage + 1;
                         nextPage = (nextPage == [self.images count]) ? 0 : nextPage;
                         self.pageControl.currentPage = nextPage;
                         
                         offset.x = kScreenWidth * nextPage;
                         
                         self.contentOffset = offset;
                         
                     }];
}

- (void)startScrollWithTimeInterval:(NSTimeInterval)intervel
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:intervel
                                                  target:self
                                                selector:@selector(timerFireMethod:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:intervel]];
}

- (void)endScroll
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
