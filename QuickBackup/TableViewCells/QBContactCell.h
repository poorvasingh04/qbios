//
//  QBContactCell.h
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBContactCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *firstNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *lastNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *companyLabel;
@property(nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property(nonatomic, weak) IBOutlet UILabel *emailLabel;
@property(nonatomic, weak) IBOutlet UILabel *addressLabel;
@property(nonatomic, strong) QBContact *contact;

+(NSString*)reuseIdentifier;
+(CGFloat)heightForContact:(QBContact*)contact;
@end
