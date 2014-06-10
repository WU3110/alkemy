//
//  AKAnimationController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKAnimationController.h"

@implementation AKAnimationController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.duration = 0.5f;
        _displaySize = [UIScreen mainScreen].bounds.size;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    UIView *containerView = [transitionContext containerView];
    
    [self animateTransition:transitionContext
                     fromVC:fromVC
                       toVC:toVC
                   fromView:fromView
                     toView:toView
              containerView:containerView];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView;
{
    NSLog(@"AKAnimationController.animateTransition is supposed to be overrided");
    abort();
}

@end
