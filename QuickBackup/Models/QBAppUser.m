//
//  QBAppUser.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBAppUser.h"

@implementation QBAppUser
- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        self.userType = [dictionary[@"isAdmin"] boolValue] ? Admin : QBUser;
        self.firstName = dictionary[@"first_name"];
        self.lastName = dictionary[@"last_name"];
        self.userId = dictionary[@"_id"];
        self.password = dictionary[@"password"];
        self.emailId = dictionary[@"email_id"];
        self.phoneNumber = dictionary[@"phoneNumber"];
        self.token = dictionary[@"token"];

    }
    return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"firstName"] = self.firstName;
    dict[@"lastName"] = self.lastName;
    dict[@"password"] = self.password;
    dict[@"emailId"] = self.emailId;
    dict[@"phoneNumber"] = self.phoneNumber;
    dict[@"isAdmin"] = self.userType == Admin ? @"Y" : @"N";

    return dict;
}

@end
