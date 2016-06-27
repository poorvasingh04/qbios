//
//  QBContact.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBContact.h"

@implementation QBContact
- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        self.contactId = dictionary[@"contactId"];
        self.firstName = dictionary[@"firstName"];
        self.lastName = dictionary[@"lastName"];
        self.company = dictionary[@"company"];
        self.createdTS = dictionary[@"createdTS"];
        self.lastUpdatedTS = dictionary[@"lastUpdatedTS"];

        NSMutableArray *addresses = [NSMutableArray array];

        for (NSDictionary *dict in dictionary[@"addresses"]) {
            QBPostalAddress *labelValue = [[QBPostalAddress alloc] initWithDictionary:dict];
            [addresses addObject:labelValue];
        }
        
        self.addresses = addresses;
        
        NSMutableArray *phonenumbers = [NSMutableArray array];
        
        for (NSDictionary *dict in dictionary[@"phonenumbers"]) {
            QBContactLabelValue *labelValue = [[QBContactLabelValue alloc] initWithDictionary:dict];
            [phonenumbers addObject:labelValue];
        }
        
        self.phoneNumbersArray = phonenumbers;
        
        NSMutableArray *emailIds = [NSMutableArray array];
        
        for (NSDictionary *dict in dictionary[@"emailAddresses"]) {
            QBContactLabelValue *labelValue = [[QBContactLabelValue alloc] initWithDictionary:@{@"label": @"", @"value" : dict[@"value"]}];
            [emailIds addObject:labelValue];
        }
        
        self.emailAddresses = emailIds;
    }
    return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"firstName"] = self.firstName;
    dict[@"lastName"] = self.lastName;
    dict[@"contactId"] = self.contactId;

    NSMutableArray *phoneArray = [NSMutableArray array];
    for (QBContactLabelValue *labelValue in self.phoneNumbersArray) {
        [phoneArray addObject:labelValue.dictionary];
    }
    dict[@"phonenumbers"] = phoneArray;

    NSMutableArray *emailArray = [NSMutableArray array];
    for (QBContactLabelValue *labelValue in self.emailAddresses) {
        [emailArray addObject:labelValue.dictionary];
    }
    
    dict[@"emailIds"] = emailArray;
    
    NSMutableArray *addresses = [NSMutableArray array];
    for (QBPostalAddress *add in self.addresses) {
        [addresses addObject:add.dictionary];
    }
    
    dict[@"addresses"] = addresses;
    dict[@"company"] = self.company;


    return dict;
}

- (CNMutableContact*)mutableContact {
    CNMutableContact *contact = self.deviceContact ? self.deviceContact : [[CNMutableContact alloc] init];
    [self updateContactData:contact];
    
    return contact;
}

- (void)updateContactData:(CNMutableContact*)contact {
    contact.givenName = self.firstName;
    contact.familyName = self.lastName;
    contact.organizationName = self.company;
    NSMutableArray *phones = [NSMutableArray array];
    for (QBContactLabelValue *labelValue in self.phoneNumbersArray) {
        CNLabeledValue *label = [[CNLabeledValue alloc] initWithLabel:labelValue.label value:[CNPhoneNumber phoneNumberWithStringValue:labelValue.value]];
        [phones addObject:label];
    }
    
    contact.phoneNumbers = phones;
    
    NSMutableArray *emailIds = [NSMutableArray array];
    for (QBContactLabelValue *labelValue in self.emailAddresses) {
        CNLabeledValue *label = [[CNLabeledValue alloc] initWithLabel:nil value:labelValue.value];
        [emailIds addObject:label];
    }
    
    contact.emailAddresses = emailIds;
    
    NSMutableArray *addresses = [NSMutableArray array];
    for (QBPostalAddress *labelValue in self.addresses) {
        CNMutablePostalAddress *address = [[CNMutablePostalAddress alloc] init];
        address.street = labelValue.street;
        address.city = labelValue.city;
        address.state = labelValue.state;
        address.country = labelValue.country;
        address.ISOCountryCode = labelValue.ISOCountryCode;
        address.postalCode = labelValue.postalCode;
        
        CNLabeledValue *label = [[CNLabeledValue alloc] initWithLabel:labelValue.label value:address];
        [addresses addObject:label];
    }
    
    contact.postalAddresses = addresses;
}

@end
