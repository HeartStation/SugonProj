//
//  BrandTypesItem.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-21.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandTypesItem : NSObject

@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSMutableArray *brandTypes;

//+ (NSArray *)getTestData;

//+ (void)getAllBrandTypesWithCompleteBlock:(void (^)(NSArray *array))block;

@end
