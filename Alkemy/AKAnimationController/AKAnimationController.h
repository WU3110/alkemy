//
//  AKAnimationController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKAnimationController : NSObject
<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) CGSize displaySize;
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView;

@end
