//
//  SelectTypeTableViewController.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "SelectTypeTableViewController.h"

@interface SelectTypeTableViewController ()

@end

@implementation SelectTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.clearsSelectionOnViewWillAppear = NO;
    
//    self.typesAndParams = @{@"类型1":@[@"参数1", @"参数2", @"参数3", @"参数4", @"参数5"],
//                            @"类型2":@[@"参数6", @"参数7", @"参数8", @"参数9", @"刀片服务器"]
//                           };
    
//    self.types = [self.typesAndParams allKeys];
    
    self.types = [NSMutableArray array];
    
    for (ProductLineItem *item in self.productLineItemArr) {
        [self.types addObject:item.productLineName];
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

    return self.types.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.types[indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"TypeBackToHome"]) {
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        
        ProductLineItem *selectedItem = nil;
        for (ProductLineItem *item in self.productLineItemArr) {
            if ([item.productLineName isEqualToString:cell.textLabel.text]) {
                selectedItem = item;
                break;
            }
        }
        
        self.selectedType = cell.textLabel.text;
        self.selectedLineItem = selectedItem;
        
    }
}

@end
