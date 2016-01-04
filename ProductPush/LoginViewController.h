//
//  ViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-20.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@property (weak, nonatomic) IBOutlet UITextField *pswTextField;

@property (weak, nonatomic) IBOutlet UISwitch *rememberPasswordSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;

@property (strong, nonatomic) User *user;

@end

