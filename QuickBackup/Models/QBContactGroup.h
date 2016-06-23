//
//  QBContactGroup.h
//  QuickBackup
//
//  Created by Nagarro on 6/14/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBContact.h"

@interface QBContactGroup : NSObject
@property(nonatomic, strong) QBContact *contact;
@property(nonatomic, strong) NSArray<QBContact*> *similarContacts;

@end
