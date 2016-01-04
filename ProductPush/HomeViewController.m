

#import "HomeViewController.h"

#import "MessageDetailViewController.h"
#import "SelectParamsTableViewController.h"
#import "SelectMoreTableViewController.h"
#import "ProductCompareViewController.h"
#import "SelectTypeTableViewController.h"
#import "SelectParamsTableViewController.h"
#import "ProductDetailViewController.h"
#import "MessageListTableViewController.h"

#import "ImageScrollTableViewCell.h"

#import "BrandTypesItem.h"
#import "User.h"
#import "HTTPRequestService.h"
#import "ImageLoadService.h"
#import "SimpleAlertView.h"
#import "AttributeItem.h"
#import "ProductLineItem.h"
#import "UIButton+adaptImageAndTitle.h"

#define kTimerRepeatInterval 6

@interface HomeViewController ()

@property (weak, nonatomic) ImageScrollView *imageScrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *brandTypes;

@property (strong, nonatomic) NSMutableArray *typesCellHeights;

@property (strong, nonatomic) NSMutableArray *scrollImages;
@property (strong, nonatomic) NSMutableArray *scrollImageLinks;

@property (strong, nonatomic) NSMutableArray *allSelectedTypes;
@property (strong, nonatomic) NSMutableArray *oneSelectedTypes;
@property (strong, nonatomic) NSMutableArray *allSelectedIds;
@property (strong, nonatomic) NSMutableArray *oneSelectedIds;


@property (strong, nonatomic) NSString *selectedType;
@property (strong, nonatomic) NSString *selectedParam;
@property (strong, nonatomic) ProductLineItem *selectedLineItem;

@property (strong, nonatomic) NSString *selectedMoreParam;

@property (nonatomic, getter=isShowMoreParam) BOOL showMoreParam;
@property (strong, nonatomic) NSArray *moreParamArr;
@property (strong, nonatomic) NSArray *moreProductArr;
@property (strong, nonatomic) ProductItem *selectedProduct;
@property (strong, nonatomic) NSArray *secondProducts;
@property (assign, nonatomic) BOOL isRemoteNotification;


@property (nonatomic, strong) NSMutableArray *productArr;
@property (strong, nonatomic) NSMutableArray *topHeaderData;
@property (strong, nonatomic) NSMutableArray *leftTableData;
@property (strong, nonatomic) NSMutableArray *contentTableData;

@property (nonatomic, strong) NSMutableArray *productArr_parent;
@property (strong, nonatomic) NSMutableArray *leftTableData_parent;
@property (strong, nonatomic) NSMutableArray *contentTableData_parent;
@property (assign, nonatomic) NSInteger parentRow;

@property (nonatomic, strong) NSMutableArray *productLineItemArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HTTPRequestService requestWithURL:@"common_fetchAllBrands.action" params:nil HTTPMethod:@"GET" completeBlock:^(id result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 1) {
            NSDictionary *dic = [result objectForKey:@"resMap"];
            [self parseBrandsData:dic];
            
        }
    }];
    
    [HTTPRequestService requestWithURL:@"common_fetchIndexInfo.action" params:nil HTTPMethod:@"GET" completeBlock:^(id result) {
        
        [self parseImageData:result];
        
        [self parseListData:result];
    }];
    
    self.scrollImages = [NSMutableArray arrayWithCapacity:3];
    self.scrollImageLinks = [NSMutableArray arrayWithCapacity:3];
    
//    UIImage *scrollImage1 = [UIImage imageNamed:@"HomeImage1"];
//    UIImage *scrollImage2 = [UIImage imageNamed:@"HomeImage2"];
//    UIImage *scrollImage3 = [UIImage imageNamed:@"HomeImage3"];
//    self.scrollImages = @[scrollImage1,scrollImage2,scrollImage3];
    
    self.selectedType = @"";
    self.selectedParam = @"";
    self.selectedMoreParam = @"";
    self.showMoreParam = NO;

    self.compareButtonItem.enabled = NO;
    [self.compareButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:205/255.0 green:219/255.0 blue:266/255.0 alpha:1]} forState:UIControlStateNormal];
    
    if(![[User currentUser].url_link isEqualToString:@""]) {
        self.isRemoteNotification = YES;
        [self performSegueWithIdentifier:@"GoToMessageDetail" sender:self];
    }
    
}

- (void)setBrandTypes:(NSArray *)brandTypes
{
    _brandTypes = brandTypes;
    
    self.typesCellHeights = nil;
    self.allSelectedTypes = nil;
    self.allSelectedIds = nil;

    NSInteger brandCount = [brandTypes count];
    self.typesCellHeights = [NSMutableArray arrayWithCapacity:brandCount];
    self.allSelectedTypes = [NSMutableArray arrayWithCapacity:brandCount];
    self.allSelectedIds = [NSMutableArray arrayWithCapacity:brandCount];
    for (int i = 0; i < brandCount; ++i) {
        NSNumber *height = @44.0;
        [self.typesCellHeights addObject:height];
        
        BrandTypesItem *item = brandTypes[i];
        NSInteger typeCount = item.brandTypes.count;
        
        self.oneSelectedTypes = [NSMutableArray arrayWithCapacity:typeCount];
        [self.allSelectedTypes addObject:self.oneSelectedTypes];
        
        self.oneSelectedIds = [NSMutableArray arrayWithCapacity:typeCount];
        [self.allSelectedIds addObject:self.oneSelectedIds];
    }
    
}

- (void)parseBrandsData:(NSDictionary *)dic {
    NSArray *brandsDic = [dic objectForKey:@"brandList"];
    
    NSMutableArray *brands = [NSMutableArray array];
    for (NSDictionary *dataDic in brandsDic) {
        NSString *brandName = [dataDic objectForKey:@"brandName"];
        
        BrandTypesItem *item = [[BrandTypesItem alloc] init];
        item.brandName = brandName;
        item.brandTypes = [NSMutableArray array];
        [brands addObject:item];
    }
    
    self.brandTypes = brands;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)parseImageData:(NSDictionary *)dic {
    
    NSArray *dataArr = [dic objectForKey:@"topImages"];
    
    for (NSDictionary *dataDic in dataArr) {
        
        NSString *fullUserName = [[User currentUser].userName stringByAppendingString:@"@sugon.com"];
        NSString *paramsStr = [NSString stringWithFormat:@"&username=%@&password=%@",fullUserName,[User currentUser].password];
        NSString *urlLink = [[dataDic objectForKey:@"url"] stringByAppendingString:paramsStr];
        
        [self.scrollImageLinks addObject:urlLink];
        
        NSString *urlStr = [dataDic objectForKey:@"value"];
        UIImage *image = [ImageLoadService imageFrom:urlStr];
        
        if (image) {
            [self.scrollImages addObject:image];
        } else {
            [self.scrollImages addObject:urlStr];
        }
        
    }
    
    for (NSUInteger i = 0; i < [self.scrollImages count]; i++) {
        if ([self.scrollImages[i] isKindOfClass:[NSString class]]) {
            
            [ImageLoadService downLoadImageFrom:self.scrollImages[i]
                                completeHandler:^(id image) {
                                    
                                    [self.scrollImages replaceObjectAtIndex:i withObject:image];
                                    
                                    BOOL flag = YES;
                                    for (NSUInteger i = 0; i < [self.scrollImages count]; i++) {
                                        if (![self.scrollImages[i] isKindOfClass:[UIImage class]]) {
                                            flag = NO;
                                            break;
                                        }
                                    }
                                    
                                    if (flag) {
                                        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                                    }
                                    
                                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                                
                                }];
        }
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)parseListData:(NSDictionary *)result
{
    self.productLineItemArr = nil;
    self.productLineItemArr = [NSMutableArray array];
    
    NSArray *listArr = [result objectForKey:@"sugonProductListByProductLine"];
    
    for (NSDictionary *dic in listArr) {
        ProductLineItem *lineItem = [[ProductLineItem alloc] initWithDic:dic];
        
        [self.productLineItemArr addObject:lineItem];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isRemoteNotification = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemotePush) name:kRemotePushNotification object:nil];
    
    if (self.imageScrollView) {
        [self.imageScrollView startScrollWithTimeInterval:kTimerRepeatInterval];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)handleRemotePush
{
    self.isRemoteNotification = YES;
    [self performSegueWithIdentifier:@"GoToMessageDetail" sender:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRemotePushNotification object:nil];
    
    if (self.imageScrollView) {
        [self.imageScrollView endScroll];
    }
}

- (IBAction)unwindToHome:(UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"TypeBackToHome"]) {
        
        SelectTypeTableViewController *typeVC = (SelectTypeTableViewController *)segue.sourceViewController;
        self.selectedType = typeVC.selectedType;
        self.selectedLineItem = typeVC.selectedLineItem;
        
        self.selectedParam = @"";
        
        self.showMoreParam = NO;
        self.moreParamArr = nil;
        self.moreProductArr = nil;
        
        [self clearBrandTypes];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    if ([segue.identifier isEqualToString:@"GoBackToHome"]) {
        SelectParamsTableViewController *paramsVC = (SelectParamsTableViewController *)segue.sourceViewController;
        
        self.selectedParam = paramsVC.selectedParam;
        
        self.showMoreParam = paramsVC.isSecondType;
        
        self.moreParamArr = nil;
        self.moreProductArr = nil;
        self.selectedMoreParam = @"";
        
        [self clearBrandTypes];
        
        if (!self.showMoreParam) {
            
            self.selectedProduct = paramsVC.selectedProduct;
            NSArray *releateProducts = self.selectedProduct.relateProducts;
            
            for (NSDictionary *dic in releateProducts) {
                
                ProductItem *item = [[ProductItem alloc] initWithDic:dic];
                for (BrandTypesItem *brandItem in self.brandTypes) {
                    
                    if ([item.brandName isEqualToString:brandItem.brandName]) {
                        [brandItem.brandTypes addObject:item];
                    }
                }
            }
            
        } else {
            
            self.secondProducts = paramsVC.products;
            
        }
        
        self.compareButtonItem.enabled = NO;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    }
    
    
    if ([segue.identifier isEqualToString:@"didSelectTypes"]) {
        
        [self clearBrandTypes];
        
        SelectMoreTableViewController *moreVC = (SelectMoreTableViewController *)segue.sourceViewController;
        
        self.moreParamArr = moreVC.selectedTypes;
        self.selectedMoreParam = [self.moreParamArr componentsJoinedByString:@";"];
        
        self.moreProductArr = moreVC.selectedProductArr;
        if (self.moreProductArr && (self.moreProductArr.count == 1)) {
            self.selectedProduct = self.moreProductArr[0];
        }
        
        if (self.moreProductArr && (self.moreProductArr.count > 0)) {
            for (ProductItem *product in self.moreProductArr) {
                
                NSArray *releateProducts = product.relateProducts;
                
                for (NSDictionary *dic in releateProducts) {
                    
                    ProductItem *item = [[ProductItem alloc] initWithDic:dic];
                    for (BrandTypesItem *brandItem in self.brandTypes) {
                        
                        if ([item.brandName isEqualToString:brandItem.brandName]) {

                            BOOL isContainItem = NO;
                            for (ProductItem *aItem in brandItem.brandTypes) {
                                if ([aItem.productName isEqualToString:item.productName]) {
                                    isContainItem = YES;
                                    break;
                                }
                            }
                            if (!isContainItem) {
                                [brandItem.brandTypes addObject:item];
                            }
                        }
                    }
                }
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)clearBrandTypes
{
    for (BrandTypesItem *item in self.brandTypes) {
        [item.brandTypes removeAllObjects];
    }
    
    for (NSMutableArray *array in self.allSelectedTypes) {
        if (array.count > 0) {
            [array removeAllObjects];
        }
    }
    
    for (NSMutableArray *array in self.allSelectedIds) {
        if (array.count > 0) {
            [array removeAllObjects];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return self.brandTypes.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        ImageScrollTableViewCell *scrollCell = [tableView dequeueReusableCellWithIdentifier:@"ImageScrollCell" forIndexPath:indexPath];
        
        scrollCell.imageScrollView.images = self.scrollImages;
        [scrollCell.imageScrollView startScrollWithTimeInterval:kTimerRepeatInterval];
        
        self.imageScrollView = scrollCell.imageScrollView;
        self.pageControl = scrollCell.pageControl;
        
        UIButton *type1 = (UIButton *)[scrollCell.contentView viewWithTag:601];
        UIButton *type2 = (UIButton *)[scrollCell.contentView viewWithTag:602];
        UIButton *type3 = (UIButton *)[scrollCell.contentView viewWithTag:603];
        UIButton *type4 = (UIButton *)[scrollCell.contentView viewWithTag:604];
        [type1 centerImageAndTitle];
        [type2 centerImageAndTitle];
        [type3 centerImageAndTitle];
        [type4 centerImageAndTitle];
        
        return scrollCell;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectParamsCell" forIndexPath:indexPath];
            cell.textLabel.text = @"产品类型:";
            if ([self.selectedType isEqualToString:@""]) {
                cell.detailTextLabel.text = @"请选择产品类型";
            } else {
                cell.detailTextLabel.text = self.selectedType;
            }
            
            
            return cell;
        }
        
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectParamsCell2" forIndexPath:indexPath];
            cell.textLabel.text = @"产品型号:";
            if ([self.selectedParam isEqualToString:@""]) {
                cell.detailTextLabel.text = @"请选择产品型号";
            } else {
                cell.detailTextLabel.text = self.selectedParam;
            }
            
            
            return cell;
        }
        
        if (indexPath.row == 2) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectMoreParamsCell" forIndexPath:indexPath];
            
            if (self.isShowMoreParam) {
                
                cell.textLabel.text = @"刀片型号:";
                if ([self.selectedMoreParam isEqualToString:@""]) {
                    cell.detailTextLabel.text = @"请选择刀片种类";
                } else {
                    cell.detailTextLabel.text = self.selectedMoreParam;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            } else {
                cell.textLabel.text = @" ";
                cell.detailTextLabel.text = @" ";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            return cell;
        }
        
        if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeeProductDetailCell" forIndexPath:indexPath];
            
            if (self.isShowMoreParam) {

                if (self.moreParamArr && (self.moreParamArr.count > 1)) {
                    cell.userInteractionEnabled = NO;
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                } else {
                    cell.userInteractionEnabled = YES;
                    cell.textLabel.textColor = [UIColor blueColor];
                }
                
            } else {
                cell.userInteractionEnabled = YES;
                cell.textLabel.textColor = [UIColor blueColor];
            }
            
            return cell;
        }
        
    }
    
    if (indexPath.section == 2) {
        SelectTypesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectOtherProductCell"  forIndexPath:indexPath];
                
        cell.delegate = self;
        BrandTypesItem *item = (BrandTypesItem *)self.brandTypes[indexPath.row];
        self.oneSelectedTypes = self.allSelectedTypes[indexPath.row];
        self.oneSelectedIds = self.allSelectedIds[indexPath.row];
        CGFloat height = [self.typesCellHeights[indexPath.row] floatValue];
        [cell setSelectTypesCell:item selectedTypes:self.oneSelectedTypes selectedIds:self.oneSelectedIds cellHeight:height];
        cell.tag = indexPath.row;
        
        [cell setNeedsDisplay];
        
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        return @"曙光存储";
    } else if (section == 2) {
        return @"相关品牌存储产品";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 242.0f;
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        if (!self.isShowMoreParam) {
            return 0.0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 3) {
        return 53.0;
    }
    
    if (indexPath.section == 2) {
        CGFloat height = [self.typesCellHeights[indexPath.row] floatValue];
        return height;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"GoToMessageDetail" sender:self];
    }
}

#pragma mark - SelectTypeCell Delegate
- (void)showOrHideTypes:(SelectTypesTableViewCell *)cell clickedBtn:(UIButton *)button
{
    
    NSInteger rowIndex = cell.tag;
    BrandTypesItem *item = (BrandTypesItem *)self.brandTypes[rowIndex];
    CGFloat cellHeight;
    
    CGFloat currentHeight = [self.typesCellHeights[rowIndex] floatValue];
    if (fabs(currentHeight - 44.0) < 0.01 ) {
        cellHeight = [cell getSelectTypesCellHeight:item];
    } else {
        cellHeight = 44.0f;
    }
    
    [self.typesCellHeights replaceObjectAtIndex:rowIndex withObject:[NSNumber numberWithFloat:cellHeight]];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:2];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)collectionViewCellClicked
{
    if ([self isAlreadySelectType]) {
        self.compareButtonItem.enabled = YES;
        [self.compareButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    } else {
        self.compareButtonItem.enabled = NO;
        [self.compareButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:205/255.0 green:219/255.0 blue:266/255.0 alpha:1]} forState:UIControlStateNormal];
    }
}

- (BOOL)isAlreadySelectType
{
    for (NSArray *array in self.allSelectedTypes) {
        if (array.count > 0) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)getReleateProductId
{
    NSMutableString *result = [NSMutableString string];
    
    for (NSArray *array in self.allSelectedIds) {
        if (array.count > 0) {
            for (NSString *str in array) {
                [result appendFormat:@"%@,",str];
            }
        }
    }
    
    return result;
}

- (IBAction)goToComparePage:(UIBarButtonItem *)sender {
    
    NSMutableString *sugonProductId = [NSMutableString string];
    
    if (self.moreProductArr && (self.moreProductArr.count > 1)) {
        for (ProductItem *item in self.moreProductArr) {
            [sugonProductId appendFormat:@"%@,",item.productId];
        }
    } else {
        sugonProductId = [[self.selectedProduct.productId stringByAppendingString:@","] mutableCopy];
    }
    
    NSString *releateProductId = [self getReleateProductId];
    
    NSString *allSelectedProductId = [sugonProductId stringByAppendingString:releateProductId];
    
    NSDictionary *params = @{@"str":allSelectedProductId};
    
    [HTTPRequestService requestWithURL:@"common_compare.action" params:params HTTPMethod:@"GET" completeBlock:^(id result) {
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        if (status == 1) {
            
            NSDictionary *temp = [result objectForKey:@"resMap"];
            [self parseDataDic:temp];
            
            ProductCompareViewController *productCompareVC = [[ProductCompareViewController alloc] init];
            productCompareVC.title = @"产品比较";
            productCompareVC.topHeaderData = self.topHeaderData;
            productCompareVC.leftTableData = self.leftTableData;
            productCompareVC.contentTableData = self.contentTableData;
            productCompareVC.parentAttrRow = self.parentRow;
            
            [self.navigationController pushViewController:productCompareVC animated:YES];
            
        } else {
            [SimpleAlertView alertWith:[result objectForKey:@"message"]];
        }
    }];
    
}

- (void)parseDataDic:(NSDictionary *)dic
{
    self.leftTableData = nil;
    self.topHeaderData = nil;
    self.contentTableData = nil;
    self.productArr = nil;
    
    self.topHeaderData = [NSMutableArray array];
    self.contentTableData = [NSMutableArray array];
    self.productArr = [NSMutableArray array];
    
    NSArray *keyAttrList = [dic objectForKey:@"productAttrIdList"];
    
    self.leftTableData = [NSMutableArray arrayWithCapacity:keyAttrList.count];
    
    for (int i = 0; i<keyAttrList.count; ++i) {
        [self.leftTableData addObject:@""];
    }
    
    NSArray *productList = [dic objectForKey:@"productList"];
    
    BOOL isShowDes = NO;
    NSString *productName = @"";
    NSMutableArray *desArr = [NSMutableArray array];
    for (NSDictionary *dic in productList) {
        NSString *brandName = [dic objectForKey:@"brandName"];
        if ([brandName isEqualToString:@"中科曙光"]) {
            
            NSDictionary *attributeDic = [dic objectForKey:@"attributeMap"];
            productName = [[dic objectForKey:@"productName"] stringByAppendingString:@"备注"];
            
            NSArray *dicArr = [attributeDic allValues];
            for (NSDictionary *dictionary in dicArr) {
                if (![[dictionary objectForKey:@"des"] isEqualToString:@""]) {
                    isShowDes = YES;
                    break;
                }
            }
            
            if (isShowDes && (desArr.count == 0)) {
                for (NSDictionary *dictionary in dicArr) {
                    NSString *des = [dictionary objectForKey:@"des"];
                    if ([des isEqualToString:@""]) {
                        [desArr addObject:@"无"];
                    } else {
                        [desArr addObject:des];
                    }
                }
            }
            
        }
        
    }
    
    
    for (NSDictionary *dic in productList) {
        
        NSString *header = [[dic objectForKey:@"brandName"] stringByAppendingString:[dic objectForKey:@"productName"]];
        [self.topHeaderData addObject:header];
        
        NSDictionary *attributeDic = [dic objectForKey:@"attributeMap"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<keyAttrList.count; ++i) {
            
            NSString *attrId = keyAttrList[i];
            NSDictionary *attrDic = [attributeDic objectForKey:attrId];
            
            if (attrDic == nil) {
                AttributeItem *item = [AttributeItem getBlankItem];
                [tempArr addObject:item];
                
                continue;
            }
            
            AttributeItem *item = [[AttributeItem alloc] initWithDic:attrDic];
            
            [tempArr addObject:item];
            
            [self.leftTableData replaceObjectAtIndex:i withObject:item.attrName];
        }
        
        [self.productArr addObject:tempArr];
    }
    
    for (int i = 0; i<keyAttrList.count; ++i) {
        
        if (isShowDes) {
            
            NSMutableArray *attrValue = [NSMutableArray array];
            
            NSArray *sugonArr = self.productArr[0];
            AttributeItem *item = sugonArr[i];
            [attrValue addObject:item.des];
            
            for (NSArray *arr in self.productArr) {
                
                AttributeItem *item = arr[i];
                [attrValue addObject:item.formatValue];
            }
            
            [self.contentTableData addObject:attrValue];
            
        } else {
            
            NSMutableArray *attrValue = [NSMutableArray array];
            for (NSArray *arr in self.productArr) {
                AttributeItem *item = arr[i];
                [attrValue addObject:item.formatValue];
            }
            
            [self.contentTableData addObject:attrValue];
        }
        
    }
    
    if (isShowDes) {
        [self.topHeaderData insertObject:productName atIndex:0];
    }

    self.parentRow = -1;
    NSArray *keyParentAttrList = [dic objectForKey:@"parentProductAttrIdList"];
    if (keyParentAttrList && keyParentAttrList.count > 0) {
        
        self.parentRow = keyAttrList.count;
        
        [self initData];

        for (int i = 0; i<keyParentAttrList.count+1; ++i) {
            [self.leftTableData_parent addObject:@""];
        }
        
        for (NSDictionary *dic in productList) {
            
            NSDictionary *parentProductDic = [dic objectForKey:@"parentProduct"];
            
            NSString *parentProductName = [parentProductDic objectForKey:@"productName"];
            
            NSDictionary *attributeDic = [parentProductDic objectForKey:@"attributeMap"];
            NSMutableArray *tempArr = [NSMutableArray array];
            
            AttributeItem *item = [[AttributeItem alloc] init];
            item.attrName = @"父产品名称";
            item.formatValue = parentProductName;
            item.des = @"";
            [tempArr addObject:item];
            
            [self.leftTableData_parent replaceObjectAtIndex:0 withObject:item.attrName];
            
            for (int i = 0; i<keyParentAttrList.count; ++i) {
                
                NSString *attrId = keyParentAttrList[i];
                NSDictionary *attrDic = [attributeDic objectForKey:attrId];
                
                if (attrDic == nil) {
                    AttributeItem *item = [AttributeItem getBlankItem];
                    [tempArr addObject:item];
                    
                    continue;
                }
                
                AttributeItem *item = [[AttributeItem alloc] initWithDic:attrDic];
                
                [tempArr addObject:item];
                
                [self.leftTableData_parent replaceObjectAtIndex:i+1 withObject:item.attrName];
            }
            
            [self.productArr_parent addObject:tempArr];
        }
        
        
        for (int i = 0; i<keyParentAttrList.count+1; ++i) {
            
            if (isShowDes) {
                
                NSMutableArray *attrValue = [NSMutableArray array];
                
                [attrValue addObject:@""];
                
                for (NSArray *arr in self.productArr_parent) {
                    
                    AttributeItem *item = arr[i];
                    [attrValue addObject:item.formatValue];
                }
                
                [self.contentTableData_parent addObject:attrValue];
                
            } else {
                
                NSMutableArray *attrValue = [NSMutableArray array];
                for (NSArray *arr in self.productArr_parent) {
                    AttributeItem *item = arr[i];
                    [attrValue addObject:item.formatValue];
                }
                
                [self.contentTableData_parent addObject:attrValue];
            }
            
        }
        
        [self.leftTableData addObjectsFromArray:self.leftTableData_parent];
        [self.contentTableData addObjectsFromArray:self.contentTableData_parent];
        
    }
    
    
}

- (void)initData
{
    self.productArr_parent = nil;
    self.productArr_parent = [NSMutableArray array];
    
    self.leftTableData_parent = nil;
    self.leftTableData_parent = [NSMutableArray array];
    
    self.contentTableData_parent = nil;
    self.contentTableData_parent = [NSMutableArray array];
    
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"GoToPruductDetail"]) {
        if ([self.selectedType isEqualToString:@""] || [self.selectedParam isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请先选择产品类型和型号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            return NO;
        } else if (self.isShowMoreParam){
            if (!self.moreParamArr || self.moreParamArr.count<1) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请选择刀片型号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
                return NO;
            }
        }
        
    }
    
    if ([identifier isEqualToString:@"GoToMessageDetail"]) {
        if (self.isRemoteNotification) {
            return YES;
        }
        
        NSString *imageLink = self.scrollImageLinks[self.pageControl.currentPage];
        if(imageLink && imageLink.length > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if ([identifier isEqualToString:@"GoToSelectParams"]) {
        if (!self.selectedLineItem) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请先选择产品类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            return NO;
        }
    }
    
    return YES;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GoToMessageDetail"]) {
        MessageDetailViewController *msgDetailVC = segue.destinationViewController;
        
        if (self.isRemoteNotification) {
            
            NSString *baseUrl = [@"http://x86.sugon.com/" stringByAppendingString:[User currentUser].url_link];
            NSString *fullUserName = [[User currentUser].userName stringByAppendingString:@"@sugon.com"];
            NSString *paramsStr = [NSString stringWithFormat:@"&username=%@&password=%@",fullUserName,[User currentUser].password];
            msgDetailVC.urlStr = [baseUrl stringByAppendingString:paramsStr];
            
            [User currentUser].url_link = @"";
            self.isRemoteNotification = NO;
            
            return;
        }
        
        NSString *imageLink = self.scrollImageLinks[self.pageControl.currentPage];
        if(imageLink && imageLink.length > 0) {
            msgDetailVC.urlStr = imageLink;
        }
        
//        switch (self.pageControl.currentPage) {
//            case 0:
//                msgDetailVC.urlStr = @"http://www.baidu.com";
//                break;
//                
//            case 1:
//                msgDetailVC.urlStr = @"http://g.wen.lu";
//                break;
//                
//            case 2:
//                msgDetailVC.urlStr = @"https://github.com";
//                break;
//                
//            default:
//                break;
//        }
        
    }
    
    if ([segue.identifier isEqualToString:@"GoToSelectDaoType"]) {
        
        SelectMoreTableViewController *moreVC = (SelectMoreTableViewController *)segue.destinationViewController;
        moreVC.typesArr = self.secondProducts;
        
        if (self.moreParamArr && self.moreParamArr.count > 0) {
            moreVC.selectedTypes = [self.moreParamArr mutableCopy];
        } else {
            moreVC.selectedTypes = [NSMutableArray array];
        }
        if (self.moreProductArr && self.moreProductArr.count > 0) {
            moreVC.selectedProductArr = [self.moreProductArr mutableCopy];
        } else {
            moreVC.selectedProductArr = [NSMutableArray array];
        }
        
    }
    
    
    if ([segue.identifier isEqualToString:@"selectProductType"]) {
        SelectTypeTableViewController *typesVC = (SelectTypeTableViewController *)segue.destinationViewController;
        
        typesVC.productLineItemArr = self.productLineItemArr;
    }
    
    if ([segue.identifier isEqualToString:@"GoToSelectParams"]) {
        SelectParamsTableViewController *paramsVC = (SelectParamsTableViewController *)segue.destinationViewController;
        
        paramsVC.lineItem = self.selectedLineItem;
    }
    
    if ([segue.identifier isEqualToString:@"GoToPruductDetail"]) {
        ProductDetailViewController *productDetailVC = (ProductDetailViewController *)segue.destinationViewController;
        
        productDetailVC.productId = self.selectedProduct.productId;
    }
    
    
    if ([segue.identifier isEqualToString:@"MessageType1"]) {
        MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
        
        messageListVC.title = @"存储前沿";
        messageListVC.msgType = @"存储前沿";
        
    } else if ([segue.identifier isEqualToString:@"MessageType2"]) {
        MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
        
        messageListVC.title = @"存储活动";
        messageListVC.msgType = @"存储活动";
        
    } else if ([segue.identifier isEqualToString:@"MessageType3"]) {
        MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
        
        messageListVC.title = @"产品要点";
        messageListVC.msgType = @"产品要点";
    } else if ([segue.identifier isEqualToString:@"MessageType4"]) {
        MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
        
        messageListVC.title = @"存储资讯";
        messageListVC.msgType = @"存储资讯";
    }
    
    
}

@end
