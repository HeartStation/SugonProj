//
//  ProductLineItem.h
//  ProductPush
//
//  Created by 高振伟 on 15/7/15.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductLineItem : NSObject

@property (nonatomic, strong) NSString *productLineName;
@property (nonatomic, strong) NSArray *productTypeArr;

@property (nonatomic, strong) NSDictionary *productDic;

- (id)initWithDic:(NSDictionary *)dic;

@end
