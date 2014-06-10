//
//  AKNavigationAnimationController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKAnimationController.h"

@interface AKNavigationAnimationController : AKAnimationController

@property (nonatomic, assign) BOOL isPushing;

// override these methods below
- (void)animatePushing:(id<UIViewControllerContextTransitioning>)transitionContext
                fromVC:(UIViewController *)fromVC
                  toVC:(UIViewController *)toVC
              fromView:(UIView *)fromView
                toView:(UIView *)toView
         containerView:(UIView *)containerView;

- (void)animatePopping:(id<UIViewControllerContextTransitioning>)transitionContext
                fromVC:(UIViewController *)fromVC
                  toVC:(UIViewController *)toVC
              fromView:(UIView *)fromView
                toView:(UIView *)toView
         containerView:(UIView *)containerView;
@end
