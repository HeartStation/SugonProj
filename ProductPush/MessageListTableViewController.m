

#import "MessageListTableViewController.h"

#import "MessageDetailViewController.h"

#import "NewsItem.h"

@interface MessageListTableViewController ()

@end

@implementation MessageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.newsArr = [NSArray array];
    
    [NewsItem getNewsListByType:self.msgType completeBlock:^(NSArray *array) {
       
        self.newsArr = array;
        [self.tableView reloadData];
        
    }];
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

    return self.newsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTitleCell" forIndexPath:indexPath];
    
    NewsItem *item = self.newsArr[indexPath.row];
    cell.textLabel.text = item.newsTitle;
    cell.detailTextLabel.text = item.addTime;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GoToMessageDetail"]) {
        MessageDetailViewController *msgDetailVC = segue.destinationViewController;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NewsItem *item = self.newsArr[indexPath.row];
        
        msgDetailVC.urlStr = item.newsURL;
    }
}


@end
