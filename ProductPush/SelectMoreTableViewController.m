//
//  SelectMoreTableViewController.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-27.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "SelectMoreTableViewController.h"

@interface SelectMoreTableViewController ()

@end

@implementation SelectMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)setTypesArr:(NSArray *)typesArr
{
    _typesArr = typesArr;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typesArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellType" forIndexPath:indexPath];
    
    ProductItem *item = (ProductItem *)self.typesArr[indexPath.row];
    NSString *type = item.productName;
    cell.textLabel.text = type;
    
    if ([self.selectedTypes containsObject:type]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ProductItem *item = (ProductItem *)self.typesArr[indexPath.row];
    NSString *type = item.productName;
    
    if ([self.selectedProductArr containsObject:item]) {
        [self.selectedProductArr removeObject:item];
    } else {
        [self.selectedProductArr addObject:item];
    }
    
    if ([self.selectedTypes containsObject:type]) {
        
        [self.selectedTypes removeObject:type];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    } else {
        [self.selectedTypes addObject:type];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
