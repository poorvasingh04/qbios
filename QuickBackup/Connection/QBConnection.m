//
//  QBConnection.m
//  QuickBackup
//
//  Created by Nagarro on 6/14/16.
//  Copyright © 2016 Nagarro. All rights reserved.
//

#import "QBConnection.h"

static NSString * const kAppURL = @"https://poorva123.herokuapp.com";
//static NSString * const kAppURL = @"http://192.168.0.100:5000";

@implementation QBConnection

- (void)connect {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kAppURL, _procedureName]];
    
    NSMutableURLRequest *urlReq = [NSMutableURLRequest requestWithURL:url];
    [urlReq setHTTPMethod:@"POST"];
    [urlReq setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [urlReq setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlReq setHTTPMethod:@"POST"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:_parameters options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error---- %@", error);
    }
    [urlReq setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    
    [urlReq setHTTPBody:data];   
    
    dispatch_async(dispatch_get_main_queue(),  ^{
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          [self handleURLResponse:response data:data withError:error];
                                      }];
        [task resume];
    });
    
}

- (void)handleURLResponse:(NSURLResponse*)response data:(NSData*)data withError:(NSError*)connectionError {
    if (!connectionError) {
        
        //Connection successful
        
        NSError *parsingError;
        NSDictionary *jsonDictionary;
        
        //Check if there is some error while parsing data to json
        if (data) {
            jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
            NSLog(@"Response:\n%@",jsonDictionary);
            NSString *error = jsonDictionary[@"error"] ? jsonDictionary[@"error"][@"message"] : nil;
            BOOL success = [jsonDictionary[@"status"] boolValue];
            if (!success) {
                error = jsonDictionary[@"message"];
            }
            if (!jsonDictionary || parsingError || error.length > 0) {
                //Error
                [self callFailureBlockWithError:parsingError ? parsingError.localizedDescription : error];
                
            } else {
                //Success
                [self callSuccessBlockWithDictionary:jsonDictionary];
            }
        } else {
            //Failure
            [self callFailureBlockWithError:@"Error occurred while parsing response."];
        }
        
    } else {
        //Failure
        [self callFailureBlockWithError:connectionError.localizedDescription];
        
    }
}

- (void)callSuccessBlockWithDictionary:(NSDictionary*)dictionary {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connection:successfulWithResponse:)]) {
        [self.delegate connection:_connectionTag successfulWithResponse:dictionary];
    }
}

- (void)callFailureBlockWithError:(NSString*)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connection: failedWithResponse:)]) {
        [self.delegate connection:_connectionTag failedWithResponse:error];
    }
}

@end
