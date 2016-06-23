//
//  QBSignUpTableViewCell.h
//  QuickBackup
//
//  Created by Nagarro on 6/1/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBAppUser.h"

@class QBSignUpTableViewCell;

@protocol QBSignUpTableViewCellDelegate <NSObject>

- (void)cellDidEdited:(QBSignUpTableViewCell*)cell string:(NSString*)string;

@end

@interface QBSignUpTableViewCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic, strong) IBOutlet UILabel *label;
@property(nonatomic, strong) IBOutlet UITextField *textfield;
@property(nonatomic, strong) QBAppUser *user;
@property(nonatomic, weak) id<QBSignUpTableViewCellDelegate> delegate;

+(NSString*)reuseIdentifier;
@end
