//
//  ProductLineItem.m
//  ProductPush
//
//  Created by 高振伟 on 15/7/15.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "ProductLineItem.h"

@implementation ProductLineItem

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self = [self setAttributes:dic];
    }
    return self;
}

- (ProductLineItem *)setAttributes:(NSDictionary *)dic
{
    self.productLineName = [dic objectForKey:@"productLineName"];
    self.productDic = [dic objectForKey:@"parentProductMap"];
    self.productTypeArr = [self.productDic allKeys];
    
    return self;
}

@end
