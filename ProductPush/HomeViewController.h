

#import <UIKit/UIKit.h>
#import "SelectTypesTableViewCell.h"

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SelectTypesTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *compareButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *compareToolBar;

@end
