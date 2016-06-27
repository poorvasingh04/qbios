//
//  QBAppSettings.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBAppSettings.h"

static NSString* kPreviousUserLoggedOut = @"PreviousUserLoggedOut";
static NSString* kUserToken = @"token";
static NSString* kUserFirstName = @"firstName";
static NSString* kUserLastName = @"lastName";
static NSString* kUserIsAdmin = @"isAdmin";

@implementation QBAppSettings
static QBAppSettings *instance;

//shared instance
+(QBAppSettings *)sharedInstance {
    @synchronized(self) {
        if (instance == nil) {
            instance = [[QBAppSettings alloc] init];
        }
    }
    return instance;
}

-(void)setPreviousUserLoggedOut:(BOOL)previousUserLoggedOut {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserToken];
    [defaults removeObjectForKey:kUserFirstName];
    [defaults removeObjectForKey:kUserLastName];
    [defaults removeObjectForKey:kUserIsAdmin];

    [defaults synchronize];
}

- (QBAppUser *)lastLoggedInUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    QBAppUser *user = [[QBAppUser alloc] init];
    user.firstName = [defaults stringForKey:kUserFirstName];
    user.lastName = [defaults stringForKey:kUserLastName];
    user.token = [defaults stringForKey:kUserToken];
    user.userType = [defaults boolForKey:kUserIsAdmin] ? Admin : QBUser;
    
    return user;
}

- (void)setLastLoggedInUser:(QBAppUser *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.token forKey:kUserToken];
    [defaults setObject:user.firstName forKey:kUserFirstName];
    [defaults setObject:user.lastName forKey:kUserLastName];
    [defaults setBool:(user.userType == Admin) forKey:kUserIsAdmin];
    [defaults synchronize];
}

@end
