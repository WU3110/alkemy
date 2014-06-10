//
//  AKDismissAnimationController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKModalAnimationController.h"

@implementation AKModalAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView
{
    if (_isPresenting)
    {
        [self animatePresenting:transitionContext
                         fromVC:fromVC
                           toVC:toVC
                       fromView:fromView
                         toView:toView
                  containerView:containerView];
    }
    else
    {
        [self animateDismissing:transitionContext
                         fromVC:fromVC
                           toVC:toVC
                       fromView:fromView
                         toView:toView
                  containerView:containerView];
    }
}

- (void)animatePresenting:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView
{
    // add the toView to the container
    toView.transform = CGAffineTransformMakeTranslation(0, self.displaySize.height);
    [containerView addSubview:toView];
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                         fromView.transform = CGAffineTransformMakeTranslation(0, self.displaySize.height/10);
                         fromView.alpha = 0.5;
                     }
                     completion:^(BOOL finished) {
                         
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         fromView.alpha = 1.0;
                         
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         
                         if (cancelled) [toView removeFromSuperview];
                         else [fromView removeFromSuperview];
                         
                         [transitionContext completeTransition:!cancelled];
                     }];
    
}

- (void)animateDismissing:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
            containerView:(UIView *)containerView
{
    // add the toView to the container
    toView.transform = CGAffineTransformMakeTranslation(0, self.displaySize.height/10);
    toView.alpha = 0.5;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1.0;
                         fromView.transform = CGAffineTransformMakeTranslation(0, self.displaySize.height);
                     }
                     completion:^(BOOL finished) {
                         
                         fromView.transform = CGAffineTransformIdentity;
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1.0;
                         
                         BOOL cancelled = [transitionContext transitionWasCancelled];
                         
                         if (cancelled) [toView removeFromSuperview];
                         else [fromView removeFromSuperview];
                         
                         [transitionContext completeTransition:!cancelled];
                     }];
}

@end
