//
//  SelectTypeTableViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProductLineItem.h"

@interface SelectTypeTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *productLineItemArr;
@property (strong, nonatomic) NSMutableArray *types;
@property (strong, nonatomic) NSString *selectedType;
@property (strong, nonatomic) ProductLineItem *selectedLineItem;

@end
