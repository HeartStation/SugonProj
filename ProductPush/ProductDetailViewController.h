//
//  ProductDetailViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15/7/20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString *productId;

@end
