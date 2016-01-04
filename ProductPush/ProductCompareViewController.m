//
//  ProductCompareViewController.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "ProductCompareViewController.h"

#import "UILabel+CountLabelSize.h"
#import "XCMultiSortTableViewDefault.h"
#import "HTTPRequestService.h"
#import "SimpleAlertView.h"
#import "AttributeItem.h"

@interface ProductCompareViewController ()

@property (nonatomic, strong) XCMultiTableView *tableView;

@property (nonatomic, strong) NSMutableArray *productArr;

@end

@implementation ProductCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initData];
    
//    self.leftTableData = [NSMutableArray array];
//    self.topHeaderData = [NSMutableArray array];
//    self.contentTableData = [NSMutableArray array];
    
//    self.leftTableData = [NSMutableArray arrayWithObjects:@"比较参数1", @"比较参数2", @"比较参数3", @"比较参数4", @"比较参数5", @"比较参数6", @"比较参数7", @"比较参数8", @"比较参数9", @"比较参数10", nil];
//    
//        self.topHeaderData = [NSMutableArray arrayWithObjects:@"品牌类型1", @"品牌类型2", @"品牌类型3", nil];
//    
//        self.contentTableData = [NSMutableArray arrayWithObjects:@[@"品牌类型1_参数1品牌类型1_参数1品牌类型1_参数1", @"品牌类型2_参数1", @"品牌类型3_参数1"],@[@"品牌类型1_参数2", @"品牌类型2_参数2", @"品牌类型3_参数2品牌类型3_参数2品牌类型3_参数2品牌类型3_参数2"],@[@"品牌类型1_参数3", @"品牌类型2_参数3", @"品牌类型3_参数3"],@[@"品牌类型1_参数4", @"品牌类型2_参数4", @"品牌类型3_参数4"],@[@"品牌类型1_参数5", @"品牌类型2_参数5", @"品牌类型3_参数5"],@[@"品牌类型1_参数6", @"品牌类型2_参数6", @"品牌类型3_参数6"],@[@"品牌类型1_参数7", @"品牌类型2_参数7", @"品牌类型3_参数7"],@[@"品牌类型1_参数8", @"品牌类型2_参数8", @"品牌类型3_参数8"],@[@"品牌类型1_参数9", @"品牌类型2_参数9", @"品牌类型3_参数9"],@[@"品牌类型1_参数10", @"品牌类型2_参数10", @"品牌类型3_参数10"], nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[XCMultiTableView alloc] initWithFrame:CGRectMake(0, 20 + 44, self.view.frame.size.width, self.view.frame.size.height-20-44)];
    self.tableView.leftHeaderEnable = YES;
    self.tableView.datasource = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - XCMutiTableView Datasource
- (NSArray *)arrayDataForTopHeaderInTableView:(XCMultiTableView *)tableView
{
    return [self.topHeaderData copy];
}

- (NSArray *)arrayDataForLeftHeaderInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section
{
    return [self.leftTableData copy];
}

- (NSArray *)arrayDataForContentInTableView:(XCMultiTableView *)tableView InSection:(NSUInteger)section
{
    return [self.contentTableData copy];
}

- (NSUInteger)numberOfSectionsInTableView:(XCMultiTableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView contentTableCellWidth:(NSUInteger)column
{
    return 140;
}

- (CGFloat)tableView:(XCMultiTableView *)tableView cellHeightInRow:(NSUInteger)row InSection:(NSUInteger)section
{
    NSArray *rowData = self.contentTableData[row];
    NSString *longestStr = @" ";
    for (NSString *str in rowData) {
        if (str.length > longestStr.length) {
            longestStr = str;
        }
    }
    
    UILabel *label = [UILabel new];
    
    label.text = longestStr;
    label.font = [UIFont systemFontOfSize:XCMultiTableView_DefaultContentFontSize];
    label.numberOfLines = 0;
    
    CGSize size = [label boundingRectWithSize:CGSizeMake(140, 1000)];
    label.frame = CGRectMake(0, 0, size.width, size.height);
    
    return size.height > 50 ? size.height+10 : 50;
}

//- (CGFloat)topHeaderHeightInTableView:(XCMultiTableView *)tableView
//{
//    return 200;
//}

- (UIColor *)tableView:(XCMultiTableView *)tableView bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column
{
    UIColor *color = [UIColor whiteColor];
    
    if (row % 2 == 0) {
        color = [UIColor colorWithRed:0xf6/255.0 green:0xf6/255.0 blue:0xf6/255.0 alpha:1.0];
    } else {
        color = [UIColor colorWithRed:0xfb/255.0 green:0xed/255.0 blue:0xed/255.0 alpha:1.0];
    }
    
    if (self.parentAttrRow != -1) {
        if (row == self.parentAttrRow) {
            color = [UIColor lightGrayColor];
        }
    }
    
    
    return color;
}

//- (UIColor *)tableView:(XCMultiTableView *)tableView headerBgColorInColumn:(NSUInteger)column
//{
//    return [UIColor whiteColor];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
