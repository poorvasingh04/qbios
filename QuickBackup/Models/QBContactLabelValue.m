//
//  QBContactLabelValue.m
//  QuickBackup
//
//  Created by Nagarro on 6/12/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBContactLabelValue.h"

@implementation QBContactLabelValue
- (id)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        self.label = dictionary[@"label"];
        self.value = dictionary[@"value"];
    }
    return self;
}

- (NSDictionary*)dictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"label"] = self.label;
    dict[@"value"] = self.value;
    return dict;
}

@end
