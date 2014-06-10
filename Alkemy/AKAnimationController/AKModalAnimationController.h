//
//  AKDismissAnimationController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKAnimationController.h"

@interface AKModalAnimationController : AKAnimationController

@property (nonatomic, assign) BOOL isPresenting;

// override these methods below
- (void)animatePresenting:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView;

- (void)animateDismissing:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView;

@end
