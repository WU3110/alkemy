//
//  AKTabAnimationController.h
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AKAnimationController.h"

@interface AKTabAnimationController : AKAnimationController

@property (nonatomic, assign) BOOL isDirectionRight;

- (void)setDirection:(UITabBarController *)tabBarController
              fromVC:(UIViewController *)fromVC
                toVC:(UIViewController *)toVC;


// override these methods below
- (void)animateDirectionRight:(id<UIViewControllerContextTransitioning>)transitionContext
                       fromVC:(UIViewController *)fromVC
                         toVC:(UIViewController *)toVC
                     fromView:(UIView *)fromView
                       toView:(UIView *)toView
                containerView:(UIView *)containerView;

- (void)animateDirectionLeft:(id<UIViewControllerContextTransitioning>)transitionContext
                      fromVC:(UIViewController *)fromVC
                        toVC:(UIViewController *)toVC
                    fromView:(UIView *)fromView
                      toView:(UIView *)toView
               containerView:(UIView *)containerView;

@end
