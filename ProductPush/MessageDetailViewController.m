

#import "MessageDetailViewController.h"

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];
    
    self.webView.delegate = self;
//    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
    
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
{
    NSURL * url = request.URL;
    NSString *urlStr = url.absoluteString;
    if ([urlStr isEqualToString:@"http://www.baidu.com"]) {
        return YES;
    }
    
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
    self.tipLabel.text = @"努力加载中";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self.activityIndicator stopAnimating];
    self.tipLabel.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    self.tipLabel.text = @"加载出错";
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     /*
     if ([segue.identifier isEqualToString:@"MessageType1"]) {
         MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
         
         messageListVC.title = @"促销信息";
         messageListVC.msgType = @"促销信息";
         
     } else if ([segue.identifier isEqualToString:@"MessageType2"]) {
         MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
         
         messageListVC.title = @"新品发布";
         messageListVC.msgType = @"新品发布";
         
     } else if ([segue.identifier isEqualToString:@"MessageType3"]) {
         MessageListTableViewController *messageListVC = (MessageListTableViewController *)segue.destinationViewController;
         
         messageListVC.title = @"教战策略";
         messageListVC.msgType = @"教战策略";
     }
      */
     
 }

@end
