//
//  QBAppContext.h
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBAppUser.h"

@interface QBAppContext : NSObject

+(QBAppContext*) sharedInstance;

-(void) userDidLogin:(QBAppUser*)user;
-(void) userDidLogout;

@property(nonatomic,strong,readonly) QBAppUser *currentUser;

@end
