//
//  SelectTypesTableViewCell.m
//  ProductPush
//
//  Created by 高振伟 on 15-6-21.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import "SelectTypesTableViewCell.h"

#import "TypesCollectionViewCell.h"
#import "ProductItem.h"

@interface SelectTypesTableViewCell()

@property (strong, nonatomic) NSArray *types;

@property (strong, nonatomic) NSMutableArray *selectedTypes;
@property (strong, nonatomic) NSMutableArray *selectedIds;

@end

@implementation SelectTypesTableViewCell

- (void)awakeFromNib {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

- (void)setSelectTypesCell:(BrandTypesItem *)item selectedTypes:(NSMutableArray *)selectedTypes selectedIds:(NSMutableArray *)selectedIds  cellHeight:(CGFloat)height
{
    self.brandLabel.text = item.brandName;
    if (selectedTypes.count) {
        self.selectedTypeLabel.text = [selectedTypes componentsJoinedByString:@";"];
    } else {
        self.selectedTypeLabel.text = @"请选择产品型号";
    }
    
    self.selectedTypes = selectedTypes;
    self.selectedIds = selectedIds;
    self.types = item.brandTypes;
    
    
    if (self.types && self.types.count > 0) {
        self.selectBtn.enabled = YES;
        self.selectBtn.backgroundColor = [UIColor clearColor];
    } else {
        self.selectBtn.enabled = NO;
        self.selectBtn.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.5];
    }
    
    if (fabs(height - 44.0) < 0.01) {
        self.stateImageV.image = [UIImage imageNamed:@"展开-1080P"];
    } else {
        self.stateImageV.image = [UIImage imageNamed:@"收缩-1080P"];
    }
}

- (void)setTypes:(NSArray *)types
{
    _types = types;
    
    [self.collectionView reloadData];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect frame = self.collectionView.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width - 15 *2;
    self.collectionView.frame = frame;
}

- (CGFloat)getSelectTypesCellHeight:(BrandTypesItem *)item
{
    NSArray *types = item.brandTypes;
    double rows = ceil(types.count / 3.0);
    
    return rows * 25 + 44.0 + 10.0 + (rows-1)*5;
}


- (IBAction)showOrHideBtnClick:(UIButton *)sender {
    [self.collectionView reloadData];
    
    [self.delegate showOrHideTypes:self clickedBtn:sender];
    
}

#pragma mark - UICollectionView DataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.types.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TypesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"typeCell" forIndexPath:indexPath];
    ProductItem *currentType = (ProductItem *)self.types[indexPath.row];
    cell.textLabel.text = currentType.productName;
    
    if ([self.selectedTypes containsObject:currentType.productName]) {
        cell.backgroundColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1];
    } else {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TypesCollectionViewCell *cell = (TypesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ProductItem *selectedProduct = (ProductItem *)self.types[indexPath.row];
    NSString *selectedType = selectedProduct.productName;
    NSString *productId = selectedProduct.productId;
    
    if ([self.selectedTypes containsObject:selectedType]) {
        [self.selectedTypes removeObject:selectedType];
        [self.selectedIds removeObject:productId];
        
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } else {
        [self.selectedTypes addObject:selectedType];
        [self.selectedIds addObject:productId];
        
        cell.backgroundColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:1];
    }
    
    self.selectedTypeLabel.text = [self.selectedTypes componentsJoinedByString:@";"];
    [self setNeedsDisplay];
    
    [self.delegate collectionViewCellClicked];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
