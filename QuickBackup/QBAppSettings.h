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

- (NSString*) lastLoggedInUser;
- (void) setLastLoggedInUser:(NSString*)username;

-(BOOL)previousUserLoggedOut;
-(void)setPreviousUserLoggedOut:(BOOL)previousUserLoggedOut;
@end
