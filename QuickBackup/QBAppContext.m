//
//  QBAppContext.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBAppContext.h"
#import "QBAppSettings.h"

@implementation QBAppContext
static QBAppContext *instance;

//Singleton instance
+(QBAppContext *)sharedInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[QBAppContext alloc] init];
        }
    }
    return instance;
}

#pragma mark - Public methods
-(void)userDidLogin:(QBAppUser *)user {
    //logout the previous user
    if (_currentUser) {
        [self userDidLogout];
    }
    
    //set ivar
    _currentUser = user;
    
    //save last logged in user
    [[QBAppSettings sharedInstance] setLastLoggedInUser:user.token];
    
    //set logout state
    [[QBAppSettings sharedInstance] setPreviousUserLoggedOut:NO];
}

-(void)userDidLogout {
    _currentUser = nil;
    //set logout state
    [[QBAppSettings sharedInstance] setPreviousUserLoggedOut:YES];
}

@end
