//
//  QBAppSettings.m
//  QuickBackup
//
//  Created by Nagarro on 5/21/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBAppSettings.h"

static NSString* kPreviousUserLoggedOut = @"PreviousUserLoggedOut";
static NSString* kLastLoggedInUser = @"lastLoggedInUser";

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

-(BOOL)previousUserLoggedOut {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPreviousUserLoggedOut];
}

-(void)setPreviousUserLoggedOut:(BOOL)previousUserLoggedOut {
    [[NSUserDefaults standardUserDefaults] setBool:previousUserLoggedOut forKey:kPreviousUserLoggedOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)lastLoggedInUser {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLastLoggedInUser];
}

- (void)setLastLoggedInUser:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kLastLoggedInUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
