//
//  AttributeItem.m
//  ProductPush
//
//  Created by 高振伟 on 15/7/15.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "AttributeItem.h"

@implementation AttributeItem

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self = [self setAttributes:dic];
    }
    return self;
}

- (AttributeItem *)setAttributes:(NSDictionary *)dic
{
    self.attrName = [dic objectForKey:@"attrName"];
    
    NSString *des = [dic objectForKey:@"des"];
    if ([des isEqualToString:@""]) {
        self.des = @"无备注";
    } else {
        self.des = des;
    }
    
    self.formatValue = [dic objectForKey:@"formatValue"];
    self.attrSortOrder = [[dic objectForKey:@"attrSortOrder"] integerValue];
    
    return self;
}

+ (AttributeItem *)getBlankItem
{
    AttributeItem *item = [[AttributeItem alloc] init];
    
    item.attrName = @"";
    item.des = @"";
    item.formatValue = @"无";
    item.attrSortOrder = 0;
    
    return item;
}

@end
