//
//  ProductItem.h
//  ProductPush
//
//  Created by 高振伟 on 15/7/15.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductItem : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSArray *relateProducts;

- (id)initWithDic:(NSDictionary *)dic;

@end
