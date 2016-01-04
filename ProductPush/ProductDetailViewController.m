//
//  ProductDetailViewController.m
//  ProductPush
//
//  Created by 高振伟 on 15/7/20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "ProductDetailViewController.h"

#import "AttributeItem.h"
#import "HTTPRequestService.h"
#import "SimpleAlertView.h"
#import "UILabel+CountLabelSize.h"
#import "ImageLoadService.h"

@interface ProductDetailViewController ()

@property (nonatomic, strong) UIImage *productImage;
@property (nonatomic, strong) NSString *productDes;
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSMutableArray *parentAttributes;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.attributes = [NSMutableArray array];
    self.parentAttributes = [NSMutableArray array];
    
    NSDictionary *params = @{@"id":self.productId};
    [HTTPRequestService requestWithURL:@"common_fetchProductInfo.action" params:params HTTPMethod:@"GET" completeBlock:^(id result) {
        
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 1) {
            NSDictionary *dic = [result objectForKey:@"resMap"][@"product"];
            self.productDes = [dic objectForKey:@"detailDes"];
            NSString *url = [dic objectForKey:@"productPic"];
            
//            UIImage *image = [ImageLoadService imageFrom:url];
            UIImage *image = nil;
            if (image) {
                self.productImage = image;
            } else {
                [self loadImage:url];
            }
            
            NSArray *attributes = [[dic objectForKey:@"attributeMap"] allValues];
            for (NSDictionary *dictionary in attributes) {
                AttributeItem *item = [[AttributeItem alloc] initWithDic:dictionary];
                [self.attributes addObject:item];
            }
            [self sortAttribute];
            
            NSDictionary *parentDic = [dic objectForKey:@"parentProduct"];
            if (![parentDic isEqual:[NSNull null]]) {
                
                NSString *parentLineName = [parentDic objectForKey:@"productLineName"];
                NSString *parentProductName = [[parentDic objectForKey:@"productName"] stringByAppendingString:@"产品参数"];
                AttributeItem *item = [[AttributeItem alloc] init];
                item.attrName = [parentLineName stringByAppendingString:parentProductName];
                item.formatValue = @"";
                [self.parentAttributes addObject:item];
                
                NSMutableArray *tempArr = [NSMutableArray array];
                NSArray *parentProductAttributes = [[parentDic objectForKey:@"attributeMap"] allValues];
                for (NSDictionary *dictionary in parentProductAttributes) {
                    AttributeItem *item = [[AttributeItem alloc] initWithDic:dictionary];
                    [tempArr addObject:item];
                }
                
                NSArray *sortedResultArr = [self sortParentAttribute:tempArr];
                [self.parentAttributes addObjectsFromArray:sortedResultArr];
                
            }
            
            [self.tableView reloadData];
            
        } else {
            [SimpleAlertView alertWith:[result objectForKey:@"message"]];
        }
        
    }];
    
}

- (void)sortAttribute
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"attrSortOrder" ascending:NO];
    NSArray *tempArray = [self.attributes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.attributes = [tempArray mutableCopy];
    
    // 对NSString/NSNumber类型的属性进行排序
    /*
    NSArray *sortedAttributes = [self.attributes sortedArrayUsingComparator:^NSComparisonResult(AttributeItem *item1, AttributeItem *item2) {
        NSComparisonResult result = [item2.attrSortOrder compare:item1.attrSortOrder];
        return result;
    }];
    self.attributes = [sortedAttributes mutableCopy];
     */
}

- (NSArray *)sortParentAttribute:(NSArray *)tempArr
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"attrSortOrder" ascending:NO];
    NSArray *sortedResults = [tempArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return sortedResults;
}

- (void)loadImage:(NSString *)url
{
    [ImageLoadService downLoadImageFrom:url completeHandler:^(id image) {
        self.productImage = image;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.attributes.count;
    } else if (section == 3) {
        return self.parentAttributes.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
        UIImageView *imageV = (UIImageView *)[cell.contentView viewWithTag:101];
        imageV.image = self.productImage;
        
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
        cell.textLabel.text = self.productDes;
        
        return cell;
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributeCell" forIndexPath:indexPath];
        
        AttributeItem *item = self.attributes[indexPath.row];
        UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:201];
        label1.text = item.attrName;
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:202];
        label2.text = item.formatValue;
        
        return cell;
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParentAttributeCell" forIndexPath:indexPath];
            
            AttributeItem *item = self.parentAttributes[indexPath.row];
            UILabel *label = (UILabel *)[cell.contentView viewWithTag:101];
            label.text = item.attrName;
            
            return cell;
            
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributeCell" forIndexPath:indexPath];
            
            AttributeItem *item = self.parentAttributes[indexPath.row];
            UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:201];
            label1.text = item.attrName;
            UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:202];
            label2.text = item.formatValue;
            
            return cell;
        }
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 190;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        label.text = self.productDes;
        
        CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame)-30, 1000);
        CGSize labelSize = [label boundingRectWithSize:size];
        
        return labelSize.height + 10;
        
    } else if (indexPath.section == 2) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:13];
        label.numberOfLines = 0;
        
        AttributeItem *item = self.attributes[indexPath.row];
        label.text = item.formatValue;
        
        CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame)-30-102-3, 1000);
        CGSize labelSize = [label boundingRectWithSize:size];
        
        CGSize size2 = CGSizeMake(102, 1000);
        label.text = item.attrName;
        CGSize labelSize2 = [label boundingRectWithSize:size2];
        
        CGFloat maxHeight = MAX(labelSize.height, labelSize2.height);
        
        return MAX(44, maxHeight+21);
        
    }  else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            return 44.0;
        } else {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.font = [UIFont systemFontOfSize:13];
            label.numberOfLines = 0;
            
            AttributeItem *item = self.parentAttributes[indexPath.row];
            label.text = item.formatValue;
            
            CGSize size = CGSizeMake(CGRectGetWidth(self.view.frame)-30-102-3, 1000);
            CGSize labelSize = [label boundingRectWithSize:size];
            
            CGSize size2 = CGSizeMake(102, 1000);
            label.text = item.attrName;
            CGSize labelSize2 = [label boundingRectWithSize:size2];
            
            CGFloat maxHeight = MAX(labelSize.height, labelSize2.height);
            
            return MAX(44, maxHeight+21);
            
        }
        
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"产品图片";
    } else if (section == 1) {
        return @"产品描述";
    } else if (section == 2) {
        return @"产品参数";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 0;
    }
    
    return 40;
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
