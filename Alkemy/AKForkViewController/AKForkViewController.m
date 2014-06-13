//
//  AKForkViewController.m
//  AlkemyDemo
//
//  Created by TomokiNakamaru on 6/6/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKForkViewController.h"

#import "AFNetworking.h"

@interface AKForkViewController ()

@end

@implementation AKForkViewController

- (void)testStatus:(NSString *)urlString
        parameters:(NSDictionary *)parameters
        completion:(NSString *(^)(AFHTTPRequestOperation *operation, id responseObject))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self onComplete:completion(operation, responseObject)];
         }
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self onComplete:completion(operation, nil)];
         }];
}

- (void)onComplete:(NSString *)segue
{
    if (segue != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:segue sender:nil];
        });
    }
    else NSLog(@"Need to pass segue identifier");
}

@end
