//
//  QBContactLabelValue.h
//  QuickBackup
//
//  Created by Nagarro on 6/12/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBContactLabelValue : NSObject
@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSString *value;

@property(nonatomic, strong, readonly) NSDictionary *dictionary;
- (id)initWithDictionary:(NSDictionary*)dictionary;


@end
