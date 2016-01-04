//
//  MessageItem.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "NewsItem.h"
#import "HTTPRequestService.h"
#import "SimpleAlertView.h"
#import "User.h"

@implementation NewsItem

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self = [self setAttributes:dic];
    }
    return self;
}

- (NewsItem *)setAttributes:(NSDictionary *)dic
{
    self.newsId = [dic objectForKey:@"id"];
    self.newsTitle = [dic objectForKey:@"newsTitle"];
    
    NSString *baseUrl = [@"http://x86.sugon.com/" stringByAppendingString:[dic objectForKey:@"newsURL"]];
    NSString *fullUserName = [[User currentUser].userName stringByAppendingString:@"@sugon.com"];
    NSString *paramsStr = [NSString stringWithFormat:@"&username=%@&password=%@",fullUserName,[User currentUser].password];
    self.newsURL = [baseUrl stringByAppendingString:paramsStr];
    
    self.addTime = [[dic objectForKey:@"addTime"] substringToIndex:10];
    self.newsType = [dic objectForKey:@"newsType"];
    self.sortOrder = [dic objectForKey:@"sortOrder"];
    
    return self;
}

+ (void)getNewsListByType:(NSString *)newsType completeBlock:(void (^)(NSArray *array))block
{
    
    NSDictionary *params = @{@"type":newsType};
    
    [HTTPRequestService requestWithURL:@"common_fetchNewsList.action" params:params HTTPMethod:@"GET" completeBlock:^(id result) {
        
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        
        if (status == 1) {
            
            NSDictionary *resultDic = [result objectForKey:@"resMap"];
            NSArray *newsArr = [resultDic objectForKey:@"newsList"];
            
            NSMutableArray *resultArr = [NSMutableArray array];
            for (NSDictionary *dic in newsArr) {
                
                NewsItem *item = [[NewsItem alloc] initWithDic:dic];
                [resultArr addObject:item];
            }
            
            if (block) {
                block(resultArr);
            }
            
        } else {
            [SimpleAlertView alertWith:[result objectForKey:@"message"]];
        }
        
    }];
}

@end
