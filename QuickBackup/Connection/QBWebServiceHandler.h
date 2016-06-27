//
//  QBWebServiceHandler.h
//  QuickBackup
//
//  Created by Nagarro on 6/14/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBWebServiceHandlerDelegate <NSObject>
- (void)connection:(NSInteger)connectionTag successfulWithResponse:(NSDictionary*)response;
- (void)connection:(NSInteger)connectionTag failedWithResponse:(NSString*)error;

@end

@interface QBWebServiceHandler : NSObject

@property(nonatomic, strong) NSString *procedureName;
@property(nonatomic, strong) NSDictionary *parameters;
@property(nonatomic, assign) NSInteger connectionTag;

@property(nonatomic, weak)id <QBWebServiceHandlerDelegate> delegate;
- (void)connect;
@end
