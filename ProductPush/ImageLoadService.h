//
//  ImageLoadService.h
//  TaoXue
//
//  Created by 高振伟 on 15-7-7.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLoadService : NSObject

typedef void (^ImageBlock)(id image);

+ (UIImage *)imageFrom:(NSString *)url;

+ (void)downLoadImageFrom:(NSString *)url completeHandler:(ImageBlock)block;

@end
