//
//  QBBaseViewController.m
//  QuickBackup
//
//  Created by Nagarro on 6/1/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBBaseViewController.h"

@interface QBBaseViewController () {
    UIActivityIndicatorView *_indicatorView;
    UIView *_loadingView;
}

@end

@implementation QBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowActivityIndicator:(BOOL)showActivityIndicator {
    _showActivityIndicator = showActivityIndicator;
    if (_showActivityIndicator) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _indicatorView.frame = CGRectMake(_loadingView.center.x-50, _loadingView.center.y-50, 100, 100);
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_loadingView addSubview:_indicatorView];
        [[UIApplication sharedApplication].keyWindow addSubview:_loadingView];
        [_indicatorView startAnimating];
        
    } else {
        [_indicatorView stopAnimating];
        [_loadingView removeFromSuperview];
    }
}

- (void)showOKAlertWithMessage :(NSString*)message {
    UIAlertController * alert =   [UIAlertController
                                   alertControllerWithTitle:message
                                   message:nil
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:NULL];
                                   
                               }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:NULL];
    
}

@end
