//
//  QBBaseViewController.h
//  QuickBackup
//
//  Created by Nagarro on 6/1/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBBaseViewController : UIViewController

@property(nonatomic, assign) BOOL showActivityIndicator;

- (void)showOKAlertWithMessage :(NSString*)message;

@end
