//
//  QBUserCell.m
//  QuickBackup
//
//  Created by Nagarro on 6/18/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBUserCell.h"

@implementation QBUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString*)reuseIdentifier {
    return @"QBUserCell";
}

+(CGFloat)heightForUser:(QBAppUser *)user {
    return 44.0;
}

- (void)setUser:(QBAppUser *)user {
    _user = user;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
    _tickImageView.image = _user.isSelected ? [UIImage imageNamed:@"tick.png"] : nil;
}

@end
