//
//  SelectParamsTableViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductLineItem.h"
#import "ProductItem.h"

@interface SelectParamsTableViewController : UITableViewController

@property (strong, nonatomic) NSString *selectedParam;

@property (strong, nonatomic) ProductLineItem *lineItem;

@property (assign, nonatomic) BOOL isSecondType;

@property (strong, nonatomic) ProductItem *selectedProduct;

@property (strong, nonatomic) NSMutableArray *products; 

@end
