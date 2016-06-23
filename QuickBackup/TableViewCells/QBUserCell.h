//
//  QBUserCell.h
//  QuickBackup
//
//  Created by Nagarro on 6/18/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBUserCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *tickImageView;
@property (nonatomic, strong) QBAppUser *user;


+(NSString*)reuseIdentifier;
+(CGFloat)heightForUser:(QBAppUser*)user;
@end
