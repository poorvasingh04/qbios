//
//  QBContact.h
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBContactLabelValue.h"
#import "QBPostalAddress.h"

@interface QBContact : NSObject
//@property(nonatomic, strong) CNContact *contact;
@property(nonatomic, strong) NSString *contactId;

@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSArray<QBContactLabelValue*> *phoneNumbersArray;
@property(nonatomic, strong) NSArray<QBContactLabelValue*> *emailAddresses;
@property(nonatomic, strong) NSArray<QBPostalAddress*> *addresses;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *createdTS;
@property(nonatomic, strong) NSString *lastUpdatedTS;

@property(nonatomic, strong) CNMutableContact *deviceContact;

@property(nonatomic, strong, readonly) NSDictionary *dictionary;
@property(nonatomic, strong, readonly) CNMutableContact *mutableContact;

- (id)initWithDictionary:(NSDictionary*)dictionary;
@end
