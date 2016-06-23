//
//  QBPostalAddress.m
//  QuickBackup
//
//  Created by Nagarro on 6/14/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBPostalAddress.h"

@implementation QBPostalAddress

- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        self.label = dictionary[@"label"];
        self.street = dictionary[@"street"];
        self.city = dictionary[@"city"];
        self.state = dictionary[@"state"];
        self.postalCode = dictionary[@"postalCode"];
        self.country = dictionary[@"country"];
        self.ISOCountryCode = dictionary[@"ISOCountryCode"];
        
        self.street = self.street.length > 0 ? self.street : @"";
        self.city = self.city.length > 0 ? self.city : @"";
        self.state = self.state.length > 0 ? self.state : @"";
        self.postalCode = self.postalCode.length > 0 ? self.postalCode : @"";
        self.country = self.country.length > 0 ? self.country : @"";
        self.ISOCountryCode = self.ISOCountryCode.length > 0 ? self.ISOCountryCode : @"";

    }
    return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"street"] = self.street;
    dict[@"city"] = self.city;
    dict[@"state"] = self.state;
    dict[@"postalCode"] = self.postalCode;
    dict[@"country"] = self.country;
    dict[@"ISOCountryCode"] = self.ISOCountryCode;
    dict[@"label"] = self.label;

    return dict;
}

- (NSString*)displayName {
    //street city, state country - postalcode
    NSMutableString *name = [[NSMutableString alloc] init];
    [name appendFormat:@"%@ %@", _street, _city];
    
    if (name.length > 0 && _state.length > 0) {
        [name appendString:@", "];
    }
    [name appendFormat:@"%@ %@", _state, _country];

    if (_postalCode.length > 0) {
        [name appendFormat:@" - %@", _postalCode];

    }
    return name;
}

@end
