//
//  ProductCompareViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XCMultiSortTableView.h"

@interface ProductCompareViewController : UIViewController <XCMultiTableViewDataSource>

@property (strong, nonatomic) NSMutableArray *topHeaderData;
@property (strong, nonatomic) NSMutableArray *leftTableData;
@property (strong, nonatomic) NSMutableArray *contentTableData;

@property (assign, nonatomic) NSInteger parentAttrRow;  

@end
