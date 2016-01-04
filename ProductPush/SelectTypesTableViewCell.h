

#import <UIKit/UIKit.h>
#import "BrandTypesItem.h"

@class SelectTypesTableViewCell;

@protocol SelectTypesTableViewCellDelegate <NSObject>

- (void)showOrHideTypes:(SelectTypesTableViewCell *)cell clickedBtn:(UIButton *)button;

- (void)collectionViewCellClicked;

@end

@interface SelectTypesTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) id<SelectTypesTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageV;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


- (void)setSelectTypesCell:(BrandTypesItem *)item selectedTypes:(NSMutableArray *)selectedTypes selectedIds:(NSMutableArray *)selectedIds cellHeight:(CGFloat)height;
- (CGFloat)getSelectTypesCellHeight:(BrandTypesItem *)item;

@end
