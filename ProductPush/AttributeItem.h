//
//  AttributeItem.h
//  ProductPush
//
//  Created by 高振伟 on 15/7/15.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributeItem : NSObject

@property (nonatomic, strong) NSString *attrName;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *formatValue;
@property (nonatomic, assign) NSInteger attrSortOrder;

- (id)initWithDic:(NSDictionary *)dic;

+ (AttributeItem *)getBlankItem;

@end
