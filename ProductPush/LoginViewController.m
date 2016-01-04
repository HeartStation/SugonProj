
#import "LoginViewController.h"
#import "HTTPRequestService.h"
#import "MBProgressHUD.h"
#import "SimpleAlertView.h"

#define USER_TEXT_FIELD 101

@interface LoginViewController ()

@property (strong,nonatomic) MBProgressHUD *hud;

@end

@implementation LoginViewController
- (IBAction)userTextFieldEndEvent:(id)sender {
    [self.pswTextField becomeFirstResponder];
}

- (IBAction)pswTextFieldEndEvent:(id)sender {
    if ([self.userTextField.text isEqualToString:@""] || [self.pswTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入账号或密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self goToLogin];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [User currentUser];
    
    self.rememberPasswordSwitch.on = self.user.isSavePassword;
    self.autoLoginSwitch.on = self.user.isAutoLogin;
    
    self.userTextField.text = self.user.userName;
    if (self.user.isSavePassword) {
        self.pswTextField.text = self.user.password;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    
    if (self.user.isAutoLogin  && ![self.user.userName isEqualToString:@""]) {
        [self goToLogin];
    }
    
}

- (void)goToLogin
{
    if (!self.hud) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    }
    [self.view addSubview:self.hud];
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.dimBackground = YES;
    self.hud.labelText = @"正在登录";
    [self.hud show:YES];
    
    NSString *fullUserName = [self.userTextField.text stringByAppendingString:@"@sugon.com"];
    
    NSDictionary *params = @{@"username":fullUserName,
                             @"password":self.pswTextField.text};
    
    [HTTPRequestService requestWithURL:@"common_phoneLoginIn.action"
                                params:params
                            HTTPMethod:@"GET"
                         completeBlock:^(id result) {
                             
                             [self.hud hide:YES];
                             
                             NSInteger status = [[result objectForKey:@"status"] integerValue];
                             if (status == 1) {
                                 
                                 [self saveCurrentUserInfo];
                                 
                                 [self goToHomePage];
                                
                                 
                             } else {
                                 [SimpleAlertView alertWith:[result objectForKey:@"message"]];
                             }
                         }
                           failedBlock:^ {
                               [self.hud hide:YES];
                           }];
}

- (void)goToHomePage
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
}

- (IBAction)TextField_DidEndOnExit:(UITextField *)sender {
    
    UITextField *textField = (UITextField *)sender;
    
    if (textField.tag == USER_TEXT_FIELD) {
        [self.pswTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
}

- (IBAction)savePassword:(UISwitch *)sender {
    
    self.user.savePassword = sender.on;
    if (![sender isOn]) {
        [self.autoLoginSwitch setOn:NO animated:YES];
        self.user.autoLogin = NO;
    }
}

- (IBAction)autoLogin:(UISwitch *)sender {
    
    self.user.autoLogin = sender.on;
    if ([sender isOn]) {
        [self.rememberPasswordSwitch setOn:YES animated:YES];
        self.user.savePassword = YES;
    }
}

- (IBAction)loginClick:(UIButton *)sender {
    
    if ([self.userTextField.text isEqualToString:@""] || [self.pswTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入账号或密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self goToLogin];
    
}

- (void)saveCurrentUserInfo
{
    self.user.userName = self.userTextField.text;
    self.user.password = self.pswTextField.text;
    [User saveCurrentUser];
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)segue {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
