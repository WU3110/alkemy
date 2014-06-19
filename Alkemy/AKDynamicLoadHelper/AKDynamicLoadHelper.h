//
//  AKDynamicLoader.h
//  FIND
//
//  Created by TomokiNakamaru on 6/6/14.
//  Copyright (c) 2014 Kazuki Saima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKDynamicLoadHelper;


@protocol AKDynamicLoadDelegate <NSObject>

- (void)didReachIgnitionHeight;
- (void)enableDynamicLoad;

@end


@interface AKDynamicLoadHelper : NSObject

+ (void)showLoadingViewOnBottom:(UIScrollView *)scrollView
                      indicator:(UIView *)indicator;
+ (void)hideLoadingViewOnBottom:(UIScrollView *)scrollView
                     completion:(void (^)(BOOL))completion;

+ (void)makeDynamicWithScrollViewDelegate:(id <UIScrollViewDelegate>)scrollViewDelegate
                                 delegate:(id <AKDynamicLoadDelegate>)dynamicLoadDelegate
                           ignitionHeight:(CGFloat)ignitionHeight;

@end
