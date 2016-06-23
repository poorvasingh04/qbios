//
//  QBPostalAddress.h
//  QuickBackup
//
//  Created by Nagarro on 6/14/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBPostalAddress : NSObject
@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSString *street;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, strong) NSString *postalCode;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *ISOCountryCode;

@property(nonatomic, strong, readonly) NSString *displayName;

@property(nonatomic, strong, readonly) NSDictionary *dictionary;
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
