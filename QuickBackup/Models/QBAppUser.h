//
//  QBAppUser.h
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBAppUser : NSObject

@property(nonatomic, assign) UserType userType;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *emailId;
@property(nonatomic, strong) NSString *phoneNumber;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *token;

@property(nonatomic, strong, readonly) NSDictionary *dictionary;

@property(nonatomic, assign) BOOL isSelected;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
