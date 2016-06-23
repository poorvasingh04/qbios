//
//  QBAdminHomeViewController.h
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBBaseViewController.h"

@interface QBAdminHomeViewController : QBBaseViewController
@property(nonatomic, strong) NSArray *usersArray;
@property(nonatomic, weak) IBOutlet UITableView *usersTableView;
@property(nonatomic, weak) IBOutlet UITableView *contactsTableView;
@property(nonatomic, weak) IBOutlet UILabel *contactNameLabel;
@property(nonatomic, weak) IBOutlet UIButton *deleteAllButton;

@end
