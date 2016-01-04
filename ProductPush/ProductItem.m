//
//  ProductItem.m
//  ProductPush
//
//  Created by 高振伟 on 15/7/15.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "ProductItem.h"

@implementation ProductItem

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self = [self setAttributes:dic];
    }
    return self;
}

- (ProductItem *)setAttributes:(NSDictionary *)dic
{
    self.productId = [[dic objectForKey:@"id"] stringValue];
    self.productName = [dic objectForKey:@"productName"];
    self.brandName = [dic objectForKey:@"brandName"];
    self.relateProducts = [dic objectForKey:@"relateProducts"];
    
    return self;
}

@end
