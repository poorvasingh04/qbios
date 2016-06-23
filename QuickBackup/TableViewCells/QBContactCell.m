//
//  QBContactCell.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBContactCell.h"

@implementation QBContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(CGFloat)heightForContact:(QBContact *)contact {
    return 250.0;
}

+(NSString*)reuseIdentifier {
    return @"QBContactCell";
}

- (void)setContact:(QBContact *)contact {
    _contact = contact;
    _firstNameLabel.text = _contact.firstName;
    _lastNameLabel.text = _contact.lastName;
    _companyLabel.text = _contact.company;
    _phoneNumberLabel.text = _contact.phoneNumbersArray.count > 0 ? [[_contact.phoneNumbersArray valueForKey:@"value"] componentsJoinedByString:@", "] :@"-";
    _emailLabel.text = _contact.emailAddresses.count > 0 ? [[_contact.emailAddresses valueForKey:@"value"] componentsJoinedByString:@"\n"] : @"-";
    _addressLabel.text = _contact.addresses.count > 0 ? [[_contact.addresses valueForKey:@"displayName"] componentsJoinedByString:@"\n\n"] : @"-";

}

@end
