

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *messageTypeBtn1;

@property (weak, nonatomic) IBOutlet UIButton *messageTypeBtn2;

@property (weak, nonatomic) IBOutlet UIButton *messageTypeBtn3;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (strong, nonatomic) NSString *urlStr;


@end
