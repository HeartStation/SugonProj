//
//  MessageItem.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (strong, nonatomic) NSString *newsId;
@property (strong, nonatomic) NSString *newsTitle;
@property (strong, nonatomic) NSString *newsURL;
@property (strong, nonatomic) NSString *addTime;
@property (strong, nonatomic) NSString *newsType;
@property (strong, nonatomic) NSString *sortOrder;

- (id)initWithDic:(NSDictionary *)dic;


+ (void)getNewsListByType:(NSString *)newsType completeBlock:(void (^)(NSArray *array))block;

@end

