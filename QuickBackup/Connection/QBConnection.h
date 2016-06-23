//
//  QBConnection.h
//  QuickBackup
//
//  Created by Nagarro on 6/14/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBConnectionDelegate <NSObject>
- (void)connection:(NSInteger)connectionTag successfulWithResponse:(NSDictionary*)response;
- (void)connection:(NSInteger)connectionTag failedWithResponse:(NSString*)error;

@end

@interface QBConnection : NSObject

@property(nonatomic, strong) NSString *procedureName;
@property(nonatomic, strong) NSDictionary *parameters;
@property(nonatomic, assign) NSInteger connectionTag;

@property(nonatomic, weak)id <QBConnectionDelegate> delegate;
- (void)connect;
@end
