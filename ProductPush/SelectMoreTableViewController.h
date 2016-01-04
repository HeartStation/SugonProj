//
//  SelectMoreTableViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-27.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductItem.h"

@interface SelectMoreTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *typesArr;

@property (nonatomic, strong) NSMutableArray *selectedTypes;

//@property (strong, nonatomic) ProductItem *selectedProduct;  // 记录当前选择的曙光产品

@property (strong, nonatomic) NSMutableArray *selectedProductArr;  // 记录当前选择的曙光产品数组

@end
