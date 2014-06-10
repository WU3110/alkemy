//
//  AKNavigationAnimationController.m
//  TabTest
//
//  Created by TomokiNakamaru on 6/8/14.
//  Copyright (c) 2014 TomokiNakamaru. All rights reserved.
//

#import "AKNavigationAnimationController.h"

@implementation AKNavigationAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView
             containerView:(UIView *)containerView
{
    if (_isPushing)
    {
        [self animatePushing:transitionContext
                      fromVC:fromVC
                        toVC:toVC
                    fromView:fromView
                      toView:toView
                containerView:containerView];
    }
    else
    {
        [self animatePushing:transitionContext
                      fromVC:fromVC
                        toVC:toVC
                    fromView:fromView
                      toView:toView
                containerView:containerView];
    }
}

- (void)animatePushing:(id<UIViewControllerContextTransitioning>)transitionContext
                fromVC:(UIViewController *)fromVC
                  toVC:(UIViewController *)toVC
              fromView:(UIView *)fromView
                toView:(UIView *)toView
          containerView:(UIView *)containerView
{
    // add toView out of screen
    toView.transform = CGAffineTransformMakeTranslation(self.displaySize.width, 0);
    [containerView addSubview:toView];
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         
                         // toView
                         toView.transform = CGAffineTransformIdentity;
                         
                         // fromView
                         fromView.transform = CGAffineTransformMakeTranslation(-self.displaySize.width/5, 0);
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

- (void)animatePopping:(id<UIViewControllerContextTransitioning>)transitionContext
                fromVC:(UIViewController *)fromVC
                  toVC:(UIViewController *)toVC
              fromView:(UIView *)fromView
                toView:(UIView *)toView
          containerView:(UIView *)containerView
{
    // add toView out of screen
    toView.transform = CGAffineTransformMakeTranslation(-toView.frame.size.width*0.9, 0);
    [containerView addSubview:toView];
    
    // send toView to back
    [containerView sendSubviewToBack:toView];
    toView.transform = CGAffineTransformMakeTranslation(-self.displaySize.width/5, 0);
    toView.alpha = 0.5;
    
    // animate
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         
                         // toView
                         toView.transform = CGAffineTransformIdentity;
                         toView.alpha = 1.0;
                         
                         // fromView
                         fromView.transform = CGAffineTransformMakeTranslation(self.displaySize.width, 0);
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
