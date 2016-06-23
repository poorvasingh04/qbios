//
//  QBSignUpViewController.h
//  QuickBackup
//
//  Created by Nagarro on 6/1/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBBaseViewController.h"

@interface QBSignUpViewController : QBBaseViewController<QBConnectionDelegate>
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end
