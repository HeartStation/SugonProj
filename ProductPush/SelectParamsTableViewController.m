//
//  SelectParamsTableViewController.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "SelectParamsTableViewController.h"

@interface SelectParamsTableViewController ()

@property (strong, nonatomic) NSMutableArray *params;

@end

@implementation SelectParamsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.params = [NSMutableArray array];
    
    NSArray *types2 = self.lineItem.productTypeArr;
    
    self.isSecondType = NO;
    
    for (NSString *str in types2) {
        if (![str isEqualToString:@""]) {
            self.isSecondType = YES;
            break;
        }
    }
    
    if (self.isSecondType) {
        for (NSString *type2 in types2) {
            if ([type2 isEqualToString:@""]) {
                [self.params addObject:@"其他"];
            } else {
                [self.params addObject:type2];
            }
        }
    } else {
        
        NSDictionary *dic = self.lineItem.productDic;
        NSArray *array = [dic allValues];
        
        for (NSArray *arr in array) {
            for (NSDictionary *dictionary in arr) {
                ProductItem *item = [[ProductItem alloc] initWithDic:dictionary];
                
                [self.params addObject:item];
            }
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.params.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paramCell" forIndexPath:indexPath];
    if (self.isSecondType) {
        cell.textLabel.text = self.params[indexPath.row];
    } else {
        ProductItem *item = (ProductItem *)self.params[indexPath.row];
        cell.textLabel.text = item.productName;
    }
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GoBackToHome"]) {
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        self.selectedParam = cell.textLabel.text;
        
        if (self.isSecondType) {
            self.products = nil;
            self.products = [NSMutableArray array];

            NSDictionary *dic = self.lineItem.productDic;
            NSArray *products = [dic objectForKey:self.selectedParam];
            for (NSDictionary *dic in products) {
                ProductItem *item = [[ProductItem alloc] initWithDic:dic];
                [self.products addObject:item];
            }
            
            
        } else {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            ProductItem *item = (ProductItem *)self.params[indexPath.row];
            self.selectedProduct = item;
        }
        
        
    }
    
}

@end
