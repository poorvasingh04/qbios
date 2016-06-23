//
//  QBSignUpTableViewCell.m
//  QuickBackup
//
//  Created by Nagarro on 6/1/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBSignUpTableViewCell.h"

@implementation QBSignUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+(NSString*)reuseIdentifier {
    return @"QBSignUpTableViewCell";
}

- (void)setUser:(QBAppUser *)user {
    _user = user;
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *appendedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidEdited:string:)]) {
        [_delegate cellDidEdited:self string:appendedString];
    }
    
    return YES;
}

@end
