//
//  AKForkViewController.h
//  AlkemyDemo
//
//  Created by TomokiNakamaru on 6/6/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFHTTPRequestOperation;

@interface AKForkViewController : UIViewController

- (void)testStatus:(NSString *)urlString
        parameters:(NSDictionary *)parameters
        completion:(NSString *(^)(AFHTTPRequestOperation *operation, id responseObject))completion;

@end
