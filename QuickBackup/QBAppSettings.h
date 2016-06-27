//
//  QBAppSettings.h
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBAppSettings : NSObject
+ (QBAppSettings*) sharedInstance;

@property(nonatomic, assign) BOOL isUserAlreadyLoggedIn;

- (QBAppUser*) lastLoggedInUser;
- (void) setLastLoggedInUser:(QBAppUser*)user;

-(void)setPreviousUserLoggedOut:(BOOL)previousUserLoggedOut;
@end
