//
//  MessageListTableViewController.h
//  ProductPush
//
//  Created by 高振伟 on 15-6-22.
//  Copyright (c) 2015年 BIT-高振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListTableViewController : UITableViewController

@property (assign, nonatomic) NSString *msgType;
@property (strong, nonatomic) NSArray *newsArr;

@end
